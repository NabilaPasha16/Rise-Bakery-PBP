abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactSending extends ContactState {}

class ContactSuccess extends ContactState {
  final String message;
  ContactSuccess(this.message);
}

class ContactFailure extends ContactState {
  final String error;
  ContactFailure(this.error);
}