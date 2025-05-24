#!/bin/sh
set -e

if [ -z "$CERTBOT_EMAIL" ] || [ -z "$CERTBOT_DOMAINS" ]; then
  echo "Missing CERTBOT_EMAIL or CERTBOT_DOMAINS"
  exit 1
fi

# Build -d domain args
DOMAIN_ARGS=""
IFS=',' read -r -a DOMAINS_ARRAY <<< "$CERTBOT_DOMAINS"
for domain in "${DOMAINS_ARRAY[@]}"; do
  DOMAIN_ARGS="$DOMAIN_ARGS -d $domain"
done

# Attempt renewal
certbot renew \
  --webroot \
  -w /var/www/certbot \
  --email "$CERTBOT_EMAIL" \
  --agree-tos \
  --non-interactive \
  $DOMAIN_ARGS

echo "✅ Certificate renewal process complete."

