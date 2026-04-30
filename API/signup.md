# Signup API

## ■ Endpoint
POST /Signup/Account

## ■ Header

| Name | Required | Description |
|:---|:---:|:---|
| Content-Type | ○ | application/json |
| X-Auth-ClientId | ○ | クライアント識別子 |

## ■ Request Body

```json
{
  "email": "test@example.com",
  "password": "abc123"
}