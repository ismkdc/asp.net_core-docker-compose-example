#build container
FROM mcr.microsoft.com/dotnet/core/sdk:2.2.300-alpine3.9 as build
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY src/*.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY src/. ./
RUN dotnet publish -c Release -o out --runtime=alpine-x64

#runtime container
FROM mcr.microsoft.com/dotnet/core/runtime:2.2.5-alpine3.9

WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "example_app.dll"]