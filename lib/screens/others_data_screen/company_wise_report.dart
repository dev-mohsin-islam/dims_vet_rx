

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/company_wise_brand_report/company_wise_brand_report_controller.dart';
import '../../controller/drawer_controller/drawer_controller.dart';
import '../printing/company_brand_report_download/print.dart';


class CompanyWiseReport extends StatelessWidget {
  const CompanyWiseReport({super.key});

  @override
  Widget build(BuildContext context) {
    final CompanyBrandReport = Get.put(BrandReportController());
    final drawerMenuController = Get.put(DrawerMenuController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download),
          onPressed: (){
        // CompanyBrandReport.branReport.clear();
            if(CompanyBrandReport.branReport.length > 0)
            Navigator.push(context, MaterialPageRoute(builder: (context) => BrandReport(selectedClinicalDataColumn1: [], selectedMedicineDataColumn2: CompanyBrandReport.branReport,)));
      },
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Company Wise Report', style: TextStyle(color: Colors.white),),
            FilledButton(onPressed: (){
              selectCompanyDialog(context);
            }, child: Row(
              children: [
                Icon(Icons.repeat_outlined),
                Text(
                    Platform.isAndroid ? "Select Company" : "Select Company for Generating Report",
                ),
              ],
            )),
            ElevatedButton(onPressed: (){
              CompanyBrandReport.getBrandReportAll();
            }, child: Text("All Companies")),
            IconButton(onPressed: (){
              CompanyBrandReport.branReport.clear();
              drawerMenuController.selectedMenuIndex.value = 0;
            }, icon: Icon(Icons.clear, color: Colors.white),)
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: SingleChildScrollView(
          child: Obx(() => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Rx-Brand Report", style: TextStyle(fontWeight: FontWeight.bold),),
                        Row(
                          children: [
                            Radio(value: true, groupValue: "data", onChanged: (value){
                            }),
                            Text("Details Report")
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Card(
                          child: DropdownButton<String>(
                            underline: Container(),
                            hint: Text(CompanyBrandReport.selectedItem.value),
                            value: CompanyBrandReport.selectedItem.value,
                            items: CompanyBrandReport.items.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              CompanyBrandReport.selectedItem.value = newValue!;
                            },
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
                if(CompanyBrandReport.branReportForDoc.length > 0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(onPressed: (){
                    doctorReport(context);
                  }, child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.report_gmailerrorred),
                      SizedBox(width: 10,),
                      Text("Report View for Doctor"),
                    ],
                  )),
                ),
                 ListView.builder(
                    shrinkWrap: true,
                    itemCount: CompanyBrandReport.brandReportAllCompany.length,
                    itemBuilder: (context, index){
                      var data = CompanyBrandReport.brandReportAllCompany[index];
                      var brands = data['brands'];
                      print(brands.length);
                      // return ExpansionTile(
                      //     title:  Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text(data['company'].company_name),
                      //         // Text("${brands.length}"),
                      //         IconButton(onPressed: (){}, icon: Icon(Icons.email)),
                      //         IconButton(onPressed: (){}, icon: Icon(Icons.sms)),
                      //         IconButton(onPressed: (){}, icon: Icon(Icons.download)),
                      //       ],
                      //     ),
                      //   children: [
                      //     ListView.builder(
                      //       shrinkWrap: true,
                      //       itemCount: brands.length,
                      //       itemBuilder: (context, index){
                      //         var brand = brands[index];
                      //          print(brand);
                      //         return ListTile(
                      //             title: Text(brand['brandInfo'].brand_name),
                      //         subtitle: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //         // Text('Drug: ${brand['drug'].name}'),
                      //         // Text('Generic: ${brand['generic'].name}'),
                      //         // Text('Prescription: ${brand['prescriptionInfo'].name}'),
                      //         // Text('Doses: ${brand['doses'].map((dose) => dose.name).join(', ')}'),
                      //         ],
                      //         ) );
                      //
                      //       },
                      //     )
                      //   ],
                      // );
                    })
                // ListView.builder(
                //   itemCount: CompanyBrandReport.brandReportAllCompany.length,
                //   itemBuilder: (context, index) {
                //     // var companyData = CompanyBrandReport.brandReportAllCompany[index];
                //     // var company = companyData['company'];
                //     // var brands = companyData['brands'];
                //     return Text("data");
                //
                //     // return ExpansionTile(
                //     //   title: Text(company.id),
                //     //   children: brands.map<Widget>((brandData) {
                //     //     return ListTile(
                //     //       title: Text("brandName"),
                //     //       // subtitle: Column(
                //     //       //   crossAxisAlignment: CrossAxisAlignment.start,
                //     //       //   children: [
                //     //       //     Text('Drug: ${brandData['drug'].name}'),
                //     //       //     Text('Generic: ${brandData['generic'].name}'),
                //     //       //     Text('Prescription: ${brandData['prescriptionInfo'].name}'),
                //     //       //     Text('Doses: ${brandData['doses'].map((dose) => dose.name).join(', ')}'),
                //     //       //   ],
                //     //       // ),
                //     //     );
                //     //   }).toList(),
                //     // );
                //   },
                // )

              ]
          ))
        ),
      )
    );
  }
}

selectCompanyDialog(context){
  final brandReport = Get.put(BrandReportController());
  showDialog(context: context, builder: (context){
    return  AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Select Company"),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.clear),)
        ],
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                controller: brandReport.searchText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(onPressed: (){
                    brandReport.searchText.clear();
                    brandReport.getCompany("");
                  }, icon: Icon(Icons.clear)),
                ),
                onChanged: (value){
                  brandReport.getCompany(value);
                },
              ),
            ),
            Obx(() => Expanded(
                child: ListView.builder(
                    itemCount: brandReport.companyList.length,
                    itemBuilder: (context, index){
                      var company = brandReport.companyList[index];
                      return Card( 
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(company.company_name.toString()),
                                ElevatedButton(onPressed: ()async{
                                   brandReport.getBrandReport(company.id);
                                  // Navigator.pop(context);
                                }, child: Text("Select For Report"))
                              ],
                            ),
                             
                          )
                      );
                    }
                )
            ))
          ]
        )
      )
    );
  });
}
BrandReportController companyWiseReport = Get.put(BrandReportController());

doctorReport(context){
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Report for Doctor"),
          IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.clear))
        ],
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(

            children: [
              ListView.builder(
                  itemCount: companyWiseReport.branReportForDoc.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                var brandName = companyWiseReport.branReportForDoc[index][0].brand_name;
                var numberOfTimes = companyWiseReport.branReportForDoc[index].length;
                return Card(
                  child: ListTile(
                    title: Text("Brand Name: ${brandName}"),
                    subtitle: Text("Number of times: ${numberOfTimes}"),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  });
}



