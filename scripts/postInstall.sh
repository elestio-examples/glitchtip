#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 60s;


docker-compose exec -T worker bash -c "export DJANGO_SUPERUSER_EMAIL=${ADMIN_EMAIL} && export DJANGO_SUPERUSER_PASSWORD=${ADMIN_PASSWORD} && ./manage.py createsuperuser --noinput"