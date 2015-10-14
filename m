From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Fix multiple GOP device support
Date: Wed, 14 Oct 2015 16:47:15 +0200
Message-ID: <20151014144715.GA17890@gmail.com>
References: <1444659236-24837-1-git-send-email-matt@codeblueprint.co.uk>
 <1444659236-24837-2-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444659236-24837-2-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, =?utf-8?B?S8WRdsOhZ8OzLCBab2x0w6Fu?= <dirty.ice.hu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> From: K=C5=91v=C3=A1g=C3=B3, Zolt=C3=A1n <dirty.ice.hu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> When multiple GOP devices exists, but none of them implements ConOut,
> the code should just choose the first GOP (according to the comments)=
=2E
> But currently fb_base will refer to the last GOP, while other paramet=
ers
> to the first GOP, which will likely result in a garbled display.
>=20
> I can reliably reproduce this bug using my ASRock Z87M Extreme4
> motherboard with CSM and integrated GPU disabled, and two PCIe video
> cards (NVidia GT640 and GTX980), booting from efi-stub (booting from
> grub works fine).  On the primary display the asrock logo remains and=
 on
> the secondary screen is garbled up completely.
>=20
> Signed-off-by: K=C5=91v=C3=A1g=C3=B3, Zolt=C3=A1n <DirtY.iCE.hu@gmail=
=2Ecom>
> Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compres=
sed/eboot.c
> index ee1b6d346b98..db51c1f27446 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -667,6 +667,7 @@ setup_gop32(struct screen_info *si, efi_guid_t *p=
roto,
>  		bool conout_found =3D false;
>  		void *dummy =3D NULL;
>  		u32 h =3D handles[i];
> +		u32 current_fb_base;

Sigh, fb_base is u64...

> @@ -770,6 +772,7 @@ setup_gop64(struct screen_info *si, efi_guid_t *p=
roto,
>  		bool conout_found =3D false;
>  		void *dummy =3D NULL;
>  		u64 h =3D handles[i];
> +		u32 current_fb_base;

Ditto.

So I've applied it with that obvious bug fixed, but could you guys plea=
se double=20
check how on earth this patch could possibly have worked fine in testin=
g, without=20
crashing 64-bit kernels?

Thanks,

	Ingo
