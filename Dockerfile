FROM node:lts-alpine as build-stage

ARG NODE_ENV
ARG VUE_APP_MAPBOX
ARG VUE_APP_GOOGLE_TAG

ENV NODE_ENV=${NODE_ENV}
ENV VUE_APP_MAPBOX=${VUE_APP_MAPBOX}
ENV VUE_APP_GOOGLE_TAG=${VUE_APP_GOOGLE_TAG}

WORKDIR /app

COPY package.json yarn.lock /app/
RUN yarn install

COPY . /app
RUN NODE_ENV=$NODE_ENV yarn build

FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/conf.d

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
