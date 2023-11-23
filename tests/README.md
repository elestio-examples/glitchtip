<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# GlitchTip, verified and packaged by Elestio

With [GlitchTip](https://glitchtip.com/) , you can rest easy knowing that if your web app throws an error or goes down, you will be notified immediately. GlitchTip combines error tracking and uptime monitoring in one open-source package to keep you and your team fully up-to-date on the status of your projects.

<img src="https://github.com/elestio-examples/glitchtip/raw/main/glitchtip.png" alt="GlitchTip" width="800">

Deploy a <a target="_blank" href="https://elest.io/open-source/glitchtip">fully managed GlitchTip</a> on <a target="_blank" href="https://elest.io/">elest.io</a> if you are interested in an open source all-in-one devops platform with the ability to manage git repositories, manage issues, and run continuous integrations.

[![deploy](https://github.com/elestio-examples/glitchtip/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?soft=glitchtip)

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/glitchtip.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Create data folders with correct permissions

Run the project with the following command

    docker-compose up -d

You can access the Web UI at: `http://your-domain:6610`

## Docker-compose

Here are some example snippets to help you get started creating a container.

        version: "3.8"
        x-environment: &default-environment
        DATABASE_URL: postgres://postgres:${DB_PASSWORD}@postgres:5432/glitchtip
        SECRET_KEY: ${SECRET_KEY}
        PORT: 8000
        EMAIL_URL: smtp://172.17.0.1:25/?skip_ssl_verify=true&legacy_ssl=false&smtp_ssl_enabled=false&disable_starttls=true
        GLITCHTIP_DOMAIN: https://${DOMAIN}
        DEFAULT_FROM_EMAIL: ${DEFAULT_FROM_EMAIL}
        CELERY_WORKER_AUTOSCALE: "1,3" # Scale between 1 and 3 to prevent excessive memory usage. Change it or remove to set it to the number of cpu cores.
        CELERY_WORKER_MAX_TASKS_PER_CHILD: "10000"

        x-depends_on: &default-depends_on
        - postgres
        - redis

        services:
        postgres:
            image: elestio/postgres:15
            restart: always
            environment:
            POSTGRES_DB: glitchtip
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: ${DB_PASSWORD}
            PGDATA: /var/lib/postgresql/data
            volumes:
            - ./pg-data:/var/lib/postgresql/data
            ports:
            - 172.17.0.1:34948:5432
        redis:
            image: elestio/redis:7.0
        web:
            image: elestio4test/glitchtip
            restart: always
            depends_on: *default-depends_on
            ports:
            - "172.17.0.1:4024:8000"
            environment: *default-environment
            volumes:
            - ./uploads:/code/uploads
        worker:
            image: elestio4test/glitchtip
            restart: always
            command: ./bin/run-celery-with-beat.sh
            depends_on: *default-depends_on
            environment: *default-environment
            volumes:
            - ./uploads:/code/uploads
        migrate:
            image: elestio4test/glitchtip
            depends_on: *default-depends_on
            command: "./manage.py migrate"
            environment: *default-environment

        pgadmin4:
            image: dpage/pgadmin4:latest
            restart: always
            environment:
            PGADMIN_DEFAULT_EMAIL: ${ADMIN_EMAIL}
            PGADMIN_DEFAULT_PASSWORD: ${ADMIN_PASSWORD}
            PGADMIN_LISTEN_PORT: 8080
            ports:
            - "172.17.0.1:38619:8080"
            volumes:
            - ./servers.json:/pgadmin4/servers.json


### Environment variables

|       Variable       | Value (example) |
| :------------------: | :-------------: |
| SOFTWARE_VERSION_TAG |     latest      |
|  DEFAULT_FROM_EMAIL  |      EMAIL      |
|     ADMIN_EMAIL      |  test@mail.com  |
|    ADMIN_PASSWORD    |    password     |
|     DOMAIN           |    http://url   |
|   DB_PASSWORD        |    password     |
|   REDIS_PASSWORD     |    password     |

# Maintenance

## Logging

The Elestio GlitchTip Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://gitlab.com/glitchtip/glitchtip-backend">GlitchTip Github repository</a>

- <a target="_blank" href="https://glitchtip.com/documentation">GlitchTip documentation</a>

- <a target="_blank" href="https://github.com/elestio-examples/glitchtip">Elestio/GlitchTip Github repository</a>
