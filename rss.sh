#!/bin/bash

if [ -z $RSS_KEY ]; then
	echo "ERROR: API_KEY has not been set!"
	exit 1
fi

echo "MAX_SIZE is set to: $MAX_SIZE"
echo "Downloading RSS Feed..."
curl -s https://rss24h.torrentleech.org/$RSS_KEY > /tmp/rss

TORRENTS=$(cat /tmp/rss | grep -E '(link>|description>)' | tail -n +4 | sed -e 's/^[ \t]*//' | sed -e 's/<link>//' -e 's/<\/link>//' -e 's/<description>/  /' -e 's/<\/description>//' | sed -e 's/<!\[CDATA\[//' | sed -e 's/\]\]>//' | grep -A1 'Seeders: 1 \|Seeders: 0 ' | grep https://)
for i in $TORRENTS; do
	curl -s $i > /tmp/${i##*/}
	INPUT=$(parse-torrent /tmp/${i##*/} | grep .length | tail -1 | awk '{print $2}' | tr -d ,)
	SIZE=$((INPUT/(1024*1024)))
	echo "${i##*/} - ${SIZE} MB"
	if [ $SIZE -ge $FREELEECH ]; then
		if [ $SIZE -le $MAX_SIZE ]; then
			echo "Outputing ${i##*/}"
			mv /tmp/${i##*/} /output/
		fi
	fi
done
rm /tmp/*.torrent