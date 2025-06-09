#!/bin/sh

echo "Waiting for MySQL to be ready..."
until mysql -h "$PDNS_gmysql_host" -u"$PDNS_gmysql_user" -p"$PDNS_gmysql_password" -e "SELECT 1" "$PDNS_gmysql_dbname"; do
    echo "MySQL not ready, waiting..."
    sleep 2
done

echo "Checking if schema already exists..."
if mysql -h "$PDNS_gmysql_host" -u"$PDNS_gmysql_user" -p"$PDNS_gmysql_password" -e "SELECT 1 FROM domains LIMIT 1;" "$PDNS_gmysql_dbname"; then
    echo "Schema already exists. Skipping import."
    exit 0
fi

echo "Importing schema..."
mysql -h "$PDNS_gmysql_host" -u"$PDNS_gmysql_user" -p"$PDNS_gmysql_password" "$PDNS_gmysql_dbname" </schema/schema.mysql.sql
