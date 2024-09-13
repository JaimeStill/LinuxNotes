# Containers

## SQL Server 2022

```bash
docker run \
    -e "ACCEPT_EULA=Y" \
    -e 'MSSQL_SA_PASSWORD=P@$$Word1234' \
    -p 1433:1433 \
    --name DevSql \
    --hostname DevSql \
    -d mcr.microsoft.com/mssql/server:2022-latest
```

```json
{
  "ConnectionStrings": {
    "Db": "Server=localhost,1433;Encrypt=Mandatory;TrustServerCertificate=True;User=sa;Password=P@$$Word1234;Database=ContaineredDb"
  }
}
```