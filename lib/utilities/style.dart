

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/prescription_controller.dart';
import 'package:dims_vet_rx/models/chief_complain/chief_complain_model.dart';

import 'app_icons.dart';
final StyleConstant styleConstant = Get.put(StyleConstant());
class StyleConstant extends GetxController{
    double formHeight = 50;
    double formWidthL = 495;
    double formWidthS = 107;
    double formWidthM = 230;
    double formWidthMAndroid = 290;
    double patientInfoFrontPageHP = 10;
    double prescriptionContainerHeight = 800;

}

class Responsive{
  responsiveMainScreen(context){

      var screenWeight = MediaQuery.of(context).size.width;

      // if(screenWeight > 2000){
      //   return screenWeight * 0.700;
      // }else{
      //   return screenWeight * 0.900;
      // }
      return screenWeight * 0.900;

  }

  responsivePrescriptionMainScreen(context){
      var screenWeight = MediaQuery.of(context).size.width;
      // if(screenWeight < 1430){
      //   return screenWeight * 0.600;
      // }else if(screenWeight < 1000){
      //   return screenWeight * 0.300;
      // }else{
      //   return screenWeight * 0.400;
      // }
      return screenWeight * 0.600;
  }

  responsivePrescriptionClinicalScreen(context){
      var screenWeight = MediaQuery.of(context).size.width;
      // if(screenWeight < 1430){
      //   return screenWeight * 0.250;
      // }else if(screenWeight < 1000){
      //   return screenWeight * 0.300;
      // }else{
      //   return screenWeight * 0.200;
      // }
      return screenWeight * 0.300;
  }

  endDrawer(context){
      var screenWeight = MediaQuery.of(context).size.width;
      print(screenWeight);
      print(screenWeight);
      if(screenWeight > 1400 ){
        return screenWeight * 0.6;
      }else if(screenWeight > 1000 && screenWeight < 1400){
        return screenWeight * 0.7;
      }else if(screenWeight > 800 && screenWeight < 1000){
        return screenWeight * 0.8;
      }else if(screenWeight > 600 && screenWeight < 800){
        return screenWeight * 0.9;
      }else if(screenWeight > 400 && screenWeight < 600){
        return screenWeight * 0.9;
      }
  }
  endDrawerHeight(context){
    var screenHeight = MediaQuery.of(context).size.height;

    if(screenHeight < 1000){
      return screenHeight * 0.7;
    }else if(screenHeight > 1200){
      return screenHeight * 0.8;
    }else if(screenHeight > 1000 && screenHeight < 1200){
      return screenHeight * 0.9;
    }else if(screenHeight > 1200 && screenHeight < 1400){
      return screenHeight * 0.9;
    }else if(screenHeight < 800){
      return screenHeight * 0.9;
    }else{
      return screenHeight * 0.9;

    }
  }

  clinicalFieldInPrescriptionW(context){
    var screenWeight = MediaQuery.of(context).size.width;
    if(screenWeight < 1430){
      return screenWeight * 0.4;
    }else if(screenWeight < 1000){
      return screenWeight * 0.6;
    }else{
      return screenWeight * 0.6;
    }
  }
  clinicalFieldInPrescriptionH(context){
    var screenWeight = MediaQuery.of(context).size.height;
    if(screenWeight < 1430){
      return screenWeight * 0.3;
    }else if(screenWeight < 1000){
      return screenWeight * 0.3;
    }else{
      return screenWeight * 0.4;
    }
  }

}

class AppWidget{

  static TextStyle expandedMenuTitleStyle(){
    return const TextStyle(
      fontSize: 16,
      color: Colors.black54,
      fontWeight: FontWeight.w500
    );
  }

  static TextStyle expandedMenuSubTitleStyle(){
    return const TextStyle(
      fontSize: 14,
      color: Colors.black54,
    );
  }
}

InputDecoration AppInputFieldLabelTextDecoration(label){
  return InputDecoration(
      // border: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(10.0), // Customize border radius
      //   borderSide: const BorderSide(
      //     color: Colors.blue,
      //     width: 0.00,
      //   ),
      // ),
      border: InputBorder.none,

      // labelText: label,
    hintText: label,
  );
}

InputDecoration AppInputFieldDecoration(hintText){
  return InputDecoration(
    hintText: hintText,
    // border: OutlineInputBorder(),
  );
}

screenHeight(context){
  return MediaQuery.of(context).size.height;
}

InputDecoration InputDecorationApp(label, controller) {
  return   InputDecoration(
  label:   Text(label),
  contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
  suffixIcon: IconButton(onPressed: (){
    controller.clear();
  }, icon: AppIcons.inputFieldDataClear),
  border: InputBorder.none
  );
}

Widget InputFieldForAppointmentNumber(
    String label,
    hintText,
    TextEditingController textEditingController,
    TextEditingController textClearController,
    TextInputType inputType,
    ) {
  return SizedBox(
    width: styleConstant.formWidthM,
    height: styleConstant.formHeight,
    child: TextField(
      keyboardType: inputType,
      inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: label,
        hintText: "edg: $hintText",
        contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
        suffixIcon: IconButton(
          onPressed: () {
            textClearController.clear();
          },
          icon: AppIcons.inputFieldDataClear,
        ),
        border: OutlineInputBorder(

        ),
      ),
    ),
  );
}
Widget InputFieldForAppointment(
    String label,
    hintText,
    TextEditingController textEditingController,
    TextEditingController textClearController,
    TextInputType inputType,
    ) {
  return SizedBox(
    width: styleConstant.formWidthM,
    height: styleConstant.formHeight,
    child: TextField(
      onTapOutside: (va){
        print("object");
      },
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: label,
        hintText: "edg: $hintText",
        contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
        suffixIcon: IconButton(
          onPressed: () {
            textClearController.clear();
          },
          icon: AppIcons.inputFieldDataClear,
        ),
        border: OutlineInputBorder(

        ),
      ),
    ),
  );
}

Widget InputFieldForAppointmentDrugHistory(
    String label,
    hintText,
    TextEditingController textEditingController,
    TextEditingController textClearController,
    TextInputType inputType,
    ) {
  return SizedBox(
    width: MediaQuery.of(Get.context!).size.width * 0.78,
    child: TextField(

      maxLines: 5,
      controller: textEditingController,
      decoration: InputDecoration(

        labelText: label,
        hintText: "edg: $hintText",
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        suffixIcon: IconButton(
          onPressed: () {
            textClearController.clear();
          },
          icon: AppIcons.inputFieldDataClear,
        ),
        border: OutlineInputBorder(

        ),
      ),
    ),
  );
}
Widget InputFieldForAppointmentText(
    String label,
    hintText,
    TextEditingController textEditingController,
    TextEditingController textClearController,
    TextInputType inputType,

    ) {
  return SizedBox(
    width: styleConstant.formWidthM,
    height: styleConstant.formHeight,
    child: TextField(
      keyboardType: inputType,
      inputFormatters: <TextInputFormatter>[
        if(inputType == TextInputType.text)
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
      ],
      controller: textEditingController,
      decoration: InputDecoration(
        label: Text(label),
        hintText: "edg: $hintText",
        contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
        suffixIcon: IconButton(
          onPressed: () {
            textClearController.clear();
          },
          icon: AppIcons.inputFieldDataClear,
        ),
        border: OutlineInputBorder(),
      ),
    ),
  );
}

Widget InputFieldForPrintPageSetup(
    String label,
    TextEditingController textEditingController,
    TextEditingController textClearController,
    TextInputType inputType,
    ) {
  return Card(
    child: SizedBox(
      width: styleConstant.formWidthM,
      height: styleConstant.formHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        child: TextField(
          keyboardType: inputType,
          controller: textEditingController,

          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
          ],
          decoration: InputDecoration(
            labelText: label, // Changed from 'label' to 'labelText'
            contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
            suffixIcon: IconButton(
              onPressed: () {
                textClearController.clear();
              },
              icon: AppIcons.inputFieldDataClear,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    ),
  );
}


SnackBarMessage(context,title, message){
  // return  ScaffoldMessenger.of(Get.context!).showSnackBar(title, message);
}
Future showDialogLoading(BuildContext context) async{
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          color: Colors.white,
          height: 250,
          width: 250,
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              // Text("Wait a moment...", style: TextStyle(fontSize: 20),),
            ],
          ),
        ),
      );
    },
  );

}
