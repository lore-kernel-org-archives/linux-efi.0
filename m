From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/3] arm64: efistub: drop __init annotation from
 handle_kernel_image()
Date: Tue, 2 Feb 2016 11:08:21 +0000
Message-ID: <20160202110821.GB2642@codeblueprint.co.uk>
References: <1453979254-25374-1-git-send-email-ard.biesheuvel@linaro.org>
 <1453979254-25374-2-git-send-email-ard.biesheuvel@linaro.org>
 <20160128225809.GF2571@codeblueprint.co.uk>
 <CAKv+Gu9sE4oJrFmSK8sEjTrU8A7k53Hj1S1pTyCqyA5Gsba2Kw@mail.gmail.com>
 <20160129160006.GD2611@codeblueprint.co.uk>
 <CAKv+Gu96tdf8ZrGHDi_YKacsRF_b336Nu4Anh61j4u3Lg18BHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu96tdf8ZrGHDi_YKacsRF_b336Nu4Anh61j4u3Lg18BHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 29 Jan, at 05:03:16PM, Ard Biesheuvel wrote:
> On 29 January 2016 at 17:00, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> =
wrote:
> > On Fri, 29 Jan, at 10:36:03AM, Ard Biesheuvel wrote:
> >> On 28 January 2016 at 23:58, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW75QkVnex5nT@public.gmane.org=
k> wrote:
> >> >
> >> > Would it make more sense to #undef __init in one of the arm64 ef=
istub
> >> > header files? I'm thinking of the case where some poor unsuspect=
ing
> >> > developer writes a new function and marks it as __init, and we m=
iss it
> >> > during review.
> >> >
> >>
> >> Yes, I can add it to efistub.h, and make sure it gets included in =
all the files
> >>
> >> Should we #undef it and #define it to a string that is easily grep=
'ed
> >> for, so it is easy to find the explanatory comment that goes along
> >> with it?
> >> E.g.,
> >>
> >> #define __init __init_not_supported_in_efi_stub
> >
> > This would produce a compilation failure if someone tags something =
as
> > __init right? Looks fine to me.
>=20
> Yes, but it makes the error message difficult to decipher, since
> __init is printed and not what it resolves to. Locally, I tried this,
> which seems to work:
>=20
> #undef __init
> #define __init __attribute__((__init_not_supported_in_efi_stub))
> #pragma GCC diagnostic error "-Wattributes"
>=20
> which produces
>=20
>   CC      drivers/firmware/efi/libstub/arm-stub.o
> /home/ard/linux-2.6/drivers/firmware/efi/libstub/arm-stub.c:24:1:
> error: =E2=80=98__init_not_supported_in_efi_stub=E2=80=99 attribute d=
irective ignored
> [-Werror=3Dattributes]
>  {
>  ^
> cc1: some warnings being treated as errors
>=20
> which is slightly dodgy, but at least puts the string right in the er=
ror message

What about,

#define __init __compiletime_error("__init not supported in EFI boot st=
ub")

?
