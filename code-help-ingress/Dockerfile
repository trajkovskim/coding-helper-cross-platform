FROM nginx:stable

WORKDIR /etc/nginx

RUN rm conf.d/*
# RUN rm nginx.conf

COPY ./code-help-ingress/nginx.conf conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]