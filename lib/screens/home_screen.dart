import 'package:flutter/material.dart';
import 'package:flutter_sql_user/sql_modal/sql_modal.dart';
import 'package:flutter_sql_user/sql_modal/users.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

Future<List<Users>> allUsers() async {
  var liste = await SqlAccess().allUser();
  return liste;
}

Future<void> addUser(String name) async {
  await SqlAccess().addUser(name);
  print("complate insert");
}

var controller = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.red,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 30.0),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 400.0,
                color: Colors.white,
                child: FutureBuilder<List<Users>>(
                  future: allUsers(),
                  builder: (context, data) {
                    if (data.hasData) {
                      var user = data.data;
                      return ListView.builder(
                        itemCount: user.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Text(
                              data.data[index].user_name,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Container(
                        color: Colors.red,
                        child: Center(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: 200.0,
                child: TextField(controller: controller),
              ),
              SizedBox(
                height: 30.0,
              ),
              Center(
                child: MaterialButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Add User"),
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      print("It can't be null");
                    } else {
                      setState(() {
                        addUser(controller.text);
                      });
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
