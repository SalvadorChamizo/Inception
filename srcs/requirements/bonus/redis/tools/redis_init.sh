#!/bin/sh

# This creates a backup file for the redis.conf file if the .bak doesn't already exists.
if [ ! -f /etc/redis/redis.conf.bak ]; then
    cp /etc/redis/redis.conf /etc/redis/redis.conf.bak
fi

# This command will search for the line "bind 127.0.0.1" and will comment it out. This will allow /
# external connections by disabling binding to localhost.
sed -i "s|bind 127.0.0.1|#bind 127.0.0.1|g" /etc/redis/redis.conf

# This command will set a password for redis if the enviroment variable is found.
if [ ! -z "$REDIS_PASSWORD" ]; then
    sed -i "s|# requirepass foobared|requirepass $REDIS_PASSWORD|g" /etc/redis/redis.conf
fi

# This line will set the maximum memory to 2mb
sed -i "s|# maxmemory <bytes>|maxmemory 2mb|g" /etc/redis/redis.conf

# This line will change the memory policy. Noeviction means that if redis runs out of memory, \
# it refuses new writes. allkeys-lru will allow redis to remove the least recently used (lru) key when memory is full.
sed -i "s|# maxmemory-policy noeviction|maxmemory-policy allkeys-lru|g" /etc/redis/redis.conf

# Runs redis-server in the foreground.
redis-server --daemonize no
