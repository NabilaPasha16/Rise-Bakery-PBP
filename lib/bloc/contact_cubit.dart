import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../model/contact_message.dart';
import 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final ApiService apiService;

  ContactCubit(this.apiService) : super(ContactInitial());

  Future<void> sendContact(ContactMessage msg) async {
    emit(ContactSending());

    try {
      final result = await apiService.sendContactMessage(msg);

      if (result) {
        emit(ContactSuccess("Pesan berhasil dikirim!"));
      } else {
        emit(ContactFailure("Gagal mengirim pesan"));
      }
    } catch (e) {
      emit(ContactFailure(e.toString()));
    }
  }
}