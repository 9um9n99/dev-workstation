FROM nginx:alpine
LABEL description="Codyssey dev-workstation mission web server"
COPY app/ /usr/share/nginx/html/
EXPOSE 80
