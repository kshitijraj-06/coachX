# Pose Detection Module

AI-powered pose detection and form analysis for Gym Paglu fitness app.

## 🏗️ Architecture

### Components
- **web_camera.py** - Flask server with MediaPipe pose detection
- **posePage.dart** - Flutter WebView interface
- **poseAnalyzer.dart** - HTTP client for pose analysis API
- **server_config.py** - Setup and configuration utility

## 🚀 Quick Setup

### 1. Python Server Setup
```bash
# Navigate to Pose_Detection directory
cd lib/Pose_Detection

# Run setup script
python server_config.py

# Start the server
python web_camera.py
```

### 2. Dependencies
```bash
pip install flask opencv-python mediapipe numpy
```

### 3. Flutter Integration
The Flutter app automatically connects to available servers:
- `http://10.5.89.22:5000` (Network)
- `http://localhost:5000` (Local)
- `http://127.0.0.1:5000` (Loopback)

## 📱 Features

### Pose Analysis
- **Real-time pose detection** using MediaPipe
- **Exercise recognition** for curls, squats, push-ups
- **Form analysis** with angle calculations
- **Rep counting** with configurable thresholds

### Supported Exercises
- **Bicep Curls** - Elbow angle tracking
- **Squats** - Knee and hip angle analysis
- **Push-ups** - Body alignment and elbow tracking

### Form Feedback
- Knee valgus detection
- Squat depth analysis
- Body alignment checking
- Shoulder positioning

## 🔧 Configuration

### Server URLs
Update server URLs in `poseAnalyzer.dart`:
```dart
static const List<String> _serverUrls = [
  'http://YOUR_IP:5000',
  'http://localhost:5000',
  'http://127.0.0.1:5000',
];
```

### Rep Counter Thresholds
Modify in `web_camera.py`:
```python
curl_counter = RepCounter(160, 40)    # down_thresh, up_thresh
squat_counter = RepCounter(100, 60)
pushup_counter = RepCounter(100, 40)
```

## 🌐 API Endpoints

### POST /analyze
Analyze pose from image data
```json
{
  "image": "base64_encoded_image",
  "exercise": "curl|squat|pushup|all"
}
```

**Response:**
```json
{
  "pose_detected": true,
  "angles": {
    "elbow": 45,
    "knee": 90,
    "hip": 120,
    "body": 180
  },
  "reps": {
    "curl": 5,
    "squat": 3,
    "pushup": 8
  },
  "issues": ["Knee valgus detected"]
}
```

### POST /reset
Reset all rep counters
```json
{
  "success": true
}
```

## 🔒 Security

### HTTPS Support
- Auto-generates self-signed certificates
- Falls back to HTTP if SSL unavailable
- Mobile camera access requires HTTPS

### Network Access
- Configurable host binding
- Firewall considerations for network access
- CORS enabled for cross-origin requests

## 🐛 Troubleshooting

### Common Issues

#### Server Connection Failed
1. Check if Python server is running
2. Verify network connectivity
3. Try different server URLs
4. Check firewall settings

#### Camera Access Denied
1. Use HTTPS for mobile devices
2. Grant camera permissions
3. Try localhost for testing

#### Poor Pose Detection
1. Ensure good lighting
2. Full body visibility required
3. Stable camera position
4. Clear background preferred

### Debug Mode
Enable debug logging in `web_camera.py`:
```python
app.run(host='0.0.0.0', port=5000, debug=True)
```

## 📊 Performance

### Optimization Tips
- Reduce analysis frequency for better performance
- Use lower resolution for faster processing
- Implement frame skipping for real-time use

### System Requirements
- **CPU**: Multi-core processor recommended
- **RAM**: 4GB minimum, 8GB recommended
- **Camera**: 720p minimum resolution
- **Network**: Local network or localhost

## 🔄 Integration with Flutter

### WebView Integration
```dart
// Navigate to pose trainer
Get.to(() => PoseTrainerWebView());

// With custom server URL
Get.to(() => PoseTrainerWebView(
  serverUrl: 'http://192.168.1.100:5000'
));
```

### Direct API Usage
```dart
// Analyze pose from camera
final result = await PoseAnalyzer.analyzePose(imageBytes, 'squat');

// Reset counters
await PoseAnalyzer.resetCounters();

// Check server status
final status = await PoseAnalyzer.getServerStatus();
```

## 🚀 Future Enhancements

### Planned Features
- Multiple person detection
- Exercise difficulty adjustment
- Custom exercise creation
- Video recording and playback
- Progress analytics
- Wearable device integration

### Technical Improvements
- WebRTC for better streaming
- Edge AI for offline processing
- Advanced ML models
- Real-time feedback system

## 📝 Development Notes

### Code Structure
```
Pose_Detection/
├── web_camera.py      # Main Flask server
├── posePage.dart      # Flutter WebView UI
├── poseAnalyzer.dart  # API client
├── server_config.py   # Setup utility
└── README.md          # This file
```

### Key Classes
- **RepCounter**: Exercise repetition counting
- **PoseAnalyzer**: Flutter HTTP client
- **PoseTrainerWebView**: Flutter UI component

### MediaPipe Integration
- Uses MediaPipe Pose solution
- 33 landmark detection points
- Real-time processing capability
- Cross-platform compatibility

---

**Note**: Ensure Python server is running before using pose detection features in the Flutter app.