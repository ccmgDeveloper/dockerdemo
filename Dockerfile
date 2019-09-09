FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 8080

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY ["Cosmic.WebApp/Cosmic.WebApp.csproj", "Cosmic.WebApp/"]
RUN dotnet restore "Cosmic.WebApp/Cosmic.WebApp.csproj"
COPY . .
WORKDIR "/src/Cosmic.WebApp"
RUN dotnet build "Cosmic.WebApp.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Cosmic.WebApp.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Cosmic.WebApp.dll"]
