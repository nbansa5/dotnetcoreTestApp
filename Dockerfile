FROM microsoft/aspnetcore:2.0

RUN apt-get update
RUN apt-get install -y nginx

WORKDIR /app

COPY ./TestApp/bin/Release/netcoreapp2.1 .

RUN rm /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx

service nginx start

ENTRYPOINT ["dotnet", "TestApp.dll"]

ENV ASPNETCORE_URLS http://+:5000
EXPOSE 5000 80

   