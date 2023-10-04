# dockerize-ws2019
#
- docker build -t wsrdp:2019 .
- docker run -d -p 3389:3389 --name ws2019 wsrdp:2019
