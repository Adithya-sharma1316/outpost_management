import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const staffpage());
}

class staffpage extends StatelessWidget {
  const staffpage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: staff(),
    );
  }
}

class staff extends StatefulWidget {
  const staff({super.key});
  @override
  State<staff> createState() => _staffState();
}

class _staffState extends State<staff> {
  final notestream = Supabase.instance.client
      .from('staff_details')
      .stream(primaryKey: ['staff_id']);

  Future<void> createnote(String name) async {
    await Supabase.instance.client
        .from('staff_details')
        .insert({'staff_name': name});
  }

  Future<void> updatenote(String id, String upname) async {
    await Supabase.instance.client
        .from('staff_details')
        .update({'staff_name': upname}).eq('staff_id', id);
  }

  Future<void> deletenote(String id) async {
    await Supabase.instance.client
        .from('staff_details')
        .delete()
        .eq('staff_id', id);
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
          final staff_details = snapshot.data!;
          return ListView.builder(
              itemCount: staff_details.length,
              itemBuilder: (context, index) {
                final notee = staff_details[index];
                final nid = notee['staff_id'];
                return ListTile(
                  title: Text(notee['staff_name']),
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
                                    initialValue: notee['staff_id'],
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
