import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;
import 'package:basic_book_crud_msib/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class RegisterController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  RxBool obscureTextPassword = true.obs;
  RxBool obscureTextConfirm = true.obs;

  RxBool isLoading = false.obs;

  Future<void> registerUser(BuildContext context) async {
    try {
      isLoading.value = true;

      Dio dio = Dio();
      Response response = await dio.post(
        'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/register',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: {
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'password_confirmation': confirmPasswordController.text,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Register Successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        // Anda dapat menavigasi ke halaman lain di sini jika diperlukan
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to add book. Status: ${response.statusCode}'),
            duration:
                Duration(seconds: 2), // Durasi snackbar ditampilkan (opsional)
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('An error occurred while registering the user'),
          duration:
              Duration(seconds: 2), // Durasi snackbar ditampilkan (opsional)
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController registerController = Get.put(RegisterController());

  final _keyFormRegister = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();
  String _email = '';
  String _password = '';
  bool _obscureTextPassword = true;
  bool _obscureTextConfirm = true;

  Future<Map<String, dynamic>> RegisterUser(String name, String email,
      String password, String confirmPassword) async {
    final response = await http.post(
      Uri.parse(
          'https://book-crud-service-6dmqxfovfq-et.a.run.app/api/register'), // Ganti dengan URL login Anda
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword
      }),
    );

    if (response.statusCode == 200) {
      // Login berhasil
      print(json.decode(response.body));
      return {'success': true, 'message': json.decode(response.body)};
    } else {
      // Login gagal
      print(json.decode(response.body));
      return {'success': false, 'message': json.decode(response.body)};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(32),
        child: Form(
            key: registerController.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  autofocus: true,
                  controller: registerController.nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                TextFormField(
                  autofocus: true,
                  controller: registerController.emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: registerController.passwordController,
                  obscureText: _obscureTextPassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureTextPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureTextPassword = !_obscureTextPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: registerController.confirmPasswordController,
                  obscureText: _obscureTextConfirm,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureTextConfirm
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureTextConfirm = !_obscureTextConfirm;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Password';
                    } else if (value != registerController.passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                    onPressed: () async {
                      if (registerController.formKey.currentState!.validate()) {
                        registerController.formKey.currentState!.save();
                        var result = await registerController.registerUser(context);
                        Get.delete<RegisterController>();
                        // if (result['success']) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       backgroundColor: Colors.green,
                        //       content: Text('Register Successfully'),
                        //       duration: Duration(
                        //           seconds:
                        //               2), // Durasi snackbar ditampilkan (opsional)
                        //     ),
                        //   );
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       backgroundColor: Colors.red,
                        //       content: Text('Failed : ${result['message']}'),
                        //       duration: Duration(
                        //           seconds:
                        //               2), // Durasi snackbar ditampilkan (opsional)
                        //     ),
                        //   );
                        // }
                      }
                    },
                    child: Text('Register')),
                const SizedBox(height: 32),
                Text('Sudah punya akun?'),
                TextButton(
                    onPressed: () {
                      Get.delete<RegisterController>();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text('Klik disini untuk Login'))
              ],
            )),
      )),
    );
  }
}
