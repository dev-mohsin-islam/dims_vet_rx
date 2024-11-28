import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyPolicyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Privacy Policy'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Data Collection and Storage',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We collect user images for profile creation and patient management purposes. Data is stored locally on your device and synced with our server via manual and automatic sync methods.',
            ),
            SizedBox(height: 16),
            Text(
              '2. User Responsibility',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'You are responsible for managing the local database folder on your device. If this folder is removed, the data will be lost, and we are not liable for any data loss.',
            ),
            SizedBox(height: 16),
            Text(
              '3. Account Deletion',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Users can remove their accounts at any time, and upon deletion, all associated data will be permanently erased from our servers.',
            ),
            SizedBox(height: 16),
            Text(
              '4. Data Security',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We take reasonable measures to secure the data, but the local database is managed by the user and not the developer company. If you manually delete the data folder, your information will be lost, and we cannot retrieve it.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

void showPrivacyPolicyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => PrivacyPolicyDialog(),
  );
}



 TermsAndCondition(BuildContext context) {

  showDialog(
    barrierDismissible: false,
     context: context,
     builder: (BuildContext context) {
       return alertBox(context);
     },
   );

}

 AlertDialog alertBox(BuildContext context) {
   return AlertDialog(
       title: Text('Data Privacy Policy'),
       content: SingleChildScrollView(
         child: Column(
           children: <Widget>[
         Text(
         'We collect the following personal data for generating prescriptions:\n'
         '- Patient Details: Name, Age, Phone, Gender, Weight, Height, Pulse, Drug History, OFC, RR, Hip, Waist, Address, Occupation, Education, Email\n'
         '- Medical Information: Fee, Blood Pressure, Temperature, Marital Status, Chief Complaint, On Examination, Diagnosis, etc.\n'
         '- Images: Patient Disease Images, Investigation Report Images\n'
         '- Doctor Profile Image\n\n'
         'Purpose: The data is collected to create and maintain accurate patient profiles for better treatment, '
         'monitoring health conditions, and generating prescriptions.\n\n'
         'Data Protection: All collected data is stored securely in a protected database. Only authorized doctors and medical staff have access to this information.\n\n'
           'Third-Party Data Sharing: We do not share any patient or doctor data with third-party services or organizations.\n\n'
           'Consent: By proceeding, you agree to the collection, use, and secure storage of the above data.',
         ),
         SizedBox(height: 20),
         Text(
           'Do you agree to these terms and allow us to collect and use this data?',
           style: TextStyle(fontWeight: FontWeight.bold),
         ),

           ],
         ),
       ),
       actions: <Widget>[
         // TextButton(
         //   child: Text('Disagree'),
         //   onPressed: () {
         //     Navigator.of(context).pop();
         //     // Handle what happens if the user disagrees
         //   },
         // ),
         TextButton(
           child: Text('Agree'),
           onPressed: () async{
             SharedPreferences pref = await SharedPreferences.getInstance();
             await pref.setBool("termPolicy", true);
             Navigator.of(context).pop();
             // Proceed with the data collection process
           },
         ),
       ],
     );
 }


Future<void> showDisclosureDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevent dismissing without action
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('User Data Disclosure'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This app collects and uploads your image to our servers for store to local database and server, and for creating and maintaining accurate patient profiles.'),
              Text('Do you allow this?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Decline'),
            onPressed: () {
              Navigator.of(context).pop();
              // Prevent further action
            },
          ),
          TextButton(
            child: Text('Accept'),
            onPressed: () {
              Navigator.of(context).pop();
              // Proceed with data collection or upload
            },
          ),
        ],
      );
    },
  );
}




