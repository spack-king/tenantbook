import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tenantbook/pages/add_house.dart';
import 'package:tenantbook/pages/tenants_page.dart';
import 'package:tenantbook/utilities/global_variable.dart';
import 'package:tenantbook/utilities/utils.dart';
import 'adapter/house_location.dart';
import 'adapter/tenant.dart';

void main() async {

  //for hive
  await Hive.initFlutter();
  Hive.registerAdapter(LocationAdapter());
  await Hive.openBox<Location>('location');
  Hive.registerAdapter(TenantAdapter());
  await Hive.openBox<Tenant>('tenant');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TenantBook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TenantBook'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var box =  Hive.box<Location>('location');

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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
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
                    const Icon(Icons.other_houses_sharp, size: 100, color: Colors.grey,),
                    const Text('No house added yet'),
                    TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              AddHouse()
                           )).then((value) {
                             setState(() {

                             });
                          });
                        },
                        child: Text('Add your first house'))
                  ],
                )
                    :ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (BuildContext context, int index){

                      var item = box.getAt(index);
                      String name= item!.name;
                      String address = item.address;
                      String id = item.id;

                      return Container(
                        margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                        child: ListTile(
                          onTap: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                TenantsPage(id: id)
                            ));
                          },
                          leading: const Icon(Icons.home),
                          title: Text(name),
                          subtitle: Text(address),
                          trailing: IconButton(
                            onPressed: (){
                              deleteItem(index);
                            },
                              icon: const Icon(CupertinoIcons.delete, color: Colors.red,)),

                        ),
                      );
                    }
                )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              AddHouse()
          )).then((value){
            setState(() {

            });
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add_home_outlined),
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
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future deleteItem(int index) {
     return showCupertinoDialog(
         context: context,
         builder: (context) =>
             CupertinoAlertDialog(
               title: const Text('Are you sure you want to delete?'),
               content: const Text('This might delete all the tenant\'s details saved in this house'),
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
}
