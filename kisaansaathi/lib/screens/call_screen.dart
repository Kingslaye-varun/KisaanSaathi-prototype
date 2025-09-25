// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:http/http.dart' as http;

// class CallScreen extends StatefulWidget {
//   const CallScreen({super.key});

//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> {
//   RTCPeerConnection? _peerConnection;
//   MediaStream? _localStream;
//   final _remoteRenderer = RTCVideoRenderer(); // For remote audio
//   bool _isConnected = false;

//   // TODO: Replace with your ElevenLabs Realtime API key
//   final String elevenLabsApiKey = "ELEVENLABS_API_KEY";
//   final String voiceId = "VOICE_ID"; // Pick voice from ElevenLabs dashboard

//   @override
//   void initState() {
//     super.initState();
//     _remoteRenderer.initialize();
//   }

//   @override
//   void dispose() {
//     _remoteRenderer.dispose();
//     _localStream?.dispose();
//     super.dispose();
//   }

//   Future<void> _startCall() async {
//     // Create peer connection
//     _peerConnection = await createPeerConnection({
//       'iceServers': [
//         {'urls': 'stun:stun.l.google.com:19302'}
//       ]
//     });

//     // Capture microphone input
//     _localStream = await navigator.mediaDevices.getUserMedia({'audio': true});
//     _peerConnection?.addStream(_localStream!);

//     // Attach remote audio
//     _peerConnection?.onAddStream = (stream) {
//       setState(() {
//         _remoteRenderer.srcObject = stream;
//       });
//     };

//     // Create SDP offer
//     RTCSessionDescription offer = await _peerConnection!.createOffer();
//     await _peerConnection!.setLocalDescription(offer);

//     // Send offer to ElevenLabs
//     final response = await http.post(
//       Uri.parse("https://api.elevenlabs.io/v1/realtime/webRTC?model=eleven_monolingual_v1&voice=$voiceId"),
//       headers: {
//         'Authorization': 'Bearer $elevenLabsApiKey',
//         'Content-Type': 'application/sdp'
//       },
//       body: offer.sdp,
//     );

//     if (response.statusCode == 200) {
//       // Set remote description from ElevenLabs
//       await _peerConnection!.setRemoteDescription(
//         RTCSessionDescription(response.body, 'answer'),
//       );

//       setState(() {
//         _isConnected = true;
//       });
//     } else {
//       debugPrint("Error starting call: ${response.body}");
//     }
//   }

//   Future<void> _endCall() async {
//     await _peerConnection?.close();
//     _peerConnection = null;
//     _localStream?.dispose();
//     setState(() {
//       _isConnected = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade50,
//       appBar: AppBar(
//         title: const Text("Farmer Helpline Call"),
//         backgroundColor: Colors.green,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               _isConnected ? Icons.call : Icons.call_end,
//               color: _isConnected ? Colors.green : Colors.red,
//               size: 80,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               _isConnected
//                   ? "Talking to AI assistant..."
//                   : "Press to start call",
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: _isConnected ? Colors.red : Colors.green,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//               ),
//               onPressed: _isConnected ? _endCall : _startCall,
//               child: Text(
//                 _isConnected ? "End Call" : "Start Call",
//                 style: const TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _isConnected = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Get these from your environment
  final String elevenLabsApiKey = "ELEVENLABS_API_KEY"; // Replace with your actual key
  final String voiceId = "VOICE_ID"; // Replace with your actual voice ID

  @override
  void initState() {
    super.initState();
    _initializeRenderer();
  }

  Future<void> _initializeRenderer() async {
    await _remoteRenderer.initialize();
  }

  @override
  void dispose() {
    _endCall();
    _remoteRenderer.dispose();
    super.dispose();
  }

  Future<bool> _checkPermissions() async {
    final microphoneStatus = await Permission.microphone.request();
    if (microphoneStatus != PermissionStatus.granted) {
      setState(() {
        _errorMessage = "Microphone permission is required for calls";
      });
      return false;
    }
    return true;
  }

  Future<void> _startCall() async {
    if (!await _checkPermissions()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Initialize WebRTC
      await _initializeWebRTC();

      // Create and set up peer connection
      await _createPeerConnection();

      // Create offer and connect to ElevenLabs
      await _createAndSendOffer();

      setState(() {
        _isConnected = true;
        _isLoading = false;
      });

    } catch (e) {
      debugPrint("Error starting call: $e");
      setState(() {
        _errorMessage = "Failed to start call: ${e.toString()}";
        _isLoading = false;
      });
      await _endCall();
    }
  }

  Future<void> _initializeWebRTC() async {
    // Ensure renderer is initialized
    if (_remoteRenderer.srcObject == null) {
      await _remoteRenderer.initialize();
    }
  }

  Future<void> _createPeerConnection() async {
    final configuration = <String, dynamic>{
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        {'urls': 'stun:stun1.l.google.com:19302'},
      ]
    };

    _peerConnection = await createPeerConnection(configuration);

    // Set up event handlers
    _peerConnection?.onIceConnectionState = (state) {
      debugPrint("ICE Connection State: $state");
      if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
          state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        _endCall();
      }
    };

    _peerConnection?.onTrack = (event) {
      if (event.track.kind == 'audio' && event.streams.isNotEmpty) {
        setState(() {
          _remoteRenderer.srcObject = event.streams.first;
        });
      }
    };

    // Get user media (microphone)
    final mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': false
    };

    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    
    // Add tracks to peer connection
    _localStream?.getAudioTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });
  }

  Future<void> _createAndSendOffer() async {
    if (_peerConnection == null) return;

    final offerConstraints = <String, dynamic>{
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': false,
      },
      'optional': [],
    };

    // Create offer
    final offer = await _peerConnection!.createOffer(offerConstraints);
    await _peerConnection!.setLocalDescription(offer);

    debugPrint("Created local offer: ${offer.sdp}");

    // Send offer to ElevenLabs
    final response = await http.post(
      Uri.parse("https://api.elevenlabs.io/v1/realtime/webRTC?model=eleven_monolingual_v1&voice_id=$voiceId"),
      headers: {
        'Authorization': 'Bearer $elevenLabsApiKey',
        'Content-Type': 'application/sdp',
        'Accept': 'application/sdp',
      },
      body: offer.sdp,
    );

    debugPrint("ElevenLabs response status: ${response.statusCode}");
    debugPrint("ElevenLabs response body: ${response.body}");

    if (response.statusCode == 200) {
      // Set remote description from ElevenLabs answer
      final answer = RTCSessionDescription(response.body, 'answer');
      await _peerConnection!.setRemoteDescription(answer);
      debugPrint("Successfully set remote description");
    } else {
      throw Exception("Failed to connect to ElevenLabs: ${response.statusCode} - ${response.body}");
    }
  }

  Future<void> _endCall() async {
    try {
      await _peerConnection?.close();
      await _localStream?.dispose();
      _peerConnection = null;
      _localStream = null;
    } catch (e) {
      debugPrint("Error ending call: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isConnected = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text("Farmer Helpline Call"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  _isConnected ? Icons.call : Icons.call_end,
                  color: _isConnected ? Colors.green : Colors.grey,
                  size: 60,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Status Text
              Text(
                _isConnected 
                  ? "Connected to AI Assistant"
                  : _isLoading 
                    ? "Connecting..."
                    : "Ready to call",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _isConnected ? Colors.green : Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 10),
              
              // Subtitle
              Text(
                _isConnected 
                  ? "You're now talking with the AI assistant"
                  : "Get instant help with farming questions",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Error Message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Call Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isConnected ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: _isConnected 
                        ? Colors.red.withOpacity(0.3) 
                        : Colors.green.withOpacity(0.3),
                  ),
                  onPressed: _isLoading ? null : (_isConnected ? _endCall : _startCall),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_isConnected ? Icons.call_end : Icons.call),
                            const SizedBox(width: 10),
                            Text(
                              _isConnected ? "End Call" : "Start Call",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Help Text
              if (!_isConnected)
                Text(
                  "Make sure you have a stable internet connection",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}