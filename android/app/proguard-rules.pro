# Keep WorkManager and Room dependencies from being stripped by R8 in release mode
-keep class androidx.work.** { *; }
-keep class androidx.room.** { *; }
-keep class androidx.sqlite.** { *; }
-keep class * extends androidx.room.RoomDatabase
-dontwarn androidx.work.**