import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
final  arr = [1, 1, 1, 1, 1, 1];
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
          title: new Text(title),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return new Container(
        width: 400,
        height: 400,
        child: new Column(
          children: <Widget>[
            new SwitchYinAndYangRoute(5),
            new SwitchYinAndYangRoute(4),
            new SwitchYinAndYangRoute(3),
            new SwitchYinAndYangRoute(2),
            new SwitchYinAndYangRoute(1),
            new SwitchYinAndYangRoute(0),
            new StateText(),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ));
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
    return new Column(
      children: <Widget>[
        RaisedButton(
          child: Text('卦序:'),
          onPressed: () => onPress(),
        ),
        Text(index)
      ],
    );
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
        new SwitchAndCheckBoxTestRoute(),
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
  bool _active = false;
  var yinYang;

  _TabpbosAState(i) {
    yinYang = i;
  }

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
    arr[yinYang] = _active ? 0 : 1;
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
                    _active ? '阴' : '阳',
                    style: new TextStyle(
                        fontSize: 16.0,
                        color: _active ? Colors.white : Colors.black),
                  ),
                ),
                width: 50.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  color: _active ? Colors.black : Colors.white,
                )),
            !_active
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: new Container(
                        width: 168, height: 10, color: Colors.black))
                : new Row(
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
                  )
          ],
        ));
  }
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
