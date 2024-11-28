import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'default_value.dart';
import 'helpers.dart';
import 'app_strings.dart';
// Future<void>setSharedPreferences() async {
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.advice, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.brand, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.cc, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.company, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.diagnosis, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.dose, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.duration, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.generic, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.handout, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.history, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.instruction, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.investigationAdvice, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.investigationReport, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.onExamination, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.onExaminationCategory, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.procedure, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.patient, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.appointment, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescription, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescriptionDrug, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescriptionDrugDose, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.template, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.templateDrug, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.templateDrugDose, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.favorite, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.patientsSocialHistory, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.patientsAllergyHistory, DefaultValues.defaultSyncStarting);
//   await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.patientsFamilyHistory, DefaultValues.defaultSyncStarting);
//
//
//
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.advice, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.brand, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.cc, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.company, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.diagnosis, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.dose, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.duration, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.generic, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.handout, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.history, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.instruction, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.investigationAdvice, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.investigationReport, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.onExamination, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.onExaminationCategory, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.procedure, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.patient, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.appointment, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.prescription, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.prescriptionDrug, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.prescriptionDrugDose, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.template, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.templateDrug, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.templateDrugDose, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.favorite, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.patientsSocialHistory, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.patientsAllergyHistory, DefaultValues.defaultPageNum);
//   await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.patientsFamilyHistory, DefaultValues.defaultPageNum);
// }