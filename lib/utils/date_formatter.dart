class DateFormatter1 {
  /// retorna el formato - 23 de Diciembre 12:34hs -
  String formatDateNumberHourDayMonthYear(DateTime dateParse) {
    //DateTime _dateParse = DateTime.parse(_date);
    String min = (dateParse.minute.toString().length == 1)
        ? "0" + dateParse.minute.toString()
        : dateParse.minute.toString();
    return '${dateParse.day} de ${mapFullMonthDate(dateParse)} ${dateParse.hour}:${min}';
  }

  String mapFullMonthDate(DateTime _date) {
    switch (_date.month) {
      case 1:
        return 'Enero';
      case 2:
        return 'Febrero';
      case 3:
        return 'Marzo';
      case 4:
        return 'Abril';
      case 5:
        return 'Mayo';
      case 6:
        return 'Junio';
      case 7:
        return 'Julio';
      case 8:
        return 'Agosto';
      case 9:
        return 'Septiembre';
      case 10:
        return 'Octubre';
      case 11:
        return 'Noviembre';
      case 12:
        return 'Diciembre';

      default:
        return '';
    }
  }
}
