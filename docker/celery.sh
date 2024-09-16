#!/bin/bash

cd /code
#celery worker -E -B --autoscale=5,2 --loglevel=INFO -Ofair --hostname=redis --app=accis.celery:app
QUEUE_NAMES_ENV=$(eval echo \$\{QUEUE_NAMES\})
QUEUE_NAMES_COPIED="${QUEUE_NAMES_ENV:-celery}"
QSIZE=${#QUEUE_NAMES_COPIED}

if [[ "$ISFLOWER" == "true" ]]; then
  pip install --user django https://github.com/codal/flower/archive/master.zip
  celery --app=saleor.celeryconf:app flower --basic_auth=$CELERY_USER:$CELERY_PASS --port=5566
else
  if [ -z "$ISNOTBEAT" ]; then
    celery --app=saleor.celeryconf:app worker -E -B --autoscale=4,10 --loglevel=INFO --scheduler saleor.core.utils.scheduler:DatabaseSchedulerWithCleanup -O fair -Q $(eval echo \$\{QUEUE_NAMES_COPIED\}) --hostname=$(eval echo \$\{MY_POD_NAME\})
  else
    celery --app=saleor.celeryconf:app worker -E --autoscale=4,10 --loglevel=INFO -O fair -Q $(eval echo \$\{QUEUE_NAMES_COPIED\}) --hostname=$(eval echo \$\{MY_POD_NAME\}\$\{QSIZE\})
  fi
fi