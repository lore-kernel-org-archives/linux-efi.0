From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] arch: x86: boot: compressed: eboot: fix cast warnings on
 32b platforms
Date: Wed, 26 Dec 2012 09:00:19 +0100
Message-ID: <20121226080019.GB11555@liondog.tnic>
References: <1356171805-16930-1-git-send-email-hasko.stevo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1356171805-16930-1-git-send-email-hasko.stevo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Hasko <hasko.stevo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, Dec 22, 2012 at 11:23:25AM +0100, Stefan Hasko wrote:
> Fixed different size cast warnings in function setup_efi_pci
>=20
> Signed-off-by: Stefan Hasko <hasko.stevo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

You might want to add the actual compiler warnings to the commit
message:

arch/x86/boot/compressed/eboot.c: In function =E2=80=98setup_efi_pci=E2=
=80=99:
arch/x86/boot/compressed/eboot.c:259:9: warning: cast to pointer from i=
nteger of different size [-Wint-to-pointer-cast]
arch/x86/boot/compressed/eboot.c:262:10: warning: cast to pointer from =
integer of different size [-Wint-to-pointer-cast]
arch/x86/boot/compressed/eboot.c:348:17: warning: cast from pointer to =
integer of different size [-Wpointer-to-int-cast]
arch/x86/boot/compressed/eboot.c:350:29: warning: cast from pointer to =
integer of different size [-Wpointer-to-int-cast]

And yes, I see them in all{mod,yes}config builds here too. The issue,
AFAICT, is that setup_data is __u64 to obviously accomodate 8-byte
pointers on x86-64 but on 32-bit they're half the size. And we obviousl=
y
cannot change struct setup_data since this is an ABI so I'd guess the
casts to native pointer sizes are ok. So

Acked-by: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>

> ---
>  arch/x86/boot/compressed/eboot.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compres=
sed/eboot.c
> index b1942e2..dd99fca 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -256,10 +256,10 @@ static efi_status_t setup_efi_pci(struct boot_p=
arams *params)
>  	int i;
>  	struct setup_data *data;
> =20
> -	data =3D (struct setup_data *)params->hdr.setup_data;
> +	data =3D (struct setup_data *)(uintptr_t)params->hdr.setup_data;
> =20
>  	while (data && data->next)
> -		data =3D (struct setup_data *)data->next;
> +		data =3D (struct setup_data *)(uintptr_t)data->next;
> =20
>  	status =3D efi_call_phys5(sys_table->boottime->locate_handle,
>  				EFI_LOCATE_BY_PROTOCOL, &pci_proto,
> @@ -345,9 +345,9 @@ static efi_status_t setup_efi_pci(struct boot_par=
ams *params)
>  		memcpy(rom->romdata, pci->romimage, pci->romsize);
> =20
>  		if (data)
> -			data->next =3D (uint64_t)rom;
> +			data->next =3D (uintptr_t)rom;
>  		else
> -			params->hdr.setup_data =3D (uint64_t)rom;
> +			params->hdr.setup_data =3D (uintptr_t)rom;
> =20
>  		data =3D (struct setup_data *)rom;
> =20
> --=20
> 1.7.10.4

Thanks.

--=20
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
