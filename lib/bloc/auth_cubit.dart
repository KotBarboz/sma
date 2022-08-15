import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  var errorMessage = "An error has occurred!";

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user!;

      emit(const AuthLogin());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }
      if (kDebugMode) {
        print(errorMessage);
      }
      emit(AuthFailure(message: errorMessage));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(AuthFailure(message: errorMessage));
    }
  }

  Future<void> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set({
        "userId": credential.user!.uid,
        "username": username,
        "email": email,
      });

      credential.user!.updateDisplayName(username);

      emit(const AuthSignedUp());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }
      if (kDebugMode) {
        print(errorMessage);
      }
      emit(AuthFailure(message: errorMessage));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(AuthFailure(message: errorMessage));
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
