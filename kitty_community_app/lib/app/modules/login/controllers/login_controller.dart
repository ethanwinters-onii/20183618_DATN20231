import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitty_community_app/app/core/base/base_controller.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:kitty_community_app/app/core/utils/extensions/logger_extension.dart';
import 'package:kitty_community_app/app/core/utils/helpers/get_account_local.dart';
import 'package:kitty_community_app/app/core/values/enums/status.dart';
import 'package:kitty_community_app/app/core/values/languages/key_language.dart';
import 'package:kitty_community_app/app/data/models/user_model/account_info.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_constants.dart';
import 'package:kitty_community_app/app/data/providers/firebase/firebase_provider.dart';
import 'package:kitty_community_app/app/global_widgets/custom_dialog.dart';
import 'package:kitty_community_app/app/routes/app_pages.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/utils/local_storage/hive_storage.dart';
import '../../../core/utils/local_storage/local_db_constants.dart';

class LoginController extends BaseController {
  final TextEditingController emailEdittingController = TextEditingController();
  final TextEditingController passwordEdittingController =
      TextEditingController();

  RxBool isAvailableEmail = false.obs;
  RxBool showPassword = false.obs;

  // for register email, password
  final TextEditingController registerFullnameEdittingController =
      TextEditingController();
  final TextEditingController registerEmailEdittingController =
      TextEditingController();
  final TextEditingController registerPasswordEdittingController =
      TextEditingController();
  final TextEditingController registerConfirmPasswordEdittingController =
      TextEditingController();

  RxBool isAvailableResgisterEmail = false.obs;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  RxBool isShowLoading = false.obs;
  RxBool isShowConfetti = false.obs;

  @override
  Future<void> initialData() {
    // TODO: implement initialData
    setStatus(Status.success);
    return super.initialData();
  }

  @override
  Future<void> fetchData() {
    // TODO: implement fetchData
    return super.fetchData();
  }

  void onChangeEmail() {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailEdittingController.text);
    isAvailableEmail.value = emailValid;
  }

  void changeShowPassword() {
    showPassword.value = !showPassword.value;
  }

  Future<void> handleLoginWithFacebook() async {
    _signInWithFacebook().then((userCredential) async {
      logger.d(userCredential);
      if (!(await FirebaseProvider.userExists())) {
        logger.d("Create New User");
        final token = await FirebaseConstants.firebaseMessaging.getToken();
        final newAccount = AccountInfo(
            userId: userCredential?.user?.uid,
            name: userCredential?.user?.displayName,
            onFirstLogin: true,
            deviceToken: token,
            avatar: userCredential?.additionalUserInfo?.profile?["picture"]
                ["data"]["url"],
            following: userCredential?.user?.uid == null ? [] : [userCredential!.user!.uid],
            isOnline: true,
            lastActive: DateTime.now().millisecondsSinceEpoch.toString()
        );
        await FirebaseProvider.createUser(newAccount);
        AccountLocalHelper.save(newAccount);
        Get.offAllNamed(Routes.UPDATE_PROFILE);
      } else {
        final accountInfo = await FirebaseProvider.getUserById(userCredential?.user?.uid ?? "");
        if (accountInfo != null) {
          logger.d(accountInfo.toJson());
          AccountLocalHelper.save(accountInfo);
          if (accountInfo.onFirstLogin == true) {
            Get.offAllNamed(Routes.UPDATE_PROFILE);
          } else {
            Get.offAllNamed(Routes.WRAP);
          }
        } else {
          showErrorDialog(KeyLanguage.c500.tr);
        }
      }
    });
  }

  Future<UserCredential?> _signInWithFacebook() async {
    // Trigger the sign-in flow
    setStatus(Status.waiting);
    isShowLoading.value = true;
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.accessToken != null) {
      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      logger.w(loginResult.accessToken?.toJson());

      check.fire();
      Future.delayed(const Duration(milliseconds: 1500), () {
        isShowLoading.value = false;
        setStatus(Status.success);
      });

      // Once signed in, return the UserCredential
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } else {
      return null;
    }
  }

  void handleLoginWithGoogle() async {
    _signInWithGoogle().then((userCredential) async {
      if (userCredential != null) {
        logger.d(userCredential);
        if (!(await FirebaseProvider.userExists())) {
          logger.d("Create New User");
          final token = await FirebaseConstants.firebaseMessaging.getToken();
          final newAccount = AccountInfo(
              userId: userCredential.user?.uid,
              name: userCredential.user?.displayName,
              onFirstLogin: true,
              deviceToken: token,
              avatar: userCredential.additionalUserInfo?.profile?["picture"],
              following: userCredential.user?.uid == null ? [] : [userCredential.user!.uid],
              isOnline: true,
              lastActive: DateTime.now().millisecondsSinceEpoch.toString()
          );
          await FirebaseProvider.createUser(newAccount);
          AccountLocalHelper.save(newAccount);
          Get.offAllNamed(Routes.UPDATE_PROFILE);
        } else {
          final accountInfo = await FirebaseProvider.getUserById(userCredential.user?.uid ?? "");
          if (accountInfo != null) {
            logger.d(accountInfo.toJson());
            AccountLocalHelper.save(accountInfo);
            if (accountInfo.onFirstLogin == true) {
              Get.offAllNamed(Routes.UPDATE_PROFILE);
            } else {
              Get.offAllNamed(Routes.WRAP);
            }
          } else {
            showErrorDialog(KeyLanguage.c500.tr);
          }
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        return null;
      }
    } on Exception catch (e) {
      // TODO
      logger.e("_signInWithGoogle: $e");

      return null;
    }
  }

  void onChangeRegisterEmail() {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(registerEmailEdittingController.text);
    isAvailableResgisterEmail.value = emailValid;
  }

  void signUpWithEmailAndPassword() async {
    if (!isAvailableResgisterEmail.value) {
      showErrorDialog(KeyLanguage.invalid_registration_email.tr);
    } else if (registerFullnameEdittingController.text.trim().isEmpty) {
      showErrorDialog(KeyLanguage.full_name_can_not_be_empty.tr);
    } else if (registerPasswordEdittingController.text.trim().isEmpty) {
      showErrorDialog(KeyLanguage.password_can_not_be_empty.tr);
    } else if (registerConfirmPasswordEdittingController.text !=
        registerPasswordEdittingController.text) {
      showErrorDialog(KeyLanguage.password_verifier_is_not_correct.tr);
    } else {
      try {
        Get.back();
        isShowLoading.value = true;
        isShowConfetti.value = true;
        setStatus(Status.waiting);
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: registerEmailEdittingController.text,
          password: registerConfirmPasswordEdittingController.text,
        )
            .then((result) async {
          logger.d(result.toString());
          await result.user?.sendEmailVerification();
          check.fire();
          Future.delayed(const Duration(milliseconds: 1500), () {
            isShowLoading.value = false;
            confetti.fire();
            Future.delayed(const Duration(seconds: 1), () {
              isShowConfetti.value = false;
              setStatus(Status.success);
              showSuccessDialog(KeyLanguage.sign_up_successfully_please_verify_your_email_to_sign_in.tr);
            });
          });
        });
      } on FirebaseAuthException catch (e) {
        logger.e(e);
        error.fire();
        Future.delayed(const Duration(seconds: 1), () {
          isShowLoading.value = false;
          isShowConfetti.value = false;
          setStatus(Status.success);
        });
        if (e.code == 'weak-password') {
          showErrorDialog("Password should be at least 6 characters");
        } else if (e.code == 'email-already-in-use') {
          showErrorDialog(KeyLanguage.account_already_exisited.tr);
        }
      } catch (e) {
        isShowLoading.value = false;
        isShowConfetti.value = false;
        setStatus(Status.success);
        showErrorDialog(KeyLanguage.c500.tr);
      }
    }
  }

  void handleLoginWithEmailAndPassword() async {
    if (!isAvailableEmail.value) {
      showErrorDialog(KeyLanguage.invalid_registration_email.tr);
    } else if (passwordEdittingController.text.trim().isEmpty) {
      showErrorDialog(KeyLanguage.password_can_not_be_empty.tr);
    } else {
      try {
        setStatus(Status.waiting);
        isShowLoading.value = true;
        isShowConfetti.value = true;
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailEdittingController.text,
                password: passwordEdittingController.text);
        logger.d(credential.toString());
        if (credential.user?.emailVerified ?? false) {
          logger.d("Authorized");
          if (!(await FirebaseProvider.userExists())) {
            logger.d("Create New User");
            final token = await FirebaseConstants.firebaseMessaging.getToken();
            final newAccount = AccountInfo(
              userId: credential.user?.uid,
              name: registerFullnameEdittingController.text.trim(),
              onFirstLogin: true,
              deviceToken: token,
              following: credential.user?.uid == null ? [] : [credential.user!.uid],
              isOnline: true,
              lastActive: DateTime.now().millisecondsSinceEpoch.toString()
            );
            await FirebaseProvider.createUser(newAccount);
            AccountLocalHelper.save(newAccount);
            Get.offAllNamed(Routes.UPDATE_PROFILE);
          } else {
            final accountInfo = await FirebaseProvider.getUserById(credential.user?.uid ?? "");
            if (accountInfo != null) {
              logger.d(accountInfo.toJson());
              AccountLocalHelper.save(accountInfo);
              if (accountInfo.onFirstLogin == true) {
                check.fire();
                Future.delayed(const Duration(milliseconds: 1500), () {
                  isShowLoading.value = false;
                  confetti.fire();
                  Future.delayed(const Duration(seconds: 1), () {
                    isShowConfetti.value = false;
                    setStatus(Status.success);
                    Get.offAllNamed(Routes.UPDATE_PROFILE);
                  });
                });
              } else {
                check.fire();
                Future.delayed(const Duration(milliseconds: 1500), () {
                  isShowLoading.value = false;
                  confetti.fire();
                  Future.delayed(const Duration(seconds: 1), () {
                    isShowConfetti.value = false;
                    setStatus(Status.success);
                    Get.offAllNamed(Routes.WRAP);
                  });
                });
              }
            } else {
              showErrorDialog(KeyLanguage.c500.tr);
            }
          }
        } else {
          credential.user?.sendEmailVerification();
          logger.d("Not Authorized");
          error.fire();
          Future.delayed(const Duration(seconds: 2), () {
            isShowLoading.value = false;
            setStatus(Status.success);
            showErrorDialog(KeyLanguage.email_is_not_verified.tr);
          });
        }
      } on FirebaseAuthException catch (e) {
        error.fire();
        Future.delayed(const Duration(seconds: 2), () {
          isShowLoading.value = false;
          isShowConfetti.value = false;
          setStatus(Status.success);
        });
        if (e.code == 'user-not-found') {
          logger.e('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          logger.e('Wrong password provided for that user.');
        }
      }
    }
  }
}
