/s/mergerfs.sh /movies /data/Movies
/s/mergerfs.sh /series /data/Series
/s/mergerfs.sh /music /data/Music
envsubst < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
nginx -g 'daemon off;'