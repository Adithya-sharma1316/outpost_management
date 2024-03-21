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
      home: vehicle(),
    );
  }
}

class vehicle extends StatefulWidget {
  const vehicle({super.key});
  @override
  State<vehicle> createState() => _vehicleState();
}

class _vehicleState extends State<vehicle> {
  final notestream = Supabase.instance.client
      .from('vehicle_details')
      .stream(primaryKey: ['reg_num']);

  Future<void> updatenote(String id, String upname) async {
    await Supabase.instance.client
        .from('vehicle_details')
        .update({'reg_num': upname}).eq('reg_num', id);
  }

  Future<void> deletenote(String id) async {
    await Supabase.instance.client
        .from('vehicle_details')
        .delete()
        .eq('reg_num', id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle entry'),
      ),
      body: StreamBuilder(
        stream: notestream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final vehicle_details = snapshot.data!;
          return ListView.builder(
              itemCount: vehicle_details.length,
              itemBuilder: (context, index) {
                final notee = vehicle_details[index];
                final nid = notee['reg_num'];
                return ListTile(
                  title: Text(notee['reg_num']),
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
                                    initialValue: notee['reg_num'],
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
