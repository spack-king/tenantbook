import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tenantbook/pages/tenant_details.dart';
import 'package:url_launcher/url_launcher.dart';

import '../adapter/tenant.dart';
import '../utilities/global_variable.dart';
import '../utilities/utils.dart';
import 'add_tenant.dart';

class TenantsPage extends StatefulWidget {
  final id;
  const TenantsPage({super.key, required this.id});

  @override
  State<TenantsPage> createState() => _TenantsPageState();
}

class _TenantsPageState extends State<TenantsPage> {
  var box =  Hive.box<Tenant>('tenant');

  bool adLoaded = false;
  late BannerAd bannerAd;


  @override
  void initState() {

    if(!kIsWeb) {
      bannerAd = BannerAd(
        adUnitId: adUnitId,
        size: AdSize.banner,
        listener: BannerAdListener(
            onAdFailedToLoad: (ad, error){
              print(error.message.toString());
              bannerAd.load();
            },
            onAdLoaded: (ad) {
              setState(() {
                adLoaded = true;
              });
            },
            onAdClicked: (Ad ad) {

            }
        ),
        request: const AdRequest(),

      );
      bannerAd.load();
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenants'),
      ),

        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(

            children: <Widget>[

              Expanded(
                  child: box.length == 0
                      ?Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_pin_outlined, size: 100, color: Colors.grey,),
                      const Text('No Tenant added yet'),
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                AddTenant(houseid: widget.id,)
                            )).then((value){
                              setState(() {

                              });
                            });
                          },
                          child: Text('Add your first tenant'))
                    ],
                  )
                      :ListView.builder(
                      itemCount: box.length,

                      itemBuilder: (BuildContext context, int index){

                        var item = box.getAt(index);
                        String tenant_name= item!.tenant_name;
                        var lastPayment = item.lastPayment;
                        var profPics = item.profPics;
                        var phoneNo = item.phoneNo;
                        String id = item.id;

                        return id == widget.id
                        ?Container(
                          margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                          child: ListTile(
                            onLongPress: (){
                              deleteItem(index);
                            },
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  TenantDetails(index: index)
                              )).then((value) {
                                setState(() {

                                });
                              });
                            },
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey.shade200,
                              foregroundImage:kIsWeb
                                  ? null//NetworkImage(imageFile!.path)
                                  :FileImage(File(profPics)),
                              child:kIsWeb ? SizedBox(
                                height: 70,
                                width: double.infinity,
                                child: Image.network(profPics),
                              )
                                  :Container(),

                            ),
                            title: Text(tenant_name, textScaleFactor: 1.3,),
                            subtitle: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: 'Last Rent: ', style: TextStyle(color: Colors.black,)),
                                  TextSpan(text: '$lastPayment', style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
                                ]
                              ),
                            ),
                            trailing: IconButton(
                                onPressed: (){
                                  //deleteItem(index);
                                  DialNumber(phoneNo);
                                },
                                icon: const Icon(Icons.call, color: Colors.green,)),

                          ),
                        )
                        :
                        index == 0
                        ?Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person_pin_outlined, size: 100, color: Colors.grey,),
                            const Text('No Tenant added here yet'),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      AddTenant(houseid: widget.id,)
                                  )).then((value){
                                    setState(() {

                                    });
                                  });
                                },
                                child: Text('Add your first tenant'))
                          ],
                        )
                        : Container();
                      }
                  )
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                AddTenant(houseid: widget.id,)
            )).then((value){
              setState(() {

              });
            });
          },
          tooltip: 'Increment',
          child: const Icon(Icons.person_add_alt),
        ),
      bottomNavigationBar: adLoaded ? Container(
        height: 50,
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: bannerAd.size.width.toDouble(),
            height: bannerAd.size.height.toDouble(),
            child: AdWidget(ad: bannerAd),
          ),
        ),
      ) : Container(height: 1,),
    );
  }

  Future deleteItem(int index) {
    return showCupertinoDialog(
        context: context,
        builder: (context) =>
            CupertinoAlertDialog(
              title: const Text('Do you want to delete this Tenant\'s details?'),
              actions: [
                CupertinoDialogAction(child: Text('No, cancel'), onPressed: (){
                  Navigator.pop(context);
                },),
                CupertinoDialogAction(
                    child: Text('Yes, delete',
                      style: TextStyle(color: Colors.red),) ,
                    onPressed: (){
                      box.deleteAt(index);
                      Navigator.pop(context);

                      showSpackSnackBar('Deleted successfully!', context, Colors.green, Icons.done_all_sharp);
                      setState(() {

                      });
                    }
                ),
              ],
            )
    );
  }
  DialNumber(var phoneNo) async {
    var url = 'tel:$phoneNo';
    if(await canLaunchUrl(Uri.parse(url))){
      await launchUrl(Uri.parse(url));
    }
  }
}
