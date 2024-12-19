import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class todofire extends StatefulWidget {
  const todofire({super.key});

  @override
  State<todofire> createState() => _todofireState();
}

class _todofireState extends State<todofire> {
  late CollectionReference _userCollection;

  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  void initState() {
    _userCollection = FirebaseFirestore.instance.collection("users");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("todo list"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userId = user.id;
              final userName = user["name"];
              final userDetails = user["details"];

              return ListTile(
                title: Text(
                  '$userName',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "$userDetails",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Wrap(
                  children: [
                    IconButton(onPressed: (){
                      nameController.text=userName;
                      detailsController.text=userDetails;
                      editUserData(userId);

                    },
                        icon: Icon(Icons.edit)),
                    IconButton(onPressed: (){
                      deleteUser(userId );
                    },
                        icon: Icon(Icons.delete))
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: Icon(Icons.add),
      ),
    );
  }
  void showForm() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 7,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: detailsController,
                  decoration: InputDecoration(
                    hintText: "details",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await addUserToDB(
                      nameController.text.trim(),
                      detailsController.text.trim(),
                    );
                  },
                  child: Text("Add User"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> addUserToDB(String name, String details) async {
    if (name.isNotEmpty && details.isNotEmpty) {
      await _userCollection.add({'name': name, 'details': details}).then((value) {
        print("User added successfully");
        nameController.clear();
        detailsController.clear();
        Navigator.of(context).pop();
      }).catchError((error) {
        print("Failed to add data: $error");
      });
    } else {
      print("Please enter both name and email.");
    }
  }

  Stream<QuerySnapshot> readUser() {
    return _userCollection.snapshots();
  }

  var  uname=TextEditingController();
  var uemail=TextEditingController();

  void editUserData(String userId){

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context){
          return Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 15,
              left: 15,
              right: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20,),

                TextFormField(
                  controller: uname,
                  decoration: InputDecoration(
                      hintText: "uname",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
                SizedBox(height: 20,),

                TextFormField(
                  controller: uemail,
                  decoration: InputDecoration(
                      hintText: "uemail",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
                SizedBox(height: 20,),

                ElevatedButton(onPressed: (){
                  updateUser(userId,uname.text,uemail.text);
                  uname.clear();
                  uemail.clear();
                },
                    child: Text("update user"))
              ],
            ),
          );

        });
  }
  Future<void> updateUser(String userId, String uname, String uemail) async {
    var updatedvalues = {"name": uname, "email": uemail};
    return _userCollection.doc(userId).update(updatedvalues).then((value) {
      Navigator.of(context).pop();
      print("userdata updated succesfully");
    }).catchError((error) {
      print("userdata updation failed");
    });
  }
  Future<void> deleteUser( var id) async {
    return _userCollection.doc(id).delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User deleted successfully")),
      );
    }).catchError((error) {
      print("User deletion failed: $error");
    });
  }
}