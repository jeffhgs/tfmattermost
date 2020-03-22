version: "3"

# based on: https://docs.mattermost.com/install/prod-docker.html

services:

#  db:
#    build: db
#    read_only: true
#    restart: unless-stopped
#    volumes:
#      - ./volumes/db/var/lib/postgresql/data:/var/lib/postgresql/data
#      - /etc/localtime:/etc/localtime:ro
#    environment:
#      - POSTGRES_USER=mmuser
#      - POSTGRES_PASSWORD=mmuser_password
#      - POSTGRES_DB=mattermost
    # uncomment the following to enable backup
    #  - AWS_ACCESS_KEY_ID=XXXX
    #  - AWS_SECRET_ACCESS_KEY=XXXX
    #  - WALE_S3_PREFIX=s3://BUCKET_NAME/PATH
    #  - AWS_REGION=us-east-1

  app:
    build: app
      # change `build:app` to `build:` and uncomment following lines for team edition or change UID/GID
      # context: app
      # args:
      #   - edition=team
      #   - PUID=1000
      #   - PGID=1000
    restart: unless-stopped
    volumes:
      - ./volumes/app/mattermost/config:/mattermost/config:rw
      - ./volumes/app/mattermost/data:/mattermost/data:rw
      - ./volumes/app/mattermost/logs:/mattermost/logs:rw
      - ./volumes/app/mattermost/plugins:/mattermost/plugins:rw
      - ./volumes/app/mattermost/client-plugins:/mattermost/client/plugins:rw
      - /etc/localtime:/etc/localtime:ro
    environment:
      # set same as db credentials and dbname
      - MM_USERNAME=mmuser
      - MM_PASSWORD=${db_password}
      - MM_DBNAME=mattermost

      - MM_SQLSETTINGS_DATASOURCE=mysql://mmuser:${db_password}@${db_host}:3306/mattermost?sslmode=disable&connect_timeout=10

      # in case your config is not in default location
      #- MM_CONFIG=/mattermost/config/config.json

  web:
    build: web
    ports:
      - "80:80"
      - "443:443"
    read_only: true
    restart: unless-stopped
    volumes:
      # This directory must have cert files if you want to enable SSL
      - ./volumes/web/cert:/cert:ro
      - /etc/localtime:/etc/localtime:ro
    # Uncomment for SSL
    # environment:
    #  - MATTERMOST_ENABLE_SSL=true
