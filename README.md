# eanserver
As simple as possible REST API to DB of products based on its EAN or more broadly GTIN

This server requries server.key and server.crt files, but as it is used in closed environment,
I'm using self-signed one. I followed instruction from:
https://github.com/denji/golang-tls

Exmaple request:
https://example.domain:10000/product/ean/4056489120155

Example answer:
{"Id":1,"Name":"Słodkie bułki 10szt","EAN":"4056489120155","Category":"unknown","Simplename":"Słodkie bulki","Manufacturer":"Lidl","Amount":10,"Unit":"pcs","Brand":""}

Structure of the Database in database.sql file.
