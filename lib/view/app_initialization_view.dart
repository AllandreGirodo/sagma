import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agenda/core/services/firestore_service.dart';
import 'package:agenda/core/models/firestore_structure_helper.dart';
import 'package:agenda/features/admin/view/admin_senha_setup_view.dart';
import 'package:agenda/features/auth/view/login_view.dart';
import 'package:agenda/view/onboarding_view.dart';

/// Tela inicial que verifica o estado de configuração do sistema.
/// 
/// Fluxo de inicialização:
/// 1. Verifica se a estrutura do banco está inicializada
/// 2. Verifica se a senha de admin está configurada
/// 3. Se não estiver, exibe o AdminSenhaSetupView
/// 4. Se estiver, prossegue para onboarding ou login
class AppInitializationView extends StatefulWidget {
  final bool onboardingComplete;

  const AppInitializationView({
    super.key,
    required this.onboardingComplete,
  });

  @override
  State<AppInitializationView> createState() => _AppInitializationViewState();
}

class _AppInitializationViewState extends State<AppInitializationView> {
  bool _isLoading = true;
  bool _senhaConfigurada = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _inicializarSistema();
  }

  Future<void> _inicializarSistema() async {
    try {
      final firestoreService = FirestoreService();
      final authUser = FirebaseAuth.instance.currentUser;

      // Sem sessao autenticada, nao acessa configuracoes protegidas por regra.
      if (authUser == null) {
        setState(() {
          _senhaConfigurada = true;
          _isLoading = false;
        });
        return;
      }

      final usuarioAtual = await firestoreService.getUsuario(authUser.uid);
      final bool eAdmin = usuarioAtual?.tipo == 'admin';

      // A inicializacao de estrutura e setup de senha pertence apenas ao admin.
      if (eAdmin) {
        final helper = FirestoreStructureHelper();
        await helper.inicializarEstruturaConfiguracoes();

        final senhaConfigurada = await firestoreService.verificaSenhaAdminFerramentasConfigurada();
        setState(() {
          _senhaConfigurada = senhaConfigurada;
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _senhaConfigurada = true;
        _isLoading = false;
      });
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        // Fallback seguro: segue para login/onboarding sem bloquear startup.
        setState(() {
          _senhaConfigurada = true;
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _errorMessage = 'Erro ao inicializar sistema: $e';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao inicializar sistema: $e';
        _isLoading = false;
      });
    }
  }

  void _onSenhaConfigurada() {
    setState(() {
      _senhaConfigurada = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Carregando
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 24),
              Text(
                'Inicializando sistema...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // Erro
    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 24),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = null;
                    });
                    _inicializarSistema();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Senha não configurada - exibe tela de setup
    if (!_senhaConfigurada) {
      return AdminSenhaSetupView(
        onSenhaConfigurada: _onSenhaConfigurada,
      );
    }

    // Sistema inicializado e senha configurada - prosseguir para o fluxo normal
    if (!widget.onboardingComplete) {
      return const OnboardingView();
    }

    return const LoginView();
  }
}
