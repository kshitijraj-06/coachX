#!/usr/bin/env python3
"""
Pose Detection Server Configuration and Setup
"""

import os
import socket
import subprocess
import sys

def get_local_ip():
    """Get the local IP address of the machine"""
    try:
        # Connect to a remote server to get local IP
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
        return local_ip
    except Exception:
        return "127.0.0.1"

def check_dependencies():
    """Check if required Python packages are installed"""
    required_packages = [
        'flask',
        'opencv-python',
        'mediapipe',
        'numpy'
    ]
    
    missing_packages = []
    for package in required_packages:
        try:
            __import__(package.replace('-', '_'))
        except ImportError:
            missing_packages.append(package)
    
    return missing_packages

def install_dependencies(packages):
    """Install missing packages"""
    if packages:
        print(f"Installing missing packages: {', '.join(packages)}")
        try:
            subprocess.check_call([sys.executable, '-m', 'pip', 'install'] + packages)
            print("✅ All dependencies installed successfully!")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to install dependencies: {e}")
            return False
    return True

def generate_ssl_certificates():
    """Generate self-signed SSL certificates for HTTPS"""
    try:
        # Check if certificates already exist
        if os.path.exists('cert.pem') and os.path.exists('key.pem'):
            print("✅ SSL certificates already exist")
            return True
        
        # Generate self-signed certificate
        subprocess.run([
            'openssl', 'req', '-x509', '-newkey', 'rsa:4096', 
            '-keyout', 'key.pem', '-out', 'cert.pem', 
            '-days', '365', '-nodes',
            '-subj', '/C=US/ST=State/L=City/O=Organization/CN=localhost'
        ], check=True, capture_output=True)
        
        print("✅ SSL certificates generated successfully!")
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("⚠️  OpenSSL not found or failed. Server will run on HTTP only.")
        return False

def main():
    print("🏋️  Gym Paglu Pose Detection Server Setup")
    print("=" * 50)
    
    # Get local IP
    local_ip = get_local_ip()
    print(f"📍 Local IP Address: {local_ip}")
    
    # Check dependencies
    print("\n📦 Checking dependencies...")
    missing = check_dependencies()
    
    if missing:
        print(f"❌ Missing packages: {', '.join(missing)}")
        if input("Install missing packages? (y/n): ").lower() == 'y':
            if not install_dependencies(missing):
                return
        else:
            print("❌ Cannot proceed without required packages")
            return
    else:
        print("✅ All dependencies are installed")
    
    # Generate SSL certificates
    print("\n🔒 Setting up SSL certificates...")
    ssl_available = generate_ssl_certificates()
    
    # Configuration summary
    print("\n⚙️  Server Configuration:")
    print(f"   Local IP: {local_ip}")
    print(f"   Default Port: 5000")
    print(f"   SSL Support: {'Yes' if ssl_available else 'No'}")
    
    # Update Flutter configuration
    print(f"\n📱 Update your Flutter app configuration:")
    print(f"   - Update poseAnalyzer.dart server URLs")
    print(f"   - Use: http://{local_ip}:5000")
    if ssl_available:
        print(f"   - Or: https://{local_ip}:5000")
    
    print(f"\n🚀 To start the server, run:")
    print(f"   python web_camera.py")
    
    print(f"\n🌐 Access URLs:")
    print(f"   - Local: http://localhost:5000")
    print(f"   - Network: http://{local_ip}:5000")
    if ssl_available:
        print(f"   - HTTPS: https://{local_ip}:5000")

if __name__ == "__main__":
    main()