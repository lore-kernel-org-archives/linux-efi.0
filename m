From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2] efi: Resolve some shadow warnings
Date: Mon, 8 Sep 2014 17:08:05 +0100
Message-ID: <20140908160805.GT3001@console-pimps.org>
References: <1410008573-444-1-git-send-email-jeffrey.t.kirsher@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1410008573-444-1-git-send-email-jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, 06 Sep, at 06:02:53AM, Jeff Kirsher wrote:
> From: Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> It is a really bad idea to declare variables or parameters that
> have the same name as common types. It is valid C, but it gets
> surprising if a macro expansion attempts to declare an inner
> local with that type. Change the local names to eliminate the
> hazard.
>=20
> Change s16 =3D> str16, s8 =3D> str8.
>=20
> This resolves warnings seen when using W=3D2 during make, for instanc=
e:
>=20
> drivers/firmware/efi/vars.c: In function =E2=80=98dup_variable_bug=E2=
=80=99:
> drivers/firmware/efi/vars.c:324:44: warning: declaration of =E2=80=98=
s16=E2=80=99 shadows a global declaration [-Wshadow]
>  static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_g=
uid,
>=20
> drivers/firmware/efi/vars.c:328:8: warning: declaration of =E2=80=98s=
8=E2=80=99 shadows a global declaration [-Wshadow]
>   char *s8;
>=20
> Signed-off-by: Mark Rustad <mark.d.rustad-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks Jeff, Mark, applied.

--=20
Matt Fleming, Intel Open Source Technology Center
