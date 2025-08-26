#!/bin/bash

# Скрипт для исправления phishlets в уже установленной EvilGinx2
# Автор: AKUMA EvilGinx2 AutoInstaller

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Функции логирования
log() { echo -e "${BLUE}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Проверка прав root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "Требуются права root. Используйте: sudo $0"
    fi
}

# Основная функция
main() {
    echo -e "${GREEN}"
    echo "=================================================="
    echo "    Исправление phishlets EvilGinx2"
    echo "=================================================="
    echo -e "${NC}\n"
    
    check_root
    
    # Определить директорию скрипта
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    log "Текущая директория скрипта: $SCRIPT_DIR"
    
    # Проверить наличие папки phishlets в репозитории
    if [[ ! -d "$SCRIPT_DIR/phishlets" ]]; then
        error "Директория $SCRIPT_DIR/phishlets не найдена! Убедитесь, что вы клонировали полный репозиторий."
    fi
    
    # Подсчитать количество phishlets в репозитории
    repo_phishlets=$(ls -1 "$SCRIPT_DIR/phishlets/"*.yaml 2>/dev/null | wc -l)
    log "Найдено $repo_phishlets phishlets в репозитории"
    
    if [[ $repo_phishlets -eq 0 ]]; then
        error "В директории $SCRIPT_DIR/phishlets/ не найдено .yaml файлов"
    fi
    
    # Создать целевую директорию если её нет
    mkdir -p /root/evilginx2-data/phishlets/
    
    # Остановить сервис EvilGinx2 если он запущен
    if systemctl is-active --quiet evilginx2; then
        warning "Остановка сервиса EvilGinx2..."
        systemctl stop evilginx2
        SERVICE_WAS_RUNNING=true
    else
        SERVICE_WAS_RUNNING=false
    fi
    
    # Создать резервную копию существующих phishlets
    if [[ -d "/root/evilginx2-data/phishlets" ]] && [[ $(ls -1 /root/evilginx2-data/phishlets/*.yaml 2>/dev/null | wc -l) -gt 0 ]]; then
        log "Создание резервной копии существующих phishlets..."
        mkdir -p /root/evilginx2-data/phishlets-backup-$(date +%Y%m%d-%H%M%S)
        cp /root/evilginx2-data/phishlets/*.yaml /root/evilginx2-data/phishlets-backup-$(date +%Y%m%d-%H%M%S)/ 2>/dev/null || true
    fi
    
    # Копировать все phishlets из репозитория
    log "Копирование $repo_phishlets phishlets из репозитория..."
    
    # Копировать файлы
    if cp "$SCRIPT_DIR/phishlets/"*.yaml /root/evilginx2-data/phishlets/ 2>/dev/null; then
        success "Phishlets скопированы успешно"
    else
        # Fallback - копируем по одному файлу
        log "Копирование по одному файлу..."
        for file in "$SCRIPT_DIR/phishlets/"*.yaml; do
            if [[ -f "$file" ]]; then
                cp "$file" /root/evilginx2-data/phishlets/
                echo "  ✓ $(basename "$file")"
            fi
        done
        success "Phishlets скопированы индивидуально"
    fi
    
    # Установить правильные права доступа
    log "Установка прав доступа..."
    chown root:root /root/evilginx2-data/phishlets/*.yaml 2>/dev/null || true
    chmod 644 /root/evilginx2-data/phishlets/*.yaml 2>/dev/null || true
    
    # Проверить результат
    final_count=$(ls -1 /root/evilginx2-data/phishlets/*.yaml 2>/dev/null | wc -l)
    success "Установлено $final_count phishlets"
    
    # Показать несколько примеров
    log "Примеры доступных phishlets:"
    ls /root/evilginx2-data/phishlets/*.yaml 2>/dev/null | head -10 | while read file; do
        echo "  • $(basename "$file" .yaml)"
    done
    
    # Перезапустить сервис если он был запущен
    if [[ "$SERVICE_WAS_RUNNING" == "true" ]]; then
        log "Перезапуск сервиса EvilGinx2..."
        systemctl start evilginx2
        if systemctl is-active --quiet evilginx2; then
            success "Сервис EvilGinx2 перезапущен"
        else
            warning "Сервис не удалось запустить автоматически. Запустите вручную: systemctl start evilginx2"
        fi
    fi
    
    echo -e "\n${GREEN}=== Phishlets исправлены! ===${NC}"
    echo -e "\n${BLUE}Что делать дальше:${NC}"
    echo -e "  ${YELLOW}1.${NC} Запустите EvilGinx2: ${YELLOW}sudo ./evilginx2_manager.sh interactive${NC}"
    echo -e "  ${YELLOW}2.${NC} Проверьте phishlets: ${YELLOW}phishlets${NC}"
    echo -e "  ${YELLOW}3.${NC} Используйте: ${YELLOW}phishlets enable [name]${NC}"
    
    echo -e "\n${BLUE}Популярные phishlets:${NC}"
    echo -e "  • ${GREEN}google, google2, google-botguard-bypass${NC}"
    echo -e "  • ${GREEN}facebook, facebook-d, facebook-fix${NC}"
    echo -e "  • ${GREEN}microsoft, o365, outlook${NC}"
    echo -e "  • ${GREEN}amazon, paypal, linkedin${NC}"
    echo -e "  • ${GREEN}bitrix24-keydisk, bitrix24-universal${NC}"
    
    echo -e "\n${RED}ВНИМАНИЕ:${NC} Используйте только для авторизованного тестирования!"
}

# Запуск
main "$@"
