#!/usr/bin/env bash
# Exit in case of error.
set -e

trap "exit" INT # Exit in case of CTRL+C

prompt_yn() {
    echo -e "$(tput setaf 1)$1$(tput sgr0)"
    read -r response
    case "$response" in
        [yY][eE][sS] | [yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# if [ "$(id -u)" != "0" ]; then
#     echo -e "$(tput setaf 1)This script must be run as root.$(tput sgr0)" 1>&2
#     exit 1
# fi

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
fi

if [[ -z "${OS}" ]]; then
    echo "$(tput setaf 1)Error getting distribution. Modify script and try again.$(tput sgr0)"
    exit
fi

echo "This script sets up libvirt and GPU passthrough on my computer."
echo "I have detected that you run the following operating system: $(tput setaf 2)${OS}$(tput sgr0)"
read -n 1 -s -p "Press any key to continue"

if [ $OS != "arch" ]; then
    echo -e "$(tput setaf 1)\nError. This script only runs on Arch Linux with systemd-boot.$(tput sgr0)"
    exit 1
fi
echo "Installing dependencies..."
yes | sudo pacman -S iptables-nft
sudo pacman -S --noconfirm qemu libvirt edk2-ovmf virt-manager dnsmasq ebtables swtpm
git clone https://aur.archlinux.org/parsec-bin.git /tmp/parsec-bin
pushd /tmp/parsec-bin
makepkg -si --noconfirm
popd

echo "Adding kernel parameters."
if command -v bootctl &>/dev/null; then
    echo "Systemd-boot detected."
    FILE=$(bootctl status | awk '/source:/ {print $2}')
    # Create a backup of the systemd-boot entries
    sudo cp $FILE "${FILE}.bak"
    # Only add the kernel parameter if it doesn't exist
    grep -qF 'amd_iommu=on' $FILE || sudo sed -i '$s/$/ amd_iommu=on/' $FILE
    grep -qF 'iommu=pt' $FILE || sudo sed -i '$s/$/ iommu=pt/' $FILE
else
    echo "Only systemd-boot is supported. If you are running GRUB2 or something else, please add 'amd_iommu=on iommu=pt' to your kernel parameters."
fi

# Isolate the GPU and load VFIO early.
echo "Adding VFIO PCI IDs."
sudo bash -c 'cat <<EOF > /etc/modprobe.d/vfio.conf
softdep nvidia pre: vfio-pci
options vfio-pci ids=10de:2488,10de:228b
EOF'
# Regenerate initramfs
sudo mkinitcpio -P
# TODO. Any operation needs to be trancendental aka. only run if operation would change something.

echo "Adding user to groups."
sudo usermod -aG kvm,input,libvirt calin

echo "Configuring libvirtd."
sudo cp -f $HOME/.libvirt/config/qemu.conf /etc/libvirt/qemu.conf
sudo cp -f $HOME/.libvirt/config/libvirtd.conf /etc/libvirt/libvirtd.conf

echo "Enabling libvirtd."
sudo systemctl enable --now libvirtd
sudo virsh net-autostart default

echo "Copying patched vgabios"
if [ ! -f "/usr/share/vgabios/rtx3070-patched.rom" ]; then
    sudo mkdir -p /usr/share/vgabios/
    sudo cp $HOME/.libvirt/vbios/rtx3070-patched.rom /usr/share/vgabios/rtx3070-patched.rom
    sudo chmod -R 644 /usr/share/vgabios/rtx3070-patched.rom
    sudo chown $(whoami):$(whoami) /usr/share/vgabios/rtx3070-patched.rom
fi

# echo "Getting the latest images..."
# mkdir -p "$HOME"/.libvirt/images/
# rsync -razvhP dietpi@10.134.6.112:/mnt/hdd/data/VMs/ "$HOME"/.libvirt/images
#
# echo "Defining Windows 11 virtual machine."
# sudo virsh define $HOME/.libvirt/win11.xml
# echo "Defining Arch virtual machine."
# sudo virsh define $HOME/.libvirt/arch.xml
#
# It's better to have the service files in here rather then my dotfiles
# This way, if I introduce a change I don't have to edit in two places
# echo "Enabling image backup service."
# mv ./services/* "$HOME"/.config/systemd/user/
# systemctl enable --user backup.timer

echo "Done! A system restart is required."
