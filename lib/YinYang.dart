import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yinyangji/EventBus.dart';

var arr = [1, 1, 1, 1, 1, 1];
var invisible = [true, true, true, true, true, true];
var _active = [false, false, false, false, false, false];

class YinYang extends StatelessWidget {
  const YinYang({
    Key key,
    @required this.title,
    this.backgroundColor: Colors.grey,
  }) : super(key: key);
  final Color backgroundColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
//centerTitle: new Text("阴阳记"),
          title: new Text("阴阳记"),
          actions: <Widget>[
            new GestureDetector(
                //按钮点击时分发通知
                onTap: () => onpress(),
                child: new Container(
                  padding: EdgeInsets.only(top: 15,right: 10),
                  child: new Text("重置"),
                ))
          ],
//          actions: <Widget>[
//            new Container(
//                alignment: Alignment.centerRight,
//                child: ),
//          ],
        ),
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    var switchYinAndYangRoute = new SwitchYinAndYangRoute(0);
    return new Container(
        padding: const EdgeInsets.only(left: 50.0),
        width: 400,
        height: 400,
        child: new Column(
          children: <Widget>[
            new SwitchYinAndYangRoute(5),
            new SwitchYinAndYangRoute(4),
            new SwitchYinAndYangRoute(3),
            new SwitchYinAndYangRoute(2),
            new SwitchYinAndYangRoute(1),
            switchYinAndYangRoute,
            new StateText(),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ));
  }

  onpress() {
    bus.emit("reset", "reset");
  }
}

class StateText extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StateText();
}

class _StateText extends State<StateText> {
  var index = "";

  onPress() {
    String num = "";
    for (var i in arr) {
      num += i.toString();
    }
    int s = int.parse(
      num,
      radix: 2,
    );
    loadAsset().then((String value) {
      List items = json.decode(value);
      for (Map map in items) {
        if (map["id"] == s) {
          setState(() {
            index =
                "第" + (map["index"] + 1).toString() + "卦" + ":" + map["name"];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        alignment: Alignment.center, //居中
        child: new Row(
          children: <Widget>[
            Expanded(
                child: new Container(
              alignment: Alignment.center,
              child: RaisedButton(
                child: Text('卦序:'),
                onPressed: () => onPress(),
              ),
            )),
            Expanded(
                child: new Container(
              alignment: Alignment.center,
              child: Text(index),
            )),
          ],
        ));
  }
}

class SwitchAndCheckBoxTestRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SwitchAndCheckBoxTestRouteState();
}

class SwitchYinAndYangRoute extends StatefulWidget {
  var yinYang;

  SwitchYinAndYangRoute(int i) {
    yinYang = i;
  }

  @override
  State<StatefulWidget> createState() => new _SwitchYinAndYangState(yinYang);
}

class _SwitchYinAndYangState extends State<SwitchYinAndYangRoute> {
  var yinYang;

  _SwitchYinAndYangState(i) {
    yinYang = i;
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new SwitchAndCheckBoxTestRoute(),
        new TapboxA(yinYang),

//        new SwitchAndCheckBoxTestRoute(),
      ],
    );
  }
}

class _SwitchAndCheckBoxTestRouteState
    extends State<SwitchAndCheckBoxTestRoute> {
  bool _checkboxSelected = false; //维护复选开关状态
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Checkbox(
          value: _checkboxSelected,
          activeColor: Colors.black,
          onChanged: (value) {
            setState(() {
              _checkboxSelected = value;
            });
          },
        )
      ],
    );
  }
}

class TapboxA extends StatefulWidget {
  var yinYang;

  TapboxA(i) {
    yinYang = i;
  }

  @override
  _TabpbosAState createState() => new _TabpbosAState(yinYang);
}

///内部管理自身State
class _TabpbosAState extends State<TapboxA> {
//  bool _active = false;
//  bool _visible;

  var yinYang;
  var index;

  _TabpbosAState(i) {
    yinYang = i;
    index = i;
    bus.on("reset", (arg) {
      setState(() {
        arr = [1, 1, 1, 1, 1, 1];
        invisible = [true, true, true, true, true, true];
        _active = [false, false, false, false, false, false];
        ;
      });
    });
//     invisible[i];
  }

  void _handleTap() {
    setState(() {
      _active[index] = !_active[index];
      invisible[index] = false;
    });
    arr[yinYang] = _active[index] ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: _handleTap,
//        ConstrainedBox
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Container(
                child: new Center(
                  child: new Text(
                    _active[index] ? '阴' : '阳',
                    style: new TextStyle(
                        fontSize: 16.0,
                        color: _active[index] ? Colors.white : Colors.black),
                  ),
                ),
                width: 50.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  color: _active[index] ? Colors.black : Colors.white,
                )),
            !_active[index]
                ? Padding(
                    //长横
                    padding: const EdgeInsets.only(left: 8.0),
                    child: new Offstage(
                        offstage: invisible[index],
                        child: new Container(
                            width: 168, height: 10, color: Colors.black)))
                : new Offstage(
                    offstage: invisible[index],
                    child: new Row(
                      //断横
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: new Container(
                                width: 80, height: 10, color: Colors.black)),
                        Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: new Container(
                                width: 80, height: 10, color: Colors.black)),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ),
//            new RaisedButton( child: Text('重置'),
//              onPressed: () => onReset(),)
          ],
        ));
  }

//  void reset() {
//    setState(() {
//
//    });
//  }
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('assetes/config.json');
}

class GBean {
  final int id;
  final int index;
  final String name;

  GBean({this.id, this.index, this.name});

  factory GBean.fromJson(Map<String, dynamic> json) {
    return GBean(
      id: json['id'],
      index: json['index'],
      name: json['name'],
    );
  }
}

class MyNotification extends Notification {
  MyNotification(this.msg);

  final String msg;
}
