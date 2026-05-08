#!/bin/bash

# Prompt for the venv name
echo -n "Jaką nazwę mają mieć wirtualne środowiska? (np. .venv lub talkerVenv): "
read venv_name

if [ -z "$venv_name" ]; then
    echo "Nie podano nazwy środowiska. Przerywam."
    exit 1
fi

# Prompt for the package name
echo -n "Jaką paczkę chcesz zainstalować w środowiskach? "
read package_name

if [ -z "$package_name" ]; then
    echo "Nie podano nazwy paczki. Przerywam."
    exit 1
fi

# Loop through each subdirectory in the current directory
for dir in */; do
    # Remove trailing slash for cleaner output
    target_dir="${dir%/}"
    
    # Skip if it's not a directory
    [ -d "$target_dir" ] || continue

    # NEW: Skip the 'rules' directory
    if [ "$target_dir" == "rules" ]; then
        echo "=== Pomijanie folderu: $target_dir ==="
        continue
    fi

    echo "=== Przetwarzanie folderu: $target_dir ==="

    venv_path="$target_dir/$venv_name"

    # 1. Usuwanie istniejącego środowiska, jeśli istnieje
    if [ -d "$venv_path" ]; then
        echo "Znaleziono istniejące środowisko $venv_name. Usuwanie..."
        rm -rf "$venv_path"
    else
        echo "Środowisko $venv_name nie istnieje. Zostanie utworzone."
    fi

    # 2. Tworzenie środowiska
    echo "Tworzenie nowego środowiska $venv_name w $target_dir..."
    python3 -m venv "$venv_path"

    # 3. Instalacja pakietu
    if [ -f "$venv_path/bin/pip" ]; then
        echo "Instalowanie $package_name..."
        "$venv_path/bin/pip" install "$package_name"
    else
        echo "BŁĄD: Nie udało się utworzyć bin/pip w $venv_path"
    fi
    echo ""
done

echo "Gotowe!"
