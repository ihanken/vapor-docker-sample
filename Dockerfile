FROM swift:3.1

RUN apt-get update && apt-get install -y \
libpq-dev

RUN ls -al
ADD /sample-app /vapor
RUN ls -al
WORKDIR /vapor

RUN ls -al
RUN swift --version


RUN swift build --configuration release

EXPOSE 8080

CMD .build/release/Run
