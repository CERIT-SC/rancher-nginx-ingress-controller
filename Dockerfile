FROM rancher/nginx-ingress-controller:v1.12.4-hardened2
COPY custom-errors/ /usr/local/nginx/html/custom-errors/
COPY nginx.tmpl /etc/nginx/template/nginx.tmpl
