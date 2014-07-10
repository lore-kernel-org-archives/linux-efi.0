From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2] efi: implement mandatory locking for UEFI Runtime
 Services
Date: Thu, 10 Jul 2014 19:14:49 +0100
Message-ID: <20140710181449.GI15932@console-pimps.org>
References: <1404818508-17537-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu86W0hBEZhz_Aw07TmRHv8kgQN7JeRMC0Qs6FL0m6BrOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu86W0hBEZhz_Aw07TmRHv8kgQN7JeRMC0Qs6FL0m6BrOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 08 Jul, at 01:23:55PM, Ard Biesheuvel wrote:
> On 8 July 2014 13:21, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrot=
e:
> > According to section 7.1 of the UEFI spec, Runtime Services are not=
 fully
> > reentrant, and there are particular combinations of calls that need=
 to be
> > serialized.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >
> > So this is v2 of the UEFI Runtime Services serialization patch: thi=
s time, I use
> > a single spinlock rather than a set of mutexes, resulting in all se=
rvices to be
> > serialized with respect to all others. Also added handling of NMI s=
tate, as this
> > results in some of the restrictions being lifted (x86, ia64 only)
> >
> > One question remains: with the NMI deadlock handling in place, is i=
t really
> > necessary to disable interrupts in all cases?
> >
>=20
> I omitted this hunk from the patch by accident:

I'm seeing the following build warning with this patch,

In file included from include/linux/seqlock.h:35:0,
                 from include/linux/time.h:5,
                 from include/linux/efi.h:16,
                 from drivers/firmware/efi/runtime-wrappers.c:18:
drivers/firmware/efi/runtime-wrappers.c: In function =E2=80=98virt_efi_=
query_capsule_caps=E2=80=99:
include/linux/spinlock.h:358:2: warning: =E2=80=98flags=E2=80=99 may be=
 used uninitialized in this function [-Wmaybe-uninitialized]
drivers/firmware/efi/runtime-wrappers.c:275:16: note: =E2=80=98flags=E2=
=80=99 was declared here

You'll need to cache the value of efi_in_nmi() in a local variable.

That should be safe, since if we're not executing in NMI context when w=
e
enter the function we won't be executing in NMI context at any point in
during function. It's just that gcc can't infer that information.

--=20
Matt Fleming, Intel Open Source Technology Center
