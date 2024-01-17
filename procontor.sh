#!/bin/bash

# Definir cores como constantes
WHITE='\033[1;37m'
RED='\033[0;31m'
BLUE='\033[0;36m'
CLEAN='\033[0m'

# Função para exibir mensagens de erro e sair
error_exit() {
    echo -e "${RED}Error: $1${CLEAN}" >&2
    exit 1
}

# Função para exibir ajuda
show_help() {
    echo -e "${WHITE}Usage:${CLEAN}"
    echo -e "${WHITE}  ./procontor.sh [OPTIONS]${CLEAN}"
    echo -e "${WHITE}Options:${CLEAN}"
    echo -e "${BLUE}  -h, --help${CLEAN}             Show this help message"
    echo -e "${BLUE}  -p, --project PROJECT${CLEAN}  Specify the project name"
    echo -e "${BLUE}  -s, --size SIZE${CLEAN}        Specify the container size (e.g., 500M, 5G)"
    echo -e "${WHITE}Description:${CLEAN}"
    echo -e "  Procontor is a Project Container Creator designed to create LUKS-encrypted containers for handling sensitive projects and subsequently mount them for further use. Please remember the password you've set for your container!"
    exit 0
}

# Processar argumentos de linha de comando
if [ "$#" -eq 0 ]; then
    show_help
fi

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            ;;
        -p|--project)
            project="$2"
            shift 2
            ;;
        -s|--size)
            size="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Unknown option: $1${CLEAN}"
            show_help
            ;;
    esac
done

# Verificar dependências
if ! command -v cryptsetup &> /dev/null; then
    error_exit "cryptsetup is not installed. Please install it."
fi

# Função para criar o contêiner
create_container() {
    echo -e "${BLUE}01 Creating a ${size} container for $project-cont${CLEAN}"
    if [[ "$size" =~ ^[0-9]+[GgMm]$ ]]; then
        dd if=/dev/zero of="$project-cont" bs=1 count=0 seek="$size"
    else
        echo -e "${RED}Invalid size format. Please use 'G' for gigabytes or 'M' for megabytes.${CLEAN}"
        exit 1
    fi
    echo ""
}

# Função para criptografar o contêiner
encrypt_container() {
    echo -e "${BLUE}02 Encrypting the $project-cont container with LUKS${CLEAN}"
    sudo cryptsetup -y --cipher aes-xts-plain64 --hash sha512 --key-size 512 -v luksFormat "$project-cont" || error_exit "Failed to encrypt the container."
    echo ""
}

# Função para criar o dispositivo
create_device() {
    echo -e "${BLUE}03 Creating the device as project-device${CLEAN}"
    sudo cryptsetup luksOpen "$project-cont" project-device || error_exit "Failed to create the device."
    echo -e "${BLUE}The project-device is in /dev/mapper:${CLEAN}"
    ls /dev/mapper/
    echo ""
}

# Função para criar o sistema de arquivos
create_filesystem() {
    echo -e "${BLUE}04 Creating a file system in the device${CLEAN}"
    sudo mkfs.xfs /dev/mapper/project-device || error_exit "Failed to create the filesystem."
    echo ""
}

# Função para montar o dispositivo
mount_device() {
    echo -e "${BLUE}05 Mounting the device at /mnt/project-mount${CLEAN}"
    sudo mount /dev/mapper/project-device /mnt/project-mount/ || error_exit "Failed to mount the device."
    lsblk
    echo ""
}

# Função para definir a propriedade
set_ownership() {
    echo -e "${BLUE}06 Changing the project-mount ownership to $USER ${CLEAN}"
    sudo chown $USER -R /mnt/project-mount/ || error_exit "Failed to change ownership."
}

# Loop para criar o contêiner
while true
do
    echo -e "                                  _             "
    echo -e "  _ __  _ __ ___   ___ ___  _ __ | |_ ___  _ __ "
    echo -e " | '_ \| '__/ _ \ / __/ _ \| '_ \| __/ _ \| '__|"
    echo -e " | |_) | | | (_) | (_| (_) | | | | || (_) | |   "
    echo -e " | .__/|_|  \___/ \___\___/|_| |_|\__\___/|_|   "
    echo -e " |_|                                            "
    echo ""
    echo -e "     by k4rkarov (v3.0)"
    echo ""
    echo ""
    create_container
    encrypt_container
    create_device
    create_filesystem
    mount_device
    set_ownership
    echo ""
    echo ""
    echo -e "${WHITE}All done.${CLEAN}"
    echo ""
    break
done
