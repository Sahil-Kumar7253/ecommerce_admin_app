import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/PromoModel.dart';
import 'package:flutter/material.dart';

import '../Container/additionalConfirm.dart';

class Promobanners extends StatefulWidget {
  const Promobanners({super.key});

  @override
  State<Promobanners> createState() => _PromobannersState();
}

class _PromobannersState extends State<Promobanners> {
  bool _isInitialized = false;
  bool _isPromo = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        final arguments = ModalRoute.of(context)?.settings.arguments;
        if(arguments != null && arguments is Map<String,dynamic>){
          _isPromo = arguments["promo"] ?? true;
        }
        print(_isPromo);
        _isInitialized = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isPromo ? "Promos" : "Banners"),
        centerTitle: true,
      ),
      body: _isInitialized? StreamBuilder(stream: DbService().readPromos(_isPromo),
          builder: (context, snapshot){
               if (snapshot.hasData) {
                 List<PromoBannersModel> promos = PromoBannersModel.fromJsonList(snapshot.data!.docs);
                 if(promos.isEmpty){
                   return  Center(child: Text("No ${_isPromo ? "promos" : "banners"} found"));
                 }
                 return ListView.builder(
                   itemCount: promos.length,
                   itemBuilder: (context, index) {
                     return ListTile(
                         onTap: (){
                           showDialog(context: context, builder: (context) => AlertDialog(
                             title: Text("Choose What you want to delete"),
                             content: Text("Delete Cannot be undone"),
                             actions: [
                               TextButton(onPressed: (){
                                 showDialog(context: context, builder: (context) =>
                                     Additionalconfirm(
                                         contentText: "Are You Suer you want to Delete the Product",
                                         onNo: (){
                                           Navigator.pop(context);
                                         },
                                         onYes: (){
                                           DbService().deletePromos(id: promos[index].Id, isPromo: _isPromo);
                                           Navigator.pop(context);
                                           Navigator.pop(context);
                                         })
                                 );

                               }, child: Text("Delete ${_isPromo? "Promo" : "Banner"}")),
                               TextButton(onPressed: (){
                               }, child: Text("Update ${_isPromo? "Promo" : "Banner"}"))
                             ],
                           ));
                         },

                       leading: Container(
                         height: 50,
                         width: 50,
                         child: Image.network(promos[index].image)
                       ),
                       title: Text(promos[index].title, maxLines: 2, overflow: TextOverflow.ellipsis,),
                       subtitle: Text(promos[index].category),
                       trailing : IconButton(onPressed: (){
                         Navigator.pushNamed(context, "/modifypromo", arguments: {
                           'detail' : promos[index],
                           'promo' : _isPromo,
                         });
                       }, icon: Icon(Icons.edit_outlined))
                     );
                   }
                 );
               }
               return Center(child: CircularProgressIndicator());
          })
          : Center(child: CircularProgressIndicator()),
          floatingActionButton: FloatingActionButton(
           onPressed: () {
             Navigator.pushNamed(context, "/modifypromo", arguments: {
               'promo' : _isPromo,
             });
           },
           child: Icon(Icons.add)
          ),
    );
  }
}
