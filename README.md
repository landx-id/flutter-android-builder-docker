# Flutter-Android Builder

This repository contains simple Dockerfile that can used as environment to build Android (.apk or .aab) with Flutter.

### What's inside Dockerfile

The Dockerfile has everything you need to build an Android application with Flutter. It has: 
1. Android SDK
2. Flutter
3. Fastlane

### Usage

*Please make sure your Flutter version matches with available tags of this image*

You can use it as base image on CI/CD pipeline. For example, if you are using GitLab CI/CD you can use it when building your Flutter’s source code

```
# on .gitlab-ci.yml

.for_staging:
  environment:
    name: staging
  only:
    - develop

.flutter_builder:
  image:
    name: landx/flutter-android-builder:latest
    entrypoint: [""]

.build_android:
  extends:
    - .flutter_builder
  artifacts:
    paths:
      - build/app/outputs/flutter-apk/app-staging-release.apk
    expire_in: 1 hour
  script:
    - android/build

android:staging:build:
  variables:
    PACKAGE_FORMAT: "apk"
    BUILD_FLAVOR: "staging"
  extends:
    - .build_android
    - .for_staging
```

### Build your own image

You can build your own image using this Dockerfile, and match it with the flutter version you are using.

1. Clone this repository
```
~$ git clone https://github.com/landx-id/flutter-android-builder-docker.git
```
2. Build with passing flutter version as arguments
```
~$ cd flutter-android-builder-docker && docker build --build-arg flutter_version=<flutter version> --build-arg flutter_branch=<branch> .
```