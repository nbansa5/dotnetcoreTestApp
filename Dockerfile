FROM microsoft/aspnetcore:2.0

WORKDIR /app

COPY ./TestApp/bin/Release/netcoreapp2.1 .

ENTRYPOINT ["dotnet", "TestApp.dll"]

EXPOSE 8080
   