import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'dart:typed_data';

class WebSocketPoseScreen extends StatefulWidget {
  @override
  _WebSocketPoseScreenState createState() => _WebSocketPoseScreenState();
}

class _WebSocketPoseScreenState extends State<WebSocketPoseScreen> {
  CameraController? controller;
  WebSocketChannel? channel;
  Map<String, dynamic> poseData = {};
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    connectWebSocket();
    initCamera();
  }

  void connectWebSocket() {
    try {
      channel = WebSocketChannel.connect(Uri.parse('ws://10.5.89.22:8765'));
      channel!.stream.listen(
            (data) {
          print('Received data: $data');
          try {
            final result = jsonDecode(data);
            print('Parsed result: $result');
            if (mounted) setState(() => poseData = result);
          } catch (e) {
            print('JSON decode error: $e');
            if (mounted) setState(() => poseData = {'error': 'Invalid response format'});
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
          setState(() => isConnected = false);
        },
        onDone: () {
          print('WebSocket connection closed');
          setState(() => isConnected = false);
        },
      );
      setState(() => isConnected = true);
      print('WebSocket connected successfully');
    } catch (e) {
      print('WebSocket connection failed: $e');
      setState(() => isConnected = false);
    }
  }

  void initCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller!.initialize();
    controller!.startImageStream(onCameraFrame);
    setState(() {});
  }

  bool isProcessing = false;

  void onCameraFrame(CameraImage image) async {
    if (!isConnected || channel == null || isProcessing) return;

    isProcessing = true;
    try {
      final bytes = await convertCameraImage(image);
      final message = jsonEncode({
        'image': base64Encode(bytes),
        'exercise': 'all'
      });

      channel!.sink.add(message);
      print('Sent frame to server');
    } catch (e) {
      print('Error processing frame: $e');
    } finally {
      await Future.delayed(Duration(milliseconds: 500)); // Throttle
      isProcessing = false;
    }
  }

  Future<Uint8List> convertCameraImage(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      final Uint8List yPlane = image.planes[0].bytes;

      // Create RGB image from Y plane (grayscale)
      final img.Image convertedImage = img.Image(width: width, height: height);

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final int pixelIndex = y * width + x;
          if (pixelIndex < yPlane.length) {
            final int gray = yPlane[pixelIndex];
            convertedImage.setPixel(x, y, img.ColorRgb8(gray, gray, gray));
          }
        }
      }

      return Uint8List.fromList(img.encodeJpg(convertedImage, quality: 70));
    } catch (e) {
      print('Image conversion error: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Pose Trainer'),
        backgroundColor: isConnected ? Colors.green : Colors.red,
      ),
      body: Column(
        children: [
          if (controller?.value.isInitialized == true)
            Expanded(child: CameraPreview(controller!)),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Status: ${isConnected ? "Connected" : "Disconnected"}'),
                Text('Data: ${poseData.toString()}'),
                if (poseData['error'] != null)
                  Text('Error: ${poseData['error']}', style: TextStyle(color: Colors.red)),
                if (poseData['pose_detected'] == true) ...[
                  Text('Reps: ${poseData['reps']}', style: TextStyle(fontSize: 18)),
                  Text('Angles: ${poseData['angles']}'),
                  if (poseData['issues'].isNotEmpty)
                    Text('Issues: ${poseData['issues'].join(', ')}',
                        style: TextStyle(color: Colors.red)),
                ] else if (poseData.isNotEmpty)
                  Text('Pose detection: ${poseData['pose_detected'] ?? 'unknown'}')
                else
                  Text('Waiting for data...'),
                ElevatedButton(
                  onPressed: () => channel?.sink.add('{"reset": true}'),
                  child: Text('Reset'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    channel?.sink.close();
    super.dispose();
  }
}
