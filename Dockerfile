FROM vapor/vapor:latest

RUN apt-get update && apt-get install -y \
libpq-dev

RUN mkdir -p /vapor
ADD /sample-app /vapor
WORKDIR /vapor
RUN swift --version

RUN swift build --configuration release

EXPOSE 8080

CMD .build/release/Run
