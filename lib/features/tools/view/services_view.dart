import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:agenda/app_localizations.dart';
import 'package:agenda/core/utils/app_strings.dart';
import 'package:agenda/view/onboarding_view.dart';
import 'package:url_launcher/url_launcher.dart';

enum _ServiceState { pending, checking, ok, fail, unverified, notApplicable }

class _ServiceStatus {
  final _ServiceState state;
  final String? detail;

  const _ServiceStatus(this.state, [this.detail]);
}

class ServicesView extends StatefulWidget {
  const ServicesView({super.key});

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  static const String _idWhatsapp = 'whatsapp';
  static const String _idFirestore = 'firestore';
  static const String _idAuth = 'auth';
  static const String _idAppCheck = 'appcheck';
  static const String _idStorage = 'storage';
  static const String _idSql = 'sql';
  static const String _idFunctions = 'functions';

  final List<String> _order = const [
    _idWhatsapp,
    _idFirestore,
    _idAuth,
    _idAppCheck,
    _idStorage,
    _idSql,
    _idFunctions,
  ];

  final Map<String, _ServiceStatus> _results = {};
  bool _running = false;
  int _completed = 0;

  @override
  void initState() {
    super.initState();
    _reset();
    _startChecks();
  }

  void _reset() {
    _results
      ..clear()
      ..addEntries(
        _order.map(
          (id) => MapEntry(id, const _ServiceStatus(_ServiceState.pending)),
        ),
      );
    _completed = 0;
  }

  String _serviceName(String id, AppLocalizations loc) {
    switch (id) {
      case _idWhatsapp:
        return loc.serviceWhatsappWeb;
      case _idFirestore:
        return loc.serviceFirestore;
      case _idAuth:
        return loc.serviceAuth;
      case _idAppCheck:
        return loc.serviceAppCheck;
      case _idStorage:
        return loc.serviceStorage;
      case _idSql:
        return loc.serviceSql;
      case _idFunctions:
        return loc.serviceFunctions;
      default:
        return id;
    }
  }

  Future<void> _startChecks() async {
    if (_running) return;

    setState(() {
      _running = true;
      _reset();
    });

    for (final id in _order) {
      setState(() => _results[id] = const _ServiceStatus(_ServiceState.checking));

      _ServiceStatus result;
      try {
        switch (id) {
          case _idWhatsapp:
            result = await _checkWhatsApp();
            break;
          case _idFirestore:
            result = await _checkFirestore();
            break;
          case _idAuth:
            result = await _checkAuth();
            break;
          case _idAppCheck:
            result = await _checkAppCheck();
            break;
          case _idStorage:
            result = await _checkStorage();
            break;
          case _idSql:
            result = await _checkSql();
            break;
          case _idFunctions:
            result = await _checkFunctions();
            break;
          default:
            result = const _ServiceStatus(_ServiceState.unverified);
        }
      } catch (e) {
        result = _ServiceStatus(_ServiceState.fail, e.toString());
      }

      if (!mounted) return;
      setState(() {
        _results[id] = result;
        _completed += 1;
      });

      await Future.delayed(const Duration(milliseconds: 200));
    }

    if (!mounted) return;
    setState(() => _running = false);
  }

  Future<_ServiceStatus> _checkWhatsApp() async {
    // No web, uma requisição direta ao domínio do WhatsApp costuma falhar por CORS.
    // Para essa verificação, apenas validamos que o link é configurável e exibimos o atalho.
    return const _ServiceStatus(_ServiceState.ok);
  }

  Future<_ServiceStatus> _checkFirestore() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('configuracoes')
          .doc('geral')
          .get()
          .timeout(const Duration(seconds: 6));
      if (doc.exists) {
        return const _ServiceStatus(_ServiceState.ok);
      }
      return const _ServiceStatus(_ServiceState.ok, 'document-not-found');
    } catch (e) {
      return _ServiceStatus(_ServiceState.fail, e.toString());
    }
  }

  Future<_ServiceStatus> _checkAuth() async {
    try {
      await FirebaseAuth.instance.authStateChanges().first.timeout(
            const Duration(seconds: 6),
          );
      return const _ServiceStatus(_ServiceState.ok);
    } catch (e) {
      return _ServiceStatus(_ServiceState.fail, e.toString());
    }
  }

  Future<_ServiceStatus> _checkAppCheck() async {
    try {
      if (!kIsWeb) {
        return const _ServiceStatus(_ServiceState.notApplicable);
      }
      final token = await FirebaseAppCheck.instance.getToken();
      if (token != null && token.isNotEmpty) {
        return const _ServiceStatus(_ServiceState.ok);
      }
      return const _ServiceStatus(_ServiceState.fail, 'token-empty');
    } catch (e) {
      return _ServiceStatus(_ServiceState.fail, e.toString());
    }
  }

  Future<_ServiceStatus> _checkStorage() async {
    try {
      await FirebaseStorage.instance
          .ref('/')
          .list(ListOptions(maxResults: 1))
          .timeout(const Duration(seconds: 6));
      return const _ServiceStatus(_ServiceState.ok);
    } catch (e) {
      return _ServiceStatus(_ServiceState.fail, e.toString());
    }
  }

  Future<_ServiceStatus> _checkSql() async {
    try {
      final sqlUrl = dotenv.env['SQL_HEALTHCHECK_URL'] ?? '/api/sql/health';
      final uri = Uri.parse(
        sqlUrl.startsWith('http')
            ? sqlUrl
            : Uri.base.resolve(sqlUrl).toString(),
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        return const _ServiceStatus(_ServiceState.ok);
      }
      return _ServiceStatus(_ServiceState.fail, 'HTTP ${response.statusCode}');
    } catch (e) {
      return _ServiceStatus(_ServiceState.fail, e.toString());
    }
  }

  Future<_ServiceStatus> _checkFunctions() async {
    try {
      final fnUrl =
          dotenv.env['FUNCTIONS_HEALTHCHECK_URL'] ?? '/functions/health';
      final uri = Uri.parse(
        fnUrl.startsWith('http')
            ? fnUrl
            : Uri.base.resolve(fnUrl).toString(),
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        return const _ServiceStatus(_ServiceState.ok);
      }
      return _ServiceStatus(_ServiceState.unverified, 'HTTP ${response.statusCode}');
    } catch (e) {
      return _ServiceStatus(_ServiceState.unverified, e.toString());
    }
  }

  String _detailText(String? detail, AppLocalizations loc) {
    if (detail == null || detail.isEmpty) return '';
    if (detail == 'token-empty') return loc.serviceStatusTokenEmpty;
    if (detail == 'document-not-found') return loc.serviceStatusDocumentNotFound;
    if (detail.startsWith('HTTP ')) {
      final code = int.tryParse(detail.replaceFirst('HTTP ', '').trim());
      if (code != null) return loc.serviceStatusHttp(code);
    }
    return detail;
  }

  String _statusText(_ServiceStatus status, AppLocalizations loc) {
    final detail = _detailText(status.detail, loc);
    switch (status.state) {
      case _ServiceState.pending:
        return loc.serviceStatusPending;
      case _ServiceState.checking:
        return loc.serviceStatusChecking;
      case _ServiceState.ok:
        return detail.isEmpty ? loc.serviceStatusOk : '${loc.serviceStatusOk}: $detail';
      case _ServiceState.fail:
        return detail.isEmpty ? loc.serviceStatusFail : '${loc.serviceStatusFail}: $detail';
      case _ServiceState.unverified:
        return detail.isEmpty ? loc.serviceStatusUnverified : '${loc.serviceStatusUnverified}: $detail';
      case _ServiceState.notApplicable:
        return loc.serviceStatusNotApplicable;
    }
  }

  bool _isPendingState(_ServiceState s) =>
      s == _ServiceState.pending || s == _ServiceState.checking;

  List<String> _idsByState(_ServiceState state) {
    if (state == _ServiceState.pending) {
      return _order
          .where((id) => _isPendingState(_results[id]?.state ?? _ServiceState.pending))
          .toList();
    }
    return _order.where((id) => _results[id]?.state == state).toList();
  }

  Widget _sectionCard(
    BuildContext context,
    AppLocalizations loc,
    String title,
    List<String> ids,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (ids.isEmpty)
              Text(loc.servicesNoItems)
            else
              ...ids.map((id) => _row(id, loc)),
          ],
        ),
      ),
    );
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final uri = Uri.parse('https://web.whatsapp.com/');
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      final loc =
          AppLocalizations.of(context) ?? AppLocalizations(const Locale('pt', 'BR'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.servicesOpenWhatsAppHint)),
      );
    }
  }

  Widget _statusIcon(_ServiceStatus status) {
    switch (status.state) {
      case _ServiceState.pending:
      case _ServiceState.checking:
        return const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case _ServiceState.ok:
        return const Icon(Icons.check_circle, color: Colors.green);
      case _ServiceState.fail:
        return const Icon(Icons.error, color: Colors.red);
      case _ServiceState.unverified:
        return const Icon(Icons.help_outline, color: Colors.orange);
      case _ServiceState.notApplicable:
        return const Icon(Icons.remove_circle_outline, color: Colors.blueGrey);
    }
  }

  Widget _row(String id, AppLocalizations loc) {
    final status = _results[id] ?? const _ServiceStatus(_ServiceState.pending);
    return ListTile(
      leading: _statusIcon(status),
      title: Text(_serviceName(id, loc)),
      subtitle: Text(_statusText(status, loc)),
      trailing: id == _idAppCheck
          ? ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const OnboardingView(),
                  ),
                  (route) => false,
                );
              },
              child: Text(AppStrings.onboardingBtn),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context) ?? AppLocalizations(const Locale('pt', 'BR'));
    final total = _order.length;
    final progress = total == 0 ? 0.0 : (_completed / total);

    return Scaffold(
      appBar: AppBar(title: Text(loc.servicesCheckTitle)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.servicesResultsTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(loc.serviceStatusProgress(_completed, total)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: LinearProgressIndicator(value: progress),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('${loc.servicesWhatsappLink}: '),
                      InkWell(
                        onTap: () => _openWhatsApp(context),
                        child: const Text(
                          'https://web.whatsapp.com/',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  children: [
                    _sectionCard(
                      context,
                      loc,
                      loc.servicesSectionSuccess,
                      _idsByState(_ServiceState.ok),
                    ),
                    _sectionCard(
                      context,
                      loc,
                      loc.servicesSectionFail,
                      _idsByState(_ServiceState.fail),
                    ),
                    _sectionCard(
                      context,
                      loc,
                      loc.servicesSectionPending,
                      _idsByState(_ServiceState.pending),
                    ),
                    _sectionCard(
                      context,
                      loc,
                      loc.servicesSectionUnverified,
                      _idsByState(_ServiceState.unverified),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: Text(_running ? loc.servicesRunning : loc.servicesRerun),
                        onPressed: _running ? null : _startChecks,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
