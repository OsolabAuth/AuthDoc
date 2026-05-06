# トークンエンドポイント

## ■ Endpoint
Post /token
## Request

### ■ Header

| Name | Required | Regex |Description |
|:---|:---:|:---|:---|
| x-flow-type | ○ | - | AuthorizationCode |
| Content-Type | ○ | - | application/json |
| Authorization | - | - | Base64(クライアントID:クライアントシークレット) |

### ■ Query
なし

### ■ Body

| Name | Required | Regex |Description |
|:---|:---:|:---|:---|
| x-flow-type | ○ | - | AuthorizationCode |
| Content-Type | ○ | - | application/json |

## Response
### ■ Header
なし

### ■ Body
```json
{
}
```