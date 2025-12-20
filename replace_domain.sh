#!/usr/bin/env bash
set -e

# USAGE:
# ./replace_domain.sh old.domain new.domain

OLD="$1"
NEW="$2"

DIR="/var/www/79club"
NGINX="/etc/nginx/sites-available/default"

[ -z "$OLD" ] || [ -z "$NEW" ] && {
  echo "Usage: $0 old.domain new.domain"
  exit 1
}

P="${OLD//./\\.}"

# replace in web folder (text files only: html, txt, js, css, ...)
grep -rIl "$OLD" "$DIR" | xargs -r sed -i "s/$P/$NEW/g"

# git commit changes in folder
cd "$DIR"
git add .
git commit -m "."
git push

# replace in nginx config
sed -i "s/$P/$NEW/g" "$NGINX"

# test & restart nginx
#nginx -t && systemctl restart nginx

echo "Done: $OLD -> $NEW"

