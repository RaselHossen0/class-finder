import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import 'every class/get_controller.dart';
import 'every class/user.dart';
import 'initialze.dart';

Future<void> initializeApp() async {

  try{
    final box = GetStorage();

    String tk= box.read('token');

    print("                                33333333333333                       ");

    //print(tk);

    print(tk);

    if(tk!=""){
      var result= await fetchUserDetails(tk);
      print("                  44444        ");
      print(result);

      final cont main = Get.find();
      print("                  44444        ");
      main.token=tk;
      print("                  44444        ");
      print(main.token);

      //print("                  44444        ");

      main.userId=result["user"]["id"];
      //print("                  44444        ");
      if(result["user"]["role"]=="class_owner"){
        print("                  44444        ");
        main.classId=result["classOwner"]["classId"];
        print("                  44444        ");
      }
      //print("                  44444        ");
      User us = User(name: result["user"]["name"], email: result["user"]["email"], latLang: [], role: result["user"]["role"]);

      if(result["user"]["role"]=="class_owner"){
        us.mobileNumber=result["classOwner"]["mobileNumber"];
        us.alternateMobileNumber=result["classOwner"]["alternateMobileNumber"];
        us.adharCardNum=result["classOwner"]["aadhaarCardNumber"];
        us.panCardNum=result["classOwner"]["panCardNumber"];
        us.aadharCardFile=result["classOwner"]["aadhaarCardFile"];
        us.panCardFile=result["classOwner"]["panCardFile"];
        us.photo=result["classOwner"]["photographFile"];
      }

      //print("                  44444        ");

      main.user=us;
      print("                  44444        ");
      main.logInState=true;
    }
  }catch(e){
    print("in                      main");
    print(e);
  }


}