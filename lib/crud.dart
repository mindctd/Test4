import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remove_emoji_input_formatter/remove_emoji_input_formatter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CrudPage extends StatefulWidget {
  const CrudPage({super.key});

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  final PanelController _panelController = PanelController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool opening = false;

  late final User? user;
  late final String uid;
  late final DocumentReference userCarDoc;

  int? editingindex;
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    uid = user?.uid ?? 'unknown';
    userCarDoc = FirebaseFirestore.instance.collection('Car').doc(uid);
  }

  Future<void> addItems() async {
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    final newItem = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'createdAt': Timestamp.now(),
    };

    try {
      await userCarDoc.set({
        'items': FieldValue.arrayUnion([newItem])
      }, SetOptions(merge: true));

      _titleController.clear();
      _descriptionController.clear();
      _panelController.close();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding item: $e')),
      );
    }
  }

  Future<void> updateItems() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill all of field')));
      return;
    }
    try {
      final doc = await userCarDoc.get();
      final List items = List.from((doc.data() as Map)['items'] ?? []);
      items[editingindex!] = {
        "title": title,
        "description": description,
        "createdAt": Timestamp.now(),
      };
      await userCarDoc.update({'items': items});

      _titleController.clear();
      _descriptionController.clear();
      editingindex = null;
      _panelController.close();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating item: $e')));
    }
  }

  Future<void> deleteItems(Map<String, dynamic> item) async {
    try {
      await userCarDoc.update({
        'items': FieldValue.arrayRemove([item])
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Item deleted')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Fail delete : $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        minHeight: 0,
        maxHeight: 300,
        panel: builtPanel(isEdit: isEdit),
        onPanelOpened: () => setState(() => opening = true),
        onPanelClosed: () => setState(() => opening = false),
        body: StreamBuilder<DocumentSnapshot>(
          stream: userCarDoc.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No data found'));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final List items = data['items'] ?? [];

            items.sort((a, b) {
              final t1 =
                  (a['createdAt'] as Timestamp?)?.toDate() ?? DateTime(0);
              final t2 =
                  (b['createdAt'] as Timestamp?)?.toDate() ?? DateTime(0);
              return t1.compareTo(t2);
            });

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  color: Colors.purple[100],
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(item['title'] ?? ''),
                    subtitle: Text(item['description'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            editingindex = index;
                            _titleController.text = item['title'] ?? "";
                            _descriptionController.text =
                                item['description'] ?? "";
                            isEdit = true;
                            _panelController.open();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteItems(item);
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Visibility(
        visible: !opening,
        child: FloatingActionButton(
          onPressed: () => _panelController.open(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget builtPanel({required bool isEdit}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 60,
            child: TextField(
              inputFormatters: [
                RemoveEmojiInputFormatter(),
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9]'),
                ),
              ],
              controller: _titleController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: TextField(
              inputFormatters: [
                RemoveEmojiInputFormatter(),
                FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9]'),
                ),
              ],
              controller: _descriptionController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: "Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? updateItems : addItems,
            child: Text(isEdit ? "Update" : "Add Data"),
          ),
        ],
      ),
    );
  }
}
