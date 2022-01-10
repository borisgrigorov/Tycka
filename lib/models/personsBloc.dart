import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tycka/models/person.dart';

class PersonBloc extends Cubit<List<Person>> {
  PersonBloc() : super([]);

  void addPerson(Person person) {
    final newList = state..add(person);
    emit(newList);
  }

  void removePersonById(String personId) {
    final newList = List<Person>.from(state)
      ..removeWhere((element) => element.id == personId);
    emit(newList);
  }

  void setList(List<Person> list) {
    emit(list);
  }
}
