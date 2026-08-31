# Hermes + 9Router di Termux (Android)

Auto-install Hermes Agent + 9Router untuk Termux, sepenuhnya self-hosted di repo ini (tidak bergantung ke repo eksternal).

## Alur Singkat (Termux di HP)

```bash
pkg install -y git
git clone https://github.com/encydu/hermes-termux-setup.git
cd hermes-termux-setup
bash setup-hermes-9router.sh
```

Setelah selesai:

```bash
hermes
```

## File

- `setup-hermes-9router.sh` — main, 6 langkah: install git → install Hermes → install 9Router → config → jalankan 9Router
- `install-hermes-local.sh` — install Hermes dari `.deb` yang di-re-host di GitHub Release repo ini (`v0.20.6-hermes`), dengan verifikasi checksum SHA256.

## Model

Config otomatis diisi:
- `model.base_url` → `https://rkmcfny.abc-tunnel.us/v1`
- `model.api_key` → diisi otomatis
- `model.model` → `Enuma`
- `model.provider` → `custom`

## Pindah ke 9Router

Setelah masuk Hermes, ketik:

```
set model ke 9router
```

Dashboard 9Router: `http://localhost:20128/dashboard`

## Catatan

- Di HP, browser-automation & voice lokal tidak tersedia.
- Hermes + 9Router bareng bisa boros RAM; jika lelet, matikan 9Router.
