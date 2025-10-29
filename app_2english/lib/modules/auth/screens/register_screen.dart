import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';
import '../common/auth_constants.dart';
import '../../../core/theme/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Using constants from auth_constants.dart

  @override
  void dispose() {
    _phoneController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AuthConstants.registerSuccess),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: AuthConstants.gapSmall),
                            _buildHeader(),
                            const SizedBox(height: AuthConstants.gapXL),
                            _buildPhoneField(),
                            const SizedBox(height: AuthConstants.gapLarge),
                            _buildFullNameField(),
                            const SizedBox(height: AuthConstants.gapLarge),
                            _buildPasswordField(),
                            const SizedBox(height: AuthConstants.gapLarge),
                            _buildConfirmPasswordField(),
                            const SizedBox(height: AuthConstants.gapLarge),
                            _buildRegisterButton(),
                          ],
                        ),
                      ),
                      const Spacer(),
                      _buildLoginPrompt(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Tạo tài khoản\nmới',
          style: TextStyle(
            fontSize: 36,
            height: 1.05,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? prefixText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefixText: prefixText,
      filled: true,
      fillColor: AuthConstants.fieldFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AuthConstants.cornerRadius),
        borderSide: const BorderSide(color: AuthConstants.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AuthConstants.cornerRadius),
        borderSide: const BorderSide(color: AuthConstants.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AuthConstants.cornerRadius),
        borderSide: const BorderSide(color: AuthConstants.brandColor, width: 1.5),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: _inputDecoration(
        label: 'Số điện thoại',
        hint: 'Số điện thoại',
        prefixIcon: const Icon(Icons.phone_iphone_outlined),
        prefixText: '  +84  ',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập số điện thoại';
        }
        final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.length < 9) {
          return 'Số điện thoại không hợp lệ';
        }
        return null;
      },
    );
  }

  Widget _buildFullNameField() {
    return TextFormField(
      controller: _fullNameController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      decoration: _inputDecoration(
        label: 'Họ và tên',
        hint: 'Nhập họ và tên của bạn',
        prefixIcon: const Icon(Icons.person_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập họ và tên';
        }
        if (value.trim().length < 2) {
          return 'Họ và tên phải có ít nhất 2 ký tự';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: _inputDecoration(
        label: 'Mật khẩu',
        hint: 'Nhập mật khẩu của bạn',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập mật khẩu';
        }
        if (value.length < 6) {
          return 'Mật khẩu phải có ít nhất 6 ký tự';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      textInputAction: TextInputAction.done,
      decoration: _inputDecoration(
        label: 'Xác nhận mật khẩu',
        hint: 'Nhập lại mật khẩu',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng xác nhận mật khẩu';
        }
        if (value != _passwordController.text) {
          return 'Mật khẩu không khớp';
        }
        return null;
      },
      onFieldSubmitted: (_) => _handleRegister(),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthConstants.buttonCornerRadius),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Tạo tài khoản',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Đã có tài khoản? ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Đăng nhập ngay',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
