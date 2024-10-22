import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:url_launcher/url_launcher.dart';

import '../adapter/tenant.dart';
import '../utilities/global_variable.dart';
import '../utilities/utils.dart';
import 'edit_tenant.dart';

class TenantDetails extends StatefulWidget {
  final index;
  const TenantDetails({super.key, required this.index});

  @override
  State<TenantDetails> createState() => _TenantDetailsState();
}

class _TenantDetailsState extends State<TenantDetails> {
  var box =  Hive.box<Tenant>('tenant');

  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathAFunction = (Match match) => '${match[1]},';

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
     
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  kIsWeb
                  ? Image.network(box.getAt(widget.index)!.profPics)
                  : Image.file(File(box.getAt(widget.index)!.profPics)),
                  //action button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.arrow_back, color: Colors.black,))),

                      IconButton(
                          onPressed: (){
                            deleteItem().then((value){
                              Navigator.pop(context);
                            });

                          },
                          icon: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(CupertinoIcons.delete, color: Colors.red,))),
                    ],
                  ),
                  //NAME
                  Container(
                    margin: EdgeInsets.only(top: 200, left: 20 ),
                    child: Text('${box.getAt(widget.index)!.tenant_name}', textScaleFactor: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.white, offset: Offset(1, 1))
                          ] ),),
                  ),
                  //number
                  Positioned(
                    bottom: 10,
                    child: Container(
                      margin: EdgeInsets.only(top: 200, left: 20, right: 20 ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Phone Number'),
                          Text('${box.getAt(widget.index)!.phoneNo}', textScaleFactor: 1.5,
                            style: TextStyle(
                              color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(color: Colors.black, offset: Offset(1, 1))
                                ] ),),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              //flat
              Container(
                margin: EdgeInsets.only(left: 20, top: 20),
                child: const Text('Apartment', style: TextStyle(color: Colors.grey),),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,),
                child: Text('${box.getAt(widget.index)!.flat}', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              //rent amount
              Container(
                margin: EdgeInsets.only(left: 20, top: 15),
                child: const Text('Rent amount', style: TextStyle(color: Colors.grey),),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,),
                child: Text('NGN ${box.getAt(widget.index)!.rentAmount.toString().replaceAllMapped(reg, mathAFunction)}', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              //occupation
              Container(
                margin: EdgeInsets.only(left: 20, top: 15),
                child: const Text('Occupation', style: TextStyle(color: Colors.grey),),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,),
                child: Text('${box.getAt(widget.index)!.occupation}', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              //last payment
              Container(
                margin: EdgeInsets.only(left: 20, top: 15),
                child: const Text('Date for last rent payment', style: TextStyle(color: Colors.grey),),
              ),
              Container(
                margin: EdgeInsets.only(left: 20,),
                child: Text('${box.getAt(widget.index)!.lastPayment}', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>  EditTenant(index: widget.index))).
              then((value) {
                setState(() {

                });
              });
            },
            mini: true,
            child: Icon(Icons.edit, color: Colors.green,),
          ),
          const SizedBox(height: 10,),
          FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: (){
              DialNumber(box.getAt(widget.index)!.phoneNo);
            },
            child: Icon(Icons.call, color: Colors.white,),
          ),
        ],
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

  DialNumber(var phoneNo) async {
    var url = 'tel:$phoneNo';
    if(await canLaunchUrl(Uri.parse(url))){
      await launchUrl(Uri.parse(url));
    }
  }
  Future deleteItem() {
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
                      box.deleteAt(widget.index);
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
}
