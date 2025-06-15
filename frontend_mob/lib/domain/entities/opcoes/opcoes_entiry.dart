class AccountOptionsEntity {
  final String? userName;
  final bool isLoading;

  AccountOptionsEntity({this.userName, this.isLoading = false});

  AccountOptionsEntity copyWith({String? userName, bool? isLoading}) {
    return AccountOptionsEntity(
      userName: userName ?? this.userName,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
