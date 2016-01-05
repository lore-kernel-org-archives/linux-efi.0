From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Don't ignore the BGRT if the 'valid' bit
 is 0
Date: Tue, 5 Jan 2016 15:46:40 +0000
Message-ID: <20160105154640.GB2714@codeblueprint.co.uk>
References: <1450648391-4631-1-git-send-email-me@moshe.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450648391-4631-1-git-send-email-me-A/3C56C7qwM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?Q?M=F4she?= van der Sterre <me-A/3C56C7qwM@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 20 Dec, at 10:53:11PM, M=F4she van der Sterre wrote:
> Unintuitively, the BGRT graphic is apparently meant to be usable if
> the valid bit in not set. The valid bit only conveys uncertainty
> about the validity in relation to the screen state.
>=20
> Windows 10 actually uses the BGRT image for its boot screen even if
> not 'valid', for example when the user triggered the boot menu.
> Because it is unclear if all firmwares will provide a usable graphic
> in this case, we now look at the BMP magic number as an additional
> check.
> ---
>  arch/x86/platform/efi/efi-bgrt.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi=
/efi-bgrt.c
> index b097066..a243381 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -57,11 +57,6 @@ void __init efi_bgrt_init(void)
>  		       bgrt_tab->status);
>  		return;
>  	}
> -	if (bgrt_tab->status !=3D 1) {
> -		pr_debug("Ignoring BGRT: invalid status %u (expected 1)\n",
> -			 bgrt_tab->status);
> -		return;
> -	}
>  	if (bgrt_tab->image_type !=3D 0) {
>  		pr_err("Ignoring BGRT: invalid image type %u (expected 0)\n",
>  		       bgrt_tab->image_type);
> @@ -80,6 +75,11 @@ void __init efi_bgrt_init(void)
> =20
>  	memcpy(&bmp_header, image, sizeof(bmp_header));
>  	memunmap(image);
> +	if (bmp_header.id !=3D 0x4d42) {
> +		pr_err("Ignoring BGRT: Incorrect BMP magic number 0x%x (expected 0=
x4d42)\n",
> +			bmp_header.id);
> +		return;
> +	}
>  	bgrt_image_size =3D bmp_header.size;
> =20
>  	bgrt_image =3D kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);


Shouldn't this be pr_debug() instead of pr_err()?
