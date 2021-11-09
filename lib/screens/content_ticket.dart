
import 'package:PesenSayur/dialogs/ticket.dart';
import 'package:PesenSayur/models/api.dart';
import 'package:PesenSayur/models/ticket.dart';
import 'package:PesenSayur/screens/content_ticket_detail.dart';
import 'package:PesenSayur/util/global.dart';
import 'package:flutter/material.dart';
import 'package:PesenSayur/util/const.dart';

class ContentTicket extends StatefulWidget {

  const ContentTicket({Key key})
      : super(key: key);

  @override
  _ContentTicketState createState() => _ContentTicketState();
}

class _ContentTicketState extends State<ContentTicket> {
  int totalTransaction = 0;
  List<Ticket> _ticket = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      select();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.lightNavbarBG,
        title: Text(
          "Ticket",
          style: TextStyle(color: Constants.lightAccent),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                select();
              },
              child: Icon(Icons.sync))
        ],
      ),
      body: SafeArea(
          child: Column(
            children: [
              if (Global.getShared(key: Prefs.PREFS_USER_TYPE) == "3")...[
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 10, bottom: 5),
                    decoration: BoxDecoration(
                      color: Constants.darkAccent,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(15),
                        right: Radius.circular(15),
                      ),
                    ),
                    child: IconButton(
                        icon: Icon(Icons.add, color: Colors.white, size: 20),
                        onPressed: () {
                          TicketDialog.show(context: context, action: (result, title, text){
                            if(result){
                              create(title, text);
                            }
                          });
                        }),
                  ),
                ),
              ],
              if (_ticket.length > 0) ...[
                ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _ticket.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          onTap: () {
                            Global.materialNavigate(context, ContentTicketDetail(ticket: _ticket[index]))
                            .then((value) => select());
                          },
                          title: Text(
                            _ticket[index].title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    if (Global.getShared(key: Prefs.PREFS_USER_TYPE) == "2")...[
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(child: Text(_ticket[index].customer)),
                                        ],
                                      ),
                                    ],
                                    Row(
                                      children: [
                                        Expanded(child: Text(Global.formatDate(date: _ticket[index].date, outputPattern: Global.DATETIME_SHOW_DATE))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if(_ticket[index].status == "1") ...[
                                Icon(Icons.check, color: Colors.green)
                              ]
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ] 
              else ...[
                SizedBox(height: 80),
                Center(
                  child: Image.asset(
                    'assets/file-storage.png',
                    width: 100.0,
                    fit: BoxFit.cover,
                  ),
                )
              ]
            ],
          )),
    );
  }

  Future<void> select() async {
    _ticket = [];
    if (Global.getShared(key: Prefs.PREFS_USER_TYPE) == "2"){
      final response = API.fromJson(await Ticket.select(context: context));
      if (response.success) {
        response.data.forEach((data) {
          Ticket ticket = Ticket.fromJson(data);
          _ticket.add(ticket);
        });
      }
    }
    else{
      final response = API.fromJson(await Ticket.selectReseller(context: context));
      if (response.success) {
        response.data.forEach((data) {
          Ticket ticket = Ticket.fromJson(data);
          _ticket.add(ticket);
        });
      }
    }

    setState(() {});
  }

  Future<void> create(String title, String text) async {
    final response = API.fromJson(await Ticket.create(context: context, title: title, text: text));
    if (response.success) {
      select();
    }
  }
}
