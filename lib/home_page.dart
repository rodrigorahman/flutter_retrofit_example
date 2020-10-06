import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_retrofit_example/repositories/user_repository.dart';

import 'models/user_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repository = UserRepository(Dio());
  final nameEditingController = TextEditingController();
  final userNameEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => newUser(),
        child: Icon(Icons.person),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _repository.findAll(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            final users = snapshot.data;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  onTap: () => showDetails(user.id),
                  title: Text(user.name),
                  subtitle: Text(user.username),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }

  void showDetails(String id) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: FutureBuilder<UserModel>(
              future: _repository.findById(id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(height: 50, child: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  final user = snapshot.data;
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.username),
                  );
                }

                return Container();
              },
            ),
          );
        });
  }

   void newUser() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Container(
              height: 200,
              child: Form(
                child: Column(
                  children: [
                    TextFormField(controller: nameEditingController),
                    TextFormField(controller: userNameEditingController)
                  ],
                )
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  await _repository.save(UserModel(
                    name: nameEditingController.text,
                    username: userNameEditingController.text
                  ));
                  Navigator.pop(context);
                  setState((){});
                },
                child: Text('Salvar'),
              )
            ],
          );
        });
  }
}
