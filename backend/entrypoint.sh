#!/bin/bash

# Wait for the database to be ready
./wait-for-it.sh postgres:${DB_PORT} -- timeout 30s echo "Database is ready!"

# Start the Flask app
exec flask run --host=0.0.0.0 --port=8000