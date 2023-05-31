#!/usr/bin/env bash

PORT="${1:-8000}"

python manage.py migrate
echo "server running at port $PORT"
echo "Author = $AUTHOR"
python manage.py runserver 0.0.0.0:$PORT

