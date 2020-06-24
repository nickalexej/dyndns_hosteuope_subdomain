#!/bin/sh
#aktualisiert DNS-Einträge bei HostEurope
#OriginalPorjekt von Christian Ulbrich
#https://gist.github.com/ChristianUlbrich/6412229

#HostEurope-Zugangsdaten
KUNDENNR=xxx
PASSWORD=xxx
#Host-ID des eigentlichen Eintrages
HOSTID=xxx

#externe IP bestimmen und dann vergleichen
IP=$(wget -qO- ifconfig.me/ip)
UPDATEIP=false

if [ -f /var/run/current.ip ]
then
    #Vergleich, ob IP sich geändert hat, wenn ja, dann Update erzwingen
    oldIP=$(cat /var/run/current.ip)
    if [ $oldIP != $IP ]
    then
      UPDATEIP=true
    fi
else
	echo $IP > /var/run/current.ip
	UPDATEIP=true
fi

#bei Bedarf ein Update machen

if $UPDATEIP ; then
	curl -k --url "https://kis.hosteurope.de/?kdnummer=$KUNDENNR&passwd=$PASSWORD" --url "https://kis.hosteurope.de/administration/domainservices/index.php?record=A&pointer=$IP&menu=1&mode=autodns&domain=zalari.de&submode=edit&truemode=host&hostid=$HOSTID&submit=Update" -c /dev/null >/dev/null 2>1
fi
