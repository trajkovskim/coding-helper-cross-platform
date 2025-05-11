#!/bin/sh

cp -f  code-help-core/code-help-core-api-docs/src/main/resources/code-help-common-api.yaml code-help-astro-ui/src/docs/
cp -f code-help-core/code-help-core-api-docs/src/main/resources/code-help-core-api.yaml code-help-astro-ui/src/docs/
cp -f code-help-forum/src/main/resources/forum-api.yaml code-help-astro-ui/src/docs/

cp -f code-help-core/code-help-core-api-docs/src/main/resources/code-help-common-api.yaml code-help-admin/code-help-admin-ui/docs/
cp -f code-help-core/code-help-core-api-docs/src/main/resources/code-help-admin-core-api.yaml code-help-admin/code-help-admin-ui/docs/
cp -f code-help-forum/src/main/resources/forum-api.yaml code-help-admin/code-help-admin-ui/docs/code-help-admin-forum-api.yaml

cd code-help-astro-ui && pnpm run generate-types && cd ..
cd code-help-admin/code-help-admin-ui && pnpm run generate-types && cd ../..

