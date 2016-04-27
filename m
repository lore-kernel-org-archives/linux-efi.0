From: =?UTF-8?Q?M=c3=b4she_van_der_Sterre?= <me-A/3C56C7qwM@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Switch all pr_err() to pr_debug() for
 invalid BGRT
Date: Wed, 27 Apr 2016 15:26:35 +0200
Message-ID: <5720BE0B.8080605@moshe.nl>
References: <1461761412-16046-1-git-send-email-jwboyer@fedoraproject.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461761412-16046-1-git-send-email-jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(additionally CC-ing Josh Triplett)

On 04/27/2016 02:50 PM, Josh Boyer wrote:
> The promise of pretty boot splashes from firmware via BGRT was at
> best only that; a promise.  The kernel diligently checks to make
> sure the BGRT data firmware gives it is valid, and dutifully warns
> the user when it isn't.  However, it does so via the pr_err log
> level which seems unnecessary.  The user cannot do anything about
> this and there really isn't an error on the part of Linux to
> correct.
>
> This lowers the log level by using pr_debug instead.  Users will
> no longer have their boot process uglified by the kernel reminding
> us that firmware can and often is broken.  Ironic, considering
> BGRT is supposed to make boot pretty to begin with.
Hi Josh Boyer,

Are you seeing these errors somewhere? I recently fixed the error=20
"Ignoring BGRT: invalid status 0 (expected 1)" because Linux apparently=
=20
interpreted that part of the specification differently than others.
If that's the error you are seeing, perhaps your problem is already=20
solved in recent kernels? (fixed in commit 66dbe99)

Personally I agree that BGRT messages should not annoy actual users of=20
production firmwares.
However I also agree with the previous consensus that these checks (for=
=20
actual spec violations) should remain pr_err unless some production=20
firmware is triggering them. What do you think?

Greetings,
M=F4she van der Sterre

> Signed-off-by: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
> ---
>   arch/x86/platform/efi/efi-bgrt.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi=
/efi-bgrt.c
> index a2433817c987..6f70d2ac8029 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -43,40 +43,40 @@ void __init efi_bgrt_init(void)
>   		return;
>  =20
>   	if (bgrt_tab->header.length < sizeof(*bgrt_tab)) {
> -		pr_err("Ignoring BGRT: invalid length %u (expected %zu)\n",
> +		pr_debug("Ignoring BGRT: invalid length %u (expected %zu)\n",
>   		       bgrt_tab->header.length, sizeof(*bgrt_tab));
>   		return;
>   	}
>   	if (bgrt_tab->version !=3D 1) {
> -		pr_err("Ignoring BGRT: invalid version %u (expected 1)\n",
> +		pr_debug("Ignoring BGRT: invalid version %u (expected 1)\n",
>   		       bgrt_tab->version);
>   		return;
>   	}
>   	if (bgrt_tab->status & 0xfe) {
> -		pr_err("Ignoring BGRT: reserved status bits are non-zero %u\n",
> +		pr_debug("Ignoring BGRT: reserved status bits are non-zero %u\n",
>   		       bgrt_tab->status);
>   		return;
>   	}
>   	if (bgrt_tab->image_type !=3D 0) {
> -		pr_err("Ignoring BGRT: invalid image type %u (expected 0)\n",
> +		pr_debug("Ignoring BGRT: invalid image type %u (expected 0)\n",
>   		       bgrt_tab->image_type);
>   		return;
>   	}
>   	if (!bgrt_tab->image_address) {
> -		pr_err("Ignoring BGRT: null image address\n");
> +		pr_debug("Ignoring BGRT: null image address\n");
>   		return;
>   	}
>  =20
>   	image =3D memremap(bgrt_tab->image_address, sizeof(bmp_header), ME=
MREMAP_WB);
>   	if (!image) {
> -		pr_err("Ignoring BGRT: failed to map image header memory\n");
> +		pr_debug("Ignoring BGRT: failed to map image header memory\n");
>   		return;
>   	}
>  =20
>   	memcpy(&bmp_header, image, sizeof(bmp_header));
>   	memunmap(image);
>   	if (bmp_header.id !=3D 0x4d42) {
> -		pr_err("Ignoring BGRT: Incorrect BMP magic number 0x%x (expected 0=
x4d42)\n",
> +		pr_debug("Ignoring BGRT: Incorrect BMP magic number 0x%x (expected=
 0x4d42)\n",
>   			bmp_header.id);
>   		return;
>   	}
> @@ -84,14 +84,14 @@ void __init efi_bgrt_init(void)
>  =20
>   	bgrt_image =3D kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN)=
;
>   	if (!bgrt_image) {
> -		pr_err("Ignoring BGRT: failed to allocate memory for image (wanted=
 %zu bytes)\n",
> +		pr_debug("Ignoring BGRT: failed to allocate memory for image (want=
ed %zu bytes)\n",
>   		       bgrt_image_size);
>   		return;
>   	}
>  =20
>   	image =3D memremap(bgrt_tab->image_address, bmp_header.size, MEMRE=
MAP_WB);
>   	if (!image) {
> -		pr_err("Ignoring BGRT: failed to map image memory\n");
> +		pr_debug("Ignoring BGRT: failed to map image memory\n");
>   		kfree(bgrt_image);
>   		bgrt_image =3D NULL;
>   		return;
