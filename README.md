# admin_toolkit_v3

Набор shell-скриптов для первичной настройки Linux-хоста: proxy, repos, packages, network, time, domain join, CIFS, отчётность и post-check.

## Что улучшено в этой версии

- Конфиг вынесен в `config.sh` с шаблоном `config.sh.example`.
- Добавлены базовые helper-функции и более строгие проверки.
- Ключевые шаги стали ближе к идемпотентным.
- `bootstrap.sh` теперь аккуратнее обрабатывает lock и выполнение шагов.
- Добавлены локальные hooks в `custom/*.local.sh`.
- Добавлена проверка качества через `scripts/validate.sh` и CI workflow.

## Быстрый старт

1. Скопируйте шаблон:

```bash
cp config.sh.example config.sh
```

2. Заполните значения под свою площадку.

3. Запустите bootstrap от `root`:

```bash
bash scripts/bootstrap.sh
```

4. Для локальной кастомизации при необходимости скопируйте шаблоны:

```bash
cp custom/repos.local.sh.example custom/repos.local.sh
cp custom/software.local.sh.example custom/software.local.sh
cp custom/security.local.sh.example custom/security.local.sh
```

## Конфигурация

Основные параметры:

- `DOMAIN`, `DOMAIN_USER`
- `DNS_SERVERS`, `NTP_SERVER`
- `PROXY`
- `REPORTS_DIR`, `CIFS_SERVER`
- `REPO_DIR`, `AUTO_UPDATE_REMOTE`, `AUTO_UPDATE_BRANCH`

Если `config.sh` отсутствует, будут использованы значения из `config.sh.example`.

## Валидация

Локальная проверка:

```bash
bash scripts/validate.sh
```

Скрипт всегда проверяет `bash -n`, а `shellcheck` и `shfmt` запускает только если они установлены.

## Расширение

- `scripts/repos.sh` вызывает `custom/repos.local.sh`, если файл существует.
- `scripts/software.sh` вызывает `custom/software.local.sh`, если файл существует.
- `scripts/security.sh` вызывает `custom/security.local.sh`, если файл существует.

Так можно держать site-specific логику отдельно от core toolkit.
