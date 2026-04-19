# admin_toolkit_v3

Набор скриптов для первичной настройки Linux-хостов: proxy, пакетная инициализация, сеть, синхронизация времени, ввод в домен, CIFS-монтирования, отчётность и итоговая проверка состояния.

![CI](https://github.com/pagrishaevich/admin_toolkit_v3/actions/workflows/shell-ci.yml/badge.svg)

## Для чего нужен проект

Проект помогает стандартизировать первичную настройку рабочих станций и управляемых хостов с помощью небольшого набора Bash-скриптов, которые можно адаптировать под конкретную инфраструктуру без постоянной переработки основной логики.

Ключевые цели:

- предсказуемый порядок bootstrap-настройки
- более безопасный повторный запуск и идемпотентное поведение
- разделение базового toolkit и локальной логики площадки

## Структура проекта

```text
scripts/
  bootstrap.sh      # основной оркестратор
  common.sh         # общий конфиг и helper-функции
  validate.sh       # локальная проверка качества
custom/
  *.local.sh        # локальные расширения под инфраструктуру
config.sh.example   # шаблон конфигурации
```

## Порядок выполнения

`scripts/bootstrap.sh` запускает шаги в таком порядке:

1. `self-update`
2. `proxy`
3. `repos`
4. `packages`
5. `network`
6. `time`
7. `autoupdate`
8. `domain`
9. `cifs`
10. `report`
11. `software`
12. `security`
13. `postcheck`

## Быстрый старт

1. Создайте локальную конфигурацию:

```bash
cp config.sh.example config.sh
```

2. Заполните параметры под свою инфраструктуру.

3. При необходимости включите локальные расширения:

```bash
cp custom/repos.local.sh.example custom/repos.local.sh
cp custom/software.local.sh.example custom/software.local.sh
cp custom/security.local.sh.example custom/security.local.sh
```

4. Запустите bootstrap от `root`:

```bash
bash scripts/bootstrap.sh
```

## Конфигурация

Основные параметры находятся в `config.sh`.

Чаще всего используются:

- `DOMAIN`, `DOMAIN_USER`
- `DNS_SERVERS`, `NTP_SERVER`
- `PROXY`
- `REPORTS_DIR`, `CIFS_SERVER`
- `REPO_DIR`, `AUTO_UPDATE_REMOTE`, `AUTO_UPDATE_BRANCH`
- `TOOLKIT_LOG_FILE`, `REPORT_ARCHIVE_DIR`

Если `config.sh` отсутствует, toolkit использует значения из `config.sh.example`.

## Модель расширения

Базовые скрипты остаются универсальными, а логика, завязанная на конкретную площадку, выносится в локальные hooks:

- `custom/repos.local.sh`
- `custom/software.local.sh`
- `custom/security.local.sh`

Эти файлы подключаются только если существуют, поэтому core-часть проекта можно переиспользовать в разных окружениях.

## Проверка

Локальная валидация:

```bash
bash scripts/validate.sh
```

Скрипт всегда запускает `bash -n`, а `shellcheck` и `shfmt` использует только если они установлены в системе.

Также в GitHub Actions настроена автоматическая проверка shell-скриптов на `push` и `pull request`.

## Текущее состояние

Что уже улучшено:

- конфигурация вынесена в отдельный шаблон
- bootstrap стал безопаснее с точки зрения lock-механизма
- для скриптов унифицирован `set -euo pipefail`
- шаги proxy, domain и CIFS сделаны более идемпотентными
- `self-update` стал безопаснее
- добавлены локальные hooks для кастомизации
- добавлены локальная валидация и CI-проверка

Что пока остаётся намеренно простым:

- `repos`, `software` и часть `security` оставлены как точки расширения
- пока нет отдельной упаковки или инсталлятора
- пока нет полноценного интеграционного тестового окружения
