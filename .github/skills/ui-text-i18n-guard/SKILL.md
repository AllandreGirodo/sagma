---
name: ui-text-i18n-guard
description: '**WORKFLOW SKILL** - Detect and refactor all user-visible hardcoded UI text in Flutter (Text, SnackBar, AlertDialog, AppBar, InputDecoration, validators, buttons, tooltips, dialogs) into localization variables aligned with LanguageSelector. USE FOR: reviewing or implementing screens so every new visible message is added to AppStrings/AppLocalizations and translated. DO NOT USE FOR: debug-only logs, internal IDs, route names, environment keys, or non-user-facing strings.'
argument-hint: 'Optional scope: file(s), folder, or feature to audit (e.g., lib/features/auth/**)'
user-invocable: true
---

# UI Text I18n Guard

## Objective
Guarantee that every user-facing message in UI is centralized as a localization variable and covered by translations used in this project.

This skill enforces the same scope used by LanguageSelector and the project localization flow so that every new text production updates the pertinent translation source files.

## Project Localization Context
- Language selector component: lib/core/widgets/language_selector.dart
- Static bilingual strings: lib/core/utils/app_strings.dart
- Map-based multi-language strings (pt/en/es/ja): lib/app_localizations.dart

## When To Use
- Creating a new screen, dialog, form, snackbar, or validation message.
- Reviewing PRs to catch hardcoded user-facing strings.
- Migrating old screens to localization variables.

## Decision Rules
1. If the target file already uses AppStrings, keep the same pattern in that file and add new keys to lib/core/utils/app_strings.dart.
2. If the target file already uses AppLocalizations.of(context), keep this pattern and add key translations to lib/app_localizations.dart for all supported languages.
3. Do not mix AppStrings and AppLocalizations in the same file unless explicitly requested.
4. For dynamic messages, create parameterized localization methods (for example, with placeholders) instead of string concatenation.
5. Keep key names in lowerCamelCase and grouped by feature intent.

## Text Sources That Must Be Localized
- Text('...'), SelectableText('...'), RichText/TextSpan text.
- SnackBar content text.
- AlertDialog title/content/actions labels.
- AppBar title.
- InputDecoration: labelText, hintText, helperText, errorText.
- Buttons (ElevatedButton, TextButton, OutlinedButton, IconButton tooltip).
- Validator returns and form error messages shown to users.
- Any message passed to ScaffoldMessenger, dialogs, toasts, or visible cards/chips.

## Allowed Literals (Do Not Force Localization)
- debugPrint/log-only diagnostics not shown to users.
- Route names, enum values, backend keys, env keys, document IDs.
- Regex patterns and technical constants.
- Test fixture internals that are not user-facing UI text.

## Workflow
1. Scan target scope for hardcoded visible text candidates.
2. Classify each candidate as:
   - User-facing message (must localize), or
   - Technical/internal literal (can stay as-is).
3. Define key names before editing.
4. Update localization source:
   - Add getters/methods in lib/core/utils/app_strings.dart, or
   - Add keys for pt/en/es/ja and corresponding getters/methods in lib/app_localizations.dart.
5. Replace literals in widgets/services/controllers where the text is displayed.
6. Validate no new hardcoded user-facing text remains in changed scope.
7. Run analyzer and fix issues introduced by the refactor.
8. Report added keys and touched files.

## Completion Checklist
- Every new visible message is referenced through localization variables.
- For AppLocalizations keys, translations exist in pt, en, es, and ja.
- Dynamic texts use localization methods with arguments/placeholders.
- No mixed localization strategy within the same file (unless requested).
- Flutter analyze passes for changed files.

## Output Format (Recommended)
- Files changed
- Keys added
- Literal texts migrated
- Residual non-localized literals (if any) with justification

## Example Prompts
- /ui-text-i18n-guard Audite lib/features/auth/view/login_view.dart e migre textos visiveis para AppStrings.
- /ui-text-i18n-guard Revise lib/features/agendamento/** e garanta cobertura em AppLocalizations (pt/en/es/ja).
- /ui-text-i18n-guard Ao implementar nova tela, bloqueie hardcoded strings de UI e adicione chaves de traducao correspondentes.
