FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Developer
ENV SA_PASSWORD=YourStrong!Passw0rd

# 設定ファイルをコンテナにコピー
# COPY ./sqlserver.conf /var/opt/mssql/sqlserver.conf

# RUN echo "PS1='\u@\h(\$(hostname -i)):\w \\$ '" >> ~/.bashrc

# 起動時に設定ファイルを使うように CMD を変更（必要に応じて）
# CMD ["/opt/mssql/bin/sqlservr", "--configfile", "/var/opt/mssql/sqlserver.conf"]
