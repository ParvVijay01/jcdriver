# Flutter-specific rules
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-dontwarn io.flutter.embedding.**

# Keep all class names from being obfuscated
-keep class * { *; }

# Keep JSON models safe from obfuscation (if using serialization)
-keepnames class com.yourcompany.yourapp.models.** { *; }

# Prevent issues with reflection (if used)
-keepattributes *Annotation*

# Retain native libraries (if using JNI)
-keep class * extends android.app.Application { *; }
