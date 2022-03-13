class Utilities {
  static List generateKeywords(String displayname) {
    final name = displayname.split(' ');

    final length = name.length;
    List flagArray = []..length = length;
    List result = []..length = length;
    List stringArray = [];

    for (var i = 0; i < length; i++) {
      flagArray[i] = false;
    }

    List createKeywords(String name) {
      final arrName = [];
      String curName = '';
      name.split('').forEach((letter) {
        curName += letter;
        arrName.add(curName.toLowerCase());
      });
      return arrName;
    }

    findPermutation(k) {
      for (var i = 0; i < length; i++) {
        if (!flagArray[i]) {
          flagArray[i] = true;
          result[k] = name[i];

          if (k == length - 1) {
            stringArray.add(result.join(' '));
          }

          findPermutation(k + 1);
          flagArray[i] = false;
        }
      }
    }

    findPermutation(0);

    final keywords = stringArray.fold([], (List previousValue, element) {
      final words = createKeywords(element);
      return [...previousValue, ...words];
    });

    return keywords;
  }

  static String getBackgroundWhenNotLoadImage(String userName) {
    List<String> listNameSplit = userName.split(" ");

    String firstChar = listNameSplit.first.substring(0, 1);
    String lastChar = listNameSplit.last.substring(0, 1);

    return listNameSplit.length == 1
        ? listNameSplit.first.substring(0, 2).toUpperCase()
        : firstChar + lastChar;
  }
}
