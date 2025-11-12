class ProfileState {
  final String? email;
  final String? name;
  const ProfileState({this.email, this.name});
}

class ProfileInitial extends ProfileState {
  const ProfileInitial() : super(email: null, name: null);
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({String? email, String? name}) : super(email: email, name: name);
}
