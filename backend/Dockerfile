FROM cached

COPY . .

RUN pip install -r requirements.txt

# WORKDIR /app

# RUN flask db init
# RUN flask db migrate -m "Initial migration."
# RUN flask db upgrade

# WORKDIR /

EXPOSE 5000

CMD ["python", "-m", "app"]