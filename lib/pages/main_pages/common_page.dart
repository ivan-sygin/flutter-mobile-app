import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sochi/api/main_api/main_api.dart';
import 'package:sochi/classes/item.dart';
import 'package:sochi/colors/colors.dart';
import 'package:sochi/storages/user_storage.dart';
import 'package:provider/provider.dart';

class CommonPage extends StatefulWidget {
  const CommonPage({super.key});

  @override
  State<CommonPage> createState() => _CommonPageState();
}

class _CommonPageState extends State<CommonPage> {
  bool isSearching = false;
  void changeStatusSearching({boolka}) {
    if (boolka != null)
      isSearching = boolka;
    else
      isSearching = !isSearching;
    setState(() {});
  }

  void updatePage() {
    setState(() {});
  }

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(children: [
        _HeaderCommonPage(
          func: changeStatusSearching,
          ctrl: searchController,
          func2: updatePage,
        ),
        if (!isSearching)
          SizedBox(
            height: 5,
          ),
        if (!isSearching) _AddNewRequest(),
        SizedBox(
          height: 15,
        ),
        if (!isSearching) _ListRecommendedPrices(),
        if (isSearching) _ListSearchInfo(ctrl: searchController),
      ])),
    );
  }
}

class _ListSearchInfo extends StatefulWidget {
  const _ListSearchInfo({super.key, required this.ctrl});
  final TextEditingController ctrl;
  @override
  State<_ListSearchInfo> createState() => __ListSearchInfoState();
}

class __ListSearchInfoState extends State<_ListSearchInfo> {
  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  Future<List<Widget>> _generateItems() async {
    List<Widget> tmp = List.empty(growable: true);
    List<ShopItem> items = await MainApi.getAllRecommendedPrices();
    items = items
        .where((element) => element.name!
            .toLowerCase()
            .contains(widget.ctrl.text.toLowerCase()))
        .toList();
    for (var i = 0; i < items.length; i++) {
      tmp.add(Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
                child: Text(
              items[i].name!,
              style: TextStyle(fontSize: 18),
            )),
            SizedBox(
              width: 50,
            ),
            Text(
              format(items[i].recommendedPrice!) + " ₽",
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ));
    }
    return Future.delayed(Duration(seconds: 0), () => tmp);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _generateItems(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: snapshot.data!,
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class _HeaderCommonPage extends StatefulWidget {
  _HeaderCommonPage(
      {super.key, required this.func, required this.ctrl, required this.func2});
  final Function func;
  final TextEditingController ctrl;
  final Function func2;

  @override
  State<_HeaderCommonPage> createState() => __HeaderCommonPageState();
}

class __HeaderCommonPageState extends State<_HeaderCommonPage> {
  @override
  Widget build(BuildContext context) {
    String textValue;
    final userStorage = Provider.of<UserStorage>(context, listen: true);
    return Container(
      padding: EdgeInsets.only(right: 10),
      width: double.infinity,
      child: Row(children: [
        IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        SizedBox(
          width: 5,
        ),
        Expanded(
            child: SizedBox(
          height: 40,
          child: Focus(
            onFocusChange: (p) {
              widget.func();
              widget.ctrl.text = "";
            },
            child: TextFormField(
              onChanged: (v) => widget.func2(),
              controller: widget.ctrl,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Введите название товара'),
            ),
          ),
        )),
        SizedBox(
          width: 10,
        ),
        if (userStorage.hasData)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(userStorage.user!.photo)),
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: ColorsApp.firstColor),
          )
        else
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: ColorsApp.firstColor),
          )
      ]),
    );
  }
}

class _AddNewRequest extends StatefulWidget {
  const _AddNewRequest({super.key});

  @override
  State<_AddNewRequest> createState() => __AddNewRequestState();
}

class __AddNewRequestState extends State<_AddNewRequest> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
            color: ColorsApp.secondColor,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "За эту неделю исправлено",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
                Expanded(
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "11",
                      style: TextStyle(
                          fontSize: 58,
                          fontWeight: FontWeight.bold,
                          color: ColorsApp.fifthColor),
                    ),
                    Text(
                      " заявок",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ListRecommendedPrices extends StatefulWidget {
  const _ListRecommendedPrices({super.key});

  @override
  State<_ListRecommendedPrices> createState() => __ListRecommendedPricesState();
}

class __ListRecommendedPricesState extends State<_ListRecommendedPrices> {
  Future<List<Widget>> _generateItems() async {
    List<Widget> tmp = List.empty(growable: true);
    List<ShopItem> items = await MainApi.getAllRecommendedPrices();
    for (var i = 0; i < items.length; i++) {
      tmp.add(_CardItem(item: items[i]));
    }
    return Future.delayed(Duration(seconds: 0), () => tmp);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Рекомендованные цены",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 13,
          ),
          FutureBuilder(
              future: _generateItems(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: snapshot.data!,
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }
}

class _CardItem extends StatefulWidget {
  const _CardItem({super.key, required this.item});
  final ShopItem item;
  @override
  State<_CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<_CardItem> {
  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 125,
                width: 125,
                child: Image(image: NetworkImage(widget.item.imageURL!)),
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 3,
                      color: Colors.black26)
                ]),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '${format(widget.item.recommendedPrice!)} ₽',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
