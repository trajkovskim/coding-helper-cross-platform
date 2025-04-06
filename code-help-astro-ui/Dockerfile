FROM node:20-alpine AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
COPY . /app
WORKDIR /app

FROM base AS prod-deps
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile

FROM base AS generateTypes
RUN apk add openjdk21
RUN pnpm run generate-types

FROM base AS build

#ARG VITE_ADMIN_API_URL
#ENV VITE_ADMIN_API_URL=$VITE_ADMIN_API_URL
#ARG VITE_KEYCLOAK_URL
#ENV VITE_KEYCLOAK_URL=$VITE_KEYCLOAK_URL
#ARG VITE_KEYCLOAK_REALM
#ENV VITE_KEYCLOAK_REALM=$VITE_KEYCLOAK_REALM
#ARG VITE_KEYCLOAK_CLIENTID
#ENV VITE_KEYCLOAK_CLIENTID=$VITE_KEYCLOAK_CLIENTID
#ARG VITE_BASE_ROUTE
#ENV VITE_BASE_ROUTE=$VITE_BASE_ROUTE

RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
RUN pnpm run build

ENV HOST=0.0.0.0
ENV PORT=4321

EXPOSE 4321
CMD [ "node", "./dist/server/entry.mjs" ]