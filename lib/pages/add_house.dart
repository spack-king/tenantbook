import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../adapter/house_location.dart';
import '../utilities/global_variable.dart';
import '../utilities/utils.dart';

class AddHouse extends StatefulWidget {
  const AddHouse({super.key});

  @override
  State<AddHouse> createState() => _AddHouseState();
}

class _AddHouseState extends State<AddHouse> {

  var box =  Hive.box<Location>('location');
  TextEditingController houseTypeEditingController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

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
    _loadRewardedAd();
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
  void dispose() {
    super.dispose();
    _rewardedAd?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add house'),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                child: TextField(
                    controller: houseTypeEditingController,
                    textCapitalization: TextCapitalization.sentences,

                    // keyboardType: TextInputType.phone,
                    decoration: InputDecoration(

                      labelText: 'House type',
                      hintText: 'e.g Bungalow',

                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      prefixIcon: Icon(CupertinoIcons.house),

                    )
                ),
              ),
              SizedBox(height: 10,),
              Container(
                child: TextField(
                    controller: textEditingController,
                    textCapitalization: TextCapitalization.sentences,

                    keyboardType: TextInputType.streetAddress,
                    // keyboardType: TextInputType.phone,
                    decoration: InputDecoration(

                      labelText: 'Street address',
                      hintText: 'e.g No 5 PH street, abc ...',

                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      prefixIcon: Icon(CupertinoIcons.location),

                    )
                ),
              ),

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
    if(houseTypeEditingController.text.isEmpty){
      showSpackSnackBar('Enter the house type', context, Colors.orange, CupertinoIcons.house);
    }else  if(textEditingController.text.isEmpty){
      showSpackSnackBar('Enter the house street address', context, Colors.orange, CupertinoIcons.house);
    }
    else{
      var id = '${DateTime.timestamp()}';
      var item = Location(
          name: houseTypeEditingController.text,
          id: id,
          address: textEditingController.text);
      box.put(id, item);
      Navigator.pop(context);
      if(_rewardedAd != null){
        _rewardedAd?.show(
          onUserEarnedReward: (_, reward) {

          },
        );
      }
      showSpackSnackBar('Successfully added!', context, Colors.green, Icons.done_outline);

    }
  }
}
