# Continuous Integration for .Net Core
## With Docker and TeamCity

_This is an incomplete Work-in-Progress._

This is a demo of how to set up Continuous Integration or Continuous
Deployment for a C# DotNet Core / SQL Server / TypeScript project using
TeamCity, Docker and Linux.

## Setup

1. Set the SQL Server password in [docker-compose.yml](https://github.com/mikebridge/TeamCityDotNetCore/blob/master/docker-compose.yml#L24).  [See the Microsoft documentation](https://hub.docker.com/r/microsoft/mssql-server-linux/) for more information on using the `mssql-server-linux` docker image

2. Run `docker-compose up` to build and run the basic TeamCity server on port 8111.



