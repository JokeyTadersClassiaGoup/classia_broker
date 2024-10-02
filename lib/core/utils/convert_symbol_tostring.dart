String convertString(String original) {
    List<String> parts = original.split(' ');

    if (parts.length == 6) {
      // Pattern: BANKEX 62600 CE 22 JUL 24
      String symbol = parts[0];
      String strikePrice = parts[1];
      String optionType = parts[2];
      String day = parts[3];
      String month = parts[4];
      String year = parts[5]; // Get last two digits of the year
      return '$symbol$year$month$strikePrice$optionType';
    } else if (parts.length == 5) {
      String symbol = parts[0];
      String fut = parts[1];
      String day = parts[2];
      String month = parts[3];
      String year = parts[4]; // Get last two digits of the year

      return '$symbol$year$month$fut';
    } else if (parts.length == 5) {
      // Pattern: HAVELLS FUT 25 JUL 24
      // Pattern: ABFRL 355 PE 29 AUG 24
      String symbol = parts[0];
      String strikePrice = parts[1];
      String optionType = parts[2];
      String day = parts[3];
      String month = parts[4];
      String year = parts[5]; // Get last two digits of the year

      return '$symbol$year$month$strikePrice$optionType';
    }

    // In case the pattern does not match
    return original;
  }
