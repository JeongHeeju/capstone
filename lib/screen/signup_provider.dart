import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupProvider with ChangeNotifier {

  /*Future<String?> signupUser() async {
    if (confirmPassword != password) {
      return '비밀번호가 일치하지 않습니다';
    }

    final url = Uri.parse('http://127.0.0.1:8000/users/signup/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': name,
          'user_id': id,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return null; // 회원가입 성공
      } else {
        final error = json.decode(response.body)['error'];
        return '회원가입 실패: $error';
      }
    } catch (e) {
      return '회원가입 중 오류 발생: $e';
    }
  }*/

  String name = '';
  String id = '';
  String password = '';
  String confirmPassword = '';

  String? nameError;
  String? idError;
  String? passwordError;
  String? confirmPasswordError;

  // 전체 유효성 검사 (회원가입 버튼 클릭 시 호출)
  void validateAll() {
    validateName();
    validateId();
    validatePassword();
    validateConfirmPassword();
  }

  // 각각 필드별 실시간 검증 함수
  void validateName() {
    nameError = name.length < 3 ? '3자리 이상 입력해주세요' : null;
    notifyListeners();
  }

  void validateId() {
    idError = id.length < 6 ? '영문 6자리 이상 입력해주세요' : null;
    notifyListeners();
  }

  void validatePassword() {
    passwordError = password.length < 6 ? '영문 6자리 이상 입력해주세요' : null;
    notifyListeners();
  }

  void validateConfirmPassword() {
    confirmPasswordError =
    confirmPassword != password ? '비밀번호가 일치하지 않습니다' : null;
    notifyListeners();
  }

  bool get isValid =>
      nameError == null &&
          idError == null &&
          passwordError == null &&
          confirmPasswordError == null;

  Future<void> saveUser() async {
    debugPrint('회원정보 저장됨: $name, $id, $password');
    // API 요청 자리
  }

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setId(String value) {
    id = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    confirmPassword = value;
    notifyListeners();
  }
}