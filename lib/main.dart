import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const JournalApp());
}

class JournalApp extends StatelessWidget {
  const JournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class JournalEntry {
  JournalEntry({
    required this.id,
    required this.title,
    required this.note,
    required this.mood,
    required this.date,
  });

  final String id;
  String title;
  String note;
  String mood;
  DateTime date;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'note': note,
    'mood': mood,
    'date': date.toIso8601String(),
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'],
    title: json['title'],
    note: json['note'],
    mood: json['mood'],
    date: DateTime.parse(json['date']),
  );
}

class JournalStore {
  static const _key = 'journal_entries';

  static Future<List<JournalEntry>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    final list = jsonDecode(raw) as List;
    return list
        .map((item) => JournalEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<void> save(List<JournalEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(entries.map((entry) => entry.toJson()).toList()),
    );
  }
}

const moods = ['Happy', 'Calm', 'Neutral', 'Sad', 'Angry'];

Color moodColor(String mood) {
  switch (mood) {
    case 'Happy':
      return Colors.green;
    case 'Calm':
      return Colors.blue;
    case 'Neutral':
      return Colors.amber;
    case 'Sad':
      return Colors.indigo;
    case 'Angry':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

IconData moodIcon(String mood) {
  switch (mood) {
    case 'Happy':
      return Icons.sentiment_very_satisfied;
    case 'Calm':
      return Icons.self_improvement;
    case 'Neutral':
      return Icons.sentiment_neutral;
    case 'Sad':
      return Icons.sentiment_dissatisfied;
    case 'Angry':
      return Icons.mood_bad;
    default:
      return Icons.help_outline;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void login() {
    if (!formKey.currentState!.validate()) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(userEmail: emailController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.menu_book,
                        size: 72,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'My Journal',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: login,
                          child: const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<JournalEntry> entries = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final loaded = await JournalStore.load();
    loaded.sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      entries = loaded;
      loading = false;
    });
  }

  Future<void> _openEditor([JournalEntry? entry]) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddEditPage(existingEntry: entry)),
    );

    if (saved == true) await _loadEntries();
  }

  Future<void> _deleteEntry(JournalEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete entry?'),
        content: Text('Delete "${entry.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => entries.removeWhere((item) => item.id == entry.id));
    await JournalStore.save(entries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal — ${widget.userEmail}'),
        actions: [
          IconButton(
            tooltip: 'Mood analytics',
            icon: const Icon(Icons.insights),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MoodAnalyticsPage(entries: entries),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add),
        label: const Text('New entry'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : entries.isEmpty
          ? const Center(
              child: Text('No journal entries yet.\nTap “New entry”.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: moodColor(entry.mood)
                          .withValues(alpha: 0.2),
                      child: Icon(
                        moodIcon(entry.mood),
                        color: moodColor(entry.mood),
                      ),
                    ),
                    title: Text(entry.title),
                    subtitle: Text(
                      '${entry.date.toLocal().toString().split('.').first}\n'
                      '${entry.mood} • ${entry.note}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') _openEditor(entry);
                        if (value == 'delete') _deleteEntry(entry);
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                    onTap: () => _openEditor(entry),
                  ),
                );
              },
            ),
    );
  }
}

class AddEditPage extends StatefulWidget {
  const AddEditPage({super.key, this.existingEntry});

  final JournalEntry? existingEntry;

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  late final TextEditingController titleController;
  late final TextEditingController noteController;
  late String selectedMood;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
      text: widget.existingEntry?.title ?? '',
    );
    noteController = TextEditingController(
      text: widget.existingEntry?.note ?? '',
    );
    selectedMood = widget.existingEntry?.mood ?? 'Neutral';
  }

  Future<void> saveEntry() async {
    if (!formKey.currentState!.validate()) return;

    final entries = await JournalStore.load();

    if (widget.existingEntry == null) {
      entries.add(
        JournalEntry(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: titleController.text.trim(),
          note: noteController.text.trim(),
          mood: selectedMood,
          date: DateTime.now(),
        ),
      );
    } else {
      final index = entries.indexWhere(
        (item) => item.id == widget.existingEntry!.id,
      );
      if (index != -1) {
        entries[index].title = titleController.text.trim();
        entries[index].note = noteController.text.trim();
        entries[index].mood = selectedMood;
      }
    }

    await JournalStore.save(entries);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingEntry != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Entry' : 'Add Entry')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a title'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: noteController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'What happened today?',
                  alignLabelWithHint: true,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Write something'
                    : null,
              ),
              const SizedBox(height: 20),
              Text('Mood', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: moods.map((mood) {
                  final selected = mood == selectedMood;
                  return ChoiceChip(
                    label: Text(mood),
                    selected: selected,
                    avatar: Icon(
                      moodIcon(mood),
                      size: 18,
                      color: moodColor(mood),
                    ),
                    onSelected: (_) => setState(() => selectedMood = mood),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: saveEntry,
                icon: const Icon(Icons.save),
                label: Text(isEditing ? 'Update entry' : 'Save entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoodAnalyticsPage extends StatelessWidget {
  const MoodAnalyticsPage({super.key, required this.entries});

  final List<JournalEntry> entries;

  Map<String, int> moodCounts() {
    final counts = <String, int>{};
    for (final mood in moods) {
      counts[mood] = entries.where((entry) => entry.mood == mood).length;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final counts = moodCounts();
    final total = entries.length;
    final mostCommon = total == 0
        ? null
        : counts.entries
              .where((item) => item.value > 0)
              .reduce((a, b) => a.value >= b.value ? a : b);

    return Scaffold(
      appBar: AppBar(title: const Text('Mood Analytics')),
      body: total == 0
          ? const Center(child: Text('Add journal entries to see analytics.'))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total entries: $total',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Most common mood: ${mostCommon?.key ?? "None"}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...counts.entries.map((item) {
                  final percent = total == 0 ? 0.0 : item.value / total;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                moodIcon(item.key),
                                color: moodColor(item.key),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${item.key} — ${item.value} entries',
                                ),
                              ),
                              Text('${(percent * 100).toStringAsFixed(0)}%'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: percent,
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(8),
                            color: moodColor(item.key),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
