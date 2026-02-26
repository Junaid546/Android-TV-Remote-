# Keep release minification resilient when legacy Conscrypt adapter classes are absent
# on newer Android runtimes.
-dontwarn com.android.org.conscrypt.SSLParametersImpl
-dontwarn org.apache.harmony.xnet.provider.jsse.SSLParametersImpl
