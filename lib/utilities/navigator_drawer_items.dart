
import 'package:get/get.dart';

import 'app_icons.dart';

class NavigatorDrawerItem{

  static final List menuSingleItem = [
    {"id":0, "label": "Prescription Home",},
    {"id":1, "label": "Appointment List",},
    {"id":2, "label": "Prescription List",},
    {"id":3, "label": "Dashboard",},
  ].obs;

  static final List menuTodayAppointment = [
    {"id":0, "label": "Rakibul Islam"},
    {"id":0, "label": "Jahidul Isalm"},
    {"id":0, "label": "Sumon"},
  ].obs;

  static final List  menuSettings = [
    // {'id':3, 'label': 'Prescription Print Setup New'},
    {'id':4, 'label': 'Prescription Print Page Setup'},
    // {'id':5, 'label': 'Prescription Print Setup New'},
    // {'id':6, 'label': 'Custom Header & Footer'},
    {'id':7, 'label': 'Customize Data Ordering'},
    {'id':8, 'label': 'Setting'},
  ].obs;

  static final List  menuBrand = [
    {'id':9, 'label': 'Brand'},
    {'id':10, 'label': 'Generic'},
    {'id':11, 'label': 'Company'},
    {'id':12, 'label': 'Dose'},
    {'id':13, 'label': 'Duration'},
    {'id':14, 'label': 'Instructions'},
  ].obs;

  static final List  menuClinicalOptions = [
    {'id':15, 'label': 'Template Create'},
    {'id':16, 'label': 'Template List'},
    {'id':17, 'label': 'Chief Complaints'},
    {'id':18, 'label': 'On Examination'},
    {'id':19, 'label': 'On Examination Category'},
    {'id':20, 'label': 'Diagnosis'},
    {'id':21, 'label': 'Investigation Advice'},
    {'id':22, 'label': 'Investigation Report'},
    {'id':23, 'label': 'Procedure'},
    {'id':24, 'label': 'History'},
    {'id':25, 'label': 'Advice'},
    {'id':26, 'label': 'Handout'},
  ].obs;

  static final List  menuOthers = [
    {'id':27, 'label': 'Referral Doctor'},
    {'id':28, 'label': 'List of Patient Referred'},
    {'id':29, 'label': 'Patient Money Receipt List'},
    {'id':30, 'label': 'Assistant Create'},
    {'id':31, 'label': 'Certificates'},
    {'id':32, 'label': 'Company Wise Brand Report'},

  ].obs;

  static final List  syncType = [
    {'id':33, 'label': 'Open Data Folder'},
    // {'id':34, 'label': 'Data Sync'},

  ].obs;
}

