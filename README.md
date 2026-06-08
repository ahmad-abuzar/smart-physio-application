# Smart Physio

Smart Physio is an AI-powered muscle pain relief and exercise recommendation system built with Flutter. It utilizes on-device pose detection and machine learning to provide users with tailored physiotherapy exercises, real-time form correction, and progress tracking to aid in their recovery journey.

## Features

- **Pain Assessment**: Interactive body map and questionnaire to identify and log pain areas, types, and severity.
- **AI Exercise Recommendation**: Machine learning-based system that suggests specific exercises tailored to the user's pain profile, age, and physical capabilities.
- **Real-Time Pose Detection**: Utilizes Google ML Kit to monitor exercise form in real-time, providing immediate visual and audio feedback to ensure safe and correct movements.
- **Progress Tracking**: Detailed dashboards to track workout history, pain trends, form scores, and milestones.
- **Voice Guidance**: Text-to-speech integration for hands-free exercise instructions and posture corrections.
- **Personalized Profiles**: Manage health conditions, exercise preferences, and track your individual recovery journey.

## Requirements

- Flutter SDK (3.x)
- Node.js (for backend services)
- Python 3.x (for ML API)
- MongoDB
- Android Studio / Xcode (for mobile development and compilation)
- A physical device with camera support (highly recommended for pose detection features)

## Installation

To get a local copy up and running, follow these steps:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/smart_physio.git
   cd smart_physio
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Set up the Node.js backend:**
   ```bash
   cd backend
   npm install
   # Create a .env file based on environment requirements (MONGODB_URI, JWT_SECRET, etc.)
   npm run dev
   ```

4. **Set up the Python ML API:**
   ```bash
   cd ../ai_model
   python -m venv venv
   
   # Activate the virtual environment:
   # On macOS/Linux:
   source venv/bin/activate
   # On Windows:
   # venv\Scripts\activate
   
   pip install -r requirements.txt
   python api/app.py
   ```

5. **Run the Flutter app:**
   Open a new terminal window, navigate back to the root `smart_physio` directory, and run:
   ```bash
   flutter run
   ```

## Usage

1. **Onboarding & Assessment:** Launch the app, create an account, and complete your first pain assessment using the interactive body map and guided questionnaire.
2. **Review Recommendations:** Browse the AI-curated list of exercises tailored specifically to your assessment and health profile.
3. **Start an Exercise Session:** Select an exercise and safely position your device so your full body is visible within the camera frame. Follow the real-time visual skeleton overlays and audio cues.
4. **Track Progress:** Check the progress dashboard regularly to monitor your form improvements, consistency, and pain reduction over time.

## Contributing Guidelines

Contributions make the open-source community an amazing place to learn, inspire, and create. Any contributions you make to Smart Physio are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure your code follows the existing style guidelines and passes any existing tests before submitting your Pull Request.

## License

Distributed under the MIT License. See `LICENSE` for more information.

---
*Disclaimer: Smart Physio is designed to assist with physical therapy and exercise recommendations. It does not replace professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.*
