import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/userPreferences/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shop_app/users/Item/item_details.dart';

import 'package:shop_app/api_connection/api_connection.dart';

import '../model/cloth.dart';

class HomeFragments extends StatelessWidget {

  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());
  final TextEditingController searchController = TextEditingController();


  Future<List<Cloth>> getTrendingItems () async {
    List<Cloth> trendingItemList = [];

    try{
      var res = await http.post(
        Uri.parse(API.trendingItems),
      );
      if(res.statusCode == 200){
        var trendingResBody = jsonDecode(res.body);
        if(trendingResBody["success"] == true){
          (trendingResBody["clothItemsData"] as List).forEach((eachRecord) {
            trendingItemList.add(Cloth.fromJson(eachRecord));
          });
        }
      } else{
        Fluttertoast.showToast(
            msg: "Error, status Code not 200");
      }
    }
    catch(errorMsg){
      print("error:: $errorMsg");
    }

    return trendingItemList;
  }

  Future<List<Cloth>> getNewItems () async {
    List<Cloth> newItemsList = [];

    try{
      var res = await http.post(
        Uri.parse(API.newItem),
      );
      if(res.statusCode == 200){
        var resNewItems = jsonDecode(res.body);
        if(resNewItems["success"] == true){
          (resNewItems["clothItemsData"] as List).forEach((eachRecord) {
            newItemsList.add(Cloth.fromJson(eachRecord));
          });
        }
      } else{
        Fluttertoast.showToast(
            msg: "Error, status Code not 200");
      }
    }
    catch(errorMsg){
      print("error:: $errorMsg");
    }

    return newItemsList;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              showSearchBarWidget(),
              const SizedBox(height: 26),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Trending",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),//trending items
              trendingItemsWidget(context),
              const SizedBox(height: 22),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "New Collections",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ), //new collections
              newCollectionWidget(context),
            ],
          ),
        );
      },
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.search, color: Colors.purple,),
          ),
          hintText: "Search items..",
          hintStyle: const TextStyle(
            color: Colors.grey
          ),
          suffixIcon: IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.shopping_cart, color: Colors.purpleAccent,)
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.purpleAccent,
            )
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Colors.purple,
              )
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Colors.purpleAccent,
              )
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          fillColor: Colors.white10, filled: true,
        ),
      ),
    );
  }

  Widget trendingItemsWidget (context) {
    return FutureBuilder(
        future: getTrendingItems(),
        builder: (context, AsyncSnapshot<List<Cloth>> dataSnapShot){
          if(dataSnapShot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          /*if(dataSnapShot == null){
            return const Center(
                child: Text(
                  "No trending item found"
                ),
            );
          }*/
          if(dataSnapShot.data!.isNotEmpty){
            return SizedBox(
              height: 260,
              child: ListView.builder(
                  itemCount: dataSnapShot.data!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Cloth eachItemData = dataSnapShot.data![index];
                    return GestureDetector(
                      onTap: (){Get.to(()=> ItemDetailsScreen(itemInfo: eachItemData));},
                      child: Container(
                        width: 200,
                        margin: EdgeInsets.fromLTRB(
                          index == 0 ? 16 : 8,
                          10,
                          index == dataSnapShot.data!.length -1 ? 16 : 8,
                          10
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black,
                          boxShadow: const [BoxShadow(
                            offset: Offset(0,3),
                            blurRadius: 6,
                            color: Colors.grey,
                          )]
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(22),
                                topRight: Radius.circular(22)
                              ),
                              child: FadeInImage(
                                  height: 150, width: 200,
                                  fit: BoxFit.cover,
                                  placeholder: const AssetImage("images/place_holder.png"),
                                  image: NetworkImage(
                                    eachItemData.item_image!,
                                  ),
                              imageErrorBuilder: (context, error, stackTraceError){
                                    return const Center(
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                      ),
                                    );
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          eachItemData.item_name!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        eachItemData.item_price.toString(),
                                        style: const TextStyle(color: Colors.purpleAccent, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RatingBar.builder(
                                          initialRating: eachItemData.item_rating!,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemBuilder: (context, c) => const Icon(Icons.star, color: Colors.amber),
                                          onRatingUpdate: (updateRating){},
                                          ignoreGestures: true,
                                          unratedColor: Colors.grey,
                                          itemSize: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "(${eachItemData.item_rating})",
                                        style: const TextStyle(
                                          color: Colors.grey
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
              ),
            );
          }
          else {
            return const Center(
              child: Text("Empty Data", style: TextStyle(color: Colors.white),),
            );
          }
        }

    );
  }

  Widget newCollectionWidget(context) {
    return FutureBuilder(
        future: getNewItems(),
        builder: (context, AsyncSnapshot<List<Cloth>> dataSnapShot){
          if(dataSnapShot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          /*if(dataSnapShot == null){
            return const Center(
                child: Text(
                  "No trending item found"
                ),
            );
          }*/
          if(dataSnapShot.data!.isNotEmpty){
            return ListView.builder(
                itemCount: dataSnapShot.data!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Cloth eachNewItem = dataSnapShot.data![index];
                  return GestureDetector(
                    onTap: (){Get.to(ItemDetailsScreen(itemInfo: eachNewItem));},
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                          16,
                          index == 0 ? 16 : 8,
                          16,
                          index == dataSnapShot.data!.length -1 ? 16 : 8,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black,
                          boxShadow: const [BoxShadow(
                            offset: Offset(0,0),
                            blurRadius: 6,
                            color: Colors.white,
                          )]
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.1),
                                            child: Text(
                                            eachNewItem.item_name!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8, right: 8),
                                          child: Text(
                                            "\$ ${eachNewItem.item_price.toString()}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                                          ),
                                        ),

                                  ],
                                ),
                                    const SizedBox(height: 16,),
                                    Text(
                                      "Tags: \n${eachNewItem.item_tag.toString().replaceAll("[", "").replaceAll("]", "")}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                                    ),
                              ],
                            ),
                          )
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20)
                            ),
                            child: FadeInImage(
                                height: 130, width: 130,
                                fit: BoxFit.cover,
                                placeholder: const AssetImage("images/place_holder.png"),
                                image: NetworkImage(
                                  eachNewItem.item_image!,
                                ),
                                imageErrorBuilder: (context, error, stackTraceError){
                                  return Center(
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );

          }
          else {
            return const Center(
              child: Text("Empty Data", style: TextStyle(color: Colors.white),),
            );
          }
        }

    );
  }

}
