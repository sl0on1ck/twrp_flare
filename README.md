# TWRP для Redmi Pad SE 8.7 WiFi (xiaomi flare)

Дерево устройства + CI-сборка TWRP через GitHub Actions.

## Устройство
- SoC: MediaTek MT6768 (Helio G85), ядро 5.10 (GKI)
- Прошивка: HyperOS 3 / OS3.0.302.0.WHXIDXM (Android 15)
- A/B, динамические разделы (erofs), FBE-шифрование данных
- Recovery живёт в ramdisk vendor_boot; TWRP собирается как boot.img

## Сборка
Запускается автоматически через GitHub Actions (Actions → Build TWRP for flare → Run workflow).
Готовый образ появится в артефактах: `recovery.img` (фактически это boot.img).

## Прошивка
```
fastboot flash boot_a recovery.img
# или для теста без прошивки:
fastboot boot recovery.img
```

Восстановить стоковое ядро можно из архива официальной прошивки: `images/boot.img`.
