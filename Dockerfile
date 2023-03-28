# Build: docker build -t blazor-js-test .
# Run: docker run -p 8080:80 blazor-js-test

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

COPY "blazor-js-test.sln" .
COPY ["Client/blazor-js-test.Client.csproj", "Client/"]
COPY ["Server/blazor-js-test.Server.csproj", "Server/"]

RUN dotnet restore

COPY . .

RUN dotnet build "Server/blazor-js-test.Server.csproj" -c Release -o /app/build

FROM build AS publish

RUN dotnet publish "Server/blazor-js-test.Server.csproj" -c Release -o /app/publish

FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html
COPY --from=publish /app/publish/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf
