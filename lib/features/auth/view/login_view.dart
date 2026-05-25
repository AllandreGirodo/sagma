import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:agenda/core/utils/app_styles.dart';
import 'package:agenda/core/utils/app_strings.dart';
import 'package:agenda/app_localizations.dart';
import 'package:agenda/core/utils/validadores.dart';
import 'package:agenda/features/agendamento/view/agendamento_view.dart';
import 'package:agenda/features/auth/controller/login_controller.dart';
import 'package:agenda/features/auth/view/signup_view.dart';
import 'package:agenda/core/widgets/language_selector.dart';
import 'package:agenda/core/services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agenda/features/tools/view/services_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  static const String _prefLembrarCredenciaisLogin =
      'login_remember_credentials';
  static const String _prefEmailLogin = 'login_saved_email';
  static const String _prefSenhaLogin = 'login_saved_password';

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _loginController = LoginController();
  bool _isLoading = false;
  bool _isObscure = true;
  bool _lembrarCredenciais = false;
  final LocalAuthentication auth = LocalAuthentication();
  Future<void>? _googleSignInInitFuture;

  void _authDiag(String message) {
    if (!kIsWeb || !kDebugMode) return;
    debugPrint('[AUTH_DIAG] $message');
  }

  void _setLoadingSafely(bool value) {
    if (!mounted) return;
    setState(() => _isLoading = value);
  }

  bool _isGoogleCancelCode(String? code) {
    final normalizado = (code ?? '').trim().toLowerCase();
    return normalizado == 'popup-closed-by-user' ||
        normalizado == 'popup_closed_by_user' ||
        normalizado == 'cancelled-popup-request' ||
        normalizado == 'cancelled_popup_request' ||
        normalizado == 'web-context-canceled' ||
        normalizado == 'web_context_canceled' ||
        normalizado == 'user-cancelled' ||
        normalizado == 'user_cancelled' ||
        normalizado == 'canceled' ||
        normalizado == 'cancelled';
  }

        bool _isGoogleAuthLikelyAppCheckError(Object e) {
          final message = e.toString().toLowerCase();
          return message.contains('app check') ||
          message.contains('appcheck') ||
          message.contains('firebase-app-check-token-is-invalid');
        }

  Future<void> _initializeGoogleSignInIfNeeded() async {
    _googleSignInInitFuture ??= GoogleSignIn.instance.initialize();
    await _googleSignInInitFuture;
  }

        bool _isFirestorePermissionLikelyAppCheck(Object e) {
          if (e is! FirebaseException) return false;
          
          // Desabilita detecção de App Check em desenvolvimento local web
          if (kIsWeb && (Uri.base.host == 'localhost' || Uri.base.host == '127.0.0.1')) {
            return false;
          }

          final message = (e.message ?? '').toLowerCase();
          return message.contains('app check') ||
          message.contains('app-check') ||
          message.contains('appcheck') ||
          message.contains('firebase app check token is invalid');
        }

  @override
  void initState() {
    super.initState();
    _authDiag('initState host=${Uri.base.host} url=${Uri.base}');
    _carregarCredenciaisSalvas();
    _processarRetornoLoginGoogleRedirect();
    _verificarBiometriaAutomatica();
  }

  Future<void> _processarRetornoLoginGoogleRedirect() async {
    if (!kIsWeb) return;

    try {
      _authDiag('redirect: chamando getRedirectResult');
      final resultado = await FirebaseAuth.instance.getRedirectResult();
      final usuarioAutenticado = resultado.user ?? FirebaseAuth.instance.currentUser;
      final temRetornoValido =
          resultado.user != null ||
          resultado.credential != null ||
          usuarioAutenticado != null;
      _authDiag(
        'redirect: result user=${resultado.user?.uid ?? '-'} '
        'credential=${resultado.credential != null} '
        'currentUser=${FirebaseAuth.instance.currentUser?.uid ?? '-'} '
        'valido=$temRetornoValido',
      );
      if (!temRetornoValido || !mounted) return;

      _setLoadingSafely(true);
      await _loginController
          .logarComGoogleAutenticado(context, authUser: usuarioAutenticado)
          .timeout(const Duration(seconds: 25));
      _authDiag('redirect: logarComGoogleAutenticado concluido');
    } on TimeoutException {
      // Evita derrubar sessão válida quando o retorno do redirect atrasa em navegadores com cache/cookies restritos.
      _authDiag('redirect: timeout');
      debugPrint('Timeout ao processar retorno do Google Redirect.');
    } on FirebaseAuthException catch (e) {
      _authDiag('redirect: FirebaseAuthException code=${e.code} message=${e.message}');
      if (_isGoogleCancelCode(e.code)) {
        if (FirebaseAuth.instance.currentUser == null) {
          await FirebaseAuth.instance.signOut();
        }
        return;
      }
      debugPrint(AppStrings.erroGoogleLogin('${e.code}: ${e.message}'));
    } catch (e) {
      _authDiag('redirect: erro generico=$e');
      debugPrint(AppStrings.erroGoogleLogin('$e'));
    } finally {
      _setLoadingSafely(false);
    }
  }

  Future<void> _carregarCredenciaisSalvas() async {
    final prefs = await SharedPreferences.getInstance();
    final lembrar = prefs.getBool(_prefLembrarCredenciaisLogin) ?? false;
    final emailSalvo = (prefs.getString(_prefEmailLogin) ?? '').trim();
    final senhaSalva = (prefs.getString(_prefSenhaLogin) ?? '').trim();

    if (!mounted) return;
    setState(() {
      _lembrarCredenciais = lembrar;
      _emailController.text = lembrar ? emailSalvo : '';
      _senhaController.text = lembrar ? senhaSalva : '';
    });
  }

  Future<void> _persistirPreferenciasLogin({
    required bool sucesso,
    required String email,
    required String senha,
  }) async {
    if (!sucesso) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefLembrarCredenciaisLogin, _lembrarCredenciais);

    if (_lembrarCredenciais) {
      await prefs.setString(_prefEmailLogin, email);
      await prefs.setString(_prefSenhaLogin, senha);
      return;
    }

    await prefs.remove(_prefEmailLogin);
    await prefs.remove(_prefSenhaLogin);
  }

  Future<void> _onAlterarLembrarCredenciais(bool? valor) async {
    final lembrar = valor ?? false;
    setState(() => _lembrarCredenciais = lembrar);

    if (lembrar) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefLembrarCredenciaisLogin, false);
    await prefs.remove(_prefEmailLogin);
    await prefs.remove(_prefSenhaLogin);
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    final emailValido = Validadores.isEmailValido(email);
    final senhaValida = senha.length >= 6;
    final motivos = <String>[];

    if (email.isEmpty || senha.isEmpty) {
      motivos.add('campos_obrigatorios_login');
    }
    if (email.isNotEmpty && !emailValido) {
      motivos.add('email_invalido_regex');
    }
    if (senha.isNotEmpty && !senhaValida) {
      motivos.add('senha_abaixo_minimo');
    }

    if (motivos.isNotEmpty) {
      unawaited(
        _loginController.auditarTentativaCredencial(
        origem: 'login_formulario',
        emailDigitado: email,
        senhaInformada: senha,
        inconformidade: true,
        lgpdConsentido: true,
        motivos: motivos,
        emailValido: emailValido,
        senhaForte: senhaValida,
        ),
      );

      if (!mounted) return;

      final mensagem = (email.isEmpty || senha.isEmpty)
          ? AppStrings.preenchaEmailSenhaLogin
          : !emailValido
          ? AppStrings.emailInvalidoLogin
          : AppStrings.senhaMinimaLogin;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensagem)));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final sucesso = await _loginController.logar(context, email, senha);

      await _persistirPreferenciasLogin(
        sucesso: sucesso,
        email: email,
        senha: senha,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _cadastro() async {
    final emailDigitado = _emailController.text.trim();
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignUpView(emailInicial: emailDigitado),
      ),
    );
  }

  Future<void> _recuperarSenha() async {
    String email = _emailController.text.trim();

    if (!mounted) return;
    final emailConfirmado = await _abrirDialogoRecuperacaoSenha(
      emailInicial: email,
    );
    if (!mounted) return;
    if (emailConfirmado == null || emailConfirmado.isEmpty) return;
    email = emailConfirmado;

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      await _loginController.recuperarSenha(context, email);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<String?> _abrirDialogoRecuperacaoSenha({
    required String emailInicial,
  }) async {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final controllerTemp = TextEditingController(text: emailInicial);
        final bool temEmailPreenchido = emailInicial.isNotEmpty;

        return AlertDialog(
          title: Text(
            temEmailPreenchido
                ? AppStrings.confirmarRecuperacaoSenha
                : AppStrings.esqueceuSenha,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!temEmailPreenchido)
                TextField(
                  controller: controllerTemp,
                  decoration: InputDecoration(
                    labelText: AppStrings.digiteEmailCadastrado,
                  ),
                  keyboardType: TextInputType.emailAddress,
                )
              else
                SelectableText(
                  emailInicial,
                  style: Theme.of(dialogContext).textTheme.bodyLarge,
                ),
              const SizedBox(height: 10),
              Text(
                AppStrings.avisoRecuperacaoSenha,
                style: Theme.of(
                  dialogContext,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppStrings.cancelButton),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, controllerTemp.text.trim()),
              child: Text(AppStrings.enviar),
            ),
          ],
        );
      },
    );
  }

  Future<void> _googleLogin() async {
    if (_isLoading) return;
    _authDiag('googleLogin: start currentUser=${FirebaseAuth.instance.currentUser?.uid ?? '-'}');
    _setLoadingSafely(true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        provider.setCustomParameters({'prompt': 'select_account'});

        _authDiag('googleLogin: web -> redirect');
        await FirebaseAuth.instance.signInWithRedirect(provider);
        return;
      }

      await _initializeGoogleSignInIfNeeded();
      final googleUser = await GoogleSignIn.instance.authenticate();
      final idToken = googleUser.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        await FirebaseAuth.instance.signOut();
        return;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;
      await _loginController.logarComGoogleAutenticado(context);
      _authDiag('googleLogin: logarComGoogleAutenticado concluido');

    } on TimeoutException {
      _authDiag('googleLogin: timeout -> signOut');
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      _authDiag('googleLogin: erro=$e');
      final erroPermissaoFirestore =
          e is FirebaseException && e.code == 'permission-denied';
      if (erroPermissaoFirestore) {
        debugPrint(
          '⚠️ permission-denied no login Google (possivel rules/AppCheck): '
          '${(e as FirebaseException?)?.message}',
        );
      }
      final emailDigitado = _emailController.text.trim();
      if (!erroPermissaoFirestore) {
        unawaited(
          _loginController.auditarTentativaCredencial(
            origem: 'login_google',
            emailDigitado: emailDigitado,
            senhaInformada: 'oauth_google_sem_senha',
            inconformidade: true,
            lgpdConsentido: true,
            motivos: <String>['erro_google_auth'],
            emailValido: Validadores.isEmailValido(emailDigitado),
            senhaForte: false,
            metodoEntrada: 'google',
            provedorEntrada: 'google_oauth',
          ),
        );
      }

      if (mounted) {
        final mensagemErro = erroPermissaoFirestore
            ? (_isFirestorePermissionLikelyAppCheck(e)
                  ? AppStrings.erroLoginAppCheck
                  : AppStrings.erroLoginPermissaoFirestore)
            : (_isGoogleAuthLikelyAppCheckError(e)
                  ? AppStrings.erroLoginAppCheck
                  : AppStrings.erroGoogleLogin('$e'));
        messenger.showSnackBar(
          SnackBar(content: Text(mensagemErro)),
        );
      }
    } finally {
      _setLoadingSafely(false);
    }
  }

  Future<void> _verificarBiometriaAutomatica() async {
    // Biometria não é suportada em web
    if (kIsWeb) return;

    try {
      // Verifica se a biometria está ativa nas configurações globais
      final config = await FirestoreService().getConfiguracao();
      if (!config.biometriaAtiva) return;

      // Verifica se o dispositivo suporta
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (canAuthenticate) {
        // Opcional: Tentar autenticar automaticamente se já houver sessão válida (mas expirada na UI)
        // Para este exemplo, deixaremos apenas o botão visível.
      }
    } catch (e) {
      debugPrint(AppStrings.erroAoVerificarBiometria);
    }
  }

  Future<void> _loginBiometrico() async {
    // Biometria não é suportada em web
    if (kIsWeb) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppStrings.biometriaErro)));
      }
      return;
    }

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: AppStrings.biometriaBtn,
        biometricOnly: false,
        persistAcrossBackgrounding: false,
      );

      if (didAuthenticate) {
        // Em um app real, aqui recuperaríamos as credenciais do SecureStorage.
        // Como estamos usando Firebase Auth que persiste a sessão, se o currentUser não for nulo,
        // podemos pular o login. Se for nulo, a biometria serve apenas como "atalho" visual,
        // mas ainda precisaria de credenciais.
        // Para o TCC, simularemos que a biometria valida o usuário atual se ele já estiver logado no cache.
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && mounted) {
          navigator.pushReplacement(
            MaterialPageRoute(builder: (_) => const AgendamentoView()),
          );
        } else if (mounted) {
          messenger.showSnackBar(
            SnackBar(content: Text(AppStrings.biometriaLoginMsg)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(AppStrings.biometriaErroComDetalhe('$e'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usa o tema atual (Light ou Dark) configurado no main.dart
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            // Cor do card adapta-se ao tema (Surface)
            color: theme.colorScheme.surface.withValues(alpha: 0.9),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.info_outline, size: 22),
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        tooltip: AppLocalizations.of(context)?.aboutAppTitle ?? 'Sobre o Aplicativo',
                        onPressed: () {
                          final loc = AppLocalizations.of(context);
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(loc?.aboutAppTitle ?? 'Sobre o Aplicativo'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(loc?.softwareVersion ?? 'Versão do software: ${AppStrings.appVersion}'),
                                  const SizedBox(height: 8),
                                  Text(loc?.lastUpdate ?? 'Última alteração: ${AppStrings.appLastUpdate}'),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.settings),
                                      label: const Text('Health App Check ⚙️'),
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (_) => const ServicesView(),
                                        ));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: Text(loc?.closeButton ?? 'Fechar'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const LanguageSelector(),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'lib/assets/Logo_favIcon.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.loginTitulo,
                    style: AppStyles.title.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    AppStrings.loginSubtitulo,
                    style: AppStyles.subtitle.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: AppStrings.emailLabel,
                      prefixIcon: const Icon(Icons.email),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _senhaController,
                    decoration: InputDecoration(
                      labelText: AppStrings.senhaLabel,
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setState(() => _isObscure = !_isObscure),
                      ),
                    ),
                    obscureText: _isObscure,
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _lembrarCredenciais,
                    title: Text(
                      AppStrings.lembrarMinhasCredenciais,
                      style: const TextStyle(fontSize: 12),
                    ),
                    onChanged: _onAlterarLembrarCredenciais,
                  ),
                  const SizedBox(height: 24),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: AppStyles.primaryButton,
                            child: Text(AppStrings.entrarBtn),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _cadastro,
                          child: Text(AppStrings.cadastrarBtn),
                        ),
                        TextButton(
                          onPressed: _recuperarSenha,
                          child: Text(
                            AppStrings.esqueceuSenha,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        const Divider(),
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.login,
                            color: Colors.red,
                          ), // Ícone genérico, ideal seria logo do Google
                          label: Text(AppStrings.googleLoginBtn),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: _googleLogin,
                        ),
                        const SizedBox(height: 10),
                        // Botão de Biometria
                        IconButton(
                          icon: const Icon(
                            Icons.fingerprint,
                            size: 40,
                            color: AppColors.primary,
                          ),
                          tooltip: AppStrings.biometriaBtn,
                          onPressed: _loginBiometrico,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
