# AGENTS.md — TWRP для Xiaomi flare (Redmi Pad SE 8.7 WiFi)

## Устройство

| Параметр | Значение |
|---|---|
| Маркетинговое имя | Redmi Pad SE 8.7 WiFi |
| Кодовое имя (ro.product.vendor.device) | **flare** |
| Стоковая прошивка | HyperOS 3 `OS3.0.302.0.WHXIDXM` (global/id, Android 15, SDK 35) |
| SoC | MediaTek MT6768 (Helio G85), ядро Linux 5.10 (GKI) |
| Схема разделов | A/B (виртуальный A/B), динамические разделы (super, erofs) |
| Шифрование данных | FBE (f2fs + inlinecrypt), ключи в `/metadata` |
| Recovery | Отдельного раздела нет; стоковое recovery живёт в ramdisk `vendor_boot` |
| boot_a | 128 МБ (`0x8000000`) |
| vendor_boot_a | 64 МБ (`0x4000000`) |
| super | 8.5 ГБ (`0x220000000`) |
| Экран | 800x1340 |

Примечание: ветка ядра MiCode — `spark-w-oss`, возможно spark = вариант 4G.
В дереве `TARGET_OTA_ASSERT_DEVICE := flare,spark` покрывает оба варианта.

## Стратегия сборки

- Сборка через GitHub Actions, манифест `minimal-manifest-twrp/platform_manifest_twrp_aosp`, ветка `twrp-14.1`.
- `BOARD_USES_RECOVERY_AS_BOOT := true` → на выходе один `recovery.img`, прошивается в **boot_a**.
- Ядро/dtb/dtbo — prebuilt из стоковой прошивки; `vendor_boot` остаётся стоковым.
- Откат: прошить стоковый `boot.img` обратно в boot_a.

Файлы в дереве (`flare/`):
- `AndroidProducts.mk` — продакты `omni_flare` и `twrp_flare` (файл makefile должен
  совпадать с PRODUCT_NAME, поэтому конфиг продублирован в `twrp_flare.mk`),
  lunch-комбо `twrp_flare-eng`.
- `omni_flare.mk` / `twrp_flare.mk` — конфигурация продукта.
- `BoardConfig.mk` — флаги платы (MTK, FBE, размеры разделов).
- `recovery.fstab` — адаптирован из стокового `system/etc/recovery.fstab`.
- `prebuilt/{kernel.gz, dtb, dtbo.img}` — из стоковой прошивки.
- `vendorsetup.sh` — для совместимости со старым envsetup (add_lunch_combo устарел,
  актуальный путь — COMMON_LUNCH_CHOICES).

## Прошивка

```bash
fastboot boot recovery.img          # безопасный тест БЕЗ прошивки
fastboot flash boot_a recovery.img  # если тест пройден
```

## Известные риски

- Расшифровка /data: FBE на Android 15 — частая точка отказа TWRP; правится
  флагами `TW_INCLUDE_FBE*` / `TW_USE_FSCRYPT_POLICY` или патчами fscrypt.
- Яркость/тачскрин: путь `/sys/class/leds/lcd-backlight/brightness` и
  `TW_MAX_BRIGHTNESS=2047` — типовые для MTK, уточнить при первом запуске.
- `mi_ext` в списке динамических разделов super не проверен (нет lpdump-дампа).
- `fastboot boot` на MTK иногда не работает → прошивать в boot_a (откат известен).

## Отладка после первого запуска

```bash
adb shell cat /proc/partitions
adb shell twrp decrypt
adb shell getprop | grep ro.crypto
cat /tmp/recovery.log
```
