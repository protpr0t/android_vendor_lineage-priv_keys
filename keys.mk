cat << 'EOF' > keys.mk
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/lineage-priv/keys/releasekey
PRODUCT_OTAKEY_EXTRA_ATTRIBUTES := vendor/lineage-priv/keys/releasekey

PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/lineage-priv/keys/releasekey
EOF
