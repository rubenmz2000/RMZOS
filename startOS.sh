#!/bin/bash

# 🚀 Crear carpetas necesarias
mkdir -p compiledFiles iso/boot/grub

# 🔥 Limpiar compilaciones previas
echo "🔹 Limpiando archivos antiguos..."
rm -f compiledFiles/* rmzso.iso

# 🚀 Compilación del Bootloader
echo "🔹 Compilando Bootloader..."
nasm -f bin src/boot.asm -o compiledFiles/boot.bin

# 🚀 Compilación del Entry Point (código ASM)
echo "🔹 Compilando Entry Point..."
nasm -f elf32 src/entry.asm -o compiledFiles/entry.o

# 🚀 Compilación del Kernel (código en C)
echo "🔹 Compilando Kernel..."
i686-elf-gcc -ffreestanding -m32 -nostdlib -static -c src/kernel.c -o compiledFiles/kernel.o

# 🚀 Enlazado del Kernel
echo "🔹 Enlazando Kernel..."
i686-elf-ld -T src/linker.ld -o compiledFiles/kernel.elf compiledFiles/entry.o compiledFiles/kernel.o

# 🚀 Creación de la imagen del SO
echo "🔹 Creando imagen final..."
cat compiledFiles/boot.bin compiledFiles/kernel.elf > compiledFiles/os.img

# 🚀 Copiar kernel a la ISO
echo "🔹 Copiando Kernel a la ISO..."
cp compiledFiles/kernel.elf iso/boot/kernel.elf
cp src/grub.cfg iso/boot/grub/grub.cfg

# 🚀 Generación de la ISO con GRUB
echo "🔹 Generando ISO booteable..."
grub-mkrescue -o rmzso.iso iso

# 🚀 Ejecutar en QEMU
echo "🔹 Iniciando QEMU..."
qemu-system-x86_64 -cdrom rmzso.iso