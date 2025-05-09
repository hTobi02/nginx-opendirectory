/s/mergerfs.sh /movies /data/Movies
/s/mergerfs.sh /series /data/Series
/s/mergerfs.sh /music /data/Music
envsubst '$LIMIT_RATE $PORT $EXPIRES $MAX_AGE $LIMIT_RATE_AFTER $PROXY_IP' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Falls $PROXY_IP gesetzt ist, entferne die Kommentarzeichen vor den drei relevanten Zeilen
if [ -n "$PROXY_IP" ]; then
  cp /etc/nginx/conf.d/default.conf.template /tmp/default.conf.template.editing

  sed -i 's|#\s*set_real_ip_from \$PROXY_IP;|set_real_ip_from $PROXY_IP;|' /tmp/default.conf.template.editing
  sed -i 's|#\s*real_ip_header X-Forwarded-For;|real_ip_header X-Forwarded-For;|' /tmp/default.conf.template.editing
  sed -i 's|#\s*real_ip_recursive on;|real_ip_recursive on;|' /tmp/default.conf.template.editing
else
  cp /etc/nginx/conf.d/default.conf.template /tmp/default.conf.template.editing
fi

# Führe envsubst auf der ggf. bearbeiteten Datei aus
envsubst '$HOME_NET $LIMIT_RATE $PORT $EXPIRES $MAX_AGE $LIMIT_RATE_AFTER $PROXY_IP' < /tmp/default.conf.template.editing > /etc/nginx/conf.d/default.conf

nginx -g 'daemon off;'