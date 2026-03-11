# 🚀 ANTES DE COMEÇAR

Se você **clonou este repositório**, siga este checklist **antes de fazer qualquer coisa**.

## ✅ paso a Paso - Configuração Inicial

### 1️⃣ Configure os GitHub Secrets

**⚠️ CRÍTICO:** O CI/CD deste projeto depende de GitHub Secrets para funcionar.

- 📋 Guia detalhado: [`.github/SECRETS_SETUP.md`](.github/SECRETS_SETUP.md)
- ⚡ Checklist rápido: [`.github/SECRETS_QUICK_SETUP.md`](.github/SECRETS_QUICK_SETUP.md) (recomendado)

**Resumo:**
1. Acesse seu repositório no GitHub
2. Vá para **Settings > Secrets and variables > Actions**
3. Cadastre cada secret da [lista de checklist](.github/SECRETS_QUICK_SETUP.md)
4. ✅ Pronto! Agora os workflows funcionarão

**Tempo:** ~20 minutos

---

### 2️⃣ Configure o Arquivo Local .env

Crie um arquivo `.env` na raiz do projeto (use como template):

```bash
cp .env.example .env
```

Ou configure manualmente com seus valores locais (veja `.env.example`).

**Nota:** O arquivo `.env` é ignorado no Git — use-o apenas localmente.

---

### 3️⃣ Instale as Dependências

```bash
flutter pub get
```

---

### 4️⃣ Teste o Projeto

```bash
flutter run
```

---

## 🔐 Segurança

- ✅ O arquivo `.env` (local) está no `.gitignore`
- ✅ Archivos de secrets (`.github/SECRETS_*.md`) estão no `.gitignore`
- ✅ Valores reais ficam em **GitHub Secrets** (100% ocultos)
- ✅ Credenciais do Firebase (`.json`) estão no `.gitignore`

**Nunca commite:** `.env`, `serviceAccountKey.json`, ou qualquer arquivo com credenciais reais.

---

## 📚 Documentação Adicional

- **Variáveis de ambiente:** [`.env.example`](.env.example)
- **Secrets do GitHub:** [`.github/SECRETS_SETUP.md`](.github/SECRETS_SETUP.md)
- **Setup Rápido:** [`.github/SECRETS_QUICK_SETUP.md`](.github/SECRETS_QUICK_SETUP.md)

---

## ❓ Problemas Comuns

### ❌ "Testes falhando sem motivo aparente"
→ Você cadastrou os GitHub Secrets? Veja [SECRETS_QUICK_SETUP.md](.github/SECRETS_QUICK_SETUP.md)

### ❌ "CI/CD não roda"
→ Verifique se todos os ~30 secrets estão cadastrados em **Settings > Secrets and variables > Actions**

### ❌ ".env: arquivo não encontrado"
→ Execute: `cp .env.example .env`

---

## ✨ Próximo Passo

Após fazer este setup inicial, você pode:
- Rodar o app localmente: `flutter run`
- Rodar testes: `flutter test`
- Fazer deploy via GitHub Actions (automático em push para `main`)

**Boa sorte! 🎉**
