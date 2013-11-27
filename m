From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v4 10/12] x86: export x86 boot_params to sysfs
Date: Wed, 27 Nov 2013 15:56:34 +0100
Message-ID: <20131127145634.GG32267@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-11-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1385445477-9665-11-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 26, 2013 at 01:57:55PM +0800, Dave Young wrote:
> kexec-tools use boot_params for getting the 1st kernel hardware_subar=
ch,
> the kexec kernel efi runtime support also need read the old efi_info =
from
> boot_params. Currently it exists in debugfs which is not a good place=
 for
> such infomation. Per HPA, we should avoid of "sploit debugfs".
>=20
> In this patch /sys/kernel/boot_params are exported, also the setup_da=
ta
> is exported as a subdirectory. For original debugfs since it's alread=
y
> there for long time and kexec-tools is using it for hardware_subarch =
so
> let's do not remove them for now.

"kexec-tools is using debugfs for hardware_subarch for a long time now
so we're not removing it yet."

> Structure are like below:

	    is

>=20
> /sys/kernel/boot_params
> =E2=94=9C=E2=94=80=E2=94=80 data		/* binary data for boot_params */

You mean "boot_params in binary"?

> =E2=94=9C=E2=94=80=E2=94=80 setup_data  	/* subdirectory for setup_da=
ta if there's any */

no need for that comment

> =E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 0		/* the first set=
up_data node */
> =E2=94=82=C2=A0=C2=A0 =E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80=
 data	/* binary data for setup_data node 0 */

"setup_data node 0 in binary"

> =E2=94=82=C2=A0=C2=A0 =E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80=
 type	/* setup_data type of setup_data node 0, hex string */
> |   [snip]		/* other setup_data nodes ... */
> =E2=94=94=E2=94=80=E2=94=80 version		/* hex string for boot protocal =
version */

"boot protocol version (in hex, "0x" prefixed)"

>=20
> Changelog:
> Greg: use __ATTR_RO() and group attr.
>=20
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/ABI/testing/sysfs-kernel-boot_params |  40 +++
>  arch/x86/kernel/Makefile                           |   2 +-
>  arch/x86/kernel/ksysfs.c                           | 339 +++++++++++=
++++++++++
>  3 files changed, 380 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-kernel-boot_param=
s
>  create mode 100644 arch/x86/kernel/ksysfs.c
>=20
> diff --git a/Documentation/ABI/testing/sysfs-kernel-boot_params b/Doc=
umentation/ABI/testing/sysfs-kernel-boot_params
> new file mode 100644
> index 0000000..8014a93
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-kernel-boot_params
> @@ -0,0 +1,40 @@
> +What:		/sys/kernel/boot_params
> +Date:		November 2013
> +Contact:	Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> +Description:
> +		The /sys/kernel/boot_params directory contains two
> +		files: "data" and "version" and one subdirectory "setup_data".
> +		It is used to export the kernel boot parameters of x86

"... of an x86 platform to userspace for kexec and debugging purposes."

> +		platform to user space for kexec and debugging purpose.
> +
> +		If there's no setup_data in boot_params the subdirectory will
> +		not be created.
> +
> +		"data" file is the binary representation of struct boot_params.
> +
> +		"version" file is the string representation of boot
> +		protocol version.
> +
> +		"setup_data" subdirectory contains the setup_data data
> +		structure in boot_params. setup_data is maintained in kernel
> +		as a link list. In "setup_data" subdirectory there's one
> +		subdirectory for each link list node named with the number
> +		of the list nodes. The list node subdirectory contains two
> +		files "type" and "data". "type" file is the string
> +		representation of setup_data type.

string or int?
> +		"data" file is the binary
> +		representation of setup_data payload.
> +
> +		The whole boot_params directory structure is like below:
> +		/sys/kernel/boot_params
> +		=E2=94=9C=E2=94=80=E2=94=80 data
> +		=E2=94=9C=E2=94=80=E2=94=80 setup_data
> +		=E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=80 0
> +		=E2=94=82=C2=A0=C2=A0 =E2=94=82=C2=A0=C2=A0 =E2=94=9C=E2=94=80=E2=94=
=80 data
> +		=E2=94=82=C2=A0=C2=A0 =E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=
=80 type
> +		=E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 1
> +		=E2=94=82=C2=A0=C2=A0     =E2=94=9C=E2=94=80=E2=94=80 data
> +		=E2=94=82=C2=A0=C2=A0     =E2=94=94=E2=94=80=E2=94=80 type
> +		=E2=94=94=E2=94=80=E2=94=80 version
> +
> +Users:
> +		Kexec Mailing List <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index a5408b9..473a4bb 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -35,7 +35,7 @@ obj-y			+=3D alternative.o i8253.o pci-nommu.o hw_b=
reakpoint.o
>  obj-y			+=3D tsc.o io_delay.o rtc.o
>  obj-y			+=3D pci-iommu_table.o
>  obj-y			+=3D resource.o
> -
> +obj-$(CONFIG_SYSFS)	+=3D ksysfs.o
>  obj-y				+=3D process.o
>  obj-y				+=3D i387.o xsave.o
>  obj-y				+=3D ptrace.o

Conflict with upstream, it should be:

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9b0a34e2cd79..851dcd1218fc 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -35,6 +35,7 @@ obj-y                 +=3D alternative.o i8253.o pci-=
nommu.o hw_breakpoint.o
 obj-y                  +=3D tsc.o io_delay.o rtc.o
 obj-y                  +=3D pci-iommu_table.o
 obj-y                  +=3D resource.o
+obj-$(CONFIG_SYSFS)    +=3D ksysfs.o
=20
 obj-$(CONFIG_PREEMPT)  +=3D preempt.o
=20

> diff --git a/arch/x86/kernel/ksysfs.c b/arch/x86/kernel/ksysfs.c
> new file mode 100644
> index 0000000..3f91207
> --- /dev/null
> +++ b/arch/x86/kernel/ksysfs.c
> @@ -0,0 +1,339 @@
> +/*
> + * Architecture specific sysfs attributes in /sys/kernel

Architecture-specific

=2E..

--=20
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
