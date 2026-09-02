#!/bin/bash
set -e

# Set current directory to the script's directory
cd "$(dirname "$0")"

export $(grep -v '^#' /home/shoestring/certbot/.env | xargs)

if [ -z "$CERTBOT_EMAIL" ] || [ -z "$CERTBOT_DOMAINS" ]; then
  echo "Missing CERTBOT_EMAIL or CERTBOT_DOMAINS"
  exit 1
fi

# Attempt renewal
docker run --rm --name certbot \
  -v "./webroot:/var/www/certbot" \
  -v "./certificates:/etc/letsencrypt" \
  -v "./logs:/var/log/letsencrypt" \
  certbot/certbot renew

if [ "$HTTP_SERVER" = "apache" ]; then
  echo "🔄 Reloading Apache in container: $CERT_CONTAINER..."
  docker exec $CERT_CONTAINER apachectl graceful
else
  echo "🔄 Reloading Nginx in container: $CERT_CONTAINER..."
  docker exec $CERT_CONTAINER nginx -s reload
fi

echo "✅ Certificate renewal process complete."

