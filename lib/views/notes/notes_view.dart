import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_actions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/dialogs/show_logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userId => AuthService.firebase().currentUser!.id;
  late final FirebaseCloudStorage _notesService;
  int currentPageIndex = 0;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: const Row(
          children: [
            Image(image: ExactAssetImage('asset/icons/my_notes.png', scale: 5)),
            Text(
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                " MyNotes"),
          ],
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
          //   },
          //   icon: const Icon(Icons.add),
          // ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (_) => false,
                      );
                    }
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Row(
                    children: [
                      Icon(Icons.logout_outlined),
                      Text("Log out"),
                    ],
                  ),
                ),
              ];
            },
          )
        ],
      ),
      body: <Widget?>[
        StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  if (allNotes.isEmpty) {
                    return Scaffold(
                      floatingActionButton: FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(createOrUpdateNoteRoute);
                        },
                        icon: const Icon(Icons.add_outlined),
                        label: const Text(
                          "Create your first note",
                        ),
                      ),
                      body: const Icon(
                        Icons.notes_rounded,
                        size: 200,
                      ),
                    );
                  } else {
                    return Scaffold(
                      appBar: AppBar(
                        centerTitle: false,
                        title: Text(
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                            "Your Notes"),
                      ),
                      body: NotesListView(
                        notes: allNotes,
                        onDeleteNote: (note) async {
                          await _notesService.deleteNote(
                              documentId: note.documentId);
                        },
                        onTap: (note) {
                          Navigator.of(context).pushNamed(
                            createOrUpdateNoteRoute,
                            arguments: note,
                          );
                        },
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(createOrUpdateNoteRoute);
                        },
                        child: const Icon(Icons.add_outlined),
                      ),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
                "Settings"),
          ),
          body: const Center(child: Text('Implementation Soon...')),
        )
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.sticky_note_2),
            icon: Icon(Icons.sticky_note_2_outlined),
            label: 'Notes',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
