import 'package:flutter/material.dart';
import 'package:localnewsapp/dataAccess/model/users.dart';
import 'package:localnewsapp/dataAccess/users_repo.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Users> _blockedUsers = [];
  List<Users> _filteredUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBlockedUsers();
  }

  Future<void> _loadBlockedUsers() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final usersRepo = UsersRepo();
      _blockedUsers = await usersRepo.getBlockedUsers();
      _filteredUsers = List.from(_blockedUsers);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading blocked users: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _blockedUsers.where((user) {
        return user.fullName.toLowerCase().contains(query.toLowerCase()) ||
               user.phonenumber.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _unblockUser(Users user) async {
    try {
      final usersRepo = UsersRepo();
      await usersRepo.unblockUser(user.userID!);
      
      setState(() {
        _blockedUsers.remove(user);
        _filteredUsers.remove(user);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User unblocked successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error unblocking user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: UserSearchDelegate(_blockedUsers),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredUsers.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.block, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No blocked users',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = _filteredUsers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.profileImagePath ?? ''),
                          child: user.profileImagePath == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(user.fullName),
                        subtitle: Text(user.email),
                        trailing: IconButton(
                          icon: const Icon(Icons.block, color: Colors.red),
                          onPressed: () => _unblockUser(user),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class UserSearchDelegate extends SearchDelegate {
  final List<Users> _allUsers;

  UserSearchDelegate(this._allUsers);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _allUsers.where((user) {
      return user.fullName.toLowerCase().contains(query.toLowerCase()) ||
             user.phonenumber.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final user = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.profileImagePath ?? ''),
            child: user.profileImagePath == null
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(user.fullName),
          subtitle: Text(user.phonenumber),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? _allUsers
        : _allUsers.where((user) {
            return user.fullName.toLowerCase().startsWith(query.toLowerCase()) ||
                   user.phonenumber.toLowerCase().startsWith(query.toLowerCase());
          }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final user = suggestions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.profileImagePath ?? ''),
            child: user.profileImagePath == null
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(user.fullName),
          subtitle: Text(user.email),
        );
      },
    );
  }
}
