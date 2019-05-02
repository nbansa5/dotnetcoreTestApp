FROM mcr.microsoft.com/dotnet/core/aspnet:2.1

RUN apt-get update
RUN apt-get install -y nginx

WORKDIR /app

COPY /TestApp/publishedApp /app

RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx

ENV ASPNETCORE_URLS http://+:5000
EXPOSE 5000 80

ENTRYPOINT ["dotnet", "TestApp.dll"]



CMD ["sh", "/app/startup.sh"]



   