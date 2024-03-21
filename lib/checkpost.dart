import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: checkpost(),
    );
  }
}

class checkpost extends StatefulWidget {
  const checkpost({super.key});
  @override
  State<checkpost> createState() => _checkpostState();
}

class _checkpostState extends State<checkpost> {
  final notestream =
      Supabase.instance.client.from('checkpost').stream(primaryKey: ['chk_id']);

  Future<void> updatenote(String id, String upname) async {
    await Supabase.instance.client
        .from('checkpost')
        .update({'chk_id': upname}).eq('chk_id', id);
  }

  Future<void> deletenote(String id) async {
    await Supabase.instance.client.from('checkpost').delete().eq('chk_id', id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Details'),
      ),
      body: StreamBuilder(
        stream: notestream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final checkpost = snapshot.data!;
          return ListView.builder(
              itemCount: checkpost.length,
              itemBuilder: (context, index) {
                final notee = checkpost[index];
                final nid = notee['chk_id'];
                return ListTile(
                  title: Text(notee['chk_id']),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Text('Update or edit'),
                                children: [
                                  TextFormField(
                                    initialValue: notee['chk_location'],
                                    onFieldSubmitted: (value) async {
                                      await updatenote(nid, value);
                                      if (mounted) Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            });
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () async {
                        bool deleted = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete '),
                                content: Text('Are u sure'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                      child: Text('Cancel')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text('Delete')),
                                ],
                              );
                            });
                        if (deleted) {
                          await deletenote(nid);
                        }
                      },
                      icon: const Icon(Icons.delete_forever),
                    )
                  ]),
                );
              });
        },
      ),
    );
  }
}
