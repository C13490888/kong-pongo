#!/bin/sh

# if we have preferences for busted set, move them to /kong
# such that busted will pick them up automagically
if [ -f /kong-plugin/.busted ]; then
  cp /kong-plugin/.busted /kong/
fi

# add the plugin code to the LUA_PATH such that the plugin will be found
export "LUA_PATH=/kong-plugin/?.lua;/kong-plugin/?/init.lua;;"

# DNS resolution on docker always has this ip. Since we have a qualified
# name for the db server, we need to set up the DNS resolver, is set
# to 8.8.8.8 on the spec conf
export KONG_DNS_RESOLVER=127.0.0.11

# set working dir in mounted volume to be able to check the logs
export KONG_PREFIX=/kong-plugin/servroot

# export the KONG_ variables also in the KONG_TEST_ range
if [ -z "$KONG_TEST_LICENSE_DATA" ]; then
  export "KONG_TEST_LICENSE_DATA=$KONG_LICENSE_DATA"
fi

if [ -z "$KONG_TEST_PG_HOST" ]; then
  export "KONG_TEST_PG_HOST=$KONG_PG_HOST"
fi

if [ -z "$KONG_TEST_CASSANDRA_CONTACT_POINTS" ]; then
  export "KONG_TEST_CASSANDRA_CONTACT_POINTS=$KONG_CASSANDRA_CONTACT_POINTS"
fi

if [ -z "$KONG_TEST_PREFIX" ]; then
  export "KONG_TEST_PREFIX=$KONG_PREFIX"
fi

if [ -z "$KONG_TEST_DNS_RESOLVER" ]; then
  export "KONG_TEST_DNS_RESOLVER=$KONG_DNS_RESOLVER"
fi

exec "$@"