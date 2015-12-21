From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Replace early_memremap() with memremap()
Date: Mon, 21 Dec 2015 12:07:52 -0800
Message-ID: <20151221200752.GA23410@x>
References: <1450707172-12561-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450707172-12561-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, =?iso-8859-1?Q?M=F4she?= van der Sterre <me-A/3C56C7qwM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Dec 21, 2015 at 02:12:52PM +0000, Matt Fleming wrote:
> M=F4she reported the following warning triggered on his machine since
> commit 50a0cb565246 ("x86/efi-bgrt: Fix kernel panic when mapping BGR=
T
> data"),
>=20
>   [    0.026936] ------------[ cut here ]------------
>   [    0.026941] WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:137 __e=
arly_ioremap+0x102/0x1bb()
>   [    0.026941] Modules linked in:
>   [    0.026944] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.4.0-rc1 =
#2
>   [    0.026945] Hardware name: Dell Inc. XPS 13 9343/09K8G1, BIOS A0=
5 07/14/2015
>   [    0.026946]  0000000000000000 900f03d5a116524d ffffffff81c03e60 =
ffffffff813a3fff
>   [    0.026948]  0000000000000000 ffffffff81c03e98 ffffffff810a0852 =
00000000d7b76000
>   [    0.026949]  0000000000000000 0000000000000001 0000000000000001 =
000000000000017c
>   [    0.026951] Call Trace:
>   [    0.026955]  [<ffffffff813a3fff>] dump_stack+0x44/0x55
>   [    0.026958]  [<ffffffff810a0852>] warn_slowpath_common+0x82/0xc0
>   [    0.026959]  [<ffffffff810a099a>] warn_slowpath_null+0x1a/0x20
>   [    0.026961]  [<ffffffff81d8c395>] __early_ioremap+0x102/0x1bb
>   [    0.026962]  [<ffffffff81d8c602>] early_memremap+0x13/0x15
>   [    0.026964]  [<ffffffff81d78361>] efi_bgrt_init+0x162/0x1ad
>   [    0.026966]  [<ffffffff81d778ec>] efi_late_init+0x9/0xb
>   [    0.026968]  [<ffffffff81d58ff5>] start_kernel+0x46f/0x49f
>   [    0.026970]  [<ffffffff81d58120>] ? early_idt_handler_array+0x12=
0/0x120
>   [    0.026972]  [<ffffffff81d58339>] x86_64_start_reservations+0x2a=
/0x2c
>   [    0.026974]  [<ffffffff81d58485>] x86_64_start_kernel+0x14a/0x16=
d
>   [    0.026977] ---[ end trace f9b3812eb8e24c58 ]---
>   [    0.026978] efi_bgrt: Ignoring BGRT: failed to map image memory
>=20
> early_memremap() has an upper limit on the size of mapping it can
> handle which is ~200KB. Clearly the BGRT image on M=F4she's machine i=
s
> much larger than that.
>=20
> There's actually no reason to restrict ourselves to using the early_*
> version of memremap() - the ACPI BGRT driver is invoked late enough i=
n
> boot that we can use the standard version, with the benefit that the
> late version allows mappings of arbitrary size.
>=20
> Reported-by: M=F4she van der Sterre <me-A/3C56C7qwM@public.gmane.org>
> Tested-by: M=F4she van der Sterre <me-A/3C56C7qwM@public.gmane.org>
> Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>

Reviewed-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>

>  arch/x86/platform/efi/efi-bgrt.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi=
/efi-bgrt.c
> index bf51f4c02562..b0970661870a 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -72,14 +72,14 @@ void __init efi_bgrt_init(void)
>  		return;
>  	}
> =20
> -	image =3D early_memremap(bgrt_tab->image_address, sizeof(bmp_header=
));
> +	image =3D memremap(bgrt_tab->image_address, sizeof(bmp_header), MEM=
REMAP_WB);
>  	if (!image) {
>  		pr_err("Ignoring BGRT: failed to map image header memory\n");
>  		return;
>  	}
> =20
>  	memcpy(&bmp_header, image, sizeof(bmp_header));
> -	early_memunmap(image, sizeof(bmp_header));
> +	memunmap(image);
>  	bgrt_image_size =3D bmp_header.size;
> =20
>  	bgrt_image =3D kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
> @@ -89,7 +89,7 @@ void __init efi_bgrt_init(void)
>  		return;
>  	}
> =20
> -	image =3D early_memremap(bgrt_tab->image_address, bmp_header.size);
> +	image =3D memremap(bgrt_tab->image_address, bmp_header.size, MEMREM=
AP_WB);
>  	if (!image) {
>  		pr_err("Ignoring BGRT: failed to map image memory\n");
>  		kfree(bgrt_image);
> @@ -98,5 +98,5 @@ void __init efi_bgrt_init(void)
>  	}
> =20
>  	memcpy(bgrt_image, image, bgrt_image_size);
> -	early_memunmap(image, bmp_header.size);
> +	memunmap(image);
>  }
> --=20
> 2.6.2
>=20
