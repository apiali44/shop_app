import 'package:flutter/material.dart';
import 'package:shop_app/users/model/cloth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class ItemDetailsScreen extends StatefulWidget {
  final Cloth? itemInfo;
  ItemDetailsScreen({this.itemInfo});


  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FadeInImage(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              placeholder: const AssetImage("images/place_holder.png"),
              image: NetworkImage(
                widget.itemInfo!.item_image!,
              ),
              imageErrorBuilder: (context, error, stackTraceError){
                return const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                  ),
                );
              }),
          //we're are going to start saying item information
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          ),
        ],
      )
    );
  }

  Widget itemInfoWidget () {
  return Container(
    height: MediaQuery.of(context).size.height * 0.55,
    width: MediaQuery.of(context).size.width,
    decoration: const BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30)
      ),
      boxShadow: [
        BoxShadow(
          offset: Offset(0,-3),
          blurRadius: 6,
          color: Colors.white
        )
      ]
    ),
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18,),
          Center(
            child: Container(
              height: 8,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)
              ),
            ),
          ),
          const SizedBox(height: 30,),
          Text(
            widget.itemInfo!.item_name!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 10,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                      children: [
                        RatingBar.builder(
                          initialRating: widget.itemInfo!.item_rating!,
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
                          "(${widget.itemInfo!.item_rating!})",
                          style: const TextStyle(
                              color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                      const SizedBox(height: 2,),
                      Text(
                        widget.itemInfo!.item_tag!.toString().replaceAll("[", "").replaceAll("]", ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.lightBlue,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                          "\$ ${widget.itemInfo!.item_price!.toString()}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purpleAccent)
                      )
                    ],

                  ))
            ],
          ),

        ],
      ),
    ),
  );
  }
}
