FROM microsoft/aspnetcore:2.0

WORKDIR /app

COPY ./MyApplication/TestApp/publish .

ENTRYPOINT ["dotnet", "TestApp.dll"]

EXPOSE 8080
   