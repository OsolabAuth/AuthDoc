# Release Workflow

## 目的

AuthFoundation の移植後ブランチでも、既存運用で使っていたリリース経路を維持する。

対象は次の2系統とする。

- GitHub Container Registry への image build / push と deploy repository への dispatch
- Cloud Run への手動 build / deploy

## 方針

リリース workflow はアプリケーション機能ではなく運用基盤として扱う。

そのため、実装リポジトリには workflow と実行に必要な最小ファイルだけを置き、設計と運用方針は AuthDoc で管理する。

## Workflow

### Build Push And Dispatch Deploy

`.github/workflows/build-push-dispatch.yml`

目的:

- AuthFoundation の Docker image を build する。
- GHCR に commit SHA tag で push する。
- `AUTH_DEPLOY_REPO` と `AUTH_DEPLOY_REPO_TOKEN` が設定されている場合、deploy repository へ `repository_dispatch` を送る。

主な入力:

- `vars.AUTH_DEPLOY_REPO`
- `secrets.AUTH_DEPLOY_REPO_TOKEN`

出力:

- `ghcr.io/{owner}/authfoundation:{sha}`
- dispatch payload:

```json
{
  "event_type": "deploy-service",
  "client_payload": {
    "service": "authfoundation-web",
    "image_tag": "{sha}"
  }
}
```

### Build and Deploy Auth to Cloud Run

`.github/workflows/deploy-cloud-run.yml`

目的:

- Artifact Registry 向け Docker image を build / push する。
- `deploy=true` の場合、Cloud Run service を更新する。
- runtime secret が不足、または古すぎる場合は deploy を止める。
- 最新 revision が ready になったことを検証する。

主な入力:

- `deploy`
- `image_tag`

主な repository variables:

- `GCP_PROJECT_ID`
- `GCP_REGION`
- `ARTIFACT_REGISTRY_REPOSITORY`
- `CLOUD_RUN_SERVICE`
- `CLOUD_RUN_IMAGE_NAME`
- `CLOUD_RUN_UPDATE_ENV_VARS`
- `CLOUD_RUN_UPDATE_SECRETS`
- `CLOUD_RUN_SECRET_MAX_AGE_DAYS`
- `AUTH_ISSUER`

主な secrets:

- `GCP_WORKLOAD_IDENTITY_PROVIDER`
- `GCP_SERVICE_ACCOUNT`

## 実装対象ファイル

AuthFoundation repository:

- `.github/workflows/build-push-dispatch.yml`
- `.github/workflows/deploy-cloud-run.yml`
- `AuthFoundation/Dockerfile`
- `scripts/build-cloud-run-image.ps1`

## テスト観点

- `dotnet build` が成功する。
- `dotnet test` が成功する。
- `docker build --file AuthFoundation/Dockerfile AuthFoundation` が成功する。
- workflow YAML の参照ファイルが repository に存在する。
- PR description にテスト結果と、実行できない検証があれば理由を記載する。
