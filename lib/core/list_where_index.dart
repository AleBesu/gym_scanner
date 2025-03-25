List listWhereIndex(List listToSeach, {required List<int> indexList}) {
  List newList = [];

  for (int i = 0; i < listToSeach.length; i++) {
    if (indexList.contains(i)) {
      print("hello $i");
      newList.add(listToSeach[i]);
    }
  }

  return newList;
}
