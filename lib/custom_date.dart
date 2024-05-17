/// Small extension of [DateTime] with a static method formatting strings before parsing them.
class FormattedDateTime extends DateTime {
  FormattedDateTime(super.year);

  static DateTime parseAndFormat(String formattedString) {
    List<String> dateParts = formattedString.split('-');
    String formattedDate = '';
    for (int i = 0; i < dateParts.length; i++) {
      if (dateParts[i].length == 1) {
        formattedDate += '0';
      }
      formattedDate += dateParts[i];
      if (i < dateParts.length - 1) {
        formattedDate += '-';
      }
    }

    return DateTime.parse(formattedDate);
  }
}
