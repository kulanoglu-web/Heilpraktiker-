
android {
    signingConfigs {
        getByName("debug") {
            storeFile = rootProject.file("../signing/debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
    }
}
