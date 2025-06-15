import 'package:bloc/bloc.dart';
import 'package:midnight_never_end/domain/entities/cadastro/cadastro_entity.dart';
import 'package:midnight_never_end/data/repositories/user/usuario_repository.dart';
import 'package:midnight_never_end/core/error/failures.dart';
import 'package:midnight_never_end/domain/error/core/cadastro_exception.dart';

class CadastroViewModel extends Cubit<CadastroEntity> {
  final UserRepository userRepository;

  CadastroViewModel({required this.userRepository}) : super(CadastroEntity());

  void updateNome(String nome) {
    emit(
      state.copyWith(
        nome: nome,
        nomeError: null,
        success: false,
        errorMessage: null,
      ),
    );
  }

  void updateEmail(String email) {
    emit(
      state.copyWith(
        email: email,
        emailError: null,
        success: false,
        errorMessage: null,
      ),
    );
  }

  void updateSenha(String senha) {
    emit(
      state.copyWith(
        senha: senha,
        senhaError: null,
        success: false,
        errorMessage: null,
      ),
    );
  }

  void updateConfirmaSenha(String confirmaSenha) {
    emit(
      state.copyWith(
        confirmaSenha: confirmaSenha,
        confirmaSenhaError: null,
        success: false,
        errorMessage: null,
      ),
    );
  }

  Future<void> cadastrar() async {
    emit(state.copyWith(isLoading: true, success: false, errorMessage: null));

    // Validações
    final nomeError = _validateNome(state.nome);
    final emailError = _validateEmail(state.email);
    final senhaError = _validateSenha(state.senha);
    final confirmaSenhaError = _validateConfirmaSenha(
      state.senha,
      state.confirmaSenha,
    );

    final hasError =
        nomeError != null ||
        emailError != null ||
        senhaError != null ||
        confirmaSenhaError != null;

    if (hasError) {
      emit(
        state.copyWith(
          isLoading: false,
          nomeError: nomeError,
          emailError: emailError,
          senhaError: senhaError,
          confirmaSenhaError: confirmaSenhaError,
          success: false,
        ),
      );
      return;
    }

    try {
      // Cadastro (deve lançar exceção em caso de erro)
      await userRepository.criarUsuario(
        nome: state.nome,
        email: state.email,
        senha: state.senha,
      );

      // Login automático (deve lançar exceção em caso de erro)
      await userRepository.fazerLogin(state.email, state.senha);

      emit(
        state.copyWith(
          isLoading: false,
          success: true,
          errorMessage: null,
          nomeError: null,
          emailError: null,
          senhaError: null,
          confirmaSenhaError: null,
        ),
      );
    } on ServerFailure catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          success: false,
          errorMessage:
              e.message, // <-- Use exatamente a mensagem recebida do backend!
        ),
      );
    } on CadastroValidationFailure {
      emit(
        state.copyWith(
          isLoading: false,
          success: false,
          errorMessage: 'Por favor, verifique os campos',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          success: false,
          errorMessage: 'Erro interno. Tente novamente.',
        ),
      );
    }
  }

  // --- Validações ---
  String? _validateNome(String nome) {
    if (nome.isEmpty) return 'O nome não pode estar vazio';
    return null;
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'O email não pode estar vazio';
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) return 'Digite um email válido';
    return null;
  }

  String? _validateSenha(String senha) {
    if (senha.isEmpty) return 'A senha não pode estar vazia';
    if (senha.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
    return null;
  }

  String? _validateConfirmaSenha(String senha, String confirmaSenha) {
    if (confirmaSenha.isEmpty)
      return 'A confirmação de senha não pode estar vazia';
    if (confirmaSenha != senha) return 'As senhas não coincidem';
    return null;
  }
}
