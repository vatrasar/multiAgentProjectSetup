#!/bin/bash

# Zatrzymanie skryptu w przypadku błędu
set -e

# Pobranie linku do repozytorium rules
read -p "Podaj link do repozytorium GitHub z rules: " RULES_REPO_URL

# Pobranie linku do repozytorium projektu
read -p "Podaj link do repozytorium GitHub z projektem: " PROJECT_REPO_URL

if [ -z "$RULES_REPO_URL" ] || [ -z "$PROJECT_REPO_URL" ]; then
    echo "Błąd: Musisz podać oba linki (do rules i do projektu)."
    exit 1
fi

echo "=========================================="
echo "Pobieranie repozytorium rules..."
echo "=========================================="
# Sklonowanie repozytorium rules pod stałą nazwą 'rules'
git clone "$RULES_REPO_URL" rules

echo "=========================================="
echo "Pobieranie projektów..."
echo "=========================================="
# Sklonowanie repozytorium projektu i nadanie odpowiednich nazw folderom
git clone "$PROJECT_REPO_URL" CleanProject
git clone "$PROJECT_REPO_URL" antigravityProject
git clone "$PROJECT_REPO_URL" OpenCodeProject
git clone "$PROJECT_REPO_URL" geminiCLIProject

echo "=========================================="
echo "Konfiguracja rules w projekcie antigravity..."
echo "=========================================="
# Sklonowanie repozytorium rules do folderu .agents w antigravityProject
git clone "$RULES_REPO_URL" antigravityProject/.agents

echo "=========================================="
echo "Uruchamianie skryptu convert_rules.sh..."
echo "=========================================="
if [ -f "./convert_rules.sh" ]; then
    # Nadanie uprawnień do wykonywania i uruchomienie skryptu
    chmod +x ./convert_rules.sh
    ./convert_rules.sh
else
    echo "Ostrzeżenie: Nie znaleziono pliku convert_rules.sh w obecnym katalogu. Pomijam ten krok."
fi

echo "=========================================="
echo "Struktura projektów została utworzona pomyślnie!"
echo "=========================================="
