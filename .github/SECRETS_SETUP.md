# Configuracao de GitHub Secrets

Este documento descreve o que deve ficar em GitHub Secrets para CI/CD e o que
nao deve permanecer no app cliente.

## Regra principal

- Variaveis client-safe podem existir no .env do app e no secret ENV_FILE.
- Segredos reais de servidor nao devem ir para o .env do app cliente.
- FCM server key, conta de servico do Firebase e senhas de
  banco devem ficar somente no backend, Cloud Functions ou GitHub Secrets.

## Como cadastrar

1. Acesse Settings > Secrets and variables > Actions.
2. Clique em New repository secret.
3. Cadastre apenas placeholders/valores do seu ambiente, nunca os exemplos deste repo.

## Secrets do app cliente

Cadastre os valores equivalentes ao seu .env local ou use um unico ENV_FILE.

- DB_ADMIN_PASSWORD=sua_senha_devtools
- ADMIN_EMAIL=admin@seu-dominio.com
- WHATSAPP_ADMIN=5511999999999
- FIREBASE_PROJECT_ID=seu-project-id
- FIREBASE_MESSAGING_SENDER_ID=123456789012
- FIREBASE_STORAGE_BUCKET=seu-project-id.firebasestorage.app
- FIREBASE_WEB_API_KEY=sua_api_key_web
- FIREBASE_WEB_APP_ID=1:123456789012:web:abcdef123456
- FIREBASE_WEB_AUTH_DOMAIN=seu-project-id.firebaseapp.com
- VAPID_KEY=sua_vapid_key_publica
- RECAPTCHA_SITE_KEY=sua_recaptcha_site_key_publica
- FIREBASE_ANDROID_API_KEY=sua_api_key_android
- FIREBASE_ANDROID_APP_ID=1:123456789012:android:abcdef123456
- FIREBASE_IOS_API_KEY=sua_api_key_ios
- FIREBASE_IOS_APP_ID=1:123456789012:ios:abcdef123456
- FIREBASE_IOS_CLIENT_ID=123456789012-abcdef.apps.googleusercontent.com
- FIREBASE_IOS_BUNDLE_ID=com.example.agenda
- PUSH_NOTIFICATION_FUNCTION_NAME=enviarNotificacaoPush
- RANDOM_MESSAGES_FUNCTION_NAME=dispararMensagensAleatoriasClientesManual

Esses valores geram o `.env` do app no workflow Flutter.

## Secrets de deploy (CI/CD)

- FIREBASE_APP_ID_ANDROID
- FIREBASE_SERVICE_ACCOUNT_JSON

Estes secrets sao usados apenas pela etapa de distribuicao no Firebase App Distribution.

## Secrets somente backend

Estes valores nao devem permanecer no .env do app cliente:

- FIREBASE_SERVICE_ACCOUNT_JSON
- FCM_SERVER_KEY
- X_ACCESS_API_KEY
- X_MASTER_API_KEY
- ACCESS_KEY_ID
- PG_PASSWORD
- DB_NAME
- DB_USER
- DB_HOST
- DB_PORT

Estes valores nao sao mais injetados no `.env` do app cliente pelo `flutter_ci.yml`.

## Seguranca

1. Nunca commite .env.
2. Nunca versione serviceAccountKey.json, google-services.json ou GoogleService-Info.plist se houver dados privados do seu ambiente.
3. Se alguma chave real ja apareceu em commit, PR, issue ou conversa publica, faca rotacao.
4. Prefira backend/Cloud Functions para qualquer operacao que exija segredo.

## Opcao ENV_FILE

Se preferir um unico secret para CI, crie ENV_FILE com o conteudo do .env do app:

```yaml
- name: Create .env from secret
  run: echo "${{ secrets.ENV_FILE }}" > .env
```

Mantenha os segredos de backend em secrets separados do backend, nao dentro do ENV_FILE do app cliente.
