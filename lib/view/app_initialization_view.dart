import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agenda/core/services/firestore_service.dart';
import 'package:agenda/core/utils/app_strings.dart';
import 'package:agenda/features/admin/view/admin_senha_setup_view.dart';
import 'package:agenda/features/auth/view/login_view.dart';
import 'package:agenda/features/agendamento/view/agendamento_view.dart';
import 'package:agenda/features/agendamento/view/admin_agendamentos_view.dart';
import 'package:agenda/features/auth/view/aguardando_aprovacao_view.dart';
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
  Widget? _navigateTo;


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
          _navigateTo = null;
        });
        return;
      }

      // Se já existe sessão autenticada, determina a navegação apropriada
      final usuarioAtual = await firestoreService.getUsuario(authUser.uid);
      
      if (usuarioAtual != null) {
        // Admin: vai para dashboard administrativo
        if (usuarioAtual.tipo == 'admin') {
          setState(() {
            _senhaConfigurada = true;
            _isLoading = false;
            _navigateTo = const AdminAgendamentosView();
          });
          return;
        }
        
        // Cliente aprovado: vai para agendamentos
        if (usuarioAtual.aprovado == true) {
          setState(() {
            _senhaConfigurada = true;
            _isLoading = false;
            _navigateTo = const AgendamentoView();
          });
          return;
        }
        
        // Cliente não aprovado: aguarda aprovação
        setState(() {
          _senhaConfigurada = true;
          _isLoading = false;
          _navigateTo = AguardandoAprovacaoView(
            dataCadastro: usuarioAtual.dataCadastro ?? DateTime.now(),
          );
        });
        return;
      }

      // Usuário autenticado mas sem perfil no Firestore - vai para login
      setState(() {
        _senhaConfigurada = true;
        _isLoading = false;
        _navigateTo = const LoginView();
      });
      return;
    } on FirebaseException catch (e) {
      // Sem permissão - fallback seguro
      if (e.code == 'permission-denied') {
        setState(() {
          _senhaConfigurada = true;
          _isLoading = false;
          _navigateTo = const LoginView();
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
                  label: Text(AppStrings.tentarNovamente),
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

    // Se há navegação pendente, exibe aquela tela
    if (_navigateTo != null) {
      return _navigateTo!;
    }

    // Sistema inicializado e sem sessão ativa - prosseguir para o fluxo normal.
    if (!widget.onboardingComplete) {
      return const OnboardingView();
    }

    return const LoginView();
  }
}
