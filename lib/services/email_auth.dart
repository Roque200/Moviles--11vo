import 'package:firebase_auth/firebase_auth.dart';

class EmailAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Regresa null si el registro fue exitoso, o un mensaje de error si falló.
  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.currentUser?.sendEmailVerification();
      await _auth.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Ese correo ya está registrado';
        case 'invalid-email':
          return 'El correo no es válido';
        case 'weak-password':
          return 'La contraseña es muy débil (mínimo 6 caracteres)';
        case 'operation-not-allowed':
          return 'El registro con correo no está habilitado en Firebase';
        case 'network-request-failed':
          return 'Sin conexión a internet';
        default:
          return 'Error al registrar: ${e.message}';
      }
    } catch (e) {
      return 'Error inesperado: $e';
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user!.emailVerified) {
        return true;
      } else {
        await _auth.signOut();
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
