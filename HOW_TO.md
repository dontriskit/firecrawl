docker compose build
docker compose up

```bash
curl -X POST http://localhost:3002/v1/crawl \
    -H 'Content-Type: application/json' \
    -d '{
      "url": "https://hardbox.eu"
    }'
```
check crawl

```bash

curl -X GET http://localhost:3002/v1/crawl/2505ea17-6aaa-42e1-8816-db992b46c761 \
    -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer sk-123'

curl -X GET
```
curl -X GET 

to po sitemap chyba leci

```bash
curl -X POST http://localhost:3002/v1/map \
    -H 'Content-Type: application/json' \
    -d '{
      "url": "https://www.synthesized.io/"
    }'
```
```bash
curl -X POST "http://localhost:3002/v1/llmstxt" \
  -H "Authorization: Bearer your_api_key" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://hardbox.eu",
    "maxUrls": 100,
    "showFullText": true
  }'

  curl -X GET "http://localhost:3002/v1/llmstxt/1825c415-1b8c-48b8-a5a7-fdb5cccbc906" \
  -H "Authorization: Bearer your_api_key"
  ```
```

  curl -X POST http://localhost:3002/v1/extract \
    -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer YOUR_API_KEY' \
    -d '{
      "urls": [
        "https://firecrawl.dev/", 
        "https://docs.firecrawl.dev/", 
        "https://www.ycombinator.com/companies"
      ],
      "prompt": "Extract the company mission, whether it supports SSO, whether it is open source, and whether it is in Y Combinator from the page.",
      "schema": {
        "type": "object",
        "properties": {
          "company_mission": {
            "type": "string"
          },
          "supports_sso": {
            "type": "boolean"
          },
          "is_open_source": {
            "type": "boolean"
          },
          "is_in_yc": {
            "type": "boolean"
          }
        },
        "required": [
          "company_mission",
          "supports_sso",
          "is_open_source",
          "is_in_yc"
        ]
      }
    }'

```