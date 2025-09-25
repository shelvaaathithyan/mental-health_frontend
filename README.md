# Neptune

Neptune is an AI-assisted mental health companion that combines CBT/DBT style prompts with voice input/output. The Flutter app listens to the user, sends conversation history to Google Gemini, and replies with natural speech.

## Prerequisites

- Flutter 3.4.0 or newer
- Dart 3.4.0 or newer (bundled with Flutter)
- A Google AI Studio API key with access to the Gemini 2.5 Flash family
- For Windows desktop builds: Visual Studio 2022 with the **Desktop development with C++** workload, Windows 10/11 SDK, and MSVC v143+ build tools

## Setup

1. Install Flutter and ensure `flutter doctor` reports no issues.
2. Install project dependencies:
	 ```powershell
	 flutter pub get
	 ```
3. Configure the environment file:
	 - Copy the root `.env` file (or create one) and set `GEMINI_API_KEY` to your Google AI Studio key. Do **not** surround the value with quotes.
	 - Example:
		 ```properties
		 GEMINI_API_KEY=ya29.a0Af...
		 ```

## Running the app

- Web (recommended for quickest testing):
	```powershell
	flutter run -d chrome
	```
- Windows desktop:
	```powershell
	flutter run -d windows
	```
	Make sure Visual Studio is installed as described above.

## Gemini models

The app currently targets the following Gemini models:

- `gemini-2.5-flash-native-audio-preview-09-2025` (primary)
- `gemini-2.5-flash-exp-native-audio-thinking-dialog` (fallback)

Requests are routed through the Google Generative Language API with text-only responses. Adjust `ChatController.primaryModel` and `ChatController.fallbackModel` if you need different models.

## Troubleshooting

- **Missing API key**: Verify `GEMINI_API_KEY` is set in `.env` and restart the app so the new value loads.
- **Quota errors**: Ensure your Google AI Studio project has sufficient quota for the selected models.
- **Windows toolchain errors**: Run `flutter doctor` after installing Visual Studio to confirm the MSVC toolchain is detected.

