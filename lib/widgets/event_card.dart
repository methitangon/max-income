import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';
import '../models/safe_calendar_event.dart';
import '../utils/date_formatter.dart';

class EventCard extends StatefulWidget {
  final SafeCalendarEvent event;
  final VoidCallback onEventUpdated;

  const EventCard({
    super.key,
    required this.event,
    required this.onEventUpdated,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _hasTriggered = false;
  double _swipeRatio = 0.0;
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  Future<void> _handleEventPaid() async {
    try {
      final String originalTitle = widget.event.title ?? 'Event';
      // Only add checkmark if it's not already there
      final String newTitle =
          originalTitle.startsWith('✅') ? originalTitle : '✅ $originalTitle';

      // Log the modification attempt
      debugPrint('=== Calendar Event Modification ===');
      debugPrint('Event ID: ${widget.event.id}');
      debugPrint('Calendar ID: ${widget.event.calendarId}');
      debugPrint('Original Title: $originalTitle');
      debugPrint('New Title: $newTitle');

      if (widget.event.id == null) {
        debugPrint('Event ID is null');
        return;
      }

      // Retrieve the existing event
      final retrieveEventResult = await _deviceCalendarPlugin.retrieveEvents(
        widget.event.calendarId,
        RetrieveEventsParams(
          eventIds: [widget.event.id!],
        ),
      );

      if (retrieveEventResult?.data?.isNotEmpty ?? false) {
        final Event eventToUpdate = retrieveEventResult!.data!.first;
        eventToUpdate.title = newTitle;

        // Update the event
        final updateResult = await _deviceCalendarPlugin.createOrUpdateEvent(
          eventToUpdate,
        );

        if (updateResult?.isSuccess ?? false) {
          debugPrint('Successfully updated event title');
          // Show success toast
          _showPaidToast();
          // Refresh the events list
          widget.onEventUpdated();
        } else {
          debugPrint(
              'Failed to update event: ${updateResult?.errors?.join(', ')}');
        }
      } else {
        debugPrint(
            'Failed to retrieve event: ${retrieveEventResult?.errors?.join(', ')}');
      }
    } catch (e) {
      debugPrint('Error updating event: $e');
    }
  }

  void _showPaidToast() {
    DelightToastBar(
      autoDismiss: true,
      position: DelightSnackbarPosition.top,
      snackbarDuration: const Duration(seconds: 3),
      builder: (context) => Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF4DB6AC),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  "${widget.event.title ?? 'Event'} จ่ายแล้ว",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            final ratio = details.localPosition.dx / constraints.maxWidth;
            if (ratio >= 0.5 && !_hasTriggered) {
              setState(() {
                _hasTriggered = true;
              });
              _handleEventPaid();
              debugPrint('Event swiped: ${widget.event.title}');
            }
            setState(() {
              _swipeRatio = ratio.clamp(0.0, 1.0);
            });
          },
          onHorizontalDragEnd: (details) {
            setState(() {
              _swipeRatio = 0.0;
              _hasTriggered = false;
            });
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFF7986CB), // Light Indigo
                    const Color(0xFF4DB6AC), // Light Teal
                    Theme.of(context).cardColor,
                  ],
                  stops: [0.0, _swipeRatio, _swipeRatio],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Swipe hint
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey.withOpacity(0.5),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        // Title and ALL DAY badge
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.event.title ?? 'No Title',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              if (widget.event.isAllDay)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'ALL DAY',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${DateFormatter.formatDateTime(widget.event.startTime, widget.event.isAllDay)} - ${DateFormatter.formatDateTime(widget.event.endTime, widget.event.isAllDay)}',
                          ),
                        ),
                      ],
                    ),
                    if (widget.event.location?.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.event.location!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (widget.event.description?.isNotEmpty == true) ...[
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.notes, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ExpansionTile(
                              title: Text(
                                widget.event.description!,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    bottom: 16,
                                  ),
                                  child: Text(
                                    widget.event.description!,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
