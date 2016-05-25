From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi: fix for_each_efi_memory_desc_in_map() for empty
 memmaps
Date: Wed, 25 May 2016 17:00:10 -0400
Message-ID: <1464210010.15044.15.camel@redhat.com>
References: <1464187015-5640-1-git-send-email-vkuznets@redhat.com>
	 <20160525204805.GE2984@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160525204805.GE2984-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "K. Y. Srinivasan" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2016-05-25 at 21:48 +0100, Matt Fleming wrote:
> (Cc'ing Mark, the original author)
>=20
> On Wed, 25 May, at 04:36:55PM, Vitaly Kuznetsov wrote:
> >=20
> > Commit 78ce248faa3c ("efi: Iterate over efi.memmap in
> > for_each_efi_memory_desc()") introduced a regression for systems bo=
oted
> > with 'noefi' kernel option. In particular, I observe early kernel h=
ang in
> > efi_find_mirror() on for_each_efi_memory_desc() call. As we don't h=
ave
> > efi memmap we enter this iterator with the following parameters:
> >=20
> > efi.memmap.map =3D 0, efi.memmap.map_end =3D 0, efi.memmap.desc_siz=
e =3D 28
> >=20
> > for_each_efi_memory_desc_in_map() does the following comparison:
> >=20
> > (md) <=3D (efi_memory_desc_t *)((m)->map_end - (m)->desc_size);
> >=20
> > where md =3D 0, (m)->map_end =3D 0 and (m)->desc_size =3D 28 but wh=
en we subtract
> > something from a NULL pointer wrap around happens and we end up ret=
urning
> > invalid pointer.
> >=20
> > Fixes: 78ce248faa3c ("efi: Iterate over efi.memmap in for_each_efi_=
memory_desc()")
> > Signed-off-by: Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0include/linux/efi.h | 3 ++-
> > =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/include/linux/efi.h b/include/linux/efi.h
> > index c2db3ca..229ccb5 100644
> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -1005,7 +1005,8 @@ extern int efi_memattr_apply_permissions(stru=
ct mm_struct *mm,
> > =C2=A0/* Iterate through an efi_memory_map */
> > =C2=A0#define for_each_efi_memory_desc_in_map(m, md)				=C2=A0=C2=A0=
=C2=A0\
> > =C2=A0	for ((md) =3D (m)->map;						=C2=A0=C2=A0=C2=A0\
> > -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(md) <=3D (efi_memory_desc_t *)((m)=
->map_end - (m)->desc_size); \
> > +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(efi_memory_desc_t *)((md) + (m)->d=
esc_size) <=3D		=C2=A0=C2=A0=C2=A0\
> > +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(efi_memory_desc_t *)(m)->map_end;=
			=C2=A0=C2=A0=C2=A0\
> > =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(md) =3D (void *)(md) + (m)->d=
esc_size)
> Curse C type casting!
>=20
> You're adding m->desc_size to a (efi_memory_desc_t *) which is 40
> bytes. You need the below to avoid breaking regular EFI boot.
>=20
> But yeah, this looks like a fine fix. Mark, any concerns?

No concerns. It looks like the right thing to do.

>=20
> ---
>=20
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index d8ab480b1089..3a3f8d8bd9be 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1026,7 +1026,7 @@ extern int efi_memattr_apply_permissions(struct=
 mm_struct *mm,
> =C2=A0/* Iterate through an efi_memory_map */
> =C2=A0#define for_each_efi_memory_desc_in_map(m, md)				=C2=A0=C2=A0=C2=
=A0\
> =C2=A0	for ((md) =3D (m)->map;						=C2=A0=C2=A0=C2=A0\
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(md) <=3D (efi_memory_desc_t *)((m)->=
map_end - (m)->desc_size); \
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0((void *)(md) + (m)->desc_size) <=3D	=
(m)->map_end;		=C2=A0=C2=A0=C2=A0\
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(md) =3D (void *)(md) + (m)->des=
c_size)
> =C2=A0
> =C2=A0/**
