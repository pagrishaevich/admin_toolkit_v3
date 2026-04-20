# Quick Start Tech

Короткая памятка для развёртывания новой машины одной последовательностью команд.

## Команды

```bash
git clone https://github.com/pagrishaevich/admin_toolkit_v3.git
cd admin_toolkit_v3
chmod +x admin_toolkit_v3/*.sh
install -d -m 700 /root/.bootstrap
printf '%s\n' 'DOMAIN_PASSWORD' > /root/.bootstrap/domain.pass
chmod 600 /root/.bootstrap/domain.pass
bash scripts/bootstrap.sh
```

## Перед запуском проверить

- в `scripts/common.sh` указан правильный `CIFS_USERNAME` (`guest` для гостевого доступа без пароля по умолчанию)
- на сетевом хранилище доступны:
  - `/mnt/distr/linux/bootstrap/kesl`
  - `/mnt/distr/linux/bootstrap/cryptopro`
  - `/mnt/distr/linux/bootstrap/vipnet`

## Ожидаемый результат

В конце лога должно быть:

```text
[RESULT] SUCCESS
```

Если на сетевом хранилище не хватает дистрибутивов, соответствующий шаг bootstrap остановится и покажет понятную ошибку по отсутствующему пакету или каталогу.
