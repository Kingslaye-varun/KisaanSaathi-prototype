// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';

// class CallScreen extends StatefulWidget {
//   const CallScreen({super.key});

//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> {
//   RTCPeerConnection? _peerConnection;
//   MediaStream? _localStream;
//   final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
//   bool _isConnected = false;
//   bool _isLoading = false;
//   String? _errorMessage;

//   // Get these from your environment
//   final String elevenLabsApiKey = dotenv.env['ELEVENLABS_API_KEY'] ?? ''; // Replace with your actual key
//   final String voiceId = dotenv.env['VOICE_ID'] ?? ''; // Replace with your actual voice ID

//   @override
//   void initState() {
//     super.initState();
//     _initializeRenderer();
//   }

//   Future<void> _initializeRenderer() async {
//     await _remoteRenderer.initialize();
//   }

//   @override
//   void dispose() {
//     _endCall();
//     _remoteRenderer.dispose();
//     super.dispose();
//   }

//   Future<bool> _checkPermissions() async {
//     final microphoneStatus = await Permission.microphone.request();
//     if (microphoneStatus != PermissionStatus.granted) {
//       setState(() {
//         _errorMessage = "Microphone permission is required for calls";
//       });
//       return false;
//     }
//     return true;
//   }

//   Future<void> _startCall() async {
//     if (!await _checkPermissions()) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       // Initialize WebRTC
//       await _initializeWebRTC();

//       // Create and set up peer connection
//       await _createPeerConnection();

//       // Create offer and connect to ElevenLabs
//       await _createAndSendOffer();

//       setState(() {
//         _isConnected = true;
//         _isLoading = false;
//       });

//     } catch (e) {
//       debugPrint("Error starting call: $e");
//       setState(() {
//         _errorMessage = "Failed to start call: ${e.toString()}";
//         _isLoading = false;
//       });
//       await _endCall();
//     }
//   }

//   Future<void> _initializeWebRTC() async {
//     // Ensure renderer is initialized
//     if (_remoteRenderer.srcObject == null) {
//       await _remoteRenderer.initialize();
//     }
//   }

//   Future<void> _createPeerConnection() async {
//     final configuration = <String, dynamic>{
//       'iceServers': [
//         {'urls': 'stun:stun.l.google.com:19302'},
//         {'urls': 'stun:stun1.l.google.com:19302'},
//       ]
//     };

//     _peerConnection = await createPeerConnection(configuration);

//     // Set up event handlers
//     _peerConnection?.onIceConnectionState = (state) {
//       debugPrint("ICE Connection State: $state");
//       if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
//           state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
//         _endCall();
//       }
//     };

//     _peerConnection?.onTrack = (event) {
//       if (event.track.kind == 'audio' && event.streams.isNotEmpty) {
//         setState(() {
//           _remoteRenderer.srcObject = event.streams.first;
//         });
//       }
//     };

//     // Get user media (microphone)
//     final mediaConstraints = <String, dynamic>{
//       'audio': true,
//       'video': false
//     };

//     _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    
//     // Add tracks to peer connection
//     _localStream?.getAudioTracks().forEach((track) {
//       _peerConnection?.addTrack(track, _localStream!);
//     });
//   }

//   Future<void> _createAndSendOffer() async {
//     if (_peerConnection == null) return;

//     final offerConstraints = <String, dynamic>{
//       'mandatory': {
//         'OfferToReceiveAudio': true,
//         'OfferToReceiveVideo': false,
//       },
//       'optional': [],
//     };

//     // Create offer
//     final offer = await _peerConnection!.createOffer(offerConstraints);
//     await _peerConnection!.setLocalDescription(offer);

//     debugPrint("Created local offer: ${offer.sdp}");

//     // Send offer to ElevenLabs
//     final response = await http.post(
//       Uri.parse("https://api.elevenlabs.io/v1/realtime/webRTC?model=eleven_monolingual_v1&voice_id=$voiceId"),
//       headers: {
//         'Authorization': 'Bearer $elevenLabsApiKey',
//         'Content-Type': 'application/sdp',
//         'Accept': 'application/sdp',
//       },
//       body: offer.sdp,
//     );

//     debugPrint("ElevenLabs response status: ${response.statusCode}");
//     debugPrint("ElevenLabs response body: ${response.body}");

//     if (response.statusCode == 200) {
//       // Set remote description from ElevenLabs answer
//       final answer = RTCSessionDescription(response.body, 'answer');
//       await _peerConnection!.setRemoteDescription(answer);
//       debugPrint("Successfully set remote description");
//     } else {
//       throw Exception("Failed to connect to ElevenLabs: ${response.statusCode} - ${response.body}");
//     }
//   }

//   Future<void> _endCall() async {
//     try {
//       await _peerConnection?.close();
//       await _localStream?.dispose();
//       _peerConnection = null;
//       _localStream = null;
//     } catch (e) {
//       debugPrint("Error ending call: $e");
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isConnected = false;
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade50,
//       appBar: AppBar(
//         title: const Text("Farmer Helpline Call"),
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Status Icon
//               Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   _isConnected ? Icons.call : Icons.call_end,
//                   color: _isConnected ? Colors.green : Colors.grey,
//                   size: 60,
//                 ),
//               ),
              
//               const SizedBox(height: 30),
              
//               // Status Text
//               Text(
//                 _isConnected 
//                   ? "Connected to AI Assistant"
//                   : _isLoading 
//                     ? "Connecting..."
//                     : "Ready to call",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: _isConnected ? Colors.green : Colors.grey.shade700,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
              
//               const SizedBox(height: 10),
              
//               // Subtitle
//               Text(
//                 _isConnected 
//                   ? "You're now talking with the AI assistant"
//                   : "Get instant help with farming questions",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey.shade600,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
              
//               const SizedBox(height: 40),
              
//               // Error Message
//               if (_errorMessage != null)
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   margin: const EdgeInsets.only(bottom: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.red.shade50,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.red.shade200),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.error, color: Colors.red.shade700),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           _errorMessage!,
//                           style: TextStyle(color: Colors.red.shade700),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
              
//               // Call Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _isConnected ? Colors.red : Colors.green,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     elevation: 4,
//                     shadowColor: _isConnected 
//                         ? Colors.red.withOpacity(0.3) 
//                         : Colors.green.withOpacity(0.3),
//                   ),
//                   onPressed: _isLoading ? null : (_isConnected ? _endCall : _startCall),
//                   child: _isLoading
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 3,
//                           ),
//                         )
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(_isConnected ? Icons.call_end : Icons.call),
//                             const SizedBox(width: 10),
//                             Text(
//                               _isConnected ? "End Call" : "Start Call",
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                 ),
//               ),
              
//               const SizedBox(height: 20),
              
//               // Help Text
//               if (!_isConnected)
//                 Text(
//                   "Make sure you have a stable internet connection",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey.shade500,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _isConnected = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _rendererInitialized = false;

  // Get these from your environment
  final String elevenLabsApiKey = dotenv.env['ELEVENLABS_API_KEY'] ?? '';
  final String voiceId = dotenv.env['VOICE_ID'] ?? '';

  @override
  void initState() {
    super.initState();
    _initializeRenderer();
  }

  Future<void> _initializeRenderer() async {
    try {
      await _remoteRenderer.initialize();
      setState(() {
        _rendererInitialized = true;
      });
    } catch (e) {
      debugPrint("Error initializing renderer: $e");
      setState(() {
        _errorMessage = "Failed to initialize audio renderer";
      });
    }
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
    if (!_rendererInitialized) {
      await _initializeRenderer();
    }
  }

  Future<void> _createPeerConnection() async {
    final configuration = <String, dynamic>{
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        {'urls': 'stun:stun1.l.google.com:19302'},
      ],
      'sdpSemantics': 'unified-plan'
    };

    _peerConnection = await createPeerConnection(configuration);

    // Set up event handlers
    _peerConnection?.onIceConnectionState = (state) {
      debugPrint("ICE Connection State: $state");
      if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
          state == RTCIceConnectionState.RTCIceConnectionStateFailed ||
          state == RTCIceConnectionState.RTCIceConnectionStateClosed) {
        _onCallEnded();
      }
    };

    _peerConnection?.onConnectionState = (state) {
      debugPrint("Connection State: $state");
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
        _onCallEnded();
      }
    };

    _peerConnection?.onTrack = (event) {
      if (event.track.kind == 'audio' && event.streams.isNotEmpty) {
        debugPrint("Remote audio track received");
        setState(() {
          _remoteRenderer.srcObject = event.streams.first;
        });
      }
    };

    // Handle ICE candidates
    _peerConnection?.onIceCandidate = (candidate) {
      debugPrint("ICE Candidate: ${candidate.candidate}");
    };

    // Get user media (microphone)
    final mediaConstraints = <String, dynamic>{
      'audio': {
        'echoCancellation': true,
        'noiseSuppression': true,
        'autoGainControl': true,
      },
      'video': false
    };

    try {
      _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      
      // Add tracks to peer connection
      _localStream?.getAudioTracks().forEach((track) {
        _peerConnection?.addTrack(track, _localStream!);
      });
    } catch (e) {
      debugPrint("Error getting user media: $e");
      throw Exception("Failed to access microphone: $e");
    }
  }

  Future<void> _createAndSendOffer() async {
    if (_peerConnection == null) {
      throw Exception("Peer connection not initialized");
    }

    // Create offer
    final offer = await _peerConnection!.createOffer({
      'offerToReceiveAudio': true,
      'offerToReceiveVideo': false,
    });

    await _peerConnection!.setLocalDescription(offer);

    debugPrint("Created local offer");

    // Try different ElevenLabs endpoints
    final endpoints = [
      // Standard voice endpoint
      Uri.parse("https://api.elevenlabs.io/v1/realtime/webrtc?model_id=eleven_monolingual_v1&voice_id=$voiceId&optimize_streaming_latency=3"),
      // Alternative endpoint
      Uri.parse("https://api.elevenlabs.io/v1/realtime/webrtc?voice_id=$voiceId"),
    ];

    http.Response? response;
    String? lastError;

    for (final uri in endpoints) {
      try {
        debugPrint("Trying endpoint: $uri");
        
        response = await http.post(
          uri,
          headers: {
            'xi-api-key': elevenLabsApiKey,
            'Content-Type': 'application/sdp',
            'Accept': 'application/sdp',
          },
          body: offer.sdp,
        );

        debugPrint("Response status: ${response.statusCode}");

        if (response.statusCode == 200) {
          break;
        } else {
          lastError = "Endpoint $uri failed with status ${response.statusCode}: ${response.body}";
          debugPrint(lastError);
        }
      } catch (e) {
        lastError = "Endpoint $uri failed with error: $e";
        debugPrint(lastError);
      }
    }

    if (response == null || response.statusCode != 200) {
      throw Exception("All endpoints failed. Last error: $lastError");
    }

    debugPrint("ElevenLabs response status: ${response.statusCode}");

    if (response.statusCode == 200) {
      // Set remote description from ElevenLabs answer
      final answer = RTCSessionDescription(response.body, 'answer');
      await _peerConnection!.setRemoteDescription(answer);
      debugPrint("Successfully set remote description - Call connected");
    } else {
      final errorBody = response.body;
      debugPrint("ElevenLabs error response: $errorBody");
      
      String errorMessage = "Failed to connect to ElevenLabs: ${response.statusCode}";
      
      if (response.statusCode == 401) {
        errorMessage = "Invalid API key. Please check your ElevenLabs API key.";
      } else if (response.statusCode == 404) {
        errorMessage = "Voice not found. Please check your Voice ID.";
      } else if (response.statusCode == 422) {
        errorMessage = "Invalid voice configuration or parameters.";
      } else if (response.statusCode == 403) {
        errorMessage = "Access denied. Check your API key permissions.";
      }
      
      // Try to parse JSON error
      try {
        final errorJson = json.decode(errorBody);
        if (errorJson['detail'] != null) {
          errorMessage += "\nDetails: ${errorJson['detail']}";
        }
      } catch (e) {
        errorMessage += "\nResponse: $errorBody";
      }
      
      throw Exception(errorMessage);
    }
  }

  void _onCallEnded() {
    if (mounted) {
      setState(() {
        _isConnected = false;
        _isLoading = false;
      });
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
      _onCallEnded();
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
              
              Text(
                _isConnected 
                  ? "You're now talking with the farming assistant"
                  : "Get instant help with farming questions",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
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