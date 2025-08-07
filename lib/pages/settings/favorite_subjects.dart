import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/subjects_providers.dart';
import '../../providers/user_provider.dart';

final userDataProvider = StreamProvider<Map?>((ref) {
  final userStream = ref.watch(userProvider);
  final currentUser = userStream.value;

  if (currentUser != null) {
    final docRef = FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);
    return docRef.snapshots().map((doc) => doc.data());
  }
  return Stream.empty();
});

class FavoriteSubjectsSettingsPage extends ConsumerStatefulWidget {
  const FavoriteSubjectsSettingsPage({super.key});

  @override
  ConsumerState<FavoriteSubjectsSettingsPage> createState() =>
      _FavoriteSubjectsSettingsPageState();
}

class _FavoriteSubjectsSettingsPageState
    extends ConsumerState<FavoriteSubjectsSettingsPage> {
  Set<String> _favoriteSubjects = {};
  Set<String> _initialFavoriteSubjects = {};
  bool _hasChanges = false;

  late final ProviderSubscription<AsyncValue<Map?>> _subscription;

  @override
  void initState() {
    super.initState();

    // Manually read the current value once
    final initialUserData = ref.read(userDataProvider);
    if (initialUserData is AsyncData<Map?> && _initialFavoriteSubjects.isEmpty) {
      final userData = initialUserData.value;
      if (userData != null && userData['favorite_subjects'] is List) {
        final favorites = (userData['favorite_subjects'] as List)
            .whereType<String>()
            .toSet();

        _initialFavoriteSubjects = Set.from(favorites);
        _favoriteSubjects = Set.from(favorites);
      }
    }

    // Still listen for future updates
    _subscription = ref.listenManual<AsyncValue<Map?>>(
      userDataProvider,
          (previous, next) {
        if (next is AsyncData<Map?> && _initialFavoriteSubjects.isEmpty) {
          final userData = next.value;
          if (userData != null && userData['favorite_subjects'] is List) {
            final favorites = (userData['favorite_subjects'] as List)
                .whereType<String>()
                .toSet();

            setState(() {
              _initialFavoriteSubjects = Set.from(favorites);
              _favoriteSubjects = Set.from(favorites);
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription.close(); // Correct way to clean up
    super.dispose();
  }


  void _updateFavoriteSubjects(Set<String> newFavorites) {
    final changed = newFavorites.length != _initialFavoriteSubjects.length ||
        !newFavorites.containsAll(_initialFavoriteSubjects);

    setState(() {
      _favoriteSubjects = newFavorites;
      _hasChanges = changed;
    });
  }

  Future<void> _savePreferences() async {
    final updater = ref.read(updateFavoriteSubjectsProvider);
    try {
      await updater.updateFavorites(_favoriteSubjects.toList());

      setState(() {
        _initialFavoriteSubjects = Set.from(_favoriteSubjects);
        _hasChanges = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preferences saved')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving preferences: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDataAsync = ref.watch(userDataProvider);
    final subjects = ref.watch(subjectsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Subjects')),
      body: userDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (userData) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _favoriteSubjects.isEmpty
                    ? const Text('No favorite subjects selected.')
                    : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _favoriteSubjects.map((subject) {
                    return Chip(
                      label: Text(subject),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        final newFavorites =
                        Set<String>.from(_favoriteSubjects);
                        newFavorites.remove(subject);
                        _updateFavoriteSubjects(newFavorites);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  'Add More Subjects:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      final isSelected = _favoriteSubjects.contains(subject);

                      return ListTile(
                        title: Text(subject),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.green)
                            : IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            final newFavorites =
                            Set<String>.from(_favoriteSubjects);
                            newFavorites.add(subject);
                            _updateFavoriteSubjects(newFavorites);
                          },
                        ),
                        onTap: () {
                          final newFavorites =
                          Set<String>.from(_favoriteSubjects);
                          if (isSelected) {
                            newFavorites.remove(subject);
                          } else {
                            newFavorites.add(subject);
                          }
                          _updateFavoriteSubjects(newFavorites);
                        },
                      );
                    },
                  ),
                ),
                if (_hasChanges)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          textStyle: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _savePreferences,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'Save Preferences',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}