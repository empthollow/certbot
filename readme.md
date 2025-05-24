## create `.env` file
```bash
CERTBOT_EMAIL=you@example.com
CERTBOT_DOMAINS=site1.com,www.site1.com,site2.com,www.site2.com,site3.com,www.site3.com,site4.com,www.site4.com
```
## issue certificates first time
```bash
export $(grep -v '^#' .env | xargs) && docker compose run --rm certbot certonly --webroot -w /var/www/certbot $(printf -- '-d %s ' ${CERTBOT_DOMAINS//,/ }) --email $CERTBOT_EMAIL --agree-tos --non-interactive
```
## start the container and renewal
```bash
docker compose run --rm certbot
```
## cron job command
```bash
0 3 * * 1 docker compose up --abort-on-container-exit certbot >> /var/log/certbot-renew.log 2>&1
```
## for the web server to read the certs these directories need to be mounted in the httpd yaml
```bash
volumes:
      - ./conf:/etc/letsencrypt
      - ./webroot:/var/www/certbot
```
