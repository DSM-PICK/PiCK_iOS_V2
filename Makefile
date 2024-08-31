generate:
	tuist fetch
	tuist generate
clean:
	tuist clean
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

cache_clean:
	rm -rf ~/Library/Developer/Xcode/DerivedData/*

regenerate:	
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
	tuist fetch
	tuist generate
