#!/bin/bash

# Prompt for the venv name
echo -n "Podaj nazwę wirtualnego środowiska, w którym chcesz instalować (np. talkerVenv): "
read venv_name

if [ -z "$venv_name" ]; then
    echo "Nie podano nazwy środowiska. Przerywam."
    exit 1
fi

# Prompt for the package name
echo -n "Jaką paczkę chcesz zainstalować? "
read package_name

if [ -z "$package_name" ]; then
    echo "Nie podano nazwy paczki. Przerywam."
    exit 1
fi

# Loop through each subdirectory in the current directory
for dir in */; do
    target_dir="${dir%/}"
    
    # Skip if it's not a directory
    [ -d "$target_dir" ] || continue

    # Skip the 'rules' directory as per previous convention
    if [ "$target_dir" == "rules" ]; then
        continue
    fi

    venv_path="$target_dir/$venv_name"

    # Check if the venv exists
    if [ -d "$venv_path" ]; then
        echo "=== Instalacja w: $target_dir ($venv_name) ==="
        
        # Check if pip exists
        if [ -f "$venv_path/bin/pip" ]; then
            "$venv_path/bin/pip" install "$package_name"
        else
            echo "BŁĄD: Nie znaleziono bin/pip w $venv_path"
        fi
        echo ""
    else
        # Silent skip or informative skip - let's go with informative
        echo "=== Pomijanie: $target_dir (brak środowiska $venv_name) ==="
        echo ""
    fi
done

echo "Zakończono instalację."
