# Hermes + 9Router di Termux (Android)

Auto-install **Hermes Agent** + **9Router** untuk Termux, sepenuhnya **self-hosted** di repo ini (Hermes di-re-host sebagai paket `.deb` di GitHub Release repo ini, tidak bergantung ke repo eksternal).

---

## 1. Prasyarat

- HP Android (termux aarch64 — kebanyakan HP modern)
- Aplikasi **Termux** dari F-Droid (bukan Play Store, supaya versi terbaru & stabil). [F-Droid link](https://f-droid.org/packages/com.termux/)
- Internet aktif

---

## 2. Tambahkan Akses Penyimpanan (opsional tapi disarankan)

Biar Termux bisa baca file di folder Downloads HP:

```bash
termux-setup-storage
```

Ikuti dialog izin yang muncul (pilih **Allow**/Izinkan).

---

## 3. Install Hermes + 9Router

```bash
pkg install -y git
git clone https://github.com/encydu/hermes-termux-setup.git
cd hermes-termux-setup
bash setup-hermes-9router.sh
```

Apa yang dilakukan script (6 langkah):

| Langkah | Aksi |
|---------|------|
| 1 | Install `git`, update/upgrade repositori Termux |
| 2 | Install Hermes dari `.deb` yang di-re-host di release repo ini (verifikasi SHA256) |
| 3 | Install 9Router (global npm) |
| 4 | Auto-config Hermes → tunnel provider + model Enuma |
| 5 | Nyalakan 9Router di background (dashboard `:20128`) |
| 6 | Selesai — tampilkan petunjuk |

> Script akan:
> - Download `.deb` dari GitHub Release repo ini (`v0.20.6-hermes`)
> - Verifikasi checksum SHA256 (mismatch = berhenti)
> - `dpkg -i` paket Hermes
> - Auto-config: `model.base_url`, `model.api_key`, `model.model=Enuma`, `model.provider=custom`

---

## 4. Mulai Menggunakan Hermes

```bash
hermes
```

Saat pertama dibuka, config sudah otomatis diisi (base_url tunnel + key + model Enuma). Obrolan langsung jalan.

### Perintah yang berguna

| Perintah | Fungsi |
|----------|--------|
| `hermes` | Buka chat (interactive) |
| `hermes config get model` | Lihat model aktif |
| `hermes model` | Ganti model/provider interaktif |
| `hermes config show` | Lihat seluruh config |
| `hermes doctor` | Diagnosa instalasi |

---

## 5. Pakai 9Router (Router Model)

9Router duduk di antara Hermes dan provider model. Untuk memakainya:

### a) Buka dashboard 9Router

```bash
# Buka browser HP ke:
http://localhost:20128/dashboard
```

### b) Connect provider

1. Login ke dashboard.
2. Masuk **Providers** → **Connect**.
3. Pilih provider free (misal **Kiro AI** atau **OpenCode Free**).
4. Copy API key yang dihasilkan.

### c) Arahkan Hermes ke 9Router

Masuk Hermes (`hermes`), lalu ketik perintah ini:

```
set model ke 9router
```

Atau di terminal (non-Hermes):

```bash
hermes config set model.base_url http://localhost:20128/v1
hermes config set model.api_key <API_KEY_9ROUTER>
hermes config set model.model kr/claude-sonnet-4.5
hermes config set model.provider custom
```

---

## 6. Troubleshooting

### `git: command not found`
```bash
pkg install -y git
```

### `hermes: command not found`
Pastikan script sukses. Cek:
```bash
hermes --version
```
Kalau kosong, kemungkinan paket belum terpasang. Re-run `bash setup-hermes-9router.sh`.

### Checksum mismatch saat install
Paket `.deb` berubah. Update `EXPECTED_SHA256` di `install-hermes-local.sh` dengan checksum baru, lalu re-run.

### 9Router tidak terbuka di browser
Pastikan 9Router jalan:
```bash
curl -s http://localhost:20128
```
Kalau blank/koneksi ditolak, matikan 9Router lama lalu nyalakan lagi:
```bash
pkill 9router
nohup 9router >~/.9router.log 2>&1 &
```

### RAM boros (Hermes + 9Router bareng)
Matikan 9Router sementara:
```bash
pkill 9router
```
Nyalakan lagi kapan pun butuh.

### `pkg install` gagal karena repo tidak stabil
```bash
pkg update -y
pkg install -y git
```

---

## 7. FAQ

### Apakah model dijalankan di HP?
**Tidak.** Model (Enuma) tetap di cloud. HP hanya menjalankan agent (Hermes) + router (9Router). Hermes & 9Router memanggil model melalui API endpoint.

### Web browser automation di HP bisa?
**Tidak.** Browser automation dan voice lokal tidak tersedia di Android/Termux.

### Kalau mau versi Hermes baru?
Upload `.deb` baru ke GitHub Release repo ini berdasarkan paket termux aarch64, lalu update `EXPECTED_SHA256` di `install-hermes-local.sh`.

### Kenapa repo ini lewat GitHub, langsung dari .deb?
Karena .deb 64MB, file besar nggak cocok di-commit ke git. Jadi Hermes di-re-host sebagai **GitHub Release asset**, dan script menariknya dari sana. Lebih rapi & tetap self-contained.

### Kalau aku pindah model dari yang gratis/murah, apakah Hermes langsung paham?
Setelah kamu `set model ke 9router` atau set config ke `http://localhost:20128/v1`, Hermes akan pakai 9Router untuk semua panggilan model.

---

## 8. Update & Maintenance

Untuk update script repo:

```bash
cd ~/hermes-termux-setup
git pull origin main
bash setup-hermes-9router.sh
```

Untuk upgrade paket Termux secara umum:

```bash
pkg update -y
pkg upgrade -y
```
