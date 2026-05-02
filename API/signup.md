# Signup API

## ■ Endpoint
POST /Signup/Account

## ■ Header

| Name | Required |  Regex |Description |
|:---|:---:|:---|:---|
| Content-Type | ○ | - | application/json |
| X-Auth-ClientId | ○ | ^[0-9]{32}$ | クライアント識別子 |

## ■ Request Body

```json
{
  "email": "test@example.com",
  "password": "abc123"
}