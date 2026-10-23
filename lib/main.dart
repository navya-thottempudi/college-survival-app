import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const CollegeSurvivalApp());
}

const Color appPurple = Color(0xFF6C4DFF);
const Color pageBackground = Color(0xFFF7F6FC);

class CollegeSurvivalApp extends StatelessWidget {
  const CollegeSurvivalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Survival',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pageBackground,
        colorScheme: ColorScheme.fromSeed(seedColor: appPurple),
        appBarTheme: const AppBarTheme(
          backgroundColor: pageBackground,
          foregroundColor: Color(0xFF25213A),
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

class TaskItem {
  TaskItem({
    required this.title,
    required this.subject,
    required this.dueDate,
    this.isExam = false,
    this.isDone = false,
  });

  String title;
  String subject;
  DateTime dueDate;
  bool isExam;
  bool isDone;
}

class SubjectAttendance {
  SubjectAttendance({
    required this.name,
    required this.attended,
    required this.total,
    required this.color,
  });

  String name;
  int attended;
  int total;
  Color color;

  double get percentage => total == 0 ? 0 : attended / total;
}

class StudentNote {
  StudentNote({required this.title, required this.subject, required this.body});

  String title;
  String subject;
  String body;
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  final List<TaskItem> tasks = [
    TaskItem(
      title: 'DBMS Assignment',
      subject: 'Database Management Systems',
      dueDate: DateTime.now().add(const Duration(days: 1)),
    ),
    TaskItem(
      title: 'Computer Networks Lab Record',
      subject: 'Computer Networks',
      dueDate: DateTime.now().add(const Duration(days: 3)),
    ),
    TaskItem(
      title: 'Operating Systems Mid Exam',
      subject: 'Operating Systems',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      isExam: true,
    ),
  ];

  final List<SubjectAttendance> attendance = [
    SubjectAttendance(
      name: 'Data Structures',
      attended: 27,
      total: 30,
      color: const Color(0xFF6C4DFF),
    ),
    SubjectAttendance(
      name: 'Database Systems',
      attended: 23,
      total: 28,
      color: const Color(0xFF159D83),
    ),
    SubjectAttendance(
      name: 'Computer Networks',
      attended: 18,
      total: 25,
      color: const Color(0xFFE99A36),
    ),
    SubjectAttendance(
      name: 'Operating Systems',
      attended: 21,
      total: 24,
      color: const Color(0xFFDA5C92),
    ),
  ];

  final List<StudentNote> notes = [
    StudentNote(
      title: 'DBMS Normalization',
      subject: 'Database Systems',
      body: '1NF: Atomic values.\n2NF: No partial dependency.\n3NF: No transitive dependency.',
    ),
    StudentNote(
      title: 'OS Quick Revision',
      subject: 'Operating Systems',
      body: 'Process scheduling, deadlocks, memory management, and paging.',
    ),
  ];

  final List<Map<String, String>> timetable = [
    {'day': 'Monday', 'time': '09:00 - 10:00', 'subject': 'Data Structures', 'room': 'Room 204'},
    {'day': 'Monday', 'time': '10:00 - 11:00', 'subject': 'Database Systems', 'room': 'Room 105'},
    {'day': 'Tuesday', 'time': '09:00 - 10:00', 'subject': 'Computer Networks', 'room': 'Lab 2'},
    {'day': 'Tuesday', 'time': '11:00 - 12:00', 'subject': 'Operating Systems', 'room': 'Room 204'},
    {'day': 'Wednesday', 'time': '10:00 - 11:00', 'subject': 'Data Structures Lab', 'room': 'Lab 1'},
    {'day': 'Thursday', 'time': '09:00 - 10:00', 'subject': 'Database Systems', 'room': 'Room 105'},
    {'day': 'Friday', 'time': '11:00 - 12:00', 'subject': 'Computer Networks', 'room': 'Room 204'},
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        tasks: tasks,
        attendance: attendance,
        onGoToTab: (index) => setState(() => selectedIndex = index),
      ),
      PlannerPage(tasks: tasks, onChanged: () => setState(() {})),
      AttendancePage(
        attendance: attendance,
        onChanged: () => setState(() {}),
      ),
      TimetablePage(timetable: timetable),
      NotesPage(notes: notes, onChanged: () => setState(() {})),
      const StudyTimerPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: appPurple.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school_rounded, color: appPurple),
            ),
            const SizedBox(width: 10),
            const Text(
              'College Survival',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.event_note_outlined), selectedIcon: Icon(Icons.event_note), label: 'Planner'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Attendance'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Timetable'),
          NavigationDestination(icon: Icon(Icons.sticky_note_2_outlined), selectedIcon: Icon(Icons.sticky_note_2), label: 'Notes'),
          NavigationDestination(icon: Icon(Icons.timer_outlined), selectedIcon: Icon(Icons.timer), label: 'Focus'),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.tasks,
    required this.attendance,
    required this.onGoToTab,
  });

  final List<TaskItem> tasks;
  final List<SubjectAttendance> attendance;
  final ValueChanged<int> onGoToTab;

  @override
  Widget build(BuildContext context) {
    final pending = tasks.where((task) => !task.isDone && !task.isExam).length;
    final average = attendance.isEmpty
        ? 0
        : attendance.fold<double>(0, (sum, item) => sum + item.percentage) /
            attendance.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
      children: [
        const Text(
          'YOUR COLLEGE PLANNER',
          style: TextStyle(
            color: appPurple,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Hey, student! 👋',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 5),
        Text(
          'A little progress every day adds up.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                icon: Icons.assignment_outlined,
                label: 'Pending tasks',
                value: '$pending',
                color: const Color(0xFFE99A36),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                icon: Icons.school_outlined,
                label: 'Avg. attendance',
                value: '${(average * 100).round()}%',
                color: const Color(0xFF159D83),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SectionHeading(
          title: 'Upcoming deadlines',
          action: 'View planner',
          onTap: () => onGoToTab(1),
        ),
        const SizedBox(height: 10),
        ...tasks.where((task) => !task.isDone).take(3).map(
              (task) => TaskCard(task: task, onToggle: null),
            ),
        if (tasks.every((task) => task.isDone))
          const EmptyMessage(message: 'All caught up! You have no pending tasks.'),
        const SizedBox(height: 18),
        SectionHeading(
          title: 'Attendance overview',
          action: 'View all',
          onTap: () => onGoToTab(2),
        ),
        const SizedBox(height: 10),
        ...attendance.take(3).map(
              (item) => AttendanceProgressCard(subject: item),
            ),
        const SizedBox(height: 18),
        Material(
          color: appPurple,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onGoToTab(5),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.play_arrow_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ready to focus?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Start a study session',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(height: 14),
          Text(value, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        ],
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.action,
    this.onTap,
  });

  final String title;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        ),
        if (action != null)
          TextButton(
            onPressed: onTap,
            child: Text(action!, style: const TextStyle(color: appPurple)),
          ),
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onToggle});

  final TaskItem task;
  final ValueChanged<bool?>? onToggle;

  @override
  Widget build(BuildContext context) {
    final days = task.dueDate.difference(DateTime.now()).inDays;
    final dueLabel = days < 0
        ? 'Overdue'
        : days == 0
            ? 'Today'
            : days == 1
                ? 'Tomorrow'
                : 'In $days days';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          if (onToggle != null)
            Checkbox(
              value: task.isDone,
              onChanged: onToggle,
              activeColor: appPurple,
            )
          else
            Container(
              width: 4,
              height: 42,
              decoration: BoxDecoration(
                color: task.isExam ? const Color(0xFFDA5C92) : appPurple,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(task.subject, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: task.isExam ? const Color(0xFFFCE7F3) : const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              task.isExam ? 'Exam\n$dueLabel' : dueLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: task.isExam ? const Color(0xFFBE185D) : appPurple,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key, required this.tasks, required this.onChanged});

  final List<TaskItem> tasks;
  final VoidCallback onChanged;

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  Future<void> addTask() async {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    DateTime dueDate = DateTime.now().add(const Duration(days: 1));
    bool isExam = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add a task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Task or exam name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(labelText: 'Subject'),
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('This is an exam'),
                  value: isExam,
                  onChanged: (value) => setDialogState(() => isExam = value ?? false),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_month),
                  label: Text('Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}'),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: dueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 730)),
                    );
                    if (picked != null) setDialogState(() => dueDate = picked);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );

    if (result == true && titleController.text.trim().isNotEmpty) {
      widget.tasks.add(
        TaskItem(
          title: titleController.text.trim(),
          subject: subjectController.text.trim().isEmpty
              ? 'General'
              : subjectController.text.trim(),
          dueDate: dueDate,
          isExam: isExam,
        ),
      );
      widget.tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      widget.onChanged();
    }
    titleController.dispose();
    subjectController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sortedTasks = [...widget.tasks]..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return Scaffold(
      backgroundColor: pageBackground,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addTask,
        backgroundColor: appPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Planner', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text('Keep assignments and exams under control.', style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 18),
          for (final task in sortedTasks)
            TaskCard(
              task: task,
              onToggle: (value) {
                task.isDone = value ?? false;
                widget.onChanged();
              },
            ),
          if (sortedTasks.isEmpty)
            const EmptyMessage(message: 'No tasks yet. Tap Add task to create one.'),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key, required this.attendance, required this.onChanged});

  final List<SubjectAttendance> attendance;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final attended = attendance.fold<int>(0, (sum, item) => sum + item.attended);
    final total = attendance.fold<int>(0, (sum, item) => sum + item.total);
    final overall = total == 0 ? 0.0 : attended / total;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Attendance', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 5),
        Text('Track every class, subject by subject.', style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: appPurple, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('OVERALL ATTENDANCE', style: TextStyle(color: Colors.white70, letterSpacing: 1)),
              const SizedBox(height: 8),
              Text('${(overall * 100).round()}%', style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('$attended of $total classes attended', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: overall,
                  minHeight: 8,
                  backgroundColor: Colors.white30,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Your subjects', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        ...attendance.map(
          (subject) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.w700))),
                    Text('${(subject.percentage * 100).round()}%', style: TextStyle(color: subject.color, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: subject.percentage,
                    minHeight: 7,
                    backgroundColor: subject.color.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(subject.color),
                  ),
                ),
                const SizedBox(height: 8),
                Text('${subject.attended} attended · ${subject.total - subject.attended} missed · ${subject.total} total',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          subject.attended++;
                          subject.total++;
                          onChanged();
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Attended'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          subject.total++;
                          onChanged();
                        },
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Missed'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Sample attendance is included for demonstration. Update it using the buttons above.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key, required this.timetable});

  final List<Map<String, String>> timetable;

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  String selectedDay = 'Monday';
  final List<String> days = const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  @override
  Widget build(BuildContext context) {
    final classes = widget.timetable.where((item) => item['day'] == selectedDay).toList();

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Class timetable', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 5),
        Text('Your week, organized in one place.', style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 16),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: days.map((day) {
              final selected = day == selectedDay;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(day.substring(0, 3)),
                  selected: selected,
                  selectedColor: appPurple,
                  labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                  onSelected: (_) => setState(() => selectedDay = day),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        if (classes.isEmpty)
          EmptyMessage(message: 'No classes added for $selectedDay yet.')
        else
          ...classes.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 58,
                    decoration: BoxDecoration(color: appPurple, borderRadius: BorderRadius.circular(8)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['time']!, style: const TextStyle(color: appPurple, fontWeight: FontWeight.w700, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(item['subject']!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(item['room']!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.menu_book_rounded, color: appPurple),
                ],
              ),
            ),
          ),
        const SizedBox(height: 10),
        Text('This is sample timetable data. We can customize it to match your real class schedule.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ],
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key, required this.notes, required this.onChanged});

  final List<StudentNote> notes;
  final VoidCallback onChanged;

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  Future<void> addNote() async {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    final bodyController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create a note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Note title')),
              const SizedBox(height: 10),
              TextField(controller: subjectController, decoration: const InputDecoration(labelText: 'Subject')),
              const SizedBox(height: 10),
              TextField(
                controller: bodyController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Write your notes'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Save')),
        ],
      ),
    );

    if (result == true && titleController.text.trim().isNotEmpty) {
      widget.notes.insert(
        0,
        StudentNote(
          title: titleController.text.trim(),
          subject: subjectController.text.trim().isEmpty ? 'General' : subjectController.text.trim(),
          body: bodyController.text.trim(),
        ),
      );
      widget.onChanged();
    }
    titleController.dispose();
    subjectController.dispose();
    bodyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addNote,
        backgroundColor: appPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New note'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('My notes', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text('Keep important concepts close at hand.', style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 18),
          if (widget.notes.isEmpty)
            const EmptyMessage(message: 'No notes yet. Tap New note to write one.'),
          ...widget.notes.asMap().entries.map((entry) {
            final index = entry.key;
            final note = entry.value;
            return Card(
              color: Colors.white,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.description_outlined, color: appPurple),
                ),
                title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text('${note.subject}\n${note.body}', maxLines: 4, overflow: TextOverflow.ellipsis),
                ),
                isThreeLine: true,
                trailing: IconButton(
                  tooltip: 'Delete note',
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () {
                    widget.notes.removeAt(index);
                    widget.onChanged();
                  },
                ),
              ),
            );
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class StudyTimerPage extends StatefulWidget {
  const StudyTimerPage({super.key});

  @override
  State<StudyTimerPage> createState() => _StudyTimerPageState();
}

class _StudyTimerPageState extends State<StudyTimerPage> {
  static const int focusSeconds = 25 * 60;
  int remainingSeconds = focusSeconds;
  int completedSessions = 0;
  Timer? timer;
  bool isRunning = false;
  bool isBreak = false;

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    if (isRunning) return;
    setState(() => isRunning = true);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        timer.cancel();
        setState(() {
          isRunning = false;
          if (!isBreak) completedSessions++;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isBreak ? 'Break complete! Time to focus.' : 'Focus session complete! Take a break.')),
        );
      }
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      remainingSeconds = isBreak ? 5 * 60 : focusSeconds;
    });
  }

  void switchMode(bool breakMode) {
    timer?.cancel();
    setState(() {
      isRunning = false;
      isBreak = breakMode;
      remainingSeconds = breakMode ? 5 * 60 : focusSeconds;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - remainingSeconds / (isBreak ? 5 * 60 : focusSeconds);

    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const Text('Study focus', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 5),
        Text('One task at a time. You’ve got this!', style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 30),
        Center(
          child: Container(
            width: 250,
            height: 250,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: appPurple.withValues(alpha: 0.08), blurRadius: 25, spreadRadius: 5),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: appPurple.withValues(alpha: 0.10),
                    valueColor: const AlwaysStoppedAnimation<Color>(appPurple),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isBreak ? Icons.coffee_rounded : Icons.menu_book_rounded, color: appPurple, size: 30),
                    const SizedBox(height: 10),
                    Text(formattedTime, style: const TextStyle(fontSize: 43, fontWeight: FontWeight.w800)),
                    Text(isBreak ? 'BREAK TIME' : 'FOCUS TIME',
                        style: TextStyle(color: Colors.grey.shade600, letterSpacing: 1.4, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 26),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => switchMode(false),
                style: OutlinedButton.styleFrom(
                  backgroundColor: !isBreak ? const Color(0xFFEDE9FE) : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: const Text('25 min focus'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () => switchMode(true),
                style: OutlinedButton.styleFrom(
                  backgroundColor: isBreak ? const Color(0xFFEDE9FE) : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: const Text('5 min break'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: isRunning ? pauseTimer : startTimer,
                style: FilledButton.styleFrom(backgroundColor: appPurple, padding: const EdgeInsets.symmetric(vertical: 15)),
                icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(isRunning ? 'Pause' : 'Start'),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: resetTimer,
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18)),
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
          child: Row(
            children: [
              const Icon(Icons.local_fire_department_rounded, color: Color(0xFFE99A36), size: 30),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Completed focus sessions', style: TextStyle(fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Keep building your study habit!', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Text('$completedSessions', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: appPurple)),
            ],
          ),
        ),
      ],
    );
  }
}

class AttendanceProgressCard extends StatelessWidget {
  const AttendanceProgressCard({super.key, required this.subject});

  final SubjectAttendance subject;

  @override
  Widget build(BuildContext context) {
    final percentage = (subject.percentage * 100).round();

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.w700))),
              Text('$percentage%', style: TextStyle(color: percentage < 75 ? Colors.redAccent : subject.color, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: subject.percentage,
              minHeight: 6,
              backgroundColor: subject.color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(subject.color),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
    );
  }
}
