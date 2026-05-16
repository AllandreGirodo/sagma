# GitHub Secrets - Setup Rapido

Use este checklist com placeholders. Nao copie valores reais para o repositorio.

## Onde cadastrar

1. Settings
2. Secrets and variables
3. Actions
4. New repository secret

## Secrets do app cliente (workflow Flutter)

```text
DB_ADMIN_PASSWORD
ADMIN_EMAIL
WHATSAPP_ADMIN
FIREBASE_PROJECT_ID
FIREBASE_MESSAGING_SENDER_ID
FIREBASE_STORAGE_BUCKET
FIREBASE_WEB_API_KEY
FIREBASE_WEB_APP_ID
FIREBASE_WEB_AUTH_DOMAIN
VAPID_KEY
RECAPTCHA_SITE_KEY
FIREBASE_ANDROID_API_KEY
FIREBASE_ANDROID_APP_ID
FIREBASE_IOS_API_KEY
FIREBASE_IOS_APP_ID
FIREBASE_IOS_CLIENT_ID
FIREBASE_IOS_BUNDLE_ID
PUSH_NOTIFICATION_FUNCTION_NAME
RANDOM_MESSAGES_FUNCTION_NAME
```

## Secrets de deploy (workflow CI)

Necessarios para a etapa de Firebase App Distribution:

```text
FIREBASE_APP_ID_ANDROID
FIREBASE_SERVICE_ACCOUNT_JSON
@sk```

## Secrets somente backend ou secret manager

Nao colocar no .env do app cliente:

```text
FIREBASE_SERVICE_ACCOUNT_JSON
FCM_SERVER_KEY
X_ACCESS_API_KEY
X_MASTER_API_KEY
ACCESS_KEY_ID
PG_PASSWORD
DB_NAME
DB_USER
DB_HOST
DB_PORT
```

## Rotacao de chaves expostas (antes de publicar)

1. Firebase Service Account
- Firebase Console > Project settings > Service accounts
- Revogue chave antiga e gere nova
- Cadastre apenas no secret manager/backend (ou GitHub Secret de deploy)

2. Provedores externos (quando aplicável)
- Revogue `X_MASTER_API_KEY` e `X_ACCESS_API_KEY` antigas
- Gere novas chaves
- Configure somente no backend/Cloud Functions/secret manager

3. Banco e credenciais infra
- Troque senhas e usuarios tecnicos comprometidos
- Atualize apenas backend e secret manager

4. Auditoria final
- Garanta que nenhuma chave real entrou em commit, PR, issue ou chat publico

## Checklist final

- [ ] Secrets do app cliente cadastrados no GitHub Actions
- [ ] Secrets de deploy (FIREBASE_APP_ID_ANDROID e FIREBASE_SERVICE_ACCOUNT_JSON) cadastrados
- [ ] Secrets backend-only cadastrados somente no backend/secret manager
- [ ] Chaves antigas revogadas
- [ ] Novas chaves testadas em ambiente de backend
- [ ] Nenhum segredo real no repositorio
