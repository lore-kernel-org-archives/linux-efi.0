From: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [patch 0/9 v3] kexec kernel efi runtime support
Date: Fri, 22 Nov 2013 15:29:45 -0700
Message-ID: <1385159385.1791.160.camel@misato.fc.hp.com>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131121061704.363730447-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-11-21 at 14:17 +0800, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> Hi,
>=20
> Here is the V3 for supporting kexec kernel efi runtime.
> Per pervious discussion I pass the 1st kernel efi runtime mapping
> via setup_data to 2nd kernel. Besides of the runtime mapping
> info I also pass the fw_vendor, runtime, config table, smbios
> physical address in setup_data. EFI spec mentioned fw_vendor,
> runtime, config table addresses will be converted to virt address
> after entering virtual mode, but we will use it as physical address
> in efi_init. For smbios EFI spec did not mention about the address
> updating, but during my test on a HP workstation, the bios will
> convert it to Virt addr, thus pass it in setup_data as well.
>=20
> For fw_vendor, runtime, config table, I export them in /sys/firmware/
> efi/, smbios is already in /sys/firmware/efi/systab.
>=20
> For efi runtime mapping I add a new directory /sys/firmware/efi/
> runtime-map/ like below
> [dave@darkstar ~]$ tree /sys/firmware/efi/runtime-map/
> /sys/firmware/efi/runtime-map/
> =E2=94=9C=E2=94=80=E2=94=80 0
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 attribute
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 num_pages
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 phys_addr
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 type
> =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 virt_addr
> =E2=94=9C=E2=94=80=E2=94=80 1
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 attribute
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 num_pages
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 phys_addr
> =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 type
> =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 virt_addr
> [snip]
> =20
> kexec-tools will assemble them as setup_data and pass to 2nd kernel.
> I will send userspace patches as well.
>=20
> Limitation is I only write support for x86_64, test on below machines=
:
> Lenovo thinkpad t420
> Dell inspiron 14 - 3421
> HP Z420 workstation
> Qemu + OVMF

Tested on an HP EFI-based 60-way server (prototype).  For the series:

Tested-by: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>

Thanks,
-Toshi
