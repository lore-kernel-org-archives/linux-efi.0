From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/mm, efi: Check for valid image type
Date: Tue, 28 Jul 2015 21:51:57 +0100
Message-ID: <20150728205157.GD2773@codeblueprint.co.uk>
References: <1437579164-20176-1-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437579164-20176-1-git-send-email-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Pulling in Josh)

On Wed, 22 Jul, at 05:32:44PM, Sebastian Andrzej Siewior wrote:
> I usually see
> |Ignoring BGRT: failed to allocate memory for image (wanted 264301314=
 bytes)
> |Ignoring BGRT: failed to allocate memory for image (wanted 392587289=
1 bytes)
>=20
> sometimes I get
>=20
> |------------[ cut here ]------------
> |WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:136 __early_ioremap.con=
stprop.0+0x113/0x1d3()
> =E2=80=A6
> | [<ffffffff81b3de8c>] __early_ioremap.constprop.0+0x113/0x1d3
> | [<ffffffff81b3e106>] early_ioremap+0x13/0x15
> | [<ffffffff81b2c4a9>] efi_bgrt_init+0x1e2/0x27d
> =E2=80=A6
>=20
> now and then. The data behind that pointer changes on each boot becau=
se
> nobody preserves the content across kexec.
>=20
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> ---
>=20
> I don't know much about the requirement of having the .bmp in memory =
all the
> time. Would it be a bad thing to compress the bmp and uncompress on c=
at from
> userland? In my case the bmp has 272 KiB and LZO gets it down to 12Ki=
B,
> XZ 7.4KiB.

The usual use for BGRT is to display it during kernel boot, so
interacting with userland doesn't help you there.

>  arch/x86/platform/efi/efi-bgrt.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi=
/efi-bgrt.c
> index d7f997f7c26d..59710f0875bb 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -79,6 +79,10 @@ void __init efi_bgrt_init(void)
>  	memcpy_fromio(&bmp_header, image, sizeof(bmp_header));
>  	if (ioremapped)
>  		early_iounmap(image, sizeof(bmp_header));
> +	if (bmp_header.id !=3D 0x4d42) {
> +		pr_err("BGRT: Not a valid BMP file.\n");
> +		return;
> +	}
>  	bgrt_image_size =3D bmp_header.size;
> =20
>  	bgrt_image =3D kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);

I'm confused, is the BMP image valid on your machine or not? You add a
validity check but talk about compressing it above.

--=20
Matt Fleming, Intel Open Source Technology Center
