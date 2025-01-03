import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 텍스트 필드 컨트롤러
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
      _nameError = _nameController.text.length < 3 ? "3자리 이상 입력해주세요" : null;
    });
  }

  void _validateId() {
    setState(() {
      _idError = _idController.text.length < 6 ? "영문 6자리 이상 입력해주세요" : null;
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
      _confirmPasswordController.text != _passwordController.text
          ? "비밀번호가 일치하지 않습니다" : null;
    });
  }

  @override
  /*void dispose() {
    // FocusNode를 해제
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }*/

  // ScrollController
  /*ScrollController _scrollController = ScrollController();

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
      appBar: AppBar(
        backgroundColor: _scrollController.hasClients && _scrollController.offset > 50
            ? Color(0xFFE0E0E0) // 스크롤 시 색상 변경
            : Color(0xFFFBFBFB), // 기본색
        title: Text(
          '회원가입',
          style: TextStyle(color: Color(0xFF2F2F2F)),
        ),
      ),
      body: Column(
        children: [
          Expanded( // 화면을 차지하는 스크롤 가능한 부분
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 사용자 이름 입력
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: '사용자 이름 입력',
                        hintText: '3자리 이상 입력해주세요',
                        // 초기 메시지
                        hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                        // hintText 색상 변경
                        errorText: _nameError,
                        // 오류 메시지
                        errorStyle: TextStyle(color: Color(0xFFFF5833)),
                        // 오류 메시지 색상 변경
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFF2F2F2F)), // 포커스 시 밑줄 색상
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFF2F2F2F)), // 기본 상태 밑줄 색상
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFFFF5833)), // 오류 상태에서 밑줄 색상
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFFFF5833)), // 오류 상태에서 포커스 시 밑줄 색상
                        ),
                      ),
                      onChanged: (text) {
                        _validateName(); // 실시간 검증
                      },
                    ),
                    SizedBox(height: 50),
                    // 아이디 입력
                    TextField(
                      controller: _idController,
                      decoration: InputDecoration(
                        labelText: '아이디 입력',
                        hintText: '영문 6자리 이상 입력해주세요',
                        // 초기 메시지
                        hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                        // hintText 색상 변경
                        errorText: _idError,
                        // 오류 메시지
                        errorStyle: TextStyle(color: Color(0xFFFF5833)),
                        // 오류 메시지 색상 변경
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFF2F2F2F)), // 포커스 시 밑줄 색상
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFF2F2F2F)), // 기본 상태 밑줄 색상
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFFFF5833)), // 오류 상태에서 밑줄 색상
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFFFF5833)), // 오류 상태에서 포커스 시 밑줄 색상
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
                      // 비밀번호 숨기기/보이기
                      decoration: InputDecoration(
                        labelText: '비밀번호 입력',
                        hintText: '영문 6자리 이상 입력해주세요',
                        // 초기 메시지
                        hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                        // hintText 색상 변경
                        errorText: _passwordError,
                        // 오류 메시지
                        errorStyle: TextStyle(color: Color(0xFFFF5833)),
                        // 오류 메시지 색상 변경
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFF2F2F2F)), // 포커스 시 밑줄 색상
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFF2F2F2F)), // 기본 상태 밑줄 색상
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFFFF5833)), // 오류 상태에서 밑줄 색상
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFFFF5833)), // 오류 상태에서 포커스 시 밑줄 색상
                        ),
                        suffixIcon: _isPasswordFieldTapped
                            ? IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons
                                .visibility_off,
                            color: Color(0xFF2F2F2F),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible =
                              !_isPasswordVisible; // 비밀번호 보이기/숨기기 토글
                            });
                          },
                        )
                            : null, // 클릭 시 아이콘이 보이도록 설정
                      ),
                      onTap: () {
                        setState(() {
                          _isPasswordFieldTapped = true; // 텍스트 필드 클릭 시 아이콘 보이기
                        });
                      },
                      onChanged: (text) {
                        _validatePassword(); // 실시간 검증
                      },
                    ),
                    SizedBox(height: 50),
                    // 비밀번호 확인 입력
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      // 비밀번호 숨기기/보이기
                      decoration: InputDecoration(
                        labelText: '비밀번호 확인',
                        hintText: '영문 6자리 이상 입력해주세요',
                        // 초기 메시지
                        hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                        // hintText 색상 변경
                        errorText: _confirmPasswordError,
                        // 오류 메시지
                        errorStyle: TextStyle(color: Color(0xFFFF5833)),
                        // 오류 메시지 색상 변경
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFF2F2F2F)), // 포커스 시 밑줄 색상
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFF2F2F2F)), // 기본 상태 밑줄 색상
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFFFF5833)), // 오류 상태에서 밑줄 색상
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(
                              0xFFFF5833)), // 오류 상태에서 포커스 시 밑줄 색상
                        ),
                        suffixIcon: _isConfirmPasswordFieldTapped
                            ? IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility : Icons
                                .visibility_off,
                            color: Color(0xFF2F2F2F),
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible; // 비밀번호 확인 보이기/숨기기 토글
                            });
                          },
                        )
                            : null, // 클릭 시 아이콘이 보이도록 설정
                      ),
                      onTap: () {
                        setState(() {
                          _isConfirmPasswordFieldTapped =
                          true; // 텍스트 필드 클릭 시 아이콘 보이기
                        });
                      },
                      onChanged: (text) {
                        _validateConfirmPassword(); // 실시간 검증
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
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
              onPressed: () {
                // 모든 입력 검증 후 성공적으로 회원가입 로직 처리
                if (_nameError == null && _idError == null &&
                    _passwordError == null && _confirmPasswordError == null) {
                  Navigator.pushNamed(context, '/success');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5833),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: Text(
                '회원가입',
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFBFBFB)),
              ),
            ),
          ),
        ],
      ),
    );
  }*/
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
      appBar: AppBar(
        backgroundColor: _scrollController.hasClients && _scrollController.offset > 3
            ? Color(0xFFE0E0E0) // 스크롤 시 색상 변경
            : Color(0xFFFBFBFB), // 기본색
        title: Text(
          '회원가입',
          style: TextStyle(color: Color(0xFF2F2F2F)),
        ),
      ),
      body: Column(
        children: [
          Expanded( // 화면을 차지하는 스크롤 가능한 부분
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 사용자 이름 입력
                    TextField(
                      controller: _nameController,
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
                      controller: _idController,
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
                            ? IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Color(0xFF2F2F2F),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible =
                              !_isPasswordVisible; // 비밀번호 보이기/숨기기 토글
                            });
                          },
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
                      controller: _confirmPasswordController,
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
                            ? IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Color(0xFF2F2F2F),
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                            });
                          },
                        )
                            : null,
                      ),
                      onTap: () {
                        setState(() {
                          _isConfirmPasswordFieldTapped =
                          true;
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5833),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: Text(
                '회원가입',
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFBFBFB)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/*import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 텍스트 필드 컨트롤러
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // 비밀번호 보이기/숨기기 상태
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // 비밀번호 입력 필드 클릭 여부
  bool _isPasswordFieldTapped = false;
  bool _isConfirmPasswordFieldTapped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFBFB),
        title: Text(
          '회원가입',
          style: TextStyle(color: Color(0xFF2F2F2F)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 비밀번호 입력
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // 비밀번호 숨기기/보이기
                decoration: InputDecoration(
                  labelText: '비밀번호 입력',
                  hintText: '영문 6자리 이상 입력해주세요', // 초기 메시지
                  hintStyle: TextStyle(color: Color(0xFFE0E0E0)), // hintText 색상 변경
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2F2F2F)), // 포커스 시 밑줄 색상
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2F2F2F)), // 기본 상태 밑줄 색상
                  ),
                  suffixIcon: _isPasswordFieldTapped
                      ? IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xFF2F2F2F),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible; // 비밀번호 보이기/숨기기 토글
                      });
                    },
                  )
                      : null, // 클릭 시 아이콘이 보이도록 설정
                ),
                onTap: () {
                  setState(() {
                    _isPasswordFieldTapped = true; // 텍스트 필드 클릭 시 아이콘 보이기
                  });
                },
              ),
              SizedBox(height: 50),
              // 비밀번호 확인 입력
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible, // 비밀번호 숨기기/보이기
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  hintText: '영문 6자리 이상 입력해주세요', // 초기 메시지
                  hintStyle: TextStyle(color: Color(0xFFE0E0E0)), // hintText 색상 변경
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2F2F2F)), // 포커스 시 밑줄 색상
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2F2F2F)), // 기본 상태 밑줄 색상
                  ),
                  suffixIcon: _isConfirmPasswordFieldTapped
                      ? IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xFF2F2F2F),
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible =
                        !_isConfirmPasswordVisible; // 비밀번호 확인 보이기/숨기기 토글
                      });
                    },
                  )
                      : null, // 클릭 시 아이콘이 보이도록 설정
                ),
                onTap: () {
                  setState(() {
                    _isConfirmPasswordFieldTapped = true; // 텍스트 필드 클릭 시 아이콘 보이기
                  });
                },
              ),
              SizedBox(height: 100),
              // 회원가입 버튼 (가운데 정렬)
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 모든 입력 검증 후 성공적으로 회원가입 로직 처리
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF5833),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    ),
                    child: Text(
                      '회원가입',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFBFBFB)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
