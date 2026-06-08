# AI Agent Delegated Scope Policy

## 目的

AI Agent Delegated Auth の初期実装では、agent に委譲できる操作を低リスクな課題管理操作へ限定する。

agent 作成時に任意の scope を保存できると、将来 `task_delete` や `project_admin` のような高リスク操作を誤って委譲できる。Phase 1 では、AuthFoundation 側で許可リストを持ち、作成時と token 発行時の両方で検証する。

## Phase 1で許可するscope

| scope | 用途 |
| --- | --- |
| `task_read` | 課題の閲覧 |
| `task_create` | 課題の作成 |
| `task_comment` | 課題へのコメント |

## 拒否するscope

以下は初期実装では拒否する。

- 許可リストにないscope
- 空のscope
- agent作成時の高リスクscope
- token発行時にdelegation外のscope

例:

- `task_delete`
- `project_admin`
- `user_invite`
- `permission_change`

## API検証方針

### POST /agent

`scope` に含まれる全scopeが許可リスト内であることを検証する。

検証に失敗した場合:

```json
{
  "response_code": "00009",
  "error": "invalid_scope",
  "error_description": "invalid scope"
}
```

### POST /agent/token

次の2段階で検証する。

1. 要求scopeが許可リスト内であること
2. 要求scopeがagent delegationに保存済みscopeの部分集合であること

どちらかに失敗した場合は `invalid_scope` を返す。

## テスト観点

- `task_read task_create task_comment` はagent作成できる。
- `task_delete` を含むagent作成は `invalid_scope`。
- token発行時に `task_delete` を要求すると `invalid_scope`。
- delegationに含まれない許可scopeを要求すると `invalid_scope`。
