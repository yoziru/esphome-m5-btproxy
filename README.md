# M5Stack AtomS3 / NanoC6 BTProxy

Turn your M5Stack AtomS3 Lite or NanoC6 into a bluetooth proxy for Home Assistant

## ESPHome instructions

If you are already running an instance of ESPHome, you can also include this repository directly by including it as a package. The main benefit here is having centralized management of all your ESPhome devices. To do this, you can use the following config for your device:
```
substitutions:
  wifi_ssid: !secret wifi_ssid
  wifi_password: !secret wifi_password
  wifi_hotspot_password: !secret wifi_hotspot_password
  ota_password: !secret ota_password
  api_encryption_key: !secret api_encryption_key

packages:
  remote_package_shorthand: github://yoziru/esphome-m5-btproxy/esphome-m5-btproxy-m5stack-atoms3.dashboard.yml@main
```