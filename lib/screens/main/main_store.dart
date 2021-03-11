import 'package:mobx/mobx.dart';

part 'main_store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  _MainStore();

  @observable
  int pageIndex = 0;

  @action
  setPageIndex(int index) {
    pageIndex = index;
  }
}
