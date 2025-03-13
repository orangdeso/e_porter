class Validators {
  static String? validatorEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    return null;
  }

  static String? validatorPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    return null;
  }

  static String? validatorName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama Lengkap tidak boleh kosong';
    }
    return null;
  }

  static String? validatorNoID(String? value) {
    if (value == null || value.isEmpty) {
      return 'No ID tidak boleh kosong';
    } else if (value.length > 16) {
      return 'No ID tidak boleh lebih dari 16 digit';
    } else if (value.length < 16) {
      return 'No ID kurang dari 16 digit';
    }
    return null;
  }
}
