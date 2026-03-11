import 'package:flutter/material.dart';
import 'package:agenda/core/services/firestore_service.dart';
import 'package:agenda/core/utils/app_strings.dart';

/// Tela Splash para configurar senha de admin se não existir
/// Aparece como splash inicial, clicando no logo permite digitar a senha
class AdminSenhaSetupView extends StatefulWidget {
  final VoidCallback onSenhaConfigurada;

  const AdminSenhaSetupView({
    super.key,
    required this.onSenhaConfigurada,
  });

  @override
  State<AdminSenhaSetupView> createState() => _AdminSenhaSetupViewState();
}

class _AdminSenhaSetupViewState extends State<AdminSenhaSetupView>
    with SingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _mostrarFormulario = false;
  bool _verificando = true;
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    _verificarSenhaExistente();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
  }

  Future<void> _verificarSenhaExistente() async {
    try {
      // Tenta buscar senha existente
      await _firestoreService.validarSenhaAdminFerramentas('teste_check');
      // Se chegou aqui sem exceção StateError, senha existe
      if (mounted) {
        widget.onSenhaConfigurada();
      }
    } on StateError {
      // Senha não configurada, precisa configurar
      if (mounted) {
        setState(() => _verificando = false);
      }
    } catch (e) {
      // Outro erro, assume que precisa configurar
      if (mounted) {
        setState(() => _verificando = false);
      }
    }
  }

  void _mostrarConfiguracao() {
    setState(() => _mostrarFormulario = true);
  }

  Future<void> _salvarSenha() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() => _verificando = true);
        
        // Salva em configuracoes/seguranca
        await _firestoreService.salvarSenhaAdminFerramentas(
          _senhaController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.senhaAdminConfigurada),
              backgroundColor: Colors.green,
            ),
          );
          widget.onSenhaConfigurada();
        }
      } catch (e) {
        if (mounted) {
          setState(() => _verificando = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.erroSalvarSenha('$e')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_verificando) {
      return Scaffold(
        backgroundColor: Colors.orange.shade50,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/logo.png',
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.spa,
                      size: 120,
                      color: Colors.orange,
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(color: Colors.orange),
              const SizedBox(height: 16),
              Text(
                AppStrings.verificandoConfiguracao,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_mostrarFormulario) {
      return Scaffold(
        backgroundColor: Colors.orange.shade50,
        body: Center(
          child: GestureDetector(
            onTap: _mostrarConfiguracao,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Image.asset(
                    'assets/logo.png',
                    height: 120,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.spa,
                        size: 120,
                        color: Colors.orange,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppStrings.cliqueLogoConfigurar,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.w500,
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

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.configuracaoInicial),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.security,
                  size: 80,
                  color: Colors.orange,
                ),
                const SizedBox(height: 24),
                Text(
                  AppStrings.configureSenhaAdmin,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.senhaAdminDescricao,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _senhaController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: AppStrings.senhaAdminLabel,
                            hintText: AppStrings.minimoSeisCaracteres,
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.senhaObrigatoria;
                            }
                            if (value.trim().length < 6) {
                              return AppStrings.minimoSeisCaracteres;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmaSenhaController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: AppStrings.confirmeSenha,
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value != _senhaController.text) {
                              return AppStrings.senhasNaoCoincidem;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _salvarSenha,
                  icon: const Icon(Icons.save),
                  label: Text(AppStrings.salvarContinuar),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.amber.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppStrings.guardeSenhaLocalSeguro,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
