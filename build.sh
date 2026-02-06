# USE GOOGLE COLAB
# 1. Mount Google Drive
from google.colab import drive
drive.mount('/content/drive')
# 2. Update & Install Dependencies
!sudo apt update -y && sudo apt upgrade -y && sudo apt install apt-utils rlwrap dialog -y && sudo apt install libterm-readline-perl-perl -y && sudo apt install nano bc bison ca-certificates curl flex gcc git libc6-dev libssl-dev openssl python-is-python3 ssh wget zip zstd sudo make clang gcc-arm-linux-gnueabi software-properties-common build-essential libarchive-tools gcc-aarch64-linux-gnu -y && sudo apt install build-essential -y && sudo apt install libssl-dev libffi-dev libncurses5-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev make gcc -y && sudo apt install pigz -y && sudo apt install python2 -y && sudo apt install python3 -y && sudo apt install cpio -y && sudo apt install lld -y && sudo apt install llvm -y && sudo apt-get install g++-aarch64-linux-gnu -y && sudo apt install libelf-dev -y && sudo apt install neofetch -y && neofetch
!sudo apt update && sudo apt install cpio lld libelf-dev -y
# 3. Setup Environment & Path
import os
os.environ['PATH'] = "/content/clang-r547379/bin:" + os.environ['PATH']
# 4. Masuk ke folder kernel
%cd /content/Veux-Positron-Mod-Kribo
!rm -rf out && rm -rf log.txt
# 5. Variabel Konfigurasi
DEFCONFIG = "veux_defconfig"
# Folder tujuan di Google Drive (akan dibuat jika belum ada)
DRIVE_PATH = "/content/drive/MyDrive/Kernel_Builds"
!mkdir -p "{DRIVE_PATH}"
print("===========================")
print("= START COMPILING KERNEL =")
print("===========================")
# 6. Langkah 1: Setup Config
!make O=out ARCH=arm64 $DEFCONFIG
# 7. Langkah 2: Mulai Kompilasi
!make -j$(nproc --all) O=out \
    ARCH=arm64 \
    LLVM=1 \
    LLVM_IAS=1 \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    KCFLAGS="-O3 -march=armv8.2-a+crypto+dotprod -mtune=generic -mllvm -polly -mllvm -enable-ml-inliner=release" \
    2>&1 | tee log.txt
# 8. Langkah 3: Otomatis Kirim ke Google Drive jika Berhasil
if os.path.exists("out/arch/arm64/boot/Image"):
    print("====================================")
    print("= BUILD SUCCESS! COPYING TO DRIVE =")
    print("====================================")
    # Copy file Image dan Log ke Google Drive
    !cp out/arch/arm64/boot/Image "{DRIVE_PATH}/Image-$(date +%Y%m%d-%H%M)"
    !cp log.txt "{DRIVE_PATH}/log-$(date +%Y%m%d-%H%M).txt"
    print(f"Selesai! File disimpan di: {DRIVE_PATH}")
else:
    print("====================================")
    print("= BUILD FAILED! CHECK log.txt      =")
    print("====================================")
    !cp log.txt "{DRIVE_PATH}/failed_log-$(date +%Y%m%d-%H%M).txt"