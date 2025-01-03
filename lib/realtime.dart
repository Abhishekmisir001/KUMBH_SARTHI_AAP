import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RealTimeUpdatesScreen extends StatefulWidget {
  const RealTimeUpdatesScreen({super.key});

  @override
  State<RealTimeUpdatesScreen> createState() => _RealTimeUpdatesScreenState();
}

class _RealTimeUpdatesScreenState extends State<RealTimeUpdatesScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  /// Fetches events from Firestore and updates the `_events` map
  void _fetchEvents() {
    FirebaseFirestore.instance.collection('events').snapshots().listen((snapshot) {
      setState(() {
        _events.clear();
        for (var doc in snapshot.docs) {
          DateTime date = (doc['date'] as Timestamp).toDate();
          final normalizedDate = DateTime(date.year, date.month, date.day);
          if (_events[normalizedDate] == null) {
            _events[normalizedDate] = [];
          }
          _events[normalizedDate]!.add(doc['title']);
        }
      });
    });
  }

  /// Builds the calendar UI
  Widget _buildCalendar() {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime(2023, 1, 1),
      lastDay: DateTime(2025, 12, 31),
      calendarFormat: CalendarFormat.month,
      selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDate = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      eventLoader: (day) => _events[DateTime(day.year, day.month, day.day)] ?? [],
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Displays the event list for the selected date
  Widget _buildEventList() {
    final events = _events[_selectedDate] ?? [];
    return Expanded(
      child: events.isEmpty
          ? const Center(
              child: Text(
                'No events for this day',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            )
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Colors.orange),
                    title: Text(events[index]),
                    subtitle: Text('Details about ${events[index]}'),
                  ),
                );
              },
            ),
    );
  }

  /// Displays the upcoming events and gallery options
  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'upcoming_events',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const UpcomingEventsScreen()),
            );
          },
          backgroundColor: Colors.orange,
          tooltip: 'Upcoming Events',
          child: const Icon(Icons.event_note),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: 'gallery',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const GalleryScreen()),
            );
          },
          backgroundColor: Colors.orange,
          tooltip: 'Gallery',
          child: const Icon(Icons.photo_library),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-time Updates'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          _buildCalendar(),
          const SizedBox(height: 10),
          _buildEventList(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }
}

class UpcomingEventsScreen extends StatelessWidget {
  const UpcomingEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Events"),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .orderBy('date', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No upcoming events',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            );
          }
          final events = snapshot.data!.docs;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final date = (event['date'] as Timestamp).toDate();
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.event, color: Colors.orange),
                  title: Text(event['title']),
                  subtitle: Text(
                    '${event['description']}\nDate: ${date.day}-${date.month}-${date.year}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kumbh-Drishya Gallery'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('gallery').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No images available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            );
          }

          final images = snapshot.data!.docs;

          return ListView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index];
              final imageUrl = image['image_url'] as String;
              final subtitle = image['subtitle'] as String;

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListTile(
                  leading: Image.network(imageUrl, width: 50, height: 50),
                  title: Text('Image ${index + 1}'),
                  subtitle: Text(subtitle),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
