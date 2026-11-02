#!/bin/bash
set -e

CERT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBJECT='/C=US/ST=California/L=Mountain View/O=Android/OU=Android/CN=Android/emailAddress=android@android.com'

# Standard AOSP keys
for key in releasekey platform shared media networkstack sdk_sandbox bluetooth; do
  if [ ! -f "$CERT_DIR/$key.pk8" ]; then
    echo "Generating $key..."
    yes "" | "$CERT_DIR/make_key" "$CERT_DIR/$key" "$SUBJECT"
    openssl pkcs8 -in "$CERT_DIR/$key.pk8" -inform DER -nocrypt -out "$CERT_DIR/$key.pem"
  fi
done

# APEX keys
APEX_LIST="com.android.adbd com.android.adservices com.android.adservices.api com.android.appsearch com.android.art com.android.bluetooth com.android.bt com.android.btservices com.android.cellbroadcast com.android.compos com.android.configinfrastructure com.android.connectivity.resources com.android.conscrypt com.android.crashrecovery com.android.devicelock com.android.extservices com.android.graphics.pdf com.android.hardware.authsecret com.android.hardware.biometrics.face.virtual com.android.hardware.biometrics.fingerprint.virtual com.android.hardware.boot com.android.hardware.cas com.android.hardware.contexthub com.android.hardware.drm.clearkey com.android.hardware.dumpstate com.android.hardware.gatekeeper.nonsecure com.android.hardware.neuralnetworks com.android.hardware.power com.android.hardware.rebootescrow com.android.hardware.thermal com.android.hardware.threadnetwork com.android.hardware.uwb com.android.hardware.vibrator com.android.hardware.wifi com.android.healthfitness com.android.hotspot2.osulogin com.android.i18n com.android.ipsec com.android.media com.android.media.swcodec com.android.mediaprovider com.android.nearby.halfsheet com.android.networkstack.tethering com.android.neuralnetworks com.android.nfcservices com.android.npumanager com.android.ondevicepersonalization com.android.os.statsd com.android.permission com.android.profiling com.android.resolv com.android.rkpd com.android.runtime com.android.safetycenter.resources com.android.scheduling com.android.sdkext com.android.support.apexer com.android.telephony com.android.telephonycore com.android.telephonymodules com.android.tethering com.android.tzdata com.android.uprobestats com.android.uwb com.android.uwb.resources com.android.virt com.android.vndk.current com.android.vndk.current.on_vendor com.android.webapp com.android.wifi com.android.wifi.dialog com.android.wifi.resources com.google.pixel.camera.hal com.google.pixel.vibrator.hal com.qorvo.uwb"

for apex in $APEX_LIST; do
  if [ ! -f "$CERT_DIR/$apex.pk8" ]; then
    echo "Generating APEX key: $apex..."
    apex_subject='/C=US/ST=California/L=Mountain View/O=Android/OU=Android/CN='$apex'/emailAddress=android@android.com'
    yes "" | "$CERT_DIR/make_key" "$CERT_DIR/$apex" "$apex_subject"
    openssl pkcs8 -in "$CERT_DIR/$apex.pk8" -inform DER -nocrypt -out "$CERT_DIR/$apex.pem"
  fi
done

echo "Done generating keys!"
