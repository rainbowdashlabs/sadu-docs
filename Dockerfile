FROM python:3.12 AS base

COPY Pipfile Pipfile.lock ./

RUN pip install pipenv && pipenv sync

COPY . .

RUN pipenv run python tools/build.py

RUN pipenv run mkdocs build -f mkdocs.yml

FROM nginx:alpine

COPY --from=base /site /usr/share/nginx/html

EXPOSE 80
