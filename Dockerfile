# syntax=docker/dockerfile:1

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY BudgetFlow/BudgetFlow.csproj BudgetFlow/
RUN dotnet restore BudgetFlow/BudgetFlow.csproj

# Copy the rest of the source
COPY . .

# Publish
RUN dotnet publish BudgetFlow/BudgetFlow.csproj -c Release -o /app/out

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

# Expose port for Fly.io
ENV ASPNETCORE_URLS=http://0.0.0.0:8080
EXPOSE 8080

# Copy build output
COPY --from=build /app/out .

# Run
ENTRYPOINT ["dotnet", "BudgetFlow.dll"]
