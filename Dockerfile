FROM ubuntu
RUN apt update
RUN apt install iproute2 -y
ADD go-mmproxy /app/
WORKDIR /app
