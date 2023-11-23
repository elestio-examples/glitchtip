#!/usr/bin/env bash

docker-compose up -d;
sleep 100s;

docker-compose exec -T worker bash -c "export DJANGO_SUPERUSER_EMAIL=${ADMIN_EMAIL} && export DJANGO_SUPERUSER_PASSWORD=${ADMIN_PASSWORD} && ./manage.py createsuperuser --noinput"