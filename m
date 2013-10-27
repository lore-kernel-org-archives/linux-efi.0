From: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [patch 0/6] kexec kernel efi runtime support
Date: Sun, 27 Oct 2013 11:47:13 +0800
Message-ID: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

Here is the 1st version for supporting kexec kernel efi runtime.
Per pervious discussion I pass the 1st kernel efi runtime mapping
via setup_data to 2nd kernel. Besides of the runtime mapping
info I also pass the fw_vendor, runtime, config table, smbios
physical address in setup_data. EFI spec mentioned fw_vendor,
runtime, config table addresses will be converted to virt address
after entering virtual mode, but we will use it as physical address
in efi_init. For smbios EFI spec did not mention about the address
updating, but during my test on a HP workstation, the bios will
convert it to Virt addr, thus pass it in setup_data as well.

=46or fw_vendor, runtime, config table, I export them in /sys/firmware/
efi/systab, smbios is already in that file.

=46or efi runtime mapping I add a new directory /sys/firmware/efi/
efi-runtime-map/ like below
[dave@darkstar ~]$ tree /sys/firmware/efi/efi-runtime-map/
/sys/firmware/efi/efi-runtime-map/
=E2=94=9C=E2=94=80=E2=94=80 0
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 attribute
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 num_pages
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 phys_addr
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 type
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 virt_addr
=E2=94=9C=E2=94=80=E2=94=80 1
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 attribute
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 num_pages
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 phys_addr
=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 type
=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 virt_addr
[snip]
=20
kexec-tools will assemble them as setup_data and pass to 2nd kernel.
I will send userspace patches as well.

Limitation is I only write support for x86_64, test on below machines:
Lenovo thinkpad t420
Dell inspiron 14 - 3421
HP Z420 workstation
Qemu + OVMF

Please help to review the patches.

The patches are based on linus tree (3.12.0-rc6+) + matt's next tree + =
bp's efi mapping patches
Boris's last patch can not directly apply, need a little line shifting.
--
Thanks
Dave
