import 'package:ai_gym_trainer/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GoogleAuthService extends GetxController {
  final AuthController authController = Get.put(AuthController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final RxBool isLoading = false.obs;

  /// IMPORTANT:
  /// If you need server auth code (for backend exchange), pass your Web client id
  /// to initialize(...) as serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com'
  /// Otherwise you can omit it if you have google-services.json + SHA configured.
  Future<void> ensureGoogleInitialized({String? serverClientId}) async {
    // initialize only once; initialize is idempotent but safe to await each call
    await GoogleSignIn.instance.initialize(
      // optional: clientId / serverClientId / nonce / hostedDomain
      // Use serverClientId only if you created a Web OAuth client and need server auth code.
      serverClientId: serverClientId,
    );
  }

  Future<bool> signInWithGoogle({String? serverClientId}) async {
    try {
      isLoading.value = true;

      // 1) initialize (required by v7)
      await ensureGoogleInitialized(serverClientId: serverClientId);

      // 2) start interactive sign-in
      // use scopeHint if you want to request additional scopes (e.g. 'https://www.googleapis.com/auth/drive')
      final GoogleSignInAccount googleAccount =
      await GoogleSignIn.instance.authenticate(scopeHint: const <String>['email', 'profile']);

      // If authenticate() completes but returns an account, proceed; otherwise handle failure
      if (googleAccount == null) return false;

      // 3) get authentication tokens (idToken available in v7)
      final GoogleSignInAuthentication auth = googleAccount.authentication;
      final String? idToken = auth.idToken;
      // Note: v7 may not return accessToken unless you request scopes & call authorization flow.
      // final String? accessToken = ??? (authorizationClient API) - not shown here for basic Firebase auth.

      if (idToken == null) {
        // idToken is required to create the Firebase credential in this flow
        print('GoogleSignIn: idToken is null â€” check initialize(serverClientId) or scopes.');
        return false;
      }

      // 4) create Firebase credential (idToken is sufficient here)
      final OAuthCredential credential = GoogleAuthProvider.credential(idToken: idToken);

      // 5) sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user == null) return false;

      // 6) store minimal info securely (optional)
      await storage.write(key: 'Googletoken', value: idToken);
      await storage.write(key: 'id', value: user.uid);
      await storage.write(key: 'user_email', value: user.email ?? '');
      await storage.write(key: 'user_name', value: user.displayName ?? '');

      // call your backend if needed
      final token = await storage.read(key: 'Googletoken');
      if (token != null && token.isNotEmpty) {
        await authController.google_login(token);
      }

      return true;
    } catch (e, st) {
      print('Google Sign In Error: $e\n$st');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    try {
      await _auth.signOut();
    } catch (_) {}
    try {
      await storage.deleteAll();
    } catch (_) {}
  }
}
