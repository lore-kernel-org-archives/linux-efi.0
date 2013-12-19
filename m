From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 02/14] x86-64/efi: Use EFI to deal with platform wall
 clock (again)
Date: Thu, 19 Dec 2013 21:32:19 +0800
Message-ID: <1387459939.3539.4092.camel@linux-s257.site>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387448416-11672-1-git-send-email-jlee@suse.com>
	 <20131219104908.GE3145@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131219104908.GE3145-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-12-19 =E6=96=BC 10:49 +0000=EF=BC=8CMa=
tt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu, 19 Dec, at 06:20:16PM, Lee, Chun-Yi wrote:
> > From: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
> >=20
> > Other than ix86, x86-64 on EFI so far didn't set the
> > {g,s}et_wallclock accessors to the EFI routines, thus
> > incorrectly using raw RTC accesses instead.
> >=20
> > Simply removing the #ifdef around the respective code isn't
> > enough, however: While so far early get-time calls were done in
> > physical mode, this doesn't work properly for x86-64, as virtual
> > addresses would still need to be set up for all runtime regions
> > (which wasn't the case on the system I have access to), so
> > instead the patch moves the call to efi_enter_virtual_mode()
> > ahead (which in turn allows to drop all code related to calling
> > efi-get-time in physical mode).
> >=20
> > Additionally the earlier calling of efi_set_executable()
> > requires the CPA code to cope, i.e. during early boot it must be
> > avoided to call cpa_flush_array(), as the first thing this
> > function does is a BUG_ON(irqs_disabled()).
> >=20
> > Also make the two EFI functions in question here static -
> > they're not being referenced elsewhere.
> >=20
> > History:
> >=20
> >     This commit was originally merged as bacef661acdb ("x86-64/efi:
> >     Use EFI to deal with platform wall clock") but it resulted in s=
ome
> >     ASUS machines no longer booting due to a firmware bug, and so w=
as
> >     reverted in f026cfa82f62.
> >=20
> >     Then a pre-emptive fix for the buggy ASUS firmware was merged i=
n
> >     03a1c254975e ("x86, efi: 1:1 pagetable mapping for virtual EFI
> >     calls") but it causes odd bootup problems on x86-64. So this pa=
tch
> >     revoked again by 11520e5e7c1.
> >=20
> >     Now Borislav Petkov's "EFI runtime services virtual mapping" is
> >     merged to EFI 'next' branch. So this patch can be reapplied aga=
in.
> >=20
> > Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
> > Tested-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Acked-by: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
> > Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> [added commit =
history]
> > Acked-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> > ---
> >  arch/x86/mm/pageattr.c      |   10 ++++++----
> >  arch/x86/platform/efi/efi.c |   35 +++++++++++--------------------=
----
> >  include/linux/efi.h         |    2 --
> >  init/main.c                 |    8 ++++----
> >  4 files changed, 21 insertions(+), 34 deletions(-)
>=20
> Lee, you can't just simply resend this patch with all the tags - I
> haven't tested this version with any recent changes and I'm pretty su=
re
> Matthew isn't going to Ack it.

I am very sorry for I didn't remove those tags before send it. I will
remove it when send second version.

>=20
> Do you know if anyone has tested this patch with Borislav's recent
> changes?
>=20

I tested Borislav's patch set on a issue BIOS and make sure it works,
but I have no chance to test this patch with it. I will find a time to
test it.


Thanks a lot!
Joey Lee
