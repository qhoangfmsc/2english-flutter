import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import 'register_screen.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../splash/screens/splash_screen.dart';
import '../common/auth_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Using constants from auth_constants.dart

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Navigate to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
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
                _buildPasswordField(),
                const SizedBox(height: AuthConstants.gapLarge),
                _buildLoginButton(),
                          ],
                        ),
                      ),
                      const Spacer(),
                      _buildSocialAndRegister(),
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
                builder: (context) => const SplashScreen(),
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
          '2English',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: AuthConstants.gap),
        Text(
          'Welcome\nback!',
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
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _usernameController,
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

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
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
      onFieldSubmitted: (_) => _handleLogin(),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthConstants.buttonCornerRadius),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Đăng nhập',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialCircle({
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chức năng đăng nhập mạng xã hội chưa được triển khai')),
        );
      },
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }

  Widget _buildSocialAndRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'hoặc đăng nhập với',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialCircle(icon: Icons.facebook, color: const Color(0xFF1877F2)),
            _buildSocialCircle(icon: Icons.g_mobiledata, color: const Color(0xFF4285F4)),
            _buildSocialCircle(icon: Icons.apple, color: Colors.black),
          ],
        ),
        const SizedBox(height: 16),
        _buildRegisterPrompt(),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildRegisterPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Chưa có tài khoản? ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          },
          child: const Text(
            'Đăng ký ngay',
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

