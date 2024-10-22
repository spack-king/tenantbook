import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tenantbook/adapter/tenant.dart';

import '../utilities/global_variable.dart';
import '../utilities/utils.dart';

class AddTenant extends StatefulWidget {
  final houseid;
  const AddTenant({super.key, required this.houseid});

  @override
  State<AddTenant> createState() => _AddTenantState();
}

class _AddTenantState extends State<AddTenant> {
  final picker = ImagePicker();
  late XFile? imageFile;
  late Uint8List? uint8list;

  bool adLoaded = false;
  late BannerAd bannerAd;

  // TODO: Add _rewardedAd
  RewardedAd? _rewardedAd;

  // TODO: Implement _loadRewardedA
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: adUnitId_reward,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
    imageFile = null;

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
  }

  var box =  Hive.box<Tenant>('tenant');

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController occupationEditingController = TextEditingController();
  TextEditingController flatEditingController = TextEditingController();
  TextEditingController phonNOEditingController = TextEditingController();
  TextEditingController rentAmountEditingController = TextEditingController();
  TextEditingController rentDueEditingController = TextEditingController();


  _selectVideoType(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select image source'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a picture'),
                onPressed: () async {
                  Navigator.pop(context);
                  imageFile =
                  await ImagePicker().pickImage(source: ImageSource.camera);
                  //
                  // _video = imageFile?.path ?? '';
                  // _futureImage = GenThumbnailImage(
                  //   thumbnailRequest: ThumbnailRequest(
                  //     video: _video,
                  //     thumbnailPath: null,
                  //     imageFormat: _format,
                  //     maxHeight: _sizeH,
                  //     maxWidth: _sizeW,
                  //     timeMs: _timeMs,
                  //     quality: _quality,
                  //     attachHeaders: _attachHeaders,
                  //   ),
                  // );
                  setState(() {
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  imageFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
                  //
                  // _video = imageFile?.path ?? '';
                  // _futureImage = GenThumbnailImage(
                  //   thumbnailRequest: ThumbnailRequest(
                  //     video: _video,
                  //     thumbnailPath: null,
                  //     imageFormat: _format,
                  //     maxHeight: _sizeH,
                  //     maxWidth: _sizeW,
                  //     timeMs: _timeMs,
                  //     quality: _quality,
                  //     attachHeaders: _attachHeaders,
                  //   ),
                  // );
                  setState(() {

                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new Tenant'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Select a photo',
                    onPressed: (){

                      _selectVideoType(context);
                    },
                    icon: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey.shade200,
                        foregroundImage:imageFile == null
                            ? null
                        :kIsWeb
                        ? null//NetworkImage(imageFile!.path)
                        :FileImage(File(imageFile!.path)),
                        child:
                        imageFile == null
                            ? Icon(Icons.add_a_photo_outlined, size: 30,)
                            : kIsWeb ? SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Image.network(imageFile!.path),
                        )
                            :Container(),

                    )),

                SizedBox(height: 10,),
                //name
                Container(
                  child: TextField(
                      controller: nameEditingController,
                      textCapitalization: TextCapitalization.sentences,

                      // keyboardType: TextInputType.phone,
                      decoration: InputDecoration(

                        labelText: 'Tenant name',
                        hintText: 'Enter tenant\'s name',

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        prefixIcon: Icon(Icons.person),

                      )
                  ),
                ),
                SizedBox(height: 10,),
                //occupation
                Container(
                  child: TextField(
                      controller: occupationEditingController,
                      textCapitalization: TextCapitalization.sentences,

                      // keyboardType: TextInputType.phone,
                      decoration: InputDecoration(

                        labelText: 'Tenant occupation',
                        hintText: 'Enter tenant\'s occupation',

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        prefixIcon: Icon(Icons.cases_outlined),

                      )
                  ),
                ),
                SizedBox(height: 10,),
                //phone
                Container(
                  child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: phonNOEditingController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(

                        labelText: 'Tenant phone number',
                        hintText: 'Enter tenant\'s phone number',

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        prefixIcon: Icon(Icons.phone),

                      )
                  ),
                ),
                SizedBox(height: 10,),
                //flat
                Container(
                  child: TextField(
                      controller: flatEditingController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(

                        labelText: 'Tenant apartment number',
                        hintText: 'Enter tenant\'s apartment number',

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        prefixIcon: Icon(Icons.apartment),

                      )
                  ),
                ),
                SizedBox(height: 10,),
                //amount
                Container(
                  child: TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                      controller: rentAmountEditingController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(

                        labelText: 'Tenant rent amount',
                        hintText: 'Enter tenant\'s rent amount',

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        prefixIcon: Icon(Icons.money),

                      )
                  ),
                ),
                SizedBox(height: 10,),
                //RENT DUE
                Container(
                  child: TextField(
                    readOnly: true,
                      onTap: (){
                        pickDate(context);
                      },
                      controller: rentDueEditingController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(

                        labelText: 'Last rent payment',
                        hintText: 'Last rent payment',

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        prefixIcon: Icon(Icons.date_range),

                      )
                  ),
                ),
                SizedBox(height: 10,),

                SizedBox(height: 25,),
                InkWell(
                  onTap: (){
                    addHouse();
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration:const ShapeDecoration(shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5),)
                    ),
                        color: Colors.deepPurple
                    ),
                    child:  const Text('ADD', style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
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

  void addHouse() {
    if(imageFile == null){
      showSpackSnackBar('Please add tenant\'s picture', context, Colors.orange, Icons.account_circle);
    } else if(nameEditingController.text.isEmpty){
      showSpackSnackBar('Enter tenant\'s name', context, Colors.orange, Icons.person);
    }else if(occupationEditingController.text.isEmpty){
      showSpackSnackBar('Enter tenant\'s occupation', context, Colors.orange, Icons.cases_rounded);
    }if(phonNOEditingController.text.isEmpty){
      showSpackSnackBar('Enter tenant\'s phone number', context, Colors.orange, Icons.phone);
    }if(flatEditingController.text.isEmpty){
      showSpackSnackBar('Enter tenant\'s apartment', context, Colors.orange, Icons.apartment);
    }if(rentAmountEditingController.text.isEmpty){
      showSpackSnackBar('Enter tenant\'s rent amount', context, Colors.orange, Icons.payments_sharp);
    }if(rentDueEditingController.text.isEmpty){
      showSpackSnackBar('Select tenant\'s last rent payment date', context, Colors.orange, Icons.date_range_outlined);
    }
    else{
     // var id = '${DateTime.timestamp()}';
      int phoneNo = int.parse(phonNOEditingController.text);
      int rentAmount = int.parse(rentAmountEditingController.text);

      var item = Tenant(
          tenant_name: nameEditingController.text,
          id: widget.houseid, //rent amount
          profPics: imageFile!.path,
          occupation: occupationEditingController.text,
          flat: flatEditingController.text,
          lastPayment: rentDueEditingController.text,
          phoneNo: phoneNo, rentAmount: rentAmount);

      box.put('$phoneNo', item);
      Navigator.pop(context);
      if(_rewardedAd != null){
        _rewardedAd?.show(
          onUserEarnedReward: (_, reward) {

          },
        );
      }
      showSpackSnackBar('Tenant successfully added!', context, Colors.green, Icons.done_outline);

    }
  }

  void pickDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2002, 23),
        lastDate: DateTime(2102, 23));
    if(picked != null){
      setState(() {
        rentDueEditingController.text = '${DateFormat.yMMMd().format(picked)}';
      });
    }
  }
}
