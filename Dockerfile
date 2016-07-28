FROM node:slim
MAINTAINER david.enke@zalari.de
WORKDIR /tmp
RUN npm install -g protractor mocha mocha-multi mocha-proshot chai chai-as-promised
RUN webdriver-manager update
RUN apt-get update && apt-get install -y --force-yes xvfb wget openjdk-7-jre
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update && apt-get install -y --force-yes google-chrome-stable && apt-get clean
RUN mkdir /protractor
COPY ./protractor.sh /protractor.sh
# Fix for the issue with Selenium, as described here:
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
WORKDIR /protractor
ENTRYPOINT ["/protractor.sh"]
