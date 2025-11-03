
class Validators {
  // Email validator
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa un correo electrónico';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor ingresa un correo válido';
    }
    
    return null;
  }

  // Password validator
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa una contraseña';
    }
    
    if (value.length < minLength) {
      return 'La contraseña debe tener al menos $minLength caracteres';
    }
    
    return null;
  }

  // Required field validator
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa $fieldName';
    }
    return null;
  }

  // Phone validator
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa un teléfono';
    }
    
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s-]'), ''))) {
      return 'Por favor ingresa un teléfono válido (10 dígitos)';
    }
    
    return null;
  }

  // Identification number validator
  static String? validateIdentification(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa un número de identificación';
    }
    
    if (value.length < 6) {
      return 'El número de identificación debe tener al menos 6 caracteres';
    }
    
    return null;
  }

  // Confirm password validator
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Por favor confirma tu contraseña';
    }
    
    if (value != password) {
      return 'Las contraseñas no coinciden';
    }
    
    return null;
  }

  // Name validator
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa un nombre';
    }
    
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    
    final nameRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
    
    if (!nameRegex.hasMatch(value)) {
      return 'El nombre solo puede contener letras';
    }
    
    return null;
  }

  // Age validator
  static String? validateAge(DateTime? birthDate) {
    if (birthDate == null) {
      return 'Por favor selecciona una fecha de nacimiento';
    }
    
    final age = DateTime.now().difference(birthDate).inDays ~/ 365;
    
    if (age < 0) {
      return 'La fecha de nacimiento no puede ser futura';
    }
    
    if (age < 1) {
      return 'La edad debe ser mayor a 1 año';
    }
    
    if (age > 120) {
      return 'Por favor verifica la fecha de nacimiento';
    }
    
    return null;
  }
}
