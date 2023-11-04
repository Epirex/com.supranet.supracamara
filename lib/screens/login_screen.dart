import 'package:flutter/material.dart';
import 'package:video_editors/screens/select_item_screen.dart';
import 'package:video_editors/shared/services/business/get_business.dart';
import 'package:video_editors/shared/services/login/post_login.dart';
import '../themes/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ScaffoldMessengerState? _snackbarManager;

  @override
  void initState() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _snackbarManager = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    _snackbarManager?.removeCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Iniciar sesión",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Usuario",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Escribe aquí tu usuario",
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColors.appColor1,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresá tu email';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Contraseña",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      //style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Escribe aquí tu contraseña",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: AppColors.appColor1,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresá tu clave';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 20.0),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                  onPressed: () {
                    loginUsers();
                  },
                  child: const Text('Iniciar sesión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginUsers() async {
    if (_formKey.currentState!.validate()) {
      //show snackbar to indicate loading
      _snackbarManager?.showSnackBar(SnackBar(
        content: const Text('Estamos validando tus datos!'),
        backgroundColor: Colors.green.shade300,
      ));

      //get response from ApiClient
      Map<String, dynamic> res = await LoginService().login(
        emailController.text,
        passwordController.text,
      );

      //if there is no error, get the user's accesstoken and pass it to HomeScreen
      if (res['success']) {
        Map<String, dynamic> business =
            await BusinessService().business(res['response']['id']);
        if (business['_id'] != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectItemScreen(
                        data: business,
                      )));
        }
        _snackbarManager?.hideCurrentSnackBar();
      } else {
        //if an error occurs, show snackbar with error message
        _snackbarManager?.showSnackBar(SnackBar(
          content: Text('Error: ${res['response']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    } else {
      _snackbarManager?.showSnackBar(
        const SnackBar(content: Text('Revisá los datos que ingresaste')),
      );
    }
  }
}
