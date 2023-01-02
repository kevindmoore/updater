import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utilities/utilities.dart';

import '../providers.dart';
import '../theme/theme.dart';

typedef VisibilityButtonPressed = void Function(bool);

class LoginDialog extends ConsumerStatefulWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _LoginDialogState();
}

class _LoginDialogState extends ConsumerState<LoginDialog> {
  late TextEditingController emailTextController;
  late TextEditingController repeatPasswordTextController;
  late TextEditingController passwordTextController;
  var rememberMe = true;
  var useLoginScreen = true;
  var hideFirstPassword = true;
  var hideSecondPassword = true;

  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController(text: '');
    repeatPasswordTextController = TextEditingController(text: '');
    passwordTextController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    emailTextController.dispose();
    repeatPasswordTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter, meta: false): oKAction,
      },
      child: SafeArea(
           child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Container(
                decoration: createWhiteBorder(),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: useLoginScreen
                        ? createLoginScreen()
                        : createCreateAccountScreen()),
                // ),
              ),
            ),
          ),
        ),
    );
  }

  void oKAction() async {
    if (useLoginScreen) {
      if (emailTextController.text.isNotEmpty &&
          passwordTextController.text.isNotEmpty) {
        if (await login(
            emailTextController.text, passwordTextController.text)) {}
      }
    } else {
      if (await createUser()) {
        // Navigator.pop(context);
      }
    }
  }

  Widget createLoginScreen() {
    return ListView(
      children: [
        createLoginLabel(),
        const SizedBox(
          height: 16,
        ),
        createEmailTextField(),
        createEmailField(),
        createPasswordTextField(),
        createPasswordField(passwordTextController, hideFirstPassword,
            toggleFirstPasswordVisibility),
        // createGoogleLoginButton(),
        createRememberMeRow(),
        const SizedBox(
          height: 16,
        ),
        createLoginButtonRow(),
        const SizedBox(
          height: 8,
        ),
        createAnAccountRow(),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  void toggleFirstPasswordVisibility(bool visible) {
    hideFirstPassword = visible;
  }

  void toggleSecondPasswordVisibility(bool visible) {
    hideSecondPassword = visible;
  }

  Widget createCreateAccountScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0.0, top: 10.0, bottom: 32.0),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      useLoginScreen = true;
                    });
                  },
                  icon: const Icon(Icons.chevron_left)),
              TextButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black)),
                  onPressed: () {
                    setState(() {
                      useLoginScreen = true;
                    });
                  },
                  child: Text(
                    'Create an account',
                    style: titleBlackText,
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0.0, top: 10.0, bottom: 12.0),
          child: Text(
            'Email',
            style: largeBlackText,
          ),
        ),
        createEmailField(),
        Padding(
          padding: const EdgeInsets.only(left: 0.0, top: 0.0, bottom: 12.0),
          child: Text(
            'Password',
            style: largeBlackText,
          ),
        ),
        createPasswordField(passwordTextController, hideFirstPassword,
            toggleFirstPasswordVisibility),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0.0, top: 0.0, bottom: 12.0),
          child: Text(
            'Repeat Password',
            style: largeBlackText,
          ),
        ),
        createPasswordField(repeatPasswordTextController, hideSecondPassword,
            toggleSecondPasswordVisibility),
        // Expanded(
        //   child: TextField(
        //     keyboardType: TextInputType.text,
        //     obscureText: true,
        //     enableSuggestions: false,
        //     autocorrect: false,
        //     decoration: createTextBorder('Min. 8 characters', null),
        //     autofocus: false,
        //     onSubmitted: (value) {},
        //     controller: repeatPasswordTextController,
        //   ),
        // ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: lightBlueColor, padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 20.0),
                    elevation: 0,
                    shape: createWhiteRoundedBorder(),
                  ),
                  onPressed: () async {
                    await createUser();
                  },
                  child: const Text('Create Account'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Future<bool> createUser() async {
    final email = emailTextController.text;
    final password1 = passwordTextController.text;
    final password2 = repeatPasswordTextController.text;
    if (email.isEmpty) {
      showSnackBar(context, 'Email cannot be empty');
      return false;
    }
    if (password1.isEmpty || password2.isEmpty) {
      showSnackBar(context, 'Passwords cannot be empty');
      return false;
    }
    if (password1 != password2) {
      showSnackBar(context, 'Passwords are not equal');
      return false;
    }
    final authenticator = getSupaAuthManager(ref);
    final result = await authenticator.createUser(email, password1);
    return result.when(success: (data) {
      return data;
    }, failure: (Exception error) {
      return false;
    }, errorMessage: (int code, String? message) {
      return false;
    });
  }

  Widget createPasswordField(TextEditingController controller, bool showText,
      VisibilityButtonPressed buttonPressed) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            keyboardType: TextInputType.text,
            obscureText: showText,
            enableSuggestions: false,
            autofocus: false,
            onSubmitted: (value) {},
            controller: controller,
            autocorrect: false,
            decoration: createTextBorder(
              'Min. 8 characters',
              IconButton(
                onPressed: () {
                  setState(() {
                    buttonPressed(showText.toggle());
                  });
                },
                icon: Icon(
                  (showText ? Icons.visibility : Icons.visibility_off),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget createEmailField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: createTextBorder('bob@example.com', null),
            autofocus: false,
            onSubmitted: (value) {},
            controller: emailTextController,
          ),
        ),
      ],
    );
  }

  Widget createGoogleLoginButton() {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: lightBlueColor, padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 20.0),
                  elevation: 0,
                  shape: createWhiteRoundedBorder(),
                ),
                onPressed: () async {
                  if (emailTextController.text.isNotEmpty &&
                      passwordTextController.text.isNotEmpty) {
                    if (await login(emailTextController.text,
                        passwordTextController.text)) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Google SignIn'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget createEmailTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, top: 10.0, bottom: 12.0),
      child: Text(
        'Email',
        style: largeBlackText,
      ),
    );
  }

  Widget createPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, top: 0.0, bottom: 12.0),
      child: Text(
        'Password',
        style: largeBlackText,
      ),
    );
  }

  Widget createRememberMeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          value: rememberMe,
          activeColor: Colors.blue,
          checkColor: Colors.white,
          onChanged: (value) {
            setState(
              () {
                if (value != null) {
                  rememberMe = value;
                }
              },
            );
          },
        ),
        Text(
          'Remember me',
          style: smallBlackText,
        ),
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            getSupaAuthManager(ref).resetPassword(emailTextController.text);
            if (!mounted) return;
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Email Sent')));
          },
          child: Text(
            'Forgot password?',
            style: smallBlueText,
          ),
        ),
      ],
    );
  }

  Widget createLoginButtonRow() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: lightBlueColor, padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 20.0),
                elevation: 0,
                shape: createWhiteRoundedBorder(),
              ),
              onPressed: () async {
                if (emailTextController.text.isNotEmpty &&
                    passwordTextController.text.isNotEmpty) {
                  await login(
                      emailTextController.text, passwordTextController.text);
                }
              },
              child: const Text('Login'),
            ),
          ),
        ),
      ],
    );
  }

  Widget createAnAccountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Not registered yet?',
          style: smallBlackText,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              useLoginScreen = false;
            });
          },
          child: Text('Create an account', style: smallBlueText),
        ),
      ],
    );
  }

  Widget createGoogleSignOn() {
    return Container();
    /*
            Center(
              child: ElevatedButton.icon(
                icon: SvgPicture.asset('assets/images/logo_googleg.svg',
                    semanticsLabel: 'Google'),
                onPressed: () {
                  ref.read(logInManagerProvider).signInWithGoogle();
                },
                label: Text(
                  'Sign in with Google',
                  style: mediumBlackText,
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
                  elevation: 0,
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: createWhiteRoundedBorder(),
                ),
              ),
            ),


            const SizedBox(
              height: 16,
            ),
            Row(
              // mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Divider(
                    color: dividerColor,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'or sign in with email',
                  style: smallGreyText,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Divider(
                    color: dividerColor,
                  ),
                ),
              ],
            ),
    );
*/
  }

  Widget createLoginLabel() {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, top: 10.0, bottom: 32.0),
      child: Text(
        'Login',
        style: titleBlackText,
      ),
    );
  }

  Future<bool> login(String email, String password) async {
    final response =
        await getSupaAuthManager(ref).login(email, password);
    response.maybeWhen(success: (result) {
      return true;
    }, errorMessage: (int code, String? message) {
      if (!mounted) return false;
      if (message != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
      return false;
    }, orElse: () {
      return false;
    });
    return false;
  }

/*
  Future<bool> googleSignIn() async {
    final response = await getSupaAuthManager(ref).googleSignIn();
    if (response is String) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response)));
    }
    return true;
  }
*/
}
