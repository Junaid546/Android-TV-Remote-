# Keep release minification resilient when legacy Conscrypt adapter classes are absent
# on newer Android runtimes.
-dontwarn com.android.org.conscrypt.SSLParametersImpl
-dontwarn org.apache.harmony.xnet.provider.jsse.SSLParametersImpl

# ── Obfuscate sensitive pairing classes ──────────────────────────────────────
-keep,allowobfuscation class com.example.atv_remote.pairing.TlsSocketFactory
-keep,allowobfuscation class com.example.atv_remote.pairing.CertificateStore
-keep,allowobfuscation class com.example.atv_remote.pairing.PairingSecretGenerator

-keepclassmembers,allowobfuscation class com.example.atv_remote.pairing.TlsSocketFactory { *; }
-keepclassmembers,allowobfuscation class com.example.atv_remote.pairing.CertificateStore { *; }
-keepclassmembers,allowobfuscation class com.example.atv_remote.pairing.PairingSecretGenerator { *; }

# ── Strip all logs in release ─────────────────────────────────────────────────
-assumenosideeffects class android.util.Log {
    public static int d(...);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int e(...);
}

# ── General hardening ─────────────────────────────────────────────────────────
-repackageclasses ''
-allowaccessmodification
-optimizationpasses 5
-dontwarn kotlin.Metadata

-assumenosideeffects class kotlin.jvm.internal.Intrinsics {
    static void checkParameterIsNotNull(java.lang.Object, java.lang.String);
    static void checkNotNullParameter(java.lang.Object, java.lang.String);
}

# ── Keep required Flutter and app entry points ────────────────────────────────
-keep class io.flutter.** { *; }
-keep class com.example.atv_remote.MainActivity { *; }
-keep class **$$serializer { *; }
