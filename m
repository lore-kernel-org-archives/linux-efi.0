From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH V3 07/10] Secure boot: Add a dummy kernel parameter
 that will switch on Secure Boot mode
Date: Mon, 29 Oct 2012 17:00:06 +0800
Message-ID: <1351501206.21227.47.camel@linux-s257.site>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <1348152065-31353-8-git-send-email-mjg@redhat.com>
	 <20120920163237.GA11077@kroah.com>
	 <20120925130818.GE18546@hansolo.jdub.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120925130818.GE18546-dHPIJuKSOV01V+h/cAXI7w8O6CCKKCg3HZ5vskTnxNA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tiwai-l3A5Bk7waGM@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Josh,=20

=E6=96=BC =E4=BA=8C=EF=BC=8C2012-09-25 =E6=96=BC 09:08 -0400=EF=BC=8CJo=
sh Boyer =E6=8F=90=E5=88=B0=EF=BC=9A
> This forcibly drops CAP_COMPROMISE_KERNEL from both cap_permitted and=
 cap_bset
> in the init_cred struct, which everything else inherits from.  This w=
orks on
> any machine and can be used to develop even if the box doesn't have U=
EFI.
>=20
> Signed-off-by: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/kernel-parameters.txt |  7 +++++++
>  kernel/cred.c                       | 17 +++++++++++++++++
>  2 files changed, 24 insertions(+)
>=20
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kern=
el-parameters.txt
> index 9b2b8d3..93978d5 100644
=2E..
> diff --git a/kernel/cred.c b/kernel/cred.c
> index de728ac..7e6e83f 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -623,6 +623,23 @@ void __init cred_init(void)
>  				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
>  }
> =20
> +void __init secureboot_enable()
> +{
=2E..
> +
> +/* Dummy Secure Boot enable option to fake out UEFI SB=3D1 */
> +static int __init secureboot_enable_opt(char *str)
> +{
> +	int sb_enable =3D !!simple_strtol(str, NULL, 0);
> +	if (sb_enable)
> +		secureboot_enable();
> +	return 1;
> +}
> +__setup("secureboot_enable=3D", secureboot_enable_opt);
> +
> =20

Tahashi has a good idea for use strtobool to allow
'secureboot_enable=3Dyes' works. Please consider the following change.


Thanks a lot!
Joey Lee

>From f6841a476f3d332fe7b04cb716e0b518cccd5055 Mon Sep 17 00:00:00 2001
=46rom: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Date: Mon, 29 Oct 2012 16:36:57 +0800
Subject: [PATCH] efi: more user-friendly secureboot_enable parameter

=46rom: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>

Use strtobool can allow 'secureboot_enable=3Dyes', it's more user-frien=
dly.

Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 kernel/cred.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 3f5be65..70897a2 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -633,9 +633,10 @@ void __init secureboot_enable()
 /* Dummy Secure Boot enable option to fake out UEFI SB=3D1 */
 static int __init secureboot_enable_opt(char *str)
 {
-	int sb_enable =3D !!simple_strtol(str, NULL, 0);
-	if (sb_enable)
+	bool sb_enable;
+	if (!strtobool(str, &sb_enable) && sb_enable)
 		secureboot_enable();
+
 	return 1;
 }
 __setup("secureboot_enable=3D", secureboot_enable_opt);
--=20
1.6.0.2
