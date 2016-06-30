From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH 11/11] x86/efi-bgrt: Use efi_mem_reserve() to avoid
 copying image data
Date: Thu, 30 Jun 2016 07:41:43 -0700
Message-ID: <20160630144143.GA13005@cloud>
References: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
 <1466681690-5850-12-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466681690-5850-12-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, =?iso-8859-1?Q?M=F4she?= van der Sterre <me-A/3C56C7qwM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 23, 2016 at 12:34:50PM +0100, Matt Fleming wrote:
> efi_mem_reserve() allows us to permanently mark EFI boot services
> regions as reserved, which means we no longer need to copy the image
> data out and into a separate buffer.
>=20
> Leaving the data in the original boot services region has the added
> benefit that BGRT images can now be passed across kexec reboot.
>=20
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
> Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> Cc: M=F4she van der Sterre <me-A/3C56C7qwM@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>

Reviewed-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>

This definitely seems like an improvement.

>  arch/x86/platform/efi/efi-bgrt.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
>=20
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi=
/efi-bgrt.c
> index 6a2f5691b1ab..6aad870e8962 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -82,21 +82,12 @@ void __init efi_bgrt_init(void)
>  	}
>  	bgrt_image_size =3D bmp_header.size;
> =20
> -	bgrt_image =3D kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
> +	bgrt_image =3D memremap(bgrt_tab->image_address, bmp_header.size, M=
EMREMAP_WB);
>  	if (!bgrt_image) {
> -		pr_notice("Ignoring BGRT: failed to allocate memory for image (wan=
ted %zu bytes)\n",
> -		       bgrt_image_size);
> -		return;
> -	}
> -
> -	image =3D memremap(bgrt_tab->image_address, bmp_header.size, MEMREM=
AP_WB);
> -	if (!image) {
>  		pr_notice("Ignoring BGRT: failed to map image memory\n");
> -		kfree(bgrt_image);
>  		bgrt_image =3D NULL;
>  		return;
>  	}
> =20
> -	memcpy(bgrt_image, image, bgrt_image_size);
> -	memunmap(image);
> +	efi_mem_reserve(bgrt_tab->image_address, bgrt_image_size);
>  }
> --=20
> 2.7.3
>=20
