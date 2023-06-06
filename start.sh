#!/usr/bin/env bash

PORT="${1:-8000}"

python3 manage.py migrate
echo "server running at port $PORT"
echo "Author = $AUTHOR"
python3 manage.py runserver 0.0.0.0:$PORT

