#!/usr/bin/env bash


git clone https://github.com/rh-cssre/glitchtip-frontend.git
cd glitchtip-frontend/
npm ci install --force
npm run build-prod
cd ..
mkdir dist
cp -rf glitchtip-frontend/dist/glitchtip-frontend/* ./dist/
rm -rf glitchtip-frontend/

sed -i 's/ARG IS_CI/ARG IS_CI="True"/g' Dockerfile
sed -i 's/ARG COLLECT_STATIC/ARG COLLECT_STATIC="True"/g' Dockerfile

docker buildx build . --output type=docker,name=elestio4test/glitchtip:latest | docker load
