#!/bin/bash
python manage.py migrate
python manage.py collectstatic --noinput  # collect static files
# python manage.py loaddata fixtures/cpd/templates.json
# python manage.py loaddata fixtures/tcc/templates.json
# python manage.py add_constance_configs

cd /code
gunicorn --log-level debug --bind 0.0.0.0:8000 --graceful-timeout 180000 --timeout 180000 --worker-class saleor.asgi.gunicorn_worker.UvicornWorker --max-requests 1024 --max-requests-jitter 25 --workers 5 --preload  saleor.asgi:application