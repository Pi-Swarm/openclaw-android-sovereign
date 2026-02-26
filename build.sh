# OpenClaw Android - Build Script
# Builds APK wrapper for native Android experience

FROM=termux/termux-app:latest

# Check prerequisites
check_prerequisites() {
    command -v java >/dev/null 2>&1 || { echo "Java required"; exit 1; }
    command -v android-sdk >/dev/null 2&1 || { echo "Android SDK required"; exit 1; }
}

# Build Termux bootstrap with OpenClaw
build_bootstrap() {
    echo "Building Termux bootstrap with OpenClaw..."
    
    # Create bootstrap structure
    mkdir -p build/bootstrap/
    cd build/bootstrap/
    
    # Download minimal Termux packages
    wget https://packages.termux.dev/bootstrap/bootstrap-aarch64.zip
    unzip bootstrap-aarch64.zip
    
    # Add OpenClaw to bootstrap
    mkdir -p data/data/com.termux/files/usr/lib/node_modules/openclaw
    
    # Copy OpenClaw files
    cp -r ../../openclaw/* data/data/com.termux/files/usr/lib/node_modules/openclaw/
    
    # Create launcher scripts
    cat > data/data/com.termux/files/usr/bin/openclaw << 'EOF'
#!/data/data/com.termux/files/usr/bin/env node
require('/data/data/com.termux/files/usr/lib/node_modules/openclaw/bin/openclaw');
EOF
    chmod +x data/data/com.termux/files/usr/bin/openclaw
    
    # Repack
    zip -r ../bootstrap-openclaw-aarch64.zip .
    cd ../..
}

# Build APK
build_apk() {
    echo "Building APK..."
    
    mkdir -p build/apk
    cd build/apk
    
    # Create Android project structure
    mkdir -p app/src/main/java/com/openclaw/android
    mkdir -p app/src/main/res/layout
    mkdir -p app/src/main/res/values
    mkdir -p app/src/main/assets
    
    # Copy bootstrap
    cp ../bootstrap-openclaw-aarch64.zip app/src/main/assets/
    
    # Create MainActivity.java
    cat > app/src/main/java/com/openclaw/android/MainActivity.java << 'EOF'
package com.openclaw.android;

import android.app.Activity;
import android.os.Bundle;
import android.widget.Button;
import android.widget.TextView;
import android.content.Intent;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        TextView status = findViewById(R.id.status);
        Button btnStatus = findViewById(R.id.btn_status);
        Button btnGateway = findViewById(R.id.btn_gateway);
        Button btnTerminal = findViewById(R.id.btn_terminal);
        
        btnStatus.setOnClickListener(v -> {
            runCommand("openclaw status");
        });
        
        btnGateway.setOnClickListener(v -> {
            runCommand("openclaw gateway");
        });
        
        btnTerminal.setOnClickListener(v -> {
            Intent intent = new Intent();
            intent.setClassName("com.termux", "com.termux.app.TermuxActivity");
            startActivity(intent);
        });
    }
    
    private void runCommand(String cmd) {
        // Implementation using Termux API
    }
}
EOF

    # Create layout
    cat > app/src/main/res/layout/main.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:padding="16dp">
    
    <TextView
        android:id="@+id/title"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="🛡️ OpenClaw Android"
        android:textSize="24sp"
        android:textStyle="bold"
        android:layout_gravity="center"
        android:padding="16dp" />
    
    <TextView
        android:id="@+id/status"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Status: Ready"
        android:layout_gravity="center"
        android:padding="8dp" />
    
    <Button
        android:id="@+id/btn_status"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="Check Status" />
    
    <Button
        android:id="@+id/btn_gateway"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="Start Gateway" />
    
    <Button
        android:id="@+id/btn_terminal"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:text="Open Terminal" />
    
</LinearLayout>
EOF

    # Create AndroidManifest.xml
    cat > app/src/main/AndroidManifest.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.openclaw.android"
    android:versionCode="1"
    android:versionName="1.0.0">
    
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    
    <application
        android:label="OpenClaw"
        android:icon="@mipmap/ic_launcher"
        android:theme="@style/Theme.AppCompat"
        android:extractNativeLibs="true">
        
        <activity android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
EOF
    
    # Build with gradle
    ./gradlew assembleRelease 2>&1 || echo "Build requires Android SDK"
    
    cd ../..
}

# Main
main() {
    echo "OpenClaw Android Builder"
    echo "========================="
    
    mkdir -p build
    
    # Uncomment to build:
    # build_bootstrap
    # build_apk
    
    echo ""
    echo "Note: Full APK build requires Android SDK"
    echo "For now, use Termux method (see README.md)"
}

main "$@"
