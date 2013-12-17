From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 3/3] efi: Make efi virtual runtime map passing more robust
Date: Tue, 17 Dec 2013 12:10:24 +0000
Message-ID: <20131217121024.GB3145@console-pimps.org>
References: <1387236997-26975-1-git-send-email-bp@alien8.de>
 <1387236997-26975-4-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1387236997-26975-4-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 17 Dec, at 12:36:37AM, Borislav Petkov wrote:
> From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
>=20
> Currently, running SetVirtualAddressMap() and passing the physical
> address of the virtual map array was working only by a lucky coincide=
nce
> because the memory was present in the EFI page table too. Until Toshi
> went and booted this on a big HP box - the krealloc() manner of resiz=
ing
> the memmap we're doing did allocate from such physical addresses whic=
h
> were not mapped anymore and boom:
>=20
> http://lkml.kernel.org/r/1386806463.1791.295.camel-RbGIw1UOYPVo/CpIj0byZw@public.gmane.org
>=20
> One way to take care of that issue is to reimplement the krealloc thi=
ng
> but with pages. We start with contiguous pages of order 1, i.e. 2 pag=
es,
> and when we deplete that memory (shouldn't happen all that often but =
you
> know firmware) we realloc the next power-of-two pages.
>=20
> Having the pages, it is much more handy and easy to map them into the
> EFI page table with the already existing mapping code which we're usi=
ng
> for building the virtual mappings.
>=20
> And, it doesn't matter all that much how much pages we've used as we'=
re
> freeing them right after they've fulfilled their purpose at the end o=
f
> the function anyway.
>=20
> Reported-by: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
> Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 57 +++++++++++++++++++++++++++++++++++=
+++-------
>  1 file changed, 48 insertions(+), 9 deletions(-)

[...]

> @@ -794,12 +814,13 @@ void __init old_map_region(efi_memory_desc_t *m=
d)
>   */
>  void __init efi_enter_virtual_mode(void)
>  {
> +	pgd_t *pgd =3D (pgd_t *)__va(real_mode_header->trampoline_pgd);
> +	unsigned long size, new_memmap_left =3D 0;
>  	efi_memory_desc_t *md, *prev_md =3D NULL;
> +	int count =3D 0, new_memmap_shift =3D 0;
>  	void *p, *new_memmap =3D NULL;
> -	unsigned long size;
>  	efi_status_t status;
>  	u64 end, systab;
> -	int count =3D 0;
> =20
>  	efi.systab =3D NULL;

You sunk my i386 battleship,

/home/build/git/efi/arch/x86/platform/efi/efi.c:824:24: error: =E2=80=98=
struct real_mode_header=E2=80=99 has no member named =E2=80=98trampolin=
e_pgd=E2=80=99
make[4]: *** [arch/x86/platform/efi/efi.o] Error 1
make[3]: *** [arch/x86/platform/efi] Error 2

--=20
Matt Fleming, Intel Open Source Technology Center
