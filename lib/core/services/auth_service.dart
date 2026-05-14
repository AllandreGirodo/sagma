import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Implementação do Singleton ---
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();
  // --- Fim do Singleton ---

  /// Retorna o stream de mudanças no estado de autenticação do usuário.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Retorna o usuário atualmente logado.
  User? get currentUser => _auth.currentUser;

  /// Realiza login com Google via Firebase (compatible com Web e Mobile).
  ///
  /// Após o login, verifica se o usuário já existe na coleção 'usuarios'.
  /// Se não existir, cria um novo registro de cliente com status 'pendente',
  /// conforme a documentação do seu projeto (RF001).
  Future<UserCredential?> signInWithGoogle() async {
    try {
      late UserCredential userCredential;

      if (kIsWeb) {
        // Para Web: usar Firebase Auth popup
        final provider = GoogleAuthProvider();
        provider.setCustomParameters({'prompt': 'select_account'});
        userCredential = await _auth.signInWithPopup(provider);
      } else {
        // Para Mobile: usar google_sign_in
        // Nota: google_sign_in não está disponível neste serviço centralizado
        // Use o login_view.dart para mobile
        throw UnsupportedError('Use signInWithGoogle no login_view.dart para mobile');
      }

      // Após o login, verifica e cria o perfil do usuário no Firestore se for novo
      if (userCredential.user != null) {
        await _criarPerfilDeUsuarioSeNaoExistir(userCredential.user!);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('[AUTH] Erro de autenticação com Google: ${e.message} (${e.code})');
      rethrow;
    } catch (e) {
      debugPrint('[AUTH] Erro inesperado durante login com Google: $e');
      rethrow;
    }
  }

  /// Cria um registro para o usuário na coleção 'usuarios' se ele for novo.
  Future<void> _criarPerfilDeUsuarioSeNaoExistir(User user) async {
    final emailNormalizado = user.email!.toLowerCase();
    final userDocRef = _firestore.collection('usuarios').doc(emailNormalizado);

    final doc = await userDocRef.get();

    if (!doc.exists) {
      // Usuário não existe, cria um novo registro.
      // Conforme RF001, novos usuários entram como "clientes" "pendentes".
      await userDocRef.set({
        'uid': user.uid,
        'email': user.email,
        'nome_exibicao': user.displayName ?? user.email,
        'foto_url': user.photoURL,
        'tipo_usuario': 'cliente',
        'status_aprovacao': 'pendente',
        'data_criacao': FieldValue.serverTimestamp(),
        'provedor_auth': 'google.com',
      });
    }
  }

  /// Realiza o logout do usuário.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('[AUTH] Erro ao fazer logout: $e');
    }
  }
}
