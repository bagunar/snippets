#!/usr/bin/env bash

## OLD VERSION
# IDS=$(docker container ls -q -l)
# echo "connection to $IDS"
# docker exec -it $IDS /bin/bash

## NEW VERSION
#!/usr/bin/env bash

# Obtenir le chemin absolu du répertoire courant
CURRENT_DIR=$(pwd)
echo "Recherche d'un container avec un volume monté pour: $CURRENT_DIR"

# Fonction pour trouver les containers correspondants
find_matching_containers() {
    local dir=$1
    docker ps -q | while read cid; do
        # Pour chaque container, vérifier ses points de montage
        if docker container inspect "$cid" --format '{{range .Mounts}}{{.Source}}{{"\n"}}{{end}}' | grep -q "^$dir"; then
            echo "$cid"
        fi
    done
}

# Stocker les containers correspondants dans un tableau
mapfile -t MATCHING_CONTAINERS < <(find_matching_containers "$CURRENT_DIR" | sort -u)

# Vérifier le nombre de containers trouvés
if [ ${#MATCHING_CONTAINERS[@]} -eq 0 ]; then
    echo "Aucun container trouvé avec un volume monté pour $CURRENT_DIR"
    exit 1
elif [ ${#MATCHING_CONTAINERS[@]} -eq 1 ]; then
    # Si un seul container est trouvé, l'utiliser directement
    CONTAINER_ID="${MATCHING_CONTAINERS[0]}"
    echo -e "Container trouvé"
    # docker ps --no-trunc --format "table {{.ID}}\t{{.Names}}\t{{.Mounts}}" -f id=$CONTAINER_ID
    
    echo -e "Connection au container..."
    docker exec -it $CONTAINER_ID /bin/bash
else
    # Si plusieurs containers sont trouvés, permettre à l'utilisateur de choisir
    echo -e "\nPlusieurs containers trouvés avec des volumes montés correspondants:"
    echo "----------------------------------------------------------------"
    
    # Afficher les containers avec leurs détails
    for i in "${!MATCHING_CONTAINERS[@]}"; do
        echo -e "\n$((i+1))) Container: ${MATCHING_CONTAINERS[$i]}"
        docker ps --no-trunc --format "{{.Names}}\nVolumes: {{.Mounts}}" -f id="${MATCHING_CONTAINERS[$i]}"
    done
    
    # Demander à l'utilisateur de choisir
    echo -e "\nChoisissez un container (1-${#MATCHING_CONTAINERS[@]}):"
    while true; do
        read -r choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#MATCHING_CONTAINERS[@]}" ]; then
            CONTAINER_ID="${MATCHING_CONTAINERS[$((choice-1))]}"
            echo -e "\nConnection au container..."
            docker exec -it $CONTAINER_ID /bin/bash
            break
        else
            echo "Choix invalide. Entrez un numéro entre 1 et ${#MATCHING_CONTAINERS[@]}"
        fi
    done
fi

