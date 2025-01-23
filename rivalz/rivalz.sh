#!/bin/bash

# Menampilkan logo dengan warna

# Mengatur warna kembali ke default setelah jeda
echo -e "\033[0m"  # Reset warna teks ke default

echo "RIVALZ NODE AUTO INSTALL...."

# Update dan upgrade sistem
sudo apt-get update && sudo apt-get upgrade -y

# Cek apakah curl sudah diinstal
if ! command -v curl &> /dev/null
then
    echo "curl belum terinstal. Menginstal curl..."
    sudo apt install -y curl
else
    echo "curl sudah terinstal."
fi

# Setup Node.js versi 20.x jika belum diinstal
if ! command -v node &> /dev/null
then
    echo "Node.js belum terinstal. Menginstal Node.js 20.x..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo "Node.js sudah terinstal."
fi

# Cek apakah screen sudah diinstal
if ! command -v screen &> /dev/null
then
    echo "screen belum terinstal. Menginstal screen..."
    sudo apt-get install -y screen
else
    echo "screen sudah terinstal."
fi

# Konfigurasi firewall untuk mengizinkan SSH jika belum diaktifkan
if ! sudo ufw status | grep -q "Status: active"
then
    echo "Firewall belum diaktifkan. Mengaktifkan firewall dan mengizinkan SSH..."
    sudo ufw allow ssh
    sudo ufw enable
else
    echo "Firewall sudah diaktifkan."
fi

# Tampilkan status firewall
sudo ufw status

# Cek apakah rivalz-node-cli sudah diinstal
if ! npm list -g rivalz-node-cli &> /dev/null
then
    echo "rivalz-node-cli belum terinstal. Menginstal rivalz-node-cli..."
    npm i -g rivalz-node-cli
else
    echo "rivalz-node-cli sudah terinstal."
fi

# Cek dan update rivalz-node-cli jika ada pembaruan
echo "Memeriksa pembaruan rivalz..."
rivalz update-version

# Mengumpulkan informasi sistem
WALLET_ADDRESS="0xbb10e331408c10e1EE3436E9dC59011F5D19f1a6" 
CPU_CORES=$(nproc)  # Mengambil jumlah core CPU yang tersedia
RAM=$(free -m | awk '/^Mem:/{print $2}')  # Mengambil total RAM dalam MB
DISK_TYPE=$(lsblk -d -o ROTA | grep -q 1 && echo "HDD" || echo "SSD")  # Mengecek tipe disk

# Menampilkan informasi disk
echo "Menampilkan informasi disk:"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT

# Mencari drive dengan ukuran terbesar
DRIVE=$(lsblk -dno NAME,SIZE | sort -h | tail -n 1 | awk '{print $1}')  # Mengambil nama drive dengan ukuran terbesar
DRIVE="/dev/$DRIVE"  # Menambahkan /dev/ ke nama drive

# Mengambil ukuran maksimum disk yang dapat digunakan
MAX_DISK_SIZE=$(df -BG --output=size $DRIVE | tail -n 1 | tr -d 'G')  # Mengambil ukuran maksimum disk yang dapat digunakan

# Mengirimkan perintah ke sesi 'rivalz'
if screen -list | grep -q "rivalz"; then
    echo "Screen 'rivalz' sudah ada. Mengirimkan perintah untuk menjalankan rivalz..."
else
    echo "Screen 'rivalz' tidak ditemukan. Membuat sesi baru..."
    screen -dmS rivalz  # Membuat sesi screen baru yang berjalan di background
fi

# Mengirim perintah ke sesi 'rivalz'
screen -S rivalz -X stuff "rivalz run\n"  # Menjalankan rivalz
sleep 2  # Tunggu sebentar agar proses rivalz dimulai

# Mengirimkan input ke sesi 'rivalz'
screen -S rivalz -X stuff "$WALLET_ADDRESS\n"  # Mengisi alamat dompet
screen -S rivalz -X stuff "$CPU_CORES\n"  # Mengisi jumlah CPU cores
screen -S rivalz -X stuff "$RAM\n"  # Mengisi RAM
screen -S rivalz -X stuff "$DISK_TYPE\n"  # Mengisi tipe disk
screen -S rivalz -X stuff "$DRIVE\n"  # Mengisi nama disk
screen -S rivalz -X stuff "$MAX_DISK_SIZE\n"  # Mengisi ukuran disk secara otomatis

# Indikasi selesai
echo "rivalz sudah dijalankan. Cek menggunakan 'screen -r rivalz'"
