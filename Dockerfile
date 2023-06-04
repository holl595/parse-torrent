FROM node:latest

ENV FREELEECH=14500
ENV MAX_SIZE = 0
ENV RSS_INTERVAL=30


RUN npm install parse-torrent -g

RUN mkdir /output

COPY ./rss.sh /rss.sh

CMD ["bash", "/rss.sh"]
