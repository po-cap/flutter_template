CLIENT_ID := 7U6bcdfd9dd2d3c0ba9bd682274d831eef
CLIENT_SECRET := 7f859ffaba9cee6c3815e867a89b6d35

run: 
	flutter run --dart-define=CLIENT_ID=$(CLIENT_ID) --dart-define=CLIENT_SECRET=$(CLIENT_SECRET)

build-android:
	flutter build appbundle --dart-define=CLIENT_ID=$(CLIENT_ID) --dart-define=CLIENT_SECRET=$(CLIENT_SECRET)

build-ios:
	flutter build ios --dart-define=CLIENT_ID=$(CLIENT_ID) --dart-define=CLIENT_SECRET=$(CLIENT_SECRET)
	open ios/Runner.xcworkspace

splash-install:
	dart run flutter_native_splash:create

splash-remove:
	dart run flutter_native_splash:remove

.PHONY: run build-android build-ios