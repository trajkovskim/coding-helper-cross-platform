FROM nginx:stable

WORKDIR /etc/nginx

COPY ./nginx.conf .

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]