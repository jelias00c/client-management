#!/usr/bin/env python

import sys
import subprocess
import os
import re
import plistlib
from distutils.version import StrictVersion

def is_system_version_supported():
    system_version_plist = plistlib.readPlist("/System/Library/CoreServices/SystemVersion.plist")
    product_name = system_version_plist['ProductName']
    product_version = system_version_plist['ProductVersion']
    if StrictVersion(product_version) >= StrictVersion('10.15'):
        return False
    elif StrictVersion(product_version) >= StrictVersion('10.9'):
        return True
    else:
        return False

def get_current_model():
    cmd = ["/usr/sbin/sysctl", "-n", "hw.model"]
    p = subprocess.Popen(cmd, bufsize=1, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (results, err) = p.communicate()
    return results.strip()

def is_supported_model():
    non_supported_models = [
        'iMac4,1',
        'iMac4,2',
        'iMac5,1',
        'iMac5,2',
        'iMac6,1',
        'iMac7,1',
        'iMac8,1',
        'iMac9,1',
        'iMac10,1',
        'iMac11,1',
        'iMac11,2',
        'iMac11,3',
        'iMac12,1',
        'iMac12,2',
        'MacBook1,1',
        'MacBook2,1',
        'MacBook3,1',
        'MacBook4,1',
        'MacBook5,1',
        'MacBook5,2',
        'MacBook6,1',
        'MacBook7,1',
        'MacBookAir1,1',
        'MacBookAir2,1',
        'MacBookAir3,1',
        'MacBookAir3,2',
        'MacBookAir4,1',
        'MacBookAir4,2',
        'MacBookPro1,1',
        'MacBookPro1,2',
        'MacBookPro2,1',
        'MacBookPro2,2',
        'MacBookPro3,1',
        'MacBookPro4,1',
        'MacBookPro5,1',
        'MacBookPro5,2',
        'MacBookPro5,3',
        'MacBookPro5,4',
        'MacBookPro5,5',
        'MacBookPro6,1',
        'MacBookPro6,2',
        'MacBookPro7,1',
        'MacBookPro8,1',
        'MacBookPro8,2',
        'MacBookPro8,3',
        'Macmini1,1',
        'Macmini2,1',
        'Macmini3,1',
        'Macmini4,1',
        'Macmini5,1',
        'Macmini5,2',
        'Macmini5,3',
        'MacPro1,1',
        'MacPro2,1',
        'MacPro3,1',
        'MacPro4,1',
        'MacPro5,1',
        'Xserve1,1',
        'Xserve2,1',
        'Xserve3,1',
        ]
    current_model = get_current_model()
    if current_model in non_supported_models:
        return False
    else:
        return True

def write_plist(dictionary):
    plist_path = '/tmp/E43E34C6-02BB-11EB-ADC1-0242AC120002/catalina.plist'
    if os.path.exists(plist_path):
        existing_dict = plistlib.readPlist(plist_path)
        output_dict = dict(existing_dict.items() + dictionary.items())
    else:
        output_dict = dictionary
    plistlib.writePlist(output_dict, plist_path)
    pass

def main(argv=None):
    catalina_supported_dict = {}

    # check model and os version
    model_passed = is_supported_model()
    system_version_passed = is_system_version_supported()

    if model_passed and system_version_passed:
        catalina_supported_dict = {'catalina_supported': True}
    else:
        catalina_supported_dict = {'catalina_supported': False}

    write_plist(catalina_supported_dict)

if __name__ == '__main__':
    sys.exit(main())
