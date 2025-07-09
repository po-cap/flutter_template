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

change-bundle-id:
	@echo "╔════════════════════════════════════════╗"
	@echo "║    Flutter 應用 Bundle ID 修改工具     ║"
	@echo "╚════════════════════════════════════════╝"
	@echo ""
	@read -p "請輸入新的 Bundle ID (例如: com.example.app): " bundle_name; \
	if [ -z "$$bundle_name" ]; then \
		echo "錯誤: Bundle ID 不能為空"; \
		exit 1; \
	elif [[ ! "$$bundle_name" =~ ^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+$$ ]]; then \
		echo "錯誤: 無效的 Bundle ID 格式"; \
		echo "正確格式範例: com.example.app"; \
		exit 1; \
	else \
		echo "正在將 Bundle ID 修改為: $$bundle_name"; \
		flutter pub global run rename setBundleId --value "$$bundle_name"; \
		echo "✅ 修改完成!"; \
	fi

change-app-name:
	@echo "╔════════════════════════════════════════╗"
	@echo "║      Flutter 應用名稱修改工具          ║"
	@echo "╚════════════════════════════════════════╝"
	@echo ""
	@read -p "Enter new app name (e.g. Woo2025): " app_name; \
	if [ -z "$$app_name" ]; then \
		echo "Error: App name cannot be empty"; \
		exit 1; \
	else \
		echo "Changing app name to: $$app_name"; \
		flutter pub global run rename setAppName --value "$$app_name"; \
		echo "✅ Done! App name changed to: $$app_name"; \
	fi

.PHONY: run build-android build-ios