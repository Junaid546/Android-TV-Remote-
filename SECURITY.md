# Security Policy

## Supported Versions

The following versions of ATV Remote are currently supported with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.x (latest) | ✅ Yes        |
| < 1.0   | ❌ No              |

---

## Reporting a Vulnerability

We take security seriously. If you discover a vulnerability in ATV Remote, please **do not open a public GitHub issue**. Instead, follow the responsible disclosure process below.

### How to Report

**Email:** [your-email@example.com]  
**Subject:** `[SECURITY] ATV Remote - <brief description>`

Please include as much of the following as possible:

- A clear description of the vulnerability
- Steps to reproduce the issue
- Potential impact or attack scenario
- Any suggested fix or mitigation (optional)
- Your contact information for follow-up

### What to Expect

- **Acknowledgement** within **48 hours** of your report
- **Status update** within **7 days** with an assessment and expected timeline
- **Credit** in the release notes (if desired) once the vulnerability is resolved

---

## Scope

### In Scope

- The Flutter/Android application code
- The Kotlin native layer (MethodChannel / EventChannel bridge)
- Android TV pairing and TLS communication logic (ATVR Protocol v2)
- Any credentials, tokens, or pairing secrets stored on-device
- Network communication between the app and Android TV devices

### Out of Scope

- The Android TV device firmware or Google's Remote Control Protocol itself
- Third-party libraries (report these directly to the respective maintainers)
- Issues on Android TV devices that are not caused by the app

---

## Security Design Notes

ATV Remote communicates with Android TV devices over a **TLS-wrapped TCP connection (port 6466)** using the Android TV Remote Control Protocol v2. The following security measures are in place:

- **TLS encryption** for all communication between the app and the TV
- **Custom TrustManager** with certificate pinning for pairing sessions
- **No cloud transmission** — all pairing and control data stays on the local network
- **No credentials stored server-side** — device certificates are stored locally on the Android device
- **mDNS/NsdManager** used for local device discovery only — no external DNS or tracking

---

## Known Limitations

- The app operates over **local network only**. If an attacker has access to your local network, they may be able to observe mDNS traffic.
- The ATV pairing flow follows Google's protocol, which relies on a short PIN. Users should only pair in trusted environments.

---

## Security Updates

Security patches will be released as soon as possible following responsible disclosure. Updates will be noted in the [CHANGELOG](./CHANGELOG.md) with the label `[SECURITY]`.

---

## Attribution

We appreciate security researchers who help keep this project safe. Responsible disclosures that result in a fix will be acknowledged in the release notes unless anonymity is requested.

---

*This policy is inspired by [GitHub's recommended community security standards](https://docs.github.com/en/code-security/getting-started/adding-a-security-policy-to-your-repository).*
