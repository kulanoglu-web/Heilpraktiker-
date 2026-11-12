"""Enforce that shipped code/assets have no external links or network permissions."""
from pathlib import Path
import re
import xml.etree.ElementTree as ET

root = Path(__file__).resolve().parents[1]
for base in ('lib', 'assets/data'):
    for path in (root / base).rglob('*'):
        if path.is_file():
            text = path.read_text(encoding='utf-8')
            assert not re.search(r'https?://|url_launcher|launchUrl|dart:io|dart:html', text), path
            assert not re.search(r'\b(?:HttpClient|WebSocket|WebView)\b', text), path
assert 'url_launcher' not in (root / 'pubspec.yaml').read_text()
android = root / 'android'
ns = '{http://schemas.android.com/apk/res/android}'
for path in android.rglob('AndroidManifest.xml'):
    tree = ET.parse(path)
    manifest = tree.getroot()
    removed = False
    for permission in list(manifest):
        if permission.tag in ('uses-permission', 'uses-permission-sdk-23') and permission.get(ns + 'name') in (
            'android.permission.INTERNET', 'android.permission.ACCESS_NETWORK_STATE'
        ):
            manifest.remove(permission)
            removed = True
    if removed:
        ET.register_namespace('android', 'http://schemas.android.com/apk/res/android')
        tree.write(path, encoding='utf-8', xml_declaration=True)
print('Offlineprüfung: keine externen Links oder Netzwerkfunktionen; Netzwerkberechtigungen entfernt.')
