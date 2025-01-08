import 'package:class_rasel/every%20class/user.dart';
import 'package:class_rasel/screen/enge/video_data.dart';
import 'package:get/get.dart';


class cont extends GetxController {

  late String token;
  late User user;
  int? classId;
  int? userId;
  int? curretEventId;
  bool logInState=false;
  late VideoData vd;
  late int otp;

}
