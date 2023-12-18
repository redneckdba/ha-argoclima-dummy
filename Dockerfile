ARG BUILD_FROM
FROM $BUILD_FROM as base

ENV LANG C.UTF-8
ARG BUILD_VERSION

RUN apk add --no-cache go

# Dependencies and build
FROM base as dependencies_and_build

RUN apk add --no-cache go git && \
  git clone --depth 1 \
  https://github.com/redneckdba/ha-argoclima-dummy.git /app && \
  cd app/dist && \
  go build .

# Release
FROM base as release

WORKDIR /app

COPY --from=dependencies_and_build /app/dist/ac-dummy /app/ac-dummy
COPY run.sh /app

ENV NODE_ENV production

RUN chmod a+x /app/run.sh
CMD [ "/app/run.sh" ]
