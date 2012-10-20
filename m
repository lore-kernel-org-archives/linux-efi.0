From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH V2 01/10] Secure boot: Add new capability
Date: Sat, 20 Oct 2012 08:15:42 +0800
Message-ID: <1350692142.14835.46.camel@linux-s257.site>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <1348152065-31353-2-git-send-email-mjg@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348152065-31353-2-git-send-email-mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,=20

Sorry for bother you!

I didn't see this Matthew's patchset merged in EFI git tree. Do you hav=
e
plan to merge it? Or those patches need wait different subsystem leader=
s
merge.


Thanks a lot!
Joey Lee

=E6=96=BC =E5=9B=9B=EF=BC=8C2012-09-20 =E6=96=BC 10:40 -0400=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> Secure boot adds certain policy requirements, including that root mus=
t not
> be able to do anything that could cause the kernel to execute arbitra=
ry code.
> The simplest way to handle this would seem to be to add a new capabil=
ity
> and gate various functionality on that. We'll then strip it from the =
initial
> capability set if required.
>=20
> Signed-off-by: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/capability.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index d10b7ed..4345bc8 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -364,7 +364,11 @@ struct cpu_vfs_cap_data {
> =20
>  #define CAP_BLOCK_SUSPEND    36
> =20
> -#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
> +/* Allow things that trivially permit root to modify the running ker=
nel */
> +
> +#define CAP_COMPROMISE_KERNEL  37
> +
> +#define CAP_LAST_CAP         CAP_COMPROMISE_KERNEL
> =20
>  #define cap_valid(x) ((x) >=3D 0 && (x) <=3D CAP_LAST_CAP)
> =20
