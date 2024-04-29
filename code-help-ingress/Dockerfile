FROM code-help-admin-ui:latest as builder

FROM nginx:stable

COPY ./nginx.conf /etc/nginx
COPY --from=builder /admin-ui/dist /usr/share/nginx/html/admin-ui

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]