#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 5000
ENV ASPNETCORE_URLS=http://*:5000

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["s3-proj/s3-proj.csproj", "s3-proj/"]
RUN dotnet restore "s3-proj/s3-proj.csproj"
COPY . .
WORKDIR "/src/s3-proj"
RUN dotnet build "s3-proj.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "s3-proj.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "s3-proj.dll"]
