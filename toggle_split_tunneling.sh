#!/bin/bash
# Скрипт включения/отключения split tunneling через IP-маршруты
set -e

JSON_FILE='/root/ip-list.json'
VPN_INTERFACE='amn0'
VPN_TABLE='splitvpn'
VPN_SUBNET='172.29.172.0/24'
STATE_FILE='/root/.splitvpn_enabled'

if [ -f "$STATE_FILE" ]; then
  echo '🔻 Отключение split tunneling...'
  jq -r '.[] | .[]' "$JSON_FILE" | sort -u | while read ip; do
    ip route del "$ip" dev "$VPN_INTERFACE" table "$VPN_TABLE" 2>/dev/null || true
  done
  ip rule del from "$VPN_SUBNET" table "$VPN_TABLE" 2>/dev/null || true
  rm "$STATE_FILE"
  echo '✅ Split tunneling отключён.'
else
  echo '🔺 Включение split tunneling...'
  grep -q "100 $VPN_TABLE" /etc/iproute2/rt_tables || echo "100 $VPN_TABLE" >> /etc/iproute2/rt_tables
  ip rule add from "$VPN_SUBNET" table "$VPN_TABLE" || true
  jq -r '.[] | .[]' "$JSON_FILE" | sort -u | while read ip; do
    ip route add "$ip" dev "$VPN_INTERFACE" table "$VPN_TABLE" || true
  done
  touch "$STATE_FILE"
  echo '✅ Split tunneling включён.'
fi