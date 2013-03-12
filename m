From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] efivars: allow efi pstore variable when validate
 filename
Date: Tue, 12 Mar 2013 11:06:19 +0800
Message-ID: <1363057579.13754.46.camel@linux-s257.site>
References: <1363028428-27976-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363028428-27976-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,=20

Sorry for I didn't aware your 123abd76edf patch fixed issue.
Please ignore my patch.


Thanks a lot!
Joey Lee

=E6=96=BC =E4=BA=8C=EF=BC=8C2013-03-12 =E6=96=BC 03:00 +0800=EF=BC=8CLe=
e, Chun-Yi =E6=8F=90=E5=88=B0=EF=BC=9A
> We mount efivarfs fail after pstore generated 'dump-type*' variables =
and
> reboot.
>=20
> This issue introduced by commit 47f531e8ba3bc3901a0c493f4252826c41dea=
1a1
> (efivarfs: Validate filenames much more aggressively)
>=20
> The pstore variable is 'dump-type*-*-*-*-GUID'style, it could not pas=
s
> the "GUID should be right after the first '-'" check. This patch allo=
w
> the variable name that has 'dump-type' pass the name check.
>=20
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
> Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> ---
>  drivers/firmware/efivars.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 3edade0..ab07f7f 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -930,7 +930,7 @@ static bool efivarfs_valid_name(const char *str, =
int len)
>  		return false;
> =20
>  	/* GUID should be right after the first '-' */
> -	if (s - 1 !=3D strchr(str, '-'))
> +	if (s - 1 !=3D strchr(str, '-') && !strstarts(str, "dump-type"))
>  		return false;
> =20
>  	/*
