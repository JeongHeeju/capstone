/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 텍스트 필드 컨트롤러
  final _usernameController = TextEditingController();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  /*Future<void> signupUser() async {
    if (_passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/users/signup/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _usernameController.text,
          'user_id': _userIdController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 성공! 로그인 화면으로 이동합니다.')),
        );
        Navigator.pushNamed(context, '/login');
      } else {
        final error = json.decode(response.body)['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: $error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 중 오류 발생: $e')),
      );
    }
  }*/

  // 오류 메시지 변수
  String? _nameError;
  String? _idError;
  String? _passwordError;
  String? _confirmPasswordError;

  // 비밀번호 보이기/숨기기 상태
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // 포커스 노드
  /*FocusNode _passwordFocusNode = FocusNode();
  FocusNode _confirmPasswordFocusNode = FocusNode();*/

  // 비밀번호 입력 필드 클릭 여부
  bool _isPasswordFieldTapped = false;
  bool _isConfirmPasswordFieldTapped = false;

  // 입력 검증 함수
  void _validateName() {
    setState(() {
      _nameError = _usernameController.text.length < 3 ? "3자리 이상 입력해주세요" : null;
    });
  }

  void _validateId() {
    setState(() {
      _idError = _userIdController.text.length < 6 ? "영문 6자리 이상 입력해주세요" : null;
    });
  }

  void _validatePassword() {
    setState(() {
      _passwordError =
          _passwordController.text.length < 6 ? "영문 6자리 이상 입력해주세요" : null;
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      _confirmPasswordError =
          _passwordConfirmController.text != _passwordController.text
              ? "비밀번호가 일치하지 않습니다"
              : null;
    });
  }

  @override

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: _scrollController.hasClients && _scrollController.offset > 3
            ? Color(0xFFE0E0E0) // 스크롤 시 색상 변경
            : Color(0xFFFBFBFB), // 기본색
        title: Text(
          '회원가입',
          style: TextStyle(color: Color(0xFF2F2F2F)),
        ),
      ),*/
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: Color(0xFFFBFBFB),
          /*backgroundColor: _scrollController.hasClients && _scrollController.offset > 3
                ? Color(0xFFE0E0E0) // 스크롤 시 색상 변경
                : Color(0xFFFBFBFB),*/ // 기본색
          title: Text('회원가입', style: TextStyle(color: Color(0xFF2F2F2F))),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFBFBFB), // 배경색 설정
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            // 화면을 차지하는 스크롤 가능한 부분
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 사용자 이름 입력
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: '사용자 이름 입력',
                        hintText: '3자리 이상 입력해주세요',
                        hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                        errorText: _nameError,
                        errorStyle: TextStyle(color: Color(0xFFFF5833)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2F2F2F)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2F2F2F)),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF5833)),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF5833)),
                        ),
                      ),
                      onChanged: (text) {
                        _validateName(); // 실시간 검증
                      },
                    ),
                    SizedBox(height: 50),
                    // 아이디 입력
                    TextField(
                      controller: _userIdController,
                      decoration: InputDecoration(
                        labelText: '아이디 입력',
                        hintText: '영문 6자리 이상 입력해주세요',
                        hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                        errorText: _idError,
                        errorStyle: TextStyle(color: Color(0xFFFF5833)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2F2F2F)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2F2F2F)),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF5833)),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF5833)),
                        ),
                      ),
                      onChanged: (text) {
                        _validateId(); // 실시간 검증
                      },
                    ),
                    SizedBox(height: 50),
                    // 비밀번호 입력
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: '비밀번호 입력',
                        hintText: '영문 6자리 이상 입력해주세요',
                        hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                        errorText: _passwordError,
                        errorStyle: TextStyle(color: Color(0xFFFF5833)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2F2F2F)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2F2F2F)),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF5833)),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF5833)),
                        ),
                        suffixIcon: _isPasswordFieldTapped
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0), // 패딩 값 추가
                                child: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(0xFF2F2F2F),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible =
                                          !_isPasswordVisible; // 비밀번호 보이기/숨기기 토글
                                    });
                                  },
                                ),
                              )
                            : null,
                      ),
                      onTap: () {
                        setState(() {
                          _isPasswordFieldTapped = true;
                        });
                      },
                      onChanged: (text) {
                        _validatePassword(); // 실시간 검증
                      },
                    ),
                    SizedBox(height: 50),
                    // 비밀번호 확인 입력
                    TextField(
                      controller: _passwordConfirmController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        labelText: '비밀번호 확인',
                        hintText: '영문 6자리 이상 입력해주세요',
                        hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                        errorText: _confirmPasswordError,
                        errorStyle: TextStyle(color: Color(0xFFFF5833)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2F2F2F)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2F2F2F)),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF5833)),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFF5833)),
                        ),
                        suffixIcon: _isConfirmPasswordFieldTapped
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0), // 좌우 패딩만 적용
                                child: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(0xFF2F2F2F),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                              )
                            : null,
                      ),
                      onTap: () {
                        setState(() {
                          _isConfirmPasswordFieldTapped = true;
                        });
                      },
                      onChanged: (text) {
                        _validateConfirmPassword();
                      },
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          // 회원가입 버튼 (하단 고정)
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                // 모든 입력 검증 후 성공적으로 회원가입 로직 처리
                if (_nameError == null && _idError == null &&
                    _passwordError == null && _confirmPasswordError == null) {
                  Navigator.pushNamed(context, '/success');
                }
              },
              //onPressed: signupUser, // 회원가입 API 호출 함수 연결
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5833),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: Text(
                '회원가입',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFBFBFB)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter_projects/screen/signup_provider.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  final bool fromInformationScreen;

  const SignupScreen({super.key, this.fromInformationScreen = false});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final ScrollController _scrollController = ScrollController();

  late TextEditingController _nameController;
  late TextEditingController _idController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  late String _initialName;
  late String _initialId;
  late String _initialPassword;
  late String _initialConfirmPassword;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isPasswordFieldTapped = false;
  bool _isConfirmPasswordFieldTapped = false;

  @override
  void initState() {
    super.initState();
    final signupProvider = Provider.of<SignupProvider>(context, listen: false);
    _initialName = signupProvider.name;
    _initialId = signupProvider.id;
    _initialPassword = signupProvider.password;
    _initialConfirmPassword = signupProvider.confirmPassword;

    _nameController = TextEditingController(text: signupProvider.name);
    _idController = TextEditingController(text: signupProvider.id);
    _passwordController = TextEditingController(text: signupProvider.password);
    _confirmPasswordController = TextEditingController(text: signupProvider.confirmPassword);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ModalRoute.of(context)?.addScopedWillPopCallback(_onWillPop);
    });
  }

  @override
  void dispose() {
    ModalRoute.of(context)?.removeScopedWillPopCallback(_onWillPop);
    _scrollController.dispose();
    _nameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final signupProvider = Provider.of<SignupProvider>(context, listen: false);
    signupProvider.setName(_initialName);
    signupProvider.setId(_initialId);
    signupProvider.setPassword(_initialPassword);
    signupProvider.setConfirmPassword(_initialConfirmPassword);
    return true;
  }


  @override
  Widget build(BuildContext context) {
    final signupProvider = Provider.of<SignupProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          //automaticallyImplyLeading: !widget.fromInformationScreen, // ← 뒤로가기 여부 설정
          backgroundColor: Color(0xFFFBFBFB),
          title: Text(widget.fromInformationScreen ? '기본정보 변경' : '회원가입'),
          centerTitle: true,
          automaticallyImplyLeading: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Color(0xFFFBFBFB)),
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이름 입력
                  TextField(
                    controller: _nameController,
                    onChanged: (val) {
                      signupProvider.setName(val);
                      signupProvider.validateName();
                    },
                    decoration: _buildInputDecoration(
                      label: '사용자 이름 입력',
                      hint: '3자리 이상 입력해주세요',
                      error: signupProvider.nameError,
                    ),
                  ),
                  SizedBox(height: 50),

                  // 아이디 입력
                  TextField(
                    controller: _idController,
                    onChanged: (val) {
                      signupProvider.setId(val);
                      signupProvider.validateId();
                    },
                    decoration: _buildInputDecoration(
                      label: '아이디 입력',
                      hint: '영문 6자리 이상 입력해주세요',
                      error: signupProvider.idError,
                    ),
                  ),
                  SizedBox(height: 50),

                  // 비밀번호 입력
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    onChanged: (val) {
                      signupProvider.setPassword(val);
                      signupProvider.validatePassword();
                    },
                    onTap: () {
                      setState(() {
                        _isPasswordFieldTapped = true;
                      });
                    },
                    decoration: _buildInputDecoration(
                      label: '비밀번호 입력',
                      hint: '영문 6자리 이상 입력해주세요',
                      error: signupProvider.passwordError,
                      iconButton: _isPasswordFieldTapped
                          ? IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFF2F2F2F),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      )
                          : null,
                    ),
                  ),
                  SizedBox(height: 50),

                  // 비밀번호 확인 입력
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    onChanged: (val) {
                      signupProvider.setConfirmPassword(val);
                      signupProvider.validateConfirmPassword();
                    },
                    onTap: () {
                      setState(() {
                        _isConfirmPasswordFieldTapped = true;
                      });
                    },
                    decoration: _buildInputDecoration(
                      label: '비밀번호 확인',
                      hint: '비밀번호를 다시 입력해주세요',
                      error: signupProvider.confirmPasswordError,
                      iconButton: _isConfirmPasswordFieldTapped
                          ? IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFF2F2F2F),
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      )
                          : null,
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () async {
                signupProvider.setName(_nameController.text);
                signupProvider.setId(_idController.text);
                signupProvider.setPassword(_passwordController.text);
                signupProvider.setConfirmPassword(_confirmPasswordController.text);
                signupProvider.validateAll();

                if (signupProvider.isValid) {
                  await signupProvider.saveUser();
                  if (widget.fromInformationScreen) {
                    Navigator.pop(context, 'saved');
                  } else {
                    Navigator.pushNamed(context, '/login');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5833),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: Text(
                widget.fromInformationScreen ? '저장' : '회원가입',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFBFBFB),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required String hint,
    required String? error,
    Widget? iconButton,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
      errorText: error,
      errorStyle: TextStyle(color: Color(0xFFFF5833)),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF2F2F2F)),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF2F2F2F)),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFF5833)),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFF5833)),
      ),
      suffixIcon: iconButton,
    );
  }
}