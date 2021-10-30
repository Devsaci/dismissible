import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MyApp is a StatefulWidget. This allows updating the state of the
// widget when an item is removed.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    const title = 'Dismissing Items';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Dismissible(
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify widgets.
              key: Key(item),
              // Provide a function that tells the app
              // what to do after an item has been swiped away.
              onDismissed: (DismissDirection direction) {
                // Remove the item from the data source.
                setState(() {
                  items.removeAt(index);
                });
                // Then show a snackbar.
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(direction == DismissDirection.startToEnd
                      ? '$item dismissed'
                      : '$item liked'),
                  action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        setState(() {
                          items.insert(index, item);
                        });
                      }),
                ));
              },
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  final bool res =
                      await showDialog(context: context, builder: (context) {
                        return AlertDialog(
                            content: Text("Are You Sure You Want to delete $item ? "),
                          actions: [
                            FlatButton(onPressed: (){}, child: Text("Cancel")),
                            FlatButton(onPressed: (){}, child: Text("Delete")),
                          ],
                        );
                      });
                  return res;
                } else {
                  return true;
                }
              },
              // Show a red background as the item is swiped away.
              child: ListTile(title: Center(child: Text(item))),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    SizedBox(
                      width: 50,
                    ),
                    Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
              secondaryBackground: Container(
                color: Colors.yellow,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    SizedBox(
                      width: 50,
                    ),
                    Icon(
                      Icons.camera,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Liked",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
