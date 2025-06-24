FROM debian:bullseye

RUN apt-get update && apt-get install -y python3 python3-pip && rm -rf /var/lib/apt/lists/*

RUN pip3 install flask

COPY app.py /app/app.py
COPY dashboard.html /app/dashboard.html


WORKDIR /app

EXPOSE 5000

CMD ["python3", "app.py"]
