#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
## Referense site URL: https://noitalog.tokyo/aspnet-core-6-0-react-js-docker/
## docker build -t my-new-app-image .
## docker run -it --rm -d -p 5000:80 my-new-app-image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5000
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

RUN curl -fsSL https://deb.nodesource.com/setup_19.x | bash -
RUN apt-get update && apt-get install -y nodejs
COPY ["my-new-app.csproj", "my-new-app/"]
RUN dotnet restore "my-new-app/my-new-app.csproj"

WORKDIR /src/my-new-app
COPY . .
RUN dotnet build "my-new-app.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "my-new-app.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "my-new-app.dll"]