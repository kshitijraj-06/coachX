from flask import Flask, render_template_string, request, jsonify
import base64
import cv2
import numpy as np
import math
import mediapipe as mp

mp_pose = mp.solutions.pose

def angle(a, b, c):
    ax, ay = a; bx, by = b; cx, cy = c
    ab = np.array([ax-bx, ay-by]); cb = np.array([cx-bx, cy-by])
    denom = (np.linalg.norm(ab)*np.linalg.norm(cb) + 1e-6)
    cosang = np.dot(ab, cb) / denom
    cosang = np.clip(cosang, -1.0, 1.0)
    return math.degrees(math.acos(cosang))

def knee_angle(hip, knee, ankle):
    return 180 - angle(hip, knee, ankle)

def hip_angle(shoulder, hip, knee):
    return 180 - angle(shoulder, hip, knee)

def body_line_angle(ankle, hip, shoulder):
    return angle(ankle, hip, shoulder)

def valgus_metric(knee, ankle, hip):
    return (knee[0] - ankle[0]) * np.sign(hip[0] - ankle[0])

class RepCounter:
    def __init__(self, down_thresh, up_thresh):
        self.stage = "start"
        self.count = 0
        self.down_thresh = down_thresh
        self.up_thresh = up_thresh

    def update(self, metric):
        if self.stage in ["start", "up"] and metric >= self.down_thresh:
            self.stage = "down"
        elif self.stage == "down" and metric <= self.up_thresh:
            self.stage = "up"
            self.count += 1

curl_counter = RepCounter(160, 40)
squat_counter = RepCounter(100, 60)
pushup_counter = RepCounter(100, 40)

def analyze_pose_logic(frame, exercise):
    with mp_pose.Pose(model_complexity=1, min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
        img = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        res = pose.process(img)
        h, w = frame.shape[:2]
        
        if not res.pose_landmarks:
            return {'pose_detected': False}
        
        lm = res.pose_landmarks.landmark
        def P(id): return (lm[id].x * w, lm[id].y * h)
        
        RS = P(mp_pose.PoseLandmark.RIGHT_SHOULDER.value)
        RE = P(mp_pose.PoseLandmark.RIGHT_ELBOW.value)
        RW = P(mp_pose.PoseLandmark.RIGHT_WRIST.value)
        RHIP = P(mp_pose.PoseLandmark.RIGHT_HIP.value)
        RK = P(mp_pose.PoseLandmark.RIGHT_KNEE.value)
        RA = P(mp_pose.PoseLandmark.RIGHT_ANKLE.value)
        LS = P(mp_pose.PoseLandmark.LEFT_SHOULDER.value)
        LE = P(mp_pose.PoseLandmark.LEFT_ELBOW.value)
        LW = P(mp_pose.PoseLandmark.LEFT_WRIST.value)
        LHIP = P(mp_pose.PoseLandmark.LEFT_HIP.value)
        LK = P(mp_pose.PoseLandmark.LEFT_KNEE.value)
        LA = P(mp_pose.PoseLandmark.LEFT_ANKLE.value)
        
        elbow_ang = angle(RS, RE, RW)
        knee_flex = (knee_angle(RHIP, RK, RA) + knee_angle(LHIP, LK, LA)) / 2
        hip_flex = (hip_angle(RS, RHIP, RK) + hip_angle(LS, LHIP, LK)) / 2
        body_align = (body_line_angle(RA, RHIP, RS) + body_line_angle(LA, LHIP, LS)) / 2
        
        curl_counter.update(elbow_ang)
        squat_counter.update(max(0, 180 - knee_flex))
        elbow_flex = (180 - angle(RS, RE, RW) + 180 - angle(LS, LE, LW)) / 2
        pushup_counter.update(elbow_flex)
        
        issues = []
        if knee_flex <= 110:
            if knee_flex > 100: issues.append("Squat depth shallow")
            if valgus_metric(RK, RA, RHIP) < -5 or valgus_metric(LK, LA, LHIP) < -5:
                issues.append("Knee valgus detected")
            if hip_flex < 30: issues.append("Torso leaning forward")
        
        if body_align < 160: issues.append("Hips sagging")
        elif body_align > 200: issues.append("Hips too high")
        
        if abs(RS[0] - RHIP[0]) > 0.20 * w:
            issues.append("Shoulder drifting")
        
        return {
            'pose_detected': True,
            'angles': {'elbow': int(elbow_ang), 'knee': int(knee_flex), 'hip': int(hip_flex), 'body': int(body_align)},
            'reps': {'curl': curl_counter.count, 'squat': squat_counter.count, 'pushup': pushup_counter.count},
            'issues': issues
        }

app = Flask(__name__)

HTML_TEMPLATE = '''
<!DOCTYPE html>
<html>
<head>
    <title>Gym Posture Trainer - Web Camera</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; text-align: center; }
        video, canvas { width: 100%; max-width: 640px; margin: 10px; }
        .stats { display: flex; justify-content: center; gap: 20px; margin: 20px; }
        .stat-box { padding: 15px; border: 1px solid #ccc; border-radius: 5px; }
        button { padding: 10px 20px; margin: 5px; font-size: 16px; }
        .issues { color: red; margin: 10px; }
    </style>
</head>
<body>
    <h1>Gym Posture Trainer</h1>
    
    <video id="video" autoplay muted></video>
    <canvas id="canvas" style="display:none;"></canvas>
    
    <div>
        <button onclick="startCamera()">Start Camera</button>
        <button onclick="stopCamera()">Stop Camera</button>
        <button onclick="resetCounters()">Reset Counters</button>
    </div>

    <div class="stats">
        <div class="stat-box">
            <h3>Rep Counts</h3>
            <div>Curls: <span id="curl-count">0</span></div>
            <div>Squats: <span id="squat-count">0</span></div>
            <div>Push-ups: <span id="pushup-count">0</span></div>
        </div>
        
        <div class="stat-box">
            <h3>Angles</h3>
            <div>Elbow: <span id="elbow-angle">-</span>°</div>
            <div>Knee: <span id="knee-angle">-</span>°</div>
            <div>Hip: <span id="hip-angle">-</span>°</div>
            <div>Body: <span id="body-angle">-</span>°</div>
        </div>
    </div>

    <div class="stat-box">
        <h3>Form Issues</h3>
        <div id="form-issues" class="issues">No issues detected</div>
    </div>

    <script>
        let video = document.getElementById('video');
        let canvas = document.getElementById('canvas');
        let ctx = canvas.getContext('2d');
        let stream = null;
        let analyzing = false;

        async function startCamera() {
            try {
                // Check if running on localhost or HTTPS
                if (location.protocol !== 'https:' && location.hostname !== 'localhost' && location.hostname !== '127.0.0.1') {
                    alert('Camera requires HTTPS or localhost. Try accessing via https:// or localhost');
                    return;
                }
                
                const constraints = {
                    video: {
                        width: { ideal: 640 },
                        height: { ideal: 480 },
                        facingMode: 'user'
                    }
                };
                
                stream = await navigator.mediaDevices.getUserMedia(constraints);
                video.srcObject = stream;
                video.onloadedmetadata = () => {
                    canvas.width = video.videoWidth;
                    canvas.height = video.videoHeight;
                    startAnalysis();
                };
            } catch (err) {
                console.error('Camera error:', err);
                alert(`Camera error: ${err.message}. Try using localhost or HTTPS.`);
            }
        }

        function stopCamera() {
            if (stream) {
                stream.getTracks().forEach(track => track.stop());
                stream = null;
            }
            analyzing = false;
        }

        function startAnalysis() {
            analyzing = true;
            analyzeFrame();
        }

        async function analyzeFrame() {
            if (!analyzing || !stream) return;

            ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
            const imageData = canvas.toDataURL('image/jpeg', 0.7);
            
            try {
                const response = await fetch('/analyze_frame', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ image: imageData })
                });

                const result = await response.json();
                updateUI(result);
            } catch (err) {
                console.error('Analysis error:', err);
            }

            setTimeout(analyzeFrame, 1000); // Analyze every second
        }

        function updateUI(result) {
            if (result.pose_detected) {
                document.getElementById('curl-count').textContent = result.reps.curl;
                document.getElementById('squat-count').textContent = result.reps.squat;
                document.getElementById('pushup-count').textContent = result.reps.pushup;

                document.getElementById('elbow-angle').textContent = result.angles.elbow;
                document.getElementById('knee-angle').textContent = result.angles.knee;
                document.getElementById('hip-angle').textContent = result.angles.hip;
                document.getElementById('body-angle').textContent = result.angles.body;

                const issuesDiv = document.getElementById('form-issues');
                if (result.issues.length > 0) {
                    issuesDiv.innerHTML = result.issues.map(issue => `⚠️ ${issue}`).join('<br>');
                } else {
                    issuesDiv.innerHTML = '✅ Good form!';
                }
            } else {
                document.getElementById('form-issues').innerHTML = '👤 No pose detected';
            }
        }

        async function resetCounters() {
            await fetch('/reset_counters', { method: 'POST' });
        }
    </script>
</body>
</html>
'''

@app.route('/')
def index():
    return render_template_string(HTML_TEMPLATE)

@app.route('/analyze_frame', methods=['POST'])
def analyze_frame():
    try:
        data = request.json
        image_data = data['image'].split(',')[1]
        image_bytes = base64.b64decode(image_data)
        
        nparr = np.frombuffer(image_bytes, np.uint8)
        frame = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        
        result = analyze_pose_logic(frame, 'all')
        return jsonify(result)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.route('/analyze', methods=['POST'])
def analyze():
    try:
        data = request.json
        image_bytes = base64.b64decode(data['image'])
        exercise = data.get('exercise', 'all')
        
        nparr = np.frombuffer(image_bytes, np.uint8)
        frame = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        
        result = analyze_pose_logic(frame, exercise)
        return jsonify(result)
        
    except Exception as e:
        return jsonify({'error': str(e)}), 400

@app.route('/reset_counters', methods=['POST'])
def reset_counters():
    global curl_counter, squat_counter, pushup_counter
    curl_counter = RepCounter(160, 40)
    squat_counter = RepCounter(100, 60)
    pushup_counter = RepCounter(100, 40)
    return jsonify({'success': True})

@app.route('/reset', methods=['POST'])
def reset():
    global curl_counter, squat_counter, pushup_counter
    curl_counter = RepCounter(160, 40)
    squat_counter = RepCounter(100, 60)
    pushup_counter = RepCounter(100, 40)
    return jsonify({'success': True})

if __name__ == '__main__':
    import os
    port = int(os.environ.get('PORT', 5000))
    
    print(f"Starting server on port {port}...")
    print(f"Visit: http://localhost:{port} or http://10.5.89.22:{port}")
    
    # Try HTTPS first, fallback to HTTP
    try:
        if os.path.exists('cert.pem') and os.path.exists('key.pem'):
            context = ('cert.pem', 'key.pem')
            print("Using HTTPS with SSL certificates")
            app.run(host='0.0.0.0', port=port, debug=True, ssl_context=context)
        else:
            print("SSL certificates not found, using HTTP")
            app.run(host='0.0.0.0', port=port, debug=True)
    except Exception as e:
        print(f"HTTPS failed: {e}, falling back to HTTP")
        app.run(host='0.0.0.0', port=port, debug=True)