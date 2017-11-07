# Continuous Integration for .Net Core
## With Docker and TeamCity

_This is an incomplete Work-in-Progress._

This is a demo of how to set up Continuous Integration or Continuous
Deployment for a C# DotNet Core / SQL Server / TypeScript project using
TeamCity, Docker and Linux.

## TeamCity Setup

1. Set the SQL Server password in [docker-compose.yml](https://github.com/mikebridge/TeamCityDotNetCore/blob/master/docker-compose.yml#L24).  [See the Microsoft documentation](https://hub.docker.com/r/microsoft/mssql-server-linux/) for more information on using the `mssql-server-linux` docker image

2. Create an empty directory `${HOME}/data`.  This will contain several subdirectories that will be mounted in the various docker containers.

3. Run `docker-compose up` to build and run the basic TeamCity server on port 8111.

4. Navigate to [http://localhost:8111](http://localhost:8111).

5. Download the correct version of [sqljdbc](https://docs.microsoft.com/en-us/sql/connect/jdbc/download-microsoft-jdbc-driver-for-sql-server) and copy it toto `data/datadir/lib/jdbc`.  I'm using [sqljdbc42.jar](https://www.microsoft.com/en-us/download/details.aspx?id=54671).

## 

TODO: Describe the build / deploy setups.


