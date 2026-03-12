import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

import '../../core/network/connectivity_service.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({
    required this.meetingLink,
    required this.userDisplayName,
    super.key,
  });

  final String meetingLink;
  final String userDisplayName;

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final _jitsi = JitsiMeet();
  final _connectivityService = ConnectivityService();
  bool _joining = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Consultation')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.video_call, size: 120, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'Room: ${widget.meetingLink}',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _joining ? null : _joinMeeting,
              icon: const Icon(Icons.play_circle_fill),
              label: Text(_joining ? 'Joining...' : 'Start Consultation'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _joinMeeting() async {
    setState(() => _joining = true);

    final weakNetwork = await _connectivityService.isWeakNetwork();

    final options = JitsiMeetConferenceOptions(
      room: widget.meetingLink,
      userInfo: JitsiMeetUserInfo(displayName: widget.userDisplayName),
      configOverrides: {
        'startWithVideoMuted': weakNetwork,
        'startWithAudioMuted': false,
      },
    );

    await _jitsi.join(options);

    if (mounted) {
      setState(() => _joining = false);
    }
  }
}
