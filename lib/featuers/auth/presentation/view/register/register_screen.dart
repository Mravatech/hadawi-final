import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/widgets/register_view_body.dart';
import 'package:hadawi_app/widgets/app_bar_without_height_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().isLoading=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithoutHeightWidget(),
      body: Directionality(
          textDirection: TextDirection.rtl,
          child: RegisterViewBody()
      )
    );
  }
}
