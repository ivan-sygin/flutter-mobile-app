import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sochi/classes/request.dart';
import 'package:sochi/colors/colors.dart';
import 'package:sochi/pages/create_request_pages/controller_start.dart';
import 'package:sochi/pages/create_request_pages/first_info_page.dart';
import 'package:sochi/pages/create_request_pages/select_create_request.dart';
import 'package:sochi/storages/requests_storage.dart';
import 'package:sochi/storages/user_storage.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: ControllerOrClient()),
    );
  }
}

class ControllerOrClient extends StatefulWidget {
  const ControllerOrClient({super.key});

  @override
  State<ControllerOrClient> createState() => _ControllerOrClientState();
}

class _ControllerOrClientState extends State<ControllerOrClient> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserStorage>(context, listen: true);
    if (userProvider.hasData) if (userProvider.user!.role == 'client')
      return _ClientVersion();
    else
      return _ControllerVersion();
    else
      return CircularProgressIndicator();
  }
}

class _ClientVersion extends StatefulWidget {
  const _ClientVersion({super.key});

  @override
  State<_ClientVersion> createState() => __ClientVersionState();
}

class __ClientVersionState extends State<_ClientVersion> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(children: [
          _CreateNewRequestButton(),
          SizedBox(
            height: 10,
          ),
          _ListRequests()
        ]),
      ),
    );
  }
}

class _ListRequests extends StatefulWidget {
  const _ListRequests({super.key});

  @override
  State<_ListRequests> createState() => __ListRequestsState();
}

class __ListRequestsState extends State<_ListRequests> {
  List<Widget> generateRequestsBlock(RequestStorage strg) {
    List<Widget> res = List.empty(growable: true);
    Map<int, RequestClass> tmp = strg.requests;
    for (var i = 0; i < tmp.length; i++) {
      res.add(_RequestBlock(rcs: tmp.values.elementAt(i)));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final requestsStorage = Provider.of<RequestStorage>(context);
    return Column(
      children: generateRequestsBlock(requestsStorage),
    );
  }
}

class _RequestBlock extends StatefulWidget {
  const _RequestBlock({super.key, required this.rcs});
  final RequestClass rcs;
  @override
  State<_RequestBlock> createState() => __RequestBlockState();
}

class __RequestBlockState extends State<_RequestBlock> {
  String format(double n) {
    return n.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorsApp.secondColor, borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    widget.rcs.itemCategory!,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  format(widget.rcs.pricerInfo!) + " ₽",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 244, 244, 244)),
                ),
              ],
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.rcs.shopName!,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        format(widget.rcs.itemRecommendedPrice!) + " ₽",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 201, 223, 177)),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CreateNewRequestButton extends StatelessWidget {
  const _CreateNewRequestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SelectedCreateRequest()));
      },
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
            color: ColorsApp.fourthColor,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_box,
                color: Colors.white,
                size: 48,
              ),
              Text(
                "Создать заявку",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ControllerVersion extends StatefulWidget {
  const _ControllerVersion({super.key});

  @override
  State<_ControllerVersion> createState() => __ControllerVersionState();
}

class __ControllerVersionState extends State<_ControllerVersion> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RefreshIndicator(
        onRefresh: () async {
          final reqStorage =
              Provider.of<RequestStorage>(context, listen: false);
          reqStorage.loadRequestsFromServer();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(children: [_ListRequestsAll()]),
        ),
      ),
    );
  }
}

class _ListRequestsAll extends StatefulWidget {
  const _ListRequestsAll({super.key});

  @override
  State<_ListRequestsAll> createState() => __ListRequestsAllState();
}

class __ListRequestsAllState extends State<_ListRequestsAll> {
  List<Widget> generateRequestsBlock(RequestStorage strg) {
    List<Widget> res = List.empty(growable: true);
    Map<int, RequestClass> tmp = strg.requests;
    for (var i = 0; i < tmp.length; i++) {
      res.add(GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ControllerStartPage(
                          rqcls: tmp.values.elementAt(i),
                        )));
          },
          child: _RequestBlock(rcs: tmp.values.elementAt(i))));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final requestsStorage = Provider.of<RequestStorage>(context);
    return Column(
      children: generateRequestsBlock(requestsStorage),
    );
  }
}
