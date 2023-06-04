FROM node:latest
ENV MAX_SIZE = 0

RUN npm install parse-torrent -g

RUN mkdir /output

COPY ./rss.sh /rss.sh

CMD ["bash", "/rss.sh"]
