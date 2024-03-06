import 'package:crud/services/firebase_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
          child: Text(
            'Firebase Crud',
            style: TextStyle(color: Colors.white),
          ),
        ) 
      ),
      body: FutureBuilder(
        future: getPeople(), 
        builder: ((context, snapshot){
          if (snapshot.hasData){
            return Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index){
                  return Dismissible(
                    onDismissed: (direction) async {
                      await deletePeople(snapshot.data?[index]['uid']);
                      snapshot.data?.removeAt(index);
                    },
                    confirmDismiss: (direction) async {
                      bool result = false;
                      result = await showDialog(
                        context: context, 
                        builder: (context){
                        return AlertDialog(
                          title: Text("Are you sure you want to eliminate ${snapshot.data?[index]['name']} ?"),
                          actions: [
                            TextButton(
                              onPressed: (){
                                return Navigator.pop(
                                  context,
                                  false
                                );
                              }, 
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.red),  
                              )
                            ),
                            TextButton(
                              onPressed: (){
                                return Navigator.pop(
                                  context,
                                  true
                                );
                              }, 
                              child: const Text('Confirm')
                            ),
                          ],
                        );
                        }
                      );
                      return result;
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    key: Key(snapshot.data?[index]['uid']),
                    child: ListTile(
                      title: Text('${snapshot.data?[index]['name']} ${snapshot.data?[index]['surname']}'),
                      onTap: () async {
                        await Navigator.pushNamed(context, '/edit', arguments: {
                          'name':snapshot.data?[index]['name'],
                          'surname': snapshot.data?[index]['surname'],
                          'uid':snapshot.data?[index]['uid'],
                        });
                        setState(() {});
                      },
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        })
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          setState(() {});
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}