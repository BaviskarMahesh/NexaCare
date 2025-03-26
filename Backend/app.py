from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials, messaging, firestore
import os

app = Flask(__name__)

FIREBASE_CRED_PATH = r"D:/flutter_projects/NexaCare/nexacare/Backend/nexacare-d797f-firebase-adminsdk-fbsvc-9f19a4ec40.json"
if not os.path.exists(FIREBASE_CRED_PATH):
    raise FileNotFoundError(f"Firebase credential file not found: {FIREBASE_CRED_PATH}")

cred = credentials.Certificate(FIREBASE_CRED_PATH)
if not firebase_admin._apps:
    firebase_admin.initialize_app(cred)

db = firestore.client()

@app.route('/send_notification', methods=['POST'])
def send_notification():
    try:
        if not request.is_json:
            return jsonify({"error": "Invalid JSON request"}), 400

        data = request.get_json()
        user_uid = data.get("user_uid")

        if not user_uid:
            return jsonify({"error": "User UID is required"}), 400

        print(f" Searching for user UID: {user_uid}")  # Debugging

        user_ref = db.collection("Attendant").document(user_uid).get()

        if not user_ref.exists:
            print(f" User UID {user_uid} not found in Firestore")  # Debugging
            return jsonify({"error": "User not found"}), 404

        user_data = user_ref.to_dict()
        fcm_token = user_data.get("fcmToken")

        if not fcm_token:
            print(f" FCM token not found for user UID {user_uid}")  # Debugging
            return jsonify({"error": "FCM token not found"}), 404

        title = data.get("title", "Emergency Alert")
        body = data.get("body", "A patient needs urgent help!")

        message = messaging.Message(
            notification=messaging.Notification(title=title, body=body),
            token=fcm_token
        )

        response = messaging.send(message)
        print(f"✅ Notification sent to {user_uid}: {response}")  # Debugging
        return jsonify({"success": True, "message_id": response})

    except messaging.UnregisteredError:
        return jsonify({"error": "FCM token is invalid or expired"}), 400

    except Exception as e:
        print(f"❌ Error: {str(e)}")  # Debugging
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)
