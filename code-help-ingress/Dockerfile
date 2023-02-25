FROM nginx:stable

WORKDIR /etc/nginx

RUN rm conf.d/*
RUN rm nginx.conf

COPY ./nginx.conf .

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]