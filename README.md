# AKUMA EvilGinx2 AutoInstaller

**Автоматический установщик Evilginx2 с исправлениями для сохранения сессий**

## Установка
```bash
git clone https://github.com/sweetpotatohack/AKUMA-EvilGinx2-AutoInstaller.git
cd AKUMA-EvilGinx2-AutoInstaller
sudo bash install_evilginx2.sh
```

## Особенности
- ✅ Исправлена проблема сохранения сессий в базе данных
- ✅ Точный формат cookies для StorageAce extension
- ✅ Удобные команды для работы с сессиями
- ✅ Автоматическое применение всех исправлений

## Основные команды
```bash
evilginx-sessions              # Показать все сессии
evilginx-sessions 1            # Детали сессии ID 1
evilginx-copy-cookies 1        # Скопировать cookies для импорта
evilginx-manager               # Менеджер управления
```

## Импорт cookies в браузер
1. Установите StorageAce extension
2. Выполните: `evilginx-copy-cookies 1`
3. Откройте сайт в браузере
4. StorageAce → Cookies → Import → вставьте JSON

**Теперь сессии надежно сохраняются!**
