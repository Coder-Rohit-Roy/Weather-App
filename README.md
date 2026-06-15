# 🌤️ SkyFlow Weather: Cyber-Natural Ecosystem

[![Flutter Version](https://img.shields.io/badge/Flutter-3.11.3%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.11%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![API Provider](https://img.shields.io/badge/API-OpenWeatherMap-FF6F00?style=for-the-badge&logo=openapi&logoColor=white)](https://openweathermap.org/)

Forget flat, cookie-cutter weather interfaces. **SkyFlow Weather** is a high-performance, cross-platform engine built with **Flutter** and **Dart** that treats environmental data like an immersive visual stream[cite: 1]. Running natively on **Android, iOS, and Web (Chrome)** from a single, rock-solid codebase[cite: 1], SkyFlow breaks down real-time weather metrics, 7-day extended forecasts, and high-value atmospheric health data without breaking a sweat[cite: 1, 2].

---

## 🌌 The Design Identity: "Cyber-Natural" 

Traditional apps are cluttered and uninspired[cite: 1]. SkyFlow breaks the mold by merging deep technical software aesthetics with organic data visualization:

*   **Deep Space Foundations:** Say goodbye to blinding white screens or muddy gray filters. SkyFlow uses sharp, low-luminance deep space canvas hues (`#0F172A` and `#0B0E14`) to anchor presentation layers and save battery life.
*   **Neon Glow Accents:** Critical meteorological shifts draw instantaneous focal priority using highly saturated, radiant signatures, like **Hot Pink (`#FF006E`)** for soaring temperatures and **Neon Cyan (`#00F5D4`)** for ambient moisture[cite: 1, 2].
*   **Glassmorphic Interfaces:** Structural cards (`GlassCard`) float across the UI using semi-transparent layers, ultra-thin high-contrast white boundaries (10% opacity), and deep background blur filters to build a high-end tactile experience[cite: 1, 2].

---

## ⚡ Core Engineering Feats

*   **☀️ Custom Painter Sun Arc:** Rather than recycling generic, static graphics, SkyFlow manipulates Flutter's native canvas (`CustomPainter`) to trace the sun's path using real-time trigonometry (`math.cos`/`math.sin`) mapped against localized sunrise and sunset UNIX timestamps.
*   **🍃 Microscopic Air Quality Index:** Delivers a fully interactive, beautifully color-coded ambient risk slider that charts micro-particulates like `PM2.5`, `PM10`, trace `CO`, `O₃`, and `NO₂` concentrations[cite: 1, 2].
*   **📍 Hyper-Local Permission Cascades:** Hooks into hardware-level GPS location engines gracefully[cite: 1, 2]. If coordinates access is restricted, the app immediately shifts to safe, informative recovery views without crashing.
*   **🔍 Globally Throttled Geocoding:** Features an asynchronous city discovery bar with real-time autocomplete suggestions, matching flags, and custom on-disk storage sorting to manage your favorited metropolises offline[cite: 1, 2].

---

## 🏗️ Decoupled 4-Layer Architecture

SkyFlow rejects monolithic "spaghetti code" in favor of a strictly structured, modular model inspired by classic MVC paradigms but built specifically for Flutter's reactive widget tree[cite: 1]:

*   **View Layer (UI Components):** Handles screen layouts, micro-animations, and user inputs[cite: 1, 2]. It remains completely isolated from raw API processing variables or networking endpoints[cite: 2].
*   **State Layer (Controller Hub):** A centralized event hub powered by the **Provider Pattern** (`WeatherProvider`)[cite: 1, 2]. It leverages explicit `notifyListeners()` parameters to perform pinpoint, atomic UI updates only where visual values change, boosting frame counts[cite: 1, 2].
*   **Service Layer (Drivers Pipeline):** Executes low-level external asynchronous networking operations (`http` requests) and bridges hardware location systems securely[cite: 1, 2].
*   **Model Layer (Data Nodes):** Enforces rigid data validation via factory deserialization (`fromJson`) to guarantee the application layer remains entirely immune to unexpected third-party API payload structural modifications[cite: 1, 2].

---

## 🛠️ Production Tech Stack

| Component Element | Production Tooling | Application Duty |
| :--- | :--- | :--- |
| **UI Framework** | **Flutter 3.11.3+** | Structural layouts, cross-compilation, and core graphics orchestration[cite: 1]. |
| **Language** | **Dart 3.x** | Strong-typed architecture, strict null-safety, and asynchronous microtasks[cite: 1, 2]. |
| **State Engine** | **Provider ^6.1.2** | Centralized dependency injection and reactive state mutation distribution[cite: 1, 2]. |
| **API Network** | **http ^1.2.2** | Low-latency HTTP client pulling down live data maps from OpenWeatherMap endpoints[cite: 1]. |
| **Data Cache** | **SharedPreferences** | Local on-disk key-value synchronization to save custom unit parameters and user favorites[cite: 1, 2]. |

---

## ⚙️ Up and Running in 60 Seconds

### Prerequisite Checklist
*   Flutter SDK $\ge$ 3.11.3 installed on your development machine[cite: 1].
*   Dart SDK $\ge$ 3.11 matching the current Flutter bundle[cite: 2].
*   An active developer access token from [OpenWeatherMap](https://openweathermap.org/api)[cite: 1].

### Fire Up the Engine

1.  **Clone the Repository:**
```bash
    git clone [https://github.com/yourusername/skyflow_weather.git](https://github.com/yourusername/skyflow_weather.git)
    cd skyflow_weather
    ```
2.  **Pull Native Packages:**
```bash
    flutter pub get
    ```
3.  **Inject the API Key:**
Drop your authorization credentials securely inside `lib/utils/constants.dart`[cite: 1]:
```dart
    class AppConstants {
      static const String apiKey = 'YOUR_SECRET_API_KEY_HERE';
      static const String baseUrl = '[https://api.openweathermap.org/data/2.5](https://api.openweathermap.org/data/2.5)';
      static const String geoUrl = '[https://api.openweathermap.org/geo/1.0](https://api.openweathermap.org/geo/1.0)';
    }
    ```
4.  **Launch the Environment:**
```bash
    # Run dynamically on an attached hardware phone, emulator, or web browser canvas
    flutter run
    ```

> 💡 **No API key handy? No worries.** SkyFlow has an integrated mathematical mock data pipeline[cite: 1, 2]. If the API token variable remains unconfigured or the device is completely offline, the system automatically spins up a coherent testing engine so you can explore the entire UI ecosystem immediately[cite: 1, 2].

---

## 🧪 Testing and Fault Resilience

Don't guess if your application layers are safe. Validate the architecture instantly:
*   **Layout Assertions:** Run automated smoke validation via `test/widget_test.dart` to confirm dashboard layout mounting trees and main AppBars compile accurately under mock provider states[cite: 1, 2].
*   **Graceful Fault Isolation:** SkyFlow catches connection drops, invalid keys, or request time-outs smoothly, serving crisp, human-readable instructions instead of crashing out to empty screens[cite: 1, 2].

```bash
# Execute the automated testing framework
flutter test
