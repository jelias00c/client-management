## Manage Firefox Browser Settings

Firefox for Mac can be managed by placing two files inside the app directory. 
  * autoconfig.js
  * firefox.cfg

These files will likely be overwritten at each app update. Make sure your deployment solution can detect the presence of these files and reinstall automatically when necessary.

#### autoconfig.js
The **autoconfig.js** JavaScript file is used to point Firefox to the configuration file. This file must begin with a comment. The file will be installed to:
```
/Applications/Firefox.app/Contents/Resources/defaults/pref
```

#### firefox.cfg
This file will include all configuration parameters. It should be installed to:
```
/Applications/Firefox.app/Contents/Resources
```