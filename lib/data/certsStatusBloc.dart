import 'package:flutter_bloc/flutter_bloc.dart';

enum FETCH_STATUS {
  OFFLINE,
  OFFLINE_FAILED,
  ONLINE_FETCHING,
  ONLINE_FETCHED,
}

class CertFetchStatus extends Cubit<FETCH_STATUS> {
  CertFetchStatus() : super(FETCH_STATUS.ONLINE_FETCHING);

  void setStatus(FETCH_STATUS status) {
    emit(status);
  }
}
