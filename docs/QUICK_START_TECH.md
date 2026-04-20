# Quick Start Tech

Короткая памятка для развёртывания новой машины одной последовательностью команд.

## Команды

```bash
git clone https://github.com/pagrishaevich/admin_toolkit_v3.git
cd admin_toolkit_v3
install -d -m 700 /root/.bootstrap
printf '%s\n' 'DOMAIN_PASSWORD' > /root/.bootstrap/domain.pass
printf '%s\n' 'CIFS_PASSWORD' > /root/.bootstrap/cifs.pass
chmod 600 /root/.bootstrap/domain.pass /root/.bootstrap/cifs.pass
bash install-host.sh
```

## Перед запуском проверить

- в `scripts/common.sh` указан правильный `CIFS_USERNAME`
- на сетевом хранилище доступны:
  - `/mnt/distr/linux/bootstrap/kesl`
  - `/mnt/distr/linux/bootstrap/cryptopro`
  - `/mnt/distr/linux/bootstrap/vipnet`

## Ожидаемый результат

В конце лога должно быть:

```text
[RESULT] SUCCESS
```

Если на сетевом хранилище не хватает дистрибутивов, `install-host.sh` остановится до запуска bootstrap и покажет понятную ошибку по отсутствующему пакету или каталогу.
