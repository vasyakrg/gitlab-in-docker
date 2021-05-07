# Gitlab in docker

Полноценная сборка сервера Gitlab, его базы на psql, 4х раннеров и своего docker-registry, разворачеваемая на докер-хосте

## Преподготовка

- нужен docker

```
curl https://get.docker.com -o install.sh && sh install.sh
```

- нужен docker-compose

```
curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
```

Подразумевается, что у вас есть `домен` и вы уже создали два поддомена `docker` и `gitlab`
Подразумевается, что и гитлаб и регистри будут работать через один порт 443
Подразумевается, что у вас уже есть webproxy или traefik, которые возьмут на себя ингрессы контейнеров и выдачу (обновление) им сертификатов
(сеть webpоxy как раз комментирована по этому - ее надо будет раскоментировать под свои условия)

traefik можно поставить по этой [репке](https://github.com/vasyakrg/traefik)

`labels` у контейнеров подготовлены, если у вас traefik, раскомментите эти поля
`runner` - костомизирован только тем, что в нем встроена система авторегистрации на сервере.

## Запуск

1. переименовываем `.env.example` в `.env`
2. заполняем по максимому внимательно все переменные (кроме `RUNNER_TOKEN=`)
3. распаковываем в папке ssl-certs сертификаты и кладем там же (сертификаты noname и нужны лишь для внутреннего взаимодействия между gitlab и registry компонентами). Убедитесь что на всех ключах выставлены права в 0644
4. запускаем сборку `docker-compose up -d`
5. когда сервер запустится, вы войдете в систему под рутом, надо сходить в раздел раннеров (/admin/runners) и подсмотреть там токен, который и нужно будет заполнить в переменной `RUNNER_TOKEN=` и снова запустить `docker-compose up -d`, после чего раннеры перезапустятся и зарегистрируються в системе.

Если некоторые из 4х раннеров ушли в ошибку `is not healthy and will be disabled!`, то нужно:
- `docker-compose stop runner_2`
- `docker-compose rm runner_2`
- `rm /srv/services/data/gitlab/gitlab-runner_3/config.toml`
- `docker-compose up -d`

То есть, останавливаем и удаляем контейнер. Удаляем конфиг и перезапускаем весь компоуз.
Он поднимет удаленный ранее контейнер и снова его перенастроит и подключит.
После чего раннер должен будет зарегистрироваться в гитлабе.

## Первый вход

- root \ пароль указанный в переменной `GITLAB_ROOT_PASSWORD`

## Автор \ Author

- **Vassiliy Yegorov** [vasyakrg](https://github.com/vasyakrg)
- [youtube](https://youtube.com/realmanual)
- [site](https://vk.com/realmanual)
- [telegram](https://t.me/realmanual)
- [any qiestions for me](https://t.me/realmanual_group)
