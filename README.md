# Journal2Life — Affective Computing & AI-Driven Wellbeing Journal

<p align="center">
  <img src="assets/journal2life_logo.png" alt="Journal2Life Logo" width="160" />
</p>

<p align="center">
  <strong>An ethical, cross-platform personal journaling platform combining linguistic psychometrics, affective computing, and large language models to foster emotional self-awareness and mental wellbeing.</strong>
</p>

<p align="center">
  <a href="https://journal2life.web.app/"><img src="https://img.shields.io/badge/Live_Demo-journal2life.web.app-4285F4?style=for-the-badge&logo=google-chrome&logoColor=white" alt="Live Demo" /></a>
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
  <a href="https://dart.dev/"><img src="https://img.shields.io/badge/Dart-3.9+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" /></a>
  <a href="https://firebase.google.com/"><img src="https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore%20%7C%20Hosting-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" /></a>
  <a href="https://ai.google.dev/"><img src="https://img.shields.io/badge/AI-Gemini%202.5%20Flash-8E75B2?style=for-the-badge&logo=google&logoColor=white" alt="Gemini AI" /></a>
  <a href="#-supported-languages-i18n"><img src="https://img.shields.io/badge/Languages-12%20Locales-brightgreen?style=for-the-badge" alt="Multi-language" /></a>
  <a href="#-responsible-ai-ethics--clinical-safety-guardrails"><img src="https://img.shields.io/badge/Responsible_AI-Ethics_%26_Safety_First-critical?style=for-the-badge" alt="Responsible AI" /></a>
</p>

---

## 📖 Table of Contents

- [Executive Summary & Vision](#-executive-summary--vision)
- [Key Features](#-key-features)
- [Live Demo & Distribution](#-live-demo--distribution)
- [Scientific Foundations & Linguistic Psychometrics](#-scientific-foundations--linguistic-psychometrics)
- [Psychometric Taxonomy & Inference Pipeline](#-psychometric-taxonomy--inference-pipeline)
- [Responsible AI, Ethics & Clinical Safety Guardrails](#-responsible-ai-ethics--clinical-safety-guardrails)
- [Data Governance, Sovereignty & Privacy](#-data-governance-sovereignty--privacy)
- [Societal Impact & Universal Accessibility](#-societal-impact--universal-accessibility)
- [App Preview](#-app-preview)
- [System Architecture & Tech Stack](#-system-architecture--tech-stack)
- [Project Directory Structure](#-project-directory-structure)
- [Supported Languages (i18n)](#-supported-languages-i18n)
- [Getting Started & Reproducibility](#-getting-started--reproducibility)
  - [Prerequisites](#prerequisites)
  - [Local Installation](#local-installation)
  - [Firebase Configuration](#firebase-configuration)
  - [Gemini Model & API Configuration](#gemini-model--api-configuration)
- [Deployment & Build Pipelines](#-deployment--build-pipelines)
  - [Web Production (Firebase Hosting)](#web-production-firebase-hosting)
  - [Android APK Build](#android-apk-build)
- [Academic & Research Roadmap](#-academic--research-roadmap)
- [Contributing & Code of Conduct](#-contributing--code-of-conduct)
- [License & Acknowledgments](#-license--acknowledgments)

---

## 🌟 Executive Summary & Vision

**Journal2Life** is an open-access, cross-platform affective computing tool designed to bridge human introspective writing with real-time natural language psychometrics. Built with **Flutter** and powered by **Google Gemini 2.5 Flash**, the platform transforms expressive daily journaling into actionable emotional insights.

In clinical and cognitive psychology, expressive writing has been demonstrated to reduce ruminative thinking, modulate sympathetic nervous system arousal, and foster cognitive reappraisal. Journal2Life operationalizes these psychological paradigms into an everyday digital companion that:
1. **Empowers Self-Reflection:** Allows individuals to externalize complex life experiences through text and voice dictation.
2. **Deconstructs Emotional Syntax:** Identifies cognitive distortions, protective factors, and acute stress signals without algorithmic judgment.
3. **Preserves Absolute Data Dignity:** Maintains zero-retention AI inference contracts and cryptographic, user-bounded data isolation.

> **Research Statement:** Journal2Life does not replace clinical therapy or medical interventions. It is engineered as a preventative, reflective digital biomarker tool aimed at early self-awareness and longitudinal affective tracking.

---

## ✨ Key Features

### ✍️ Multimodal Journaling (Voice & Text)
- **Fluid Text & Speech-to-Text Input:** Native voice dictation powered by `speech_to_text`, removing barriers for non-typists or individuals experiencing motor fatigue.
- **Immediate Empathetic Synthesis:** Real-time generation of an empathetic, first-person cognitive summary tailored to the writer's language and mood.

### 🧠 Grounded Psychometric Analysis
- Evaluates entries across **26 clinical and wellbeing dimensions** (13 positive protective traits and 13 risk vulnerability indicators).
- Enforces **verbatim textual evidence citation** (`evidencia_textual`) for every detected classification to prevent model hallucination.
- Quantifies detected dimensions using **granular intensity/risk scales (1–5)**.

### 📊 Longitudinal Affective Analytics & Data Visualization
- **Dynamic Emotional Ratio Tracking:** Visualizes positive-to-negative affect ratios over time using `fl_chart` and `syncfusion_flutter_charts`.
- **Topmatic Frequency Mapping:** Aggregates recurring psychological themes (e.g., self-worth, academic stressors, interpersonal friction, mindfulness).
- **Time-Series Analysis:** Empowers users to observe cyclical behavioral patterns and emotional inflection points.

### 🌐 Cross-Cultural & Multilingual Localization (12 Languages)
- Full localized UI and dynamic prompt localization across 12 major world languages, accounting for cultural idioms and semantic variations in emotion expression.
- Persistent user locale synchronization across cloud Firestore and local device preferences.

### 📲 Responsive Cross-Platform Deployment
- Seamless single-codebase parity across **Web (Progressive Web App)** and **Android** (with architectural support for iOS and Desktop).
- Automated APK version negotiation and client notification via **Firebase Remote Config**.
- Complete data portability via **CSV export and OS-level sharing**.

---

## 🚀 Live Demo & Distribution

- 🌐 **Web Application:** [https://journal2life.web.app/](https://journal2life.web.app/)
- 📱 **Android Mobile Client:** Direct APK download integrated via web landing page and remote config channels.

---

## 🔬 Scientific Foundations & Linguistic Psychometrics

The architecture of Journal2Life is rooted in established paradigms across cognitive linguistics, positive psychology, and affective computing:

1. **Pennebaker’s Expressive Writing Paradigm & Linguistic Psychology:**
   - Decades of research initiated by Dr. James W. Pennebaker demonstrate that the selective use of cognitive words (causation, insight) and affective markers correlates directly with psychological coping and immune functioning.
   - Journal2Life leverages large language models as psychometric parsing engines to identify these exact markers in naturalistic user prose.

2. **Martin Seligman’s PERMA Model of Positive Psychology:**
   - The platform’s 13 protective dimensions explicitly capture elements of PERMA: **P**ositive Emotions (gratitude, optimism), **E**ngagement (sports/art, flow), **R**elationships (healthy friendships, conflict resolution), **M**eaning (altruism, spiritual growth), and **A**ccomplishment (personal achievements, overcoming adversity).

3. **Grounded Extraction & Anti-Hallucination Constraints:**
   - Unlike generic generative chatbots that may confabulate emotional states, Journal2Life's model prompt strictly enforces **evidence-grounded extraction**:
     $$\forall \, d \in \text{Detections}, \quad \text{EvidenciaTextual}(d) \subseteq \text{UserNarrative}$$
   - Any detected dimension must be supported by an exact verbatim excerpt from the user’s text alongside a calibrated risk score (1–5).

---

## 🧬 Psychometric Taxonomy & Inference Pipeline

The prompt pipeline (`GeminiService`) classifies prose against a dual-axis taxonomy:

```
                            User Journal Entry (Prose / Voice)
                                           │
                                           ▼
                      ┌─────────────────────────────────────────┐
                      │   Gemini 2.5 Flash Ingestion Engine     │
                      │  (Temperature: 0.2, TopP: 0.8, JSON)    │
                      └────────────────────┬────────────────────┘
                                           │
                 ┌─────────────────────────┴─────────────────────────┐
                 ▼                                                   ▼
     13 Wellbeing Dimensions                             13 Risk & Vulnerability Factors
 ┌──────────────────────────────────────┐            ┌──────────────────────────────────────┐
 │ • Gratitude (gratitude)              │            │ • Depression (depression)            │
 │ • Motivation (motivation)            │            │ • Anxiety (anxiety)                  │
 │ • Self-Love (self_love)              │            │ • Chronic Stress (chronic_stress)    │
 │ • Healthy Friendships                │            │ • Bullying (bullying)                │
 │ • Overcoming Adversity (overcoming)  │            │ • Cyberbullying (cyberbullying)      │
 │ • Optimism (optimism)                │            │ • Relational Discord (relationship)  │
 │ • Mindfulness (mindfulness)          │            │ • Academic Issues (academic_problems)│
 │ • Conflict Resolution                │            │ • Body Image Concerns (body_image)   │
 │ • Recreation & Fun (fun)             │            │ • Addictions (addictions)            │
 │ • Altruism (altruism)                │            │ • Traumatic Events (traumatic_events)│
 │ • Achievements (personal_achievement)│            │ • Paranoia / Distrust (distrust)     │
 │ • Spiritual Growth (spiritual_growth)│            │ • Interpersonal Abuse (abuse)        │
 │ • Sports & Creative Art (sports_art) │            │ • Sexual Harassment                  │
 └──────────────────────────────────────┘            └──────────────────────────────────────┘
                 │                                                   │
                 └─────────────────────────┬─────────────────────────┘
                                           │
                                           ▼
                      ┌─────────────────────────────────────────┐
                      │          Structured JSON Output         │
                      │  - First-person empathetic feedback     │
                      │  - Verbatim citations & severity scores │
                      │  - Critical safety flag (alertas_crit)  │
                      └─────────────────────────────────────────┘
```

---

## 🛡️ Responsible AI, Ethics & Clinical Safety Guardrails

Because algorithmic feedback on mental states carries profound ethical implications, Journal2Life incorporates stringent safety boundaries:

### 1. Explicit Non-Clinical Boundary
> [!IMPORTANT]
> **Clinical Disclaimer:** Journal2Life is not a medical device, nor does it provide clinical diagnoses, psychiatric triage, or therapeutic treatment. It is an introspective wellness journal. Users experiencing persistent affective distress are proactively advised to seek licensed clinical consultation.

### 2. Acute Crisis Detection & Escalation Architecture
- The system checks for acute indicators of self-harm, severe violence, or exploitation via the `alertas_criticas` Boolean flag.
- Designed to trigger automated safety warnings and hotlines (e.g., 988 Suicide & Crisis Lifeline in the US, and regional emergency mental health contacts globally).

### 3. Cross-Cultural & Linguistic Bias Mitigation
- Emotion expressions differ across cultural and linguistic typologies. For instance, idioms of distress in collectivist cultures often present somatically rather than through direct affective labels.
- The prompt explicitly conditions the model on the writer's language (`languageCode`), instructing the parser to interpret vernacular idioms within their native cultural context while mapping to standardized analytical keys.

### 4. Deterministic Temperature & Safety Controls
- Generation temperature is constrained to **0.2** (with `topP = 0.8`), ensuring consistent, reproducible psychometric extraction while avoiding volatile or erratic responses.

---

## 🔒 Data Governance, Sovereignty & Privacy

Personal reflections constitute the most intimate category of human data. The system enforces strict architectural safeguards:

* **Zero-Training Guarantee on User Data:**
  In compliance with enterprise Google Cloud / Generative Language API terms, user narrative prompts and extracted outputs are **never** utilized to train, retrain, or improve foundation models.
* **Cryptographic Identity & Row-Level Authorization:**
  Access control is enforced at the database kernel level through Cloud Firestore rules:
  ```javascript
  match /entries/{entryId} {
    allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
    allow create: if request.auth != null && request.auth.uid == request.resource.data.userId;
  }
  ```
  Neither multi-tenancy leakage nor cross-account access is structurally possible.
* **Data Sovereignty & Portability:**
  Users retain absolute sovereignty over their intellectual and emotional history. The client provides full local **CSV export** capabilities and supports immediate account and data deletion in alignment with GDPR ("Right to be Forgotten") and CCPA mandates.

---

## 🌍 Societal Impact & Universal Accessibility

1. **Democratization of Reflective Digital Health:**
   - Traditional therapy and guided wellbeing tools are cost-prohibitive for vast populations globally. Journal2Life is 100% free and open, eliminating financial barriers to emotional self-reflection.
2. **Global Reach Across 12 Languages:**
   - Native localization covers **~4.5+ billion native speakers** across English, Spanish, French, German, Portuguese, Italian, Russian, Arabic, Bengali, Hindi, Japanese, and Chinese.
3. **Universal Device & Bandwidth Accessibility:**
   - Implemented as a lightweight Progressive Web App (PWA) and an efficient Android client, running smoothly on low-end devices and modest mobile connections without requiring expensive flagship hardware.
4. **Motor & Neurodivergent Accessibility:**
   - Real-time speech-to-text dictation facilitates access for users with repetitive strain injuries, motor disabilities, ADHD, or dyslexia who find manual typing cognitively exhausting.

---

## 📱 App Preview

<p align="center">
  <img src="flutter_01.png" alt="Home Screen" width="23%" />
  <img src="flutter_02.png" alt="Journal Editor" width="23%" />
  <img src="flutter_03.png" alt="AI Analysis Result" width="23%" />
  <img src="flutter_04.png" alt="Statistics & Charts" width="23%" />
</p>

---

## 🛠️ System Architecture & Tech Stack

```
 ┌────────────────────────────────────────────────────────────────────────┐
 │                           PRESENTATION LAYER                           │
 │        Flutter Web (PWA) / Android Client (Material 3 Theme)           │
 │  ┌───────────────────────┬────────────────────────┬─────────────────┐  │
 │  │      Home Feed        │   Diary Voice Editor   │  Visual Stats   │  │
 │  │  (Entries Stream)     │   (Speech-to-Text)     │   (FL / Charts) │  │
 │  └───────────────────────┴────────────────────────┴─────────────────┘  │
 └───────────────────────────────────┬────────────────────────────────────┘
                                     │
 ┌───────────────────────────────────▼────────────────────────────────────┐
 │                           SERVICES & STATE                             │
 │  ┌─────────────────┬──────────────────┬──────────────┬──────────────┐  │
 │  │   AuthService   │  GeminiService   │ RemoteConfig │ EasyLocalize │  │
 │  │ (Firebase/OAuth)│ (Affective NLP)  │ (OTA Update) │ (12 Locales) │  │
 │  └─────────────────┴──────────────────┴──────────────┴──────────────┘  │
 └──────────────────┬─────────────────────────────────┬───────────────────┘
                    │                                 │
 ┌──────────────────▼──────────────┐   ┌──────────────▼───────────────────┐
 │       FIREBASE BACKEND          │   │      COGNITIVE / AI ENGINE       │
 │ • Firebase Authentication       │   │ • Google Gemini 2.5 Flash API    │
 │ • Cloud Firestore (User Scoped) │   │ • Zero-shot structured JSON      │
 │ • Firebase Hosting (Global CDN) │   │ • Textual grounding verification │
 └─────────────────────────────────┘   └──────────────────────────────────┘
```

### Technology Matrix

| Layer | Component | Specification / Version |
| :--- | :--- | :--- |
| **Client Framework** | Flutter | SDK `^3.9.2` (Dart 3.9+) |
| **State & Localization** | Provider / EasyLocalization | `provider: ^6.1.2`, `easy_localization: ^3.0.5` |
| **Speech Processing** | Native Speech Engine | `speech_to_text: ^7.3.0` |
| **Data Analytics** | Visual Graphing Engines | `fl_chart: ^0.70.0`, `syncfusion_flutter_charts: ^31.1.22` |
| **AI Ingestion** | Google Generative Language | Gemini 2.5 Flash (`generativelanguage.googleapis.com`) |
| **Identity & Storage** | Google Firebase | `firebase_auth: ^6.1.0`, `cloud_firestore: ^6.0.2` |
| **Remote Orchestration**| Firebase Remote Config | `firebase_remote_config: ^6.0.2` |
| **Data Export** | Structured Document Engine | `csv: ^6.0.0`, `share_plus: ^12.0.0` |

---

## 📂 Project Directory Structure

```bash
journaltwolife/
├── android/                 # Native Android runner, Gradle build scripts, manifest
├── assets/
│   ├── images/              # Vectors, logos, and UI illustration assets
│   ├── langs/               # 12 standardized JSON i18n localization dictionaries
│   │   ├── en.json          # English reference dictionary
│   │   ├── es.json          # Spanish reference dictionary
│   │   └── ...              # 10 additional language dictionaries
│   └── journal2life_logo.png
├── ios/                     # Native iOS CocoaPods & Runner configuration
├── lib/
│   ├── firebase_options.dart# Auto-generated Firebase client credentials
│   ├── main.dart            # Bootstrap, Path URL strategy, i18n & Remote Config
│   ├── screens/             # Modular presentation views
│   │   ├── about_page.dart          # Platform mission and feature documentation
│   │   ├── diary_editor_page.dart   # Text/Voice editor with live Gemini inference
│   │   ├── forgot_password_page.dart# Self-serve credential recovery
│   │   ├── home_page.dart           # Reactive chronological entry stream
│   │   ├── login_page.dart          # OAuth & Email authentication
│   │   ├── profile_page.dart        # Account settings & language sync
│   │   ├── settings_page.dart       # Preferences & theme toggles
│   │   ├── sign_up_page.dart        # Registration & email verification flow
│   │   ├── statistics_page.dart     # Affective ratio & category trend charts
│   │   └── widgets/
│   │       └── app_drawer.dart      # Navigation drawer component
│   └── services/            # Decoupled business logic & external APIs
│       ├── auth_service.dart        # Firebase Auth & Google Sign-In routines
│       ├── gemini_service.dart      # Ingestion pipeline, psychometric prompt & parsing
│       ├── microsoft_service.dart   # Cognitive Services integration connector
│       ├── textrazor_service.dart   # Linguistic entity analysis connector
│       └── watson_service.dart      # Secondary NLU cognitive connector
├── web/                     # Web assembly/JS loader, manifest, and SEO metadata
├── firestore.rules          # Strict user-isolated database security rules
├── firestore.indexes.json   # Composite index definitions for Firestore queries
├── firebase.json            # Deployment routing, caching, and hosting rewrites
└── pubspec.yaml             # Dependency manifest and asset declarations
```

---

## 🌐 Supported Languages (i18n)

The platform features seamless, live locale switching across 12 linguistic families:

| Code | Language | Native Title | Script Direction | Dictionary File |
| :---: | :--- | :--- | :---: | :--- |
| `en` | English | English | LTR | `assets/langs/en.json` |
| `es` | Spanish | Español | LTR | `assets/langs/es.json` |
| `fr` | French | Français | LTR | `assets/langs/fr.json` |
| `de` | German | Deutsch | LTR | `assets/langs/de.json` |
| `pt` | Portuguese | Português | LTR | `assets/langs/pt.json` |
| `it` | Italian | Italiano | LTR | `assets/langs/it.json` |
| `ru` | Russian | Русский | LTR | `assets/langs/ru.json` |
| `ar` | Arabic | العربية | RTL | `assets/langs/ar.json` |
| `zh` | Chinese | 简体中文 | LTR | `assets/langs/zh.json` |
| `ja` | Japanese | 日本語 | LTR | `assets/langs/ja.json` |
| `hi` | Hindi | हिन्दी | LTR | `assets/langs/hi.json` |
| `bn` | Bengali | বাংলা | LTR | `assets/langs/bn.json` |

---

## 🚀 Getting Started & Reproducibility

### Prerequisites
- **Flutter SDK:** Version `3.9.2` or higher ([Installation Guide](https://docs.flutter.dev/get-started/install))
- **Dart SDK:** Version `3.9.0` or higher
- **Node.js & Firebase CLI:** `npm install -g firebase-tools`
- **Google Cloud Account:** With Generative Language API (Gemini) enabled

### Local Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/journal2life.git
   cd journal2life
   ```

2. **Fetch dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify toolchain health:**
   ```bash
   flutter doctor
   ```

### Firebase Configuration

1. Authenticate with the Firebase CLI:
   ```bash
   firebase login
   ```
2. Bind the local client to your Firebase instance using FlutterFire:
   ```bash
   flutterfire configure
   ```
3. Deploy Firestore database rules and index specifications:
   ```bash
   firebase deploy --only firestore:rules,firestore:indexes
   ```

### Gemini Model & API Configuration

To customize or supply your API credentials:
- Generate an API key in [Google AI Studio](https://aistudio.google.com/).
- Inject your key at build/runtime using Dart defines:
  ```bash
  flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
  ```
  *(Or configure the environment variable in `lib/services/gemini_service.dart`).*

---

## 💻 Running the Application

### Run on Web (Chrome)
```bash
flutter run -d chrome
```

### Run on Connected Android Device or Emulator
```bash
flutter run -d android
```

---

## 📦 Deployment & Build Pipelines

### Web Production (Firebase Hosting)

```bash
# 1. Compile optimized release bundle with clean path strategy
flutter build web --release

# 2. Deploy to global Firebase CDN
firebase deploy --only hosting
```
The application is pre-configured with SPA route rewriting and aggressive cache-control policies in `firebase.json`.

### Android APK Build

```bash
flutter build apk --release
```
The compiled binary will be located at `build/app/outputs/flutter-apk/app-release.apk`.

---

## 🔭 Academic & Research Roadmap

Journal2Life offers a fertile foundation for ongoing academic investigation in affective computing, NLP, and digital medicine:

1. **On-Device Edge Inference (LiteRT / Small Language Models):**
   - Evaluating localized on-device inference using Google Gemma 2B/7B via **LiteRT** (formerly TensorFlow Lite) to enable 100% offline, air-gapped emotional processing.
2. **Multimodal Biomarker Fusion:**
   - Correlating longitudinal text sentiment indices with physiological telemetry (e.g., Apple HealthKit / Google Health Connect for Heart Rate Variability [HRV], sleep disruption, and skin temperature).
3. **Cross-Cultural Psycholinguistic Validation:**
   - Conducting comparative studies to measure how semantic framing in non-Western languages influences emotional disclosure and perceived AI empathy.
4. **Clinical Efficacy Trials:**
   - Designing randomized controlled trials (RCTs) to measure whether continuous self-reflective journaling with grounded AI feedback measurably decreases subjective stress scores (PSS) or depressive symptoms (PHQ-9).

---

## 🤝 Contributing & Code of Conduct

Academic and open-source contributions are encouraged. Please adhere to the following workflow:

1. **Fork the Repository**
2. **Create a Topic Branch** (`git checkout -b feature/ScientificEnhancement`)
3. **Validate Code Style & Formatting:**
   ```bash
   flutter analyze
   dart format --set-exit-if-changed .
   ```
4. **Commit Changes with Conventional Commit Semantics:**
   ```bash
   git commit -m 'feat: implement on-device psychometric inference parser'
   ```
5. **Submit a Pull Request** with detailed methodological explanation.

---

### Scientific & Technical Acknowledgments
- **Google DeepMind & Google AI Studio** for the Gemini generative infrastructure.
- **Flutter & Dart Core Teams** for high-performance multiplatform compilation.
- **Firebase Platform** for robust, privacy-compliant serverless infrastructure.
- **The Affective Computing and Positive Psychology Research Communities** whose seminal literature informs this platform.

---

<p align="center">
  <em>Dedicated to the democratization of mental wellbeing through ethical artificial intelligence and compassionate technology.</em>
</p>
