#!/bin/bash

# Skrypt do konwersji reguł i umiejętności dla OpenCode i GeminiCLI

# Konfiguracja ścieżek
RULES_SRC="rules/rules"
SKILLS_SRC="rules/skills"

TARGETS=("OpenCodeProject" "geminiCLIProject")
OPENCODE_RULES_FILE="AGENTS.md"
GEMINI_RULES_FILE="GEMINI.md"

# Kolejność plików reguł (zgodnie z instrukcją, poprawione źródło dla ui.md)
ORDER=(
    "project-info.md"
    "architecture.md"
    "routing_and_reactivity.md"
    "screensAndComponents.md"
    "coding.md"
    "ui.md"
)

# Funkcja usuwająca blok YAML frontmatter (pomiędzy liniami '---') na początku pliku
strip_yaml_and_append() {
    local file=$1
    local dest=$2
    awk '
    # Rozpocznij pomijanie, jeśli w pierwszej linii jest "---"
    NR==1 && /^---[ \t]*$/ { skip=1; next }
    # Zakończ pomijanie, jeśli napotkasz zamykające "---"
    skip==1 && /^---[ \t]*$/ { skip=0; next }
    # Drukuj każdą inną linię
    !skip { print }
    ' "$file" >> "$dest"
    
    # Dodaj odstęp przed kolejnym plikiem
    echo -e "\n\n" >> "$dest"
}

# Funkcja do syntetyzowania reguł
synthesize_rules() {
    local target_path=$1
    local output_file=$2
    local tmp_combined=$(mktemp)
    
    echo "Syntetyzowanie reguł dla $target_path..."
    
    # 1. Dodaj pliki w określonej kolejności
    declare -A processed_files
    
    for file in "${ORDER[@]}"; do
        if [ -f "$RULES_SRC/$file" ]; then
            strip_yaml_and_append "$RULES_SRC/$file" "$tmp_combined"
            processed_files["$file"]=1
        else
            echo "Uwaga: brak pliku $RULES_SRC/$file"
        fi
    done
    
    # 2. Dodaj resztę plików z rules/rules, jeśli pojawią się w przyszłości
    for file_path in "$RULES_SRC"/*.md; do
        if [ -f "$file_path" ]; then
            file=$(basename "$file_path")
            if [[ -z "${processed_files[$file]}" ]]; then
                strip_yaml_and_append "$file_path" "$tmp_combined"
                processed_files["$file"]=1
            fi
        fi
    done
    
    # Zapisz do folderu docelowego
    mv "$tmp_combined" "$target_path/$output_file"
}

# Główna pętla po projektach
for target in "${TARGETS[@]}"; do
    if [ ! -d "$target" ]; then
        echo "Ostrzeżenie: Katalog $target nie istnieje. Pomijam."
        continue
    fi

    # Wybierz nazwę pliku w zależności od projektu
    if [ "$target" == "OpenCodeProject" ]; then
        synthesize_rules "$target" "$OPENCODE_RULES_FILE"
    else
        synthesize_rules "$target" "$GEMINI_RULES_FILE"
    fi

    # Kopiowanie umiejętności (skills)
    if [ "$target" == "OpenCodeProject" ]; then
        SKILLS_DEST="$target/.opencode/skills"
        # Czyszczenie folderu skills przed kopiowaniem (bez usuwania całego .opencode)
        if [ -d "$SKILLS_DEST" ]; then
            echo "Czyszczenie $SKILLS_DEST..."
            rm -rf "$SKILLS_DEST"
        fi
    else
        SKILLS_DEST="$target/.agents/skills"
    fi

    echo "Kopiowanie umiejętności do $SKILLS_DEST..."
    mkdir -p "$SKILLS_DEST"
    
    if [ -d "$SKILLS_SRC" ]; then
        # Kopiujemy całą zawartość folderu skills
        cp -r "$SKILLS_SRC"/* "$SKILLS_DEST/"
    fi
done

echo "Gotowe! Zaktualizowane reguły (bez YAML) i umiejętności zostały rozdzielone."
