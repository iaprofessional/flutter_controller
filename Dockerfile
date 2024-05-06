# Use the official Flutter image.
FROM cirrusci/flutter:stable

# Install additional dependencies for Android development.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-8-jdk \
    android-sdk \
    && rm -rf /var/lib/apt/lists/*

# Download Android Studio command line tools.
RUN mkdir -p /opt/android-studio && \
    curl -o /opt/android-studio/android-studio.zip https://developer.android.com/studio/?pkg=commandlinetools-linux && \
    unzip -d /opt/android-studio /opt/android-studio/android-studio.zip && \
    rm /opt/android-studio/android-studio.zip

# Add Android Studio command line tools to PATH.
ENV PATH="$PATH:/opt/android-studio/cmdline-tools/bin"

# Set up environment variables for Flutter and Android SDK paths.
ENV PATH $PATH:/usr/lib/flutter/bin:/usr/lib/android-sdk/tools:/usr/lib/android-sdk/tools/bin:/usr/lib/android-sdk/platform-tools

# Set up the workspace.
WORKDIR /workspace

# Expose necessary ports for Flutter development.
EXPOSE 8000 8080
