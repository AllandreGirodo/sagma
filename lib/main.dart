import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Para kReleaseMode e kDebugMode
import 'package:agenda/core/utils/logger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:agenda/core/services/firestore_service.dart';
import 'package:agenda/core/utils/custom_theme_data.dart';
import 'package:agenda/core/widgets/animated_background.dart';
import 'package:agenda/core/widgets/background_sound_manager.dart';
import 'package:agenda/core/utils/app_styles.dart';
import 'package:agenda/core/utils/app_strings.dart';
import 'package:agenda/core/utils/app_check_debug_token.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:agenda/config/firebase_options.dart';
import 'package:agenda/view/config_error_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:agenda/view/manutencao_view.dart';
import 'package:agenda/app_localizations.dart';
import 'package:agenda/view/app_initialization_view.dart';
import 'package:agenda/features/tools/view/services_view.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Garantir que o Firebase esteja inicializado no isolate de background
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (_) {
    // Ignora falha de re-inicialização — pode já estar inicializado
  }

  // Manipular mensagens em segundo plano
  Logger.info(AppStrings.backgroundMessageHandling(message.messageId));
}

void _bootDiag(String message) {
  if (!kDebugMode) return;
  debugPrint('[BOOT_DIAG] $message');
}

String _normalizeAppCheckDebugToken(String? raw) {
  final token = (raw ?? '').trim();
  if (token.isEmpty) return '';

  final lower = token.toLowerCase();
  final placeholderTokens = <String>{
    'seu_token',
    '<seu_token>',
    'your_token',
    '<your_token>',
    'seu_token_debug_app_check_aqui',
    'your_app_check_debug_token_here',
  };

  return placeholderTokens.contains(lower) ? '' : token;
}

String _normalizeRecaptchaSiteKey(String? raw) {
  final siteKey = (raw ?? '').trim();
  if (siteKey.isEmpty) return '';

  final lower = siteKey.toLowerCase();
  final placeholderValues = <String>{
    'agenda-horario-recaptcha-site-key',
    'sua_recaptcha_site_key_publica',
    'your_recaptcha_site_key_public',
    'seu_site_key_publico',
    '<seu_site_key_publico>',
  };

  return placeholderValues.contains(lower) ? '' : siteKey;
}

String _resolveRecaptchaSiteKey() {
  final candidateEnvKeys = <String>[
    'RECAPTCHA_SITE_KEY',
    'RECAPTCHA_SITE_KEY_CLIENT',
    'RECAPTCHA_SITE_KEY_CLIENT_V3',
  ];

  for (final envKey in candidateEnvKeys) {
    final siteKey = _normalizeRecaptchaSiteKey(dotenv.env[envKey]);
    if (siteKey.isNotEmpty) {
      return siteKey;
    }
  }

  return '';
}

List<String> _requiredFirebaseEnvKeysForCurrentPlatform() {
  final keys = <String>[
    'FIREBASE_PROJECT_ID',
    'FIREBASE_MESSAGING_SENDER_ID',
    'FIREBASE_STORAGE_BUCKET',
  ];

  if (kIsWeb) {
    return [...keys, 'FIREBASE_WEB_API_KEY', 'FIREBASE_WEB_APP_ID'];
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return [...keys, 'FIREBASE_ANDROID_API_KEY', 'FIREBASE_ANDROID_APP_ID'];
    case TargetPlatform.iOS:
      return [...keys, 'FIREBASE_IOS_API_KEY', 'FIREBASE_IOS_APP_ID'];
    default:
      return keys;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('language_code');
    final String? countryCode = prefs.getString('country_code');
    final String? themeMode = prefs.getString('theme_mode');
    final String? customTheme = prefs.getString('custom_theme_type');
    final bool onboardingComplete =
        prefs.getBool('onboarding_complete') ?? false;
    final Locale? initialLocale = languageCode != null
        ? Locale(languageCode, countryCode)
        : null;

    if (initialLocale != null) {
      AppStrings.setLocale(initialLocale);
    }

    // 1. Configuração de Ambiente (.env)
    // Uso: flutter run --dart-define=ENV=prod (Padrão: dev)
    const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
    // Permite testar a tela de erro mesmo em debug via --dart-define=FORCE_CONFIG_CHECK=true
    const bool forceConfigCheck = bool.fromEnvironment(
      'FORCE_CONFIG_CHECK',
      defaultValue: false,
    );
    final String envFile = env == 'dev' ? '.env' : '.env.$env';

    try {
      // Carrega base e depois (opcionalmente) sobrepõe com ambiente específico.
      // Em ENV=dev, evita tentar carregar ".env.dev" quando ele não existe no Web.
      await dotenv.load(fileName: '.env', isOptional: true);

      if (envFile != '.env') {
        final baseEnv = Map<String, String>.from(dotenv.env);
        await dotenv.load(
          fileName: envFile,
          isOptional: true,
          mergeWith: baseEnv,
        );
      }

      // Verificacao opcional de chaves: so executa quando forçado via
      // --dart-define=FORCE_CONFIG_CHECK=true.
      if (forceConfigCheck) {
        final requiredKeys = <String>[
          'DB_ADMIN_PASSWORD',
          'ADMIN_EMAIL',
          ..._requiredFirebaseEnvKeysForCurrentPlatform(),
        ];
        final missingKeys = requiredKeys
            .where((key) => dotenv.env[key] == null || dotenv.env[key]!.isEmpty)
            .toSet()
            .toList();

        if (missingKeys.isNotEmpty) {
          debugPrint(AppStrings.configAlertMissingKeys(missingKeys.join(', ')));
          runApp(
            ConfigErrorView(
              message: AppStrings.appInitConfigSegurancaAusente,
              details: AppStrings.appInitDetalhesChavesAusentes(
                env,
                missingKeys.join(', '),
              ),
            ),
          );
          return;
        }
      }
    } catch (e) {
      if (forceConfigCheck) {
        runApp(
          ConfigErrorView(
            message: AppStrings.appInitArquivoConfigNaoEncontrado,
            details: AppStrings.appInitDetalhesArquivoEsperado(
              envFile,
              e.toString(),
            ),
          ),
        );
        return;
      }
      debugPrint(AppStrings.envFileLoadWarning(e.toString()));
    }

    String appCheckDebugToken = _normalizeAppCheckDebugToken(
      const String.fromEnvironment(
        'FIREBASE_APPCHECK_DEBUG_TOKEN',
        defaultValue: '',
      ),
    );

    if (appCheckDebugToken.isEmpty) {
      appCheckDebugToken = _normalizeAppCheckDebugToken(
        dotenv.env['FIREBASE_APPCHECK_DEBUG_TOKEN'],
      );
    }
    if (appCheckDebugToken.isEmpty) {
      appCheckDebugToken = _normalizeAppCheckDebugToken(
        dotenv.env['web_dev_app'],
      );
    }
    if (appCheckDebugToken.isEmpty) {
      appCheckDebugToken = _normalizeAppCheckDebugToken(
        dotenv.env['web_warranty_app'],
      );
    }

    final bool isLocalWebHost =
        kIsWeb &&
        (Uri.base.host == 'localhost' ||
            Uri.base.host == '127.0.0.1' ||
            Uri.base.host == '0.0.0.0' ||
            Uri.base.host == '::1');

    const bool enableAppCheckInDebug = bool.fromEnvironment(
      'ENABLE_APPCHECK_IN_DEBUG',
      defaultValue: false,
    );
    const bool enableAppCheckInRelease = bool.fromEnvironment(
      'ENABLE_APPCHECK_IN_RELEASE',
      defaultValue: false,
    );

    // Flag global para habilitar/desabilitar o Firebase Storage
    const bool enableStorage = bool.fromEnvironment(
      'ENABLE_STORAGE',
      defaultValue: false, // Como 'false', o Storage fica inativo por padrão
    );

    final String? debugTokenForWeb =
        (kIsWeb && (kReleaseMode || enableAppCheckInDebug || isLocalWebHost))
        ? appCheckDebugToken
        : null;

    _bootDiag(
      'host=${Uri.base.host} localWeb=$isLocalWebHost '
      'enableAppCheckInDebug=$enableAppCheckInDebug '
      'enableAppCheckInRelease=$enableAppCheckInRelease '
      'debugTokenProvided=${appCheckDebugToken.isNotEmpty}',
    );

    await configureWebAppCheckDebugToken(
      (debugTokenForWeb == null || debugTokenForWeb.isEmpty)
          ? null
          : debugTokenForWeb,
    );

    // 2. Inicialização do Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // --- CONFIGURACAO DE AMBIENTE FIREBASE ---
    // Por padrao, usa Firebase online (projeto gratuito).
    // Para usar emuladores locais, rode com: --dart-define=USE_FIREBASE_EMULATORS=true
    bool useFirebaseEmulators = const bool.fromEnvironment(
      'USE_FIREBASE_EMULATORS',
      defaultValue: false,
    );

    // O uso de emuladores precisa ser ativado explicitamente por flag.
    if (useFirebaseEmulators) {
      try {
        // '10.0.2.2' é o IP especial para o emulador Android acessar o host.
        // Para Web, desktop e iOS, usamos 'localhost' para manter o fluxo no mesmo host do app.
        final String host = defaultTargetPlatform == TargetPlatform.android
            ? '10.0.2.2'
            : 'localhost';

        // Conecta Auth (Porta definida em firebase.json)
        await FirebaseAuth.instance.useAuthEmulator(host, 9199);
        // Conecta Firestore (Porta 8080)
        FirebaseFirestore.instance.useFirestoreEmulator(host, 8081);
        // Conecta Storage (Porta 9199)
        if (enableStorage) {
          await FirebaseStorage.instance.useStorageEmulator(host, 9199);
        }
        // Conecta Functions (Porta 5001)
        FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);

        Logger.info(AppStrings.firebaseEmulatorConnected(host));
      } catch (e) {
        Logger.error(AppStrings.firebaseEmulatorConnectionError(e.toString()));
      }
    } else {
      Logger.info(AppStrings.firebaseUsingOnline);
    }

    // --- Ajuste de persistência para Web ---
    // Tentativa de manter persistência (IndexedDB). Se falhar (ex.: modo
    // privativo do navegador ou bloqueio de IndexedDB) desliga a persistência
    // para evitar erros 'client is offline' ao tentar ler documentos.
    if (kIsWeb) {
      try {
        FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: true,
        );
        _bootDiag('Firestore persistence enabled for Web.');
      } catch (e) {
        try {
          FirebaseFirestore.instance.settings = const Settings(
            persistenceEnabled: false,
          );
          Logger.warn('IndexedDB not available or persistence failed; disabled Firestore persistence for Web.');
        } catch (_) {
          // Não é crítico — prosseguir sem persistência configurada explicitamente.
        }
      }
    }

    // 3. App Check para Web
    final recaptchaKey = _resolveRecaptchaSiteKey();
    // Nunca ativa App Check em localhost (development)
    // Ativa App Check apenas quando explicitamente habilitado em flags.
    // Evita ativar automaticamente em builds de release sem configuração adequada.
    final bool shouldEnableWebAppCheck =
        kIsWeb &&
        (enableAppCheckInRelease || enableAppCheckInDebug) &&
        !isLocalWebHost;
    _bootDiag(
      'webAppCheck shouldEnable=$shouldEnableWebAppCheck '
      'recaptchaConfigured=${recaptchaKey.isNotEmpty}',
    );
    if (shouldEnableWebAppCheck && recaptchaKey.isNotEmpty) {
      try {
        await FirebaseAppCheck.instance.activate(
          // Atualizado para reCAPTCHA Enterprise.
          // Se estiver utilizando reCAPTCHA v3 no Firebase Console, volte para ReCaptchaV3Provider.
          providerWeb: ReCaptchaEnterpriseProvider(recaptchaKey),
        );
      } on FirebaseException catch (e) {
        if (e.code == 'already-initialized') {
          Logger.warn(AppStrings.appCheckAlreadyInitialized);
        } else {
          Logger.error(AppStrings.appCheckActivationFailure(e.toString()));
        }
      } catch (e) {
        Logger.error(AppStrings.appCheckActivationFailure(e.toString()));
      }
    } else if (kIsWeb && kDebugMode && !enableAppCheckInDebug) {
      Logger.info(AppStrings.appCheckDisabledInDebug);
    } else if (kIsWeb) {
      Logger.warn(AppStrings.appCheckRecaptchaMissing);
    }

    // 4. Configurações adicionais
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(
          initialLocale: initialLocale,
          initialThemeMode: themeMode,
          initialCustomTheme: customTheme,
          onboardingComplete: onboardingComplete,
        ),
      ),
    );
  } catch (e) {
    // Se der erro fatal, mostra na tela em vez de ficar branco
    debugPrint(AppStrings.appInitFatalLog(e.toString()));
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                AppStrings.appInitErroFatal(e.toString()),
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  final Locale? initialLocale;
  final String? initialThemeMode;
  final String? initialCustomTheme;
  final bool onboardingComplete;

  const MyApp({
    super.key,
    this.initialLocale,
    this.initialThemeMode,
    this.initialCustomTheme,
    required this.onboardingComplete,
  });

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  static void setCustomTheme(BuildContext context, AppThemeType type) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setCustomTheme(type);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;
  AppThemeType _customThemeType = AppThemeType.sistema;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final FirestoreService _firestoreService = FirestoreService();
  late final Stream<bool> _manutencaoStream;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
    if (_locale != null) {
      AppStrings.setLocale(_locale!);
    }
    if (widget.initialThemeMode != null) {
      _themeMode = _getThemeModeFromString(widget.initialThemeMode!);
    }
    if (widget.initialCustomTheme != null) {
      _customThemeType = AppThemeType.values.firstWhere(
        (e) => e.toString() == widget.initialCustomTheme,
        orElse: () => AppThemeType.sistema,
      );
    }
    _manutencaoStream = _firestoreService.getManutencaoStream();
    _setupNotifications();
  }

  ThemeMode _getThemeModeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _getStringFromThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }

  void setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    AppStrings.setLocale(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    if (locale.countryCode != null) {
      await prefs.setString('country_code', locale.countryCode!);
    }
    _atualizarPreferenciasUsuario(
      locale: '${locale.languageCode}_${locale.countryCode ?? ""}',
    );
  }

  void setCustomTheme(AppThemeType type) async {
    setState(() {
      _customThemeType = type;
      // Mapeia o tipo customizado para o ThemeMode do Flutter
      if (type == AppThemeType.claro) {
        _themeMode = ThemeMode.light;
      } else if (type == AppThemeType.escuro) {
        _themeMode = ThemeMode.dark;
      } else if (type == AppThemeType.sistema) {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = ThemeMode.light;
      } // Temas coloridos usam base clara por padrão
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('custom_theme_type', type.toString());
    await prefs.setString('theme_mode', _getStringFromThemeMode(_themeMode));

    _atualizarPreferenciasUsuario(theme: type.toString());
  }

  Future<void> _atualizarPreferenciasUsuario({
    String? theme,
    String? locale,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Usa o método unificado para atualizar preferências do usuário
      await FirestoreService().atualizarPreferenciasUsuario(
        user.uid,
        theme: theme,
        locale: locale,
      );
    }
  }

  void _setupNotifications() async {
    const bool enableWebPushInDebug = bool.fromEnvironment(
      'ENABLE_WEB_PUSH_IN_DEBUG',
      defaultValue: false,
    );

    if (kIsWeb && kDebugMode && !enableWebPushInDebug) {
      debugPrint(AppStrings.webPushDisabledInDebug);
      return;
    }

    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);

      // Listener para mensagens em Primeiro Plano (Foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint(
          AppStrings.foregroundNotificationReceived(
            message.notification?.title,
          ),
        );

        if (message.notification != null) {
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(
                AppStrings.foregroundNotificationContent(
                  message.notification!.title ?? '',
                  message.notification!.body ?? '',
                ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.teal,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      });

      String? token;
      if (kIsWeb) {
        // Prioriza VAPID key passada via --dart-define em produção.
        final vapidKeyFromDefine = const String.fromEnvironment(
          'VAPID_KEY',
          defaultValue: '',
        );
        final vapidKeyFromDotenv = dotenv.env['VAPID_KEY'] ?? '';
        final vapidKey = vapidKeyFromDefine.isNotEmpty
            ? vapidKeyFromDefine
            : vapidKeyFromDotenv;

        if (vapidKey.isEmpty) {
          debugPrint(AppStrings.vapidKeyMissing);
        } else {
          token = await messaging.getToken(vapidKey: vapidKey);
        }
      } else {
        token = await messaging.getToken();
      }

      if (token != null) {
        _salvarTokenNoBanco(token);
      }

      messaging.onTokenRefresh.listen(
        _salvarTokenNoBanco,
        onError: (Object e) =>
            debugPrint(AppStrings.fcmTokenRefreshError(e.toString())),
      );
    } catch (e) {
      Logger.error(AppStrings.pushNotificationsInitFailure(e.toString()));
    }
  }

  void _salvarTokenNoBanco(String token) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirestoreService().atualizarToken(user.uid, token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Locale? effectiveLocale = _locale ?? DevicePreview.locale(context);
    if (effectiveLocale != null) {
      AppStrings.setLocale(effectiveLocale);
    }

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          scaffoldMessengerKey:
              _scaffoldMessengerKey, // Chave para exibir SnackBars globais
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          debugShowCheckedModeBanner:
              false, // Havia sido retirado, mas é importante para o DevicePreview
          theme: ThemeData(
            colorScheme: lightDynamic ?? AppColors.lightScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic ?? AppColors.darkScheme,
            useMaterial3: true,
          ),
          themeAnimationDuration: const Duration(
            milliseconds: 800,
          ), // Transição suave (Fade)
          themeAnimationCurve: Curves.easeInOut,
          themeMode: _themeMode,
          locale: effectiveLocale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
            Locale('en', 'US'),
            Locale('es', 'ES'),
            Locale('fr', 'FR'),
            Locale('ja', 'JP'),
          ],
          // Rota pública para checagem de serviços (acessível em /services)
          routes: {'/services': (context) => const ServicesView()},
          home: AppInitializationView(
            onboardingComplete: widget.onboardingComplete,
          ),
          // Builder global: Envolve todo o app no fundo animado e verifica manutenção
          builder: (context, child) {
            final childWithPreview = DevicePreview.appBuilder(context, child);
            // StreamBuilder para verificar manutenção em tempo real
            return StreamBuilder<bool>(
              stream: _manutencaoStream,
              builder: (context, snapshot) {
                final emManutencao = snapshot.data ?? false;

                if (emManutencao) {
                  return const MaterialApp(
                    home: ManutencaoView(),
                    debugShowCheckedModeBanner: false,
                  );
                }

                return BackgroundSoundManager(
                  themeType: _customThemeType,
                  child: AnimatedBackground(
                    themeType: _customThemeType,
                    // Garante que o fundo do Scaffold seja transparente para ver a animação
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        scaffoldBackgroundColor:
                            _customThemeType != AppThemeType.sistema &&
                                _customThemeType != AppThemeType.claro &&
                                _customThemeType != AppThemeType.escuro
                            ? Colors.transparent
                            : null,
                      ),
                      child: childWithPreview,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
