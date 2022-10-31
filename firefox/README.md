# Customize Firefox

On Firefox:
	- about:config
	- search for "legacyUserProfileCustomizations.stylesheets", change to "true"
	- (close firefox)

On terminal:
	$ ln -s /storage/src/dot_files/firefox/chrome $(find ~/.mozilla/firefox -name *default-release*)/chrome

Then, reopen firefox.
