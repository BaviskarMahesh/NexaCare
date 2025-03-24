from flask import Flask, request, jsonify
import firebase_admin  # type: ignore
from firebase_admin import credentials, messaging
import os

app = Flask(__name__)

# 🔹 Load Firebase Admin SDK (Ensure correct path)
FIREBASE_CRED_PATH = r"D:\flutter_projects\NexaCare\nexacare\Backend\nexacare-d797f-firebase-adminsdk-fbsvc-9f19a4ec40.json"
if not os.path.exists(FIREBASE_CRED_PATH):
    raise FileNotFoundError(f"Firebase credential file not found: {FIREBASE_CRED_PATH}")

cred = credentials.Certificate(FIREBASE_CRED_PATH)
if not firebase_admin._apps:
    firebase_admin.initialize_app(cred)

# 🔹 Route to send FCM notification
@app.route('/send_notification', methods=['POST'])
def send_notification():
    try:
        data = request.get_json()
        fcm_token = data.get("fcm_token")
        title = data.get("title", "🚨 Emergency Alert")
        body = data.get("body", "A patient needs urgent help!")

        if not fcm_token:
            return jsonify({"error": "FCM token is required"}), 400

        print(f"📡 Sending Notification to Token: {fcm_token}")

        # 🔹 Create and send the notification
        message = messaging.Message(
            notification=messaging.Notification(title=title, body=body),
            token=fcm_token
        )

        response = messaging.send(message)
        print(f"✅ Notification Sent: {response}")
        return jsonify({"success": True, "message_id": response})

    except messaging.UnregisteredError:
        return jsonify({"error": "FCM token is invalid or expired"}), 400

    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)