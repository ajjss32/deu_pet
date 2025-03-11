class Validators {
  static bool validarCPF(String cpf) {
    // Remove caracteres não numéricos
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se o CPF tem 11 dígitos
    if (cpf.length != 11) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    // Calcula o primeiro dígito verificador
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int resto = soma % 11;
    int digito1 = resto < 2 ? 0 : 11 - resto;

    // Calcula o segundo dígito verificador
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    resto = soma % 11;
    int digito2 = resto < 2 ? 0 : 11 - resto;

    // Verifica se os dígitos calculados conferem com os dígitos informados
    return cpf[9] == digito1.toString() && cpf[10] == digito2.toString();
  }

  static bool validarCNPJ(String cnpj) {
    // Remove caracteres não numéricos
    cnpj = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se o CNPJ tem 14 dígitos
    if (cnpj.length != 14) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cnpj)) return false;

    // Calcula o primeiro dígito verificador
    int soma = 0;
    int peso = 5;
    for (int i = 0; i < 12; i++) {
      soma += int.parse(cnpj[i]) * peso;
      peso = peso == 2 ? 9 : peso - 1;
    }
    int resto = soma % 11;
    int digito1 = resto < 2 ? 0 : 11 - resto;

    // Calcula o segundo dígito verificador
    soma = 0;
    peso = 6;
    for (int i = 0; i < 13; i++) {
      soma += int.parse(cnpj[i]) * peso;
      peso = peso == 2 ? 9 : peso - 1;
    }
    resto = soma % 11;
    int digito2 = resto < 2 ? 0 : 11 - resto;

    // Verifica se os dígitos calculados conferem com os dígitos informados
    return cnpj[12] == digito1.toString() && cnpj[13] == digito2.toString();
  }
}
