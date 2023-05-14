import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';

class Utils {
  static String humanDateFormat(DateTime date) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(date);

    if (diferencia.inSeconds < 60) {
      return '${diferencia.inSeconds} segundos';
    } else if (diferencia.inMinutes < 60) {
      return '${diferencia.inMinutes} minutos';
    } else if (diferencia.inHours < 24) {
      return '${diferencia.inHours} horas';
    } else if (diferencia.inDays < 7) {
      return '${diferencia.inDays} días';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  static String formatDate(DateTime date) {
    return DateFormat('d MMM y H:mm').format(date);
  }

  static String simpleFormatDate(DateTime date) {
    return DateFormat('d MMM').format(date);
  }

  static String formatDateWithHours(DateTime date) {
    return DateFormat('d MMM y').format(date);
  }

  static String todoDate(DateTime date) {
    return DateFormat('EEEE, MMMM d').format(date);
  }

  static String formatHour(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  static String getFileExtension(String path) {
    return path.split('/').last.split('.').last;
  }

  static MediaType getValidContentType(String path) {
    final extension = path.split('/').last.split('.').last;

    switch (extension) {
      case 'jpg':
        return MediaType('image', 'jpg');
      case 'png':
        return MediaType('image', 'png');
      case 'pdf':
        return MediaType('application', 'pdf');
      default:
        throw Error();
    }
  }

  static showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }
}
