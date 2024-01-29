FROM python:3.12

RUN pip install pipenv

COPY Pipfile Pipfile.lock ./

RUN pipenv sync

EXPOSE 80

WORKDIR /docs

COPY mkdocs.yml mkdocs.yml

COPY docs /docs/

COPY .git/ .git/

ENTRYPOINT ["pipenv", "run", "mkdocs", "serve", "-a", "0.0.0.0:80"]
