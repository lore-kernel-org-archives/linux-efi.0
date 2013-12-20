From: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH 02/14] x86-64/efi: Use EFI to deal with platform wall
 clock (again)
Date: Fri, 20 Dec 2013 11:29:55 +0000
Message-ID: <20131220112955.75e82a86@alan.etchedpixels.co.uk>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	<1387448416-11672-1-git-send-email-jlee@suse.com>
	<20131219104908.GE3145@console-pimps.org>
	<1387459939.3539.4092.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387459939.3539.4092.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 19 Dec 2013 21:32:19 +0800
joeyli <jlee-IBi9RG/b67k@public.gmane.org> wrote:

> =E6=96=BC =E5=9B=9B=EF=BC=8C2013-12-19 =E6=96=BC 10:49 +0000=EF=BC=8C=
Matt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> > On Thu, 19 Dec, at 06:20:16PM, Lee, Chun-Yi wrote:
> > > From: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
> > >=20
> > > Other than ix86, x86-64 on EFI so far didn't set the
> > > {g,s}et_wallclock accessors to the EFI routines, thus
> > > incorrectly using raw RTC accesses instead.

Probably wise.

Before anyone reverts that please make sure it also works on EFI32,
because right now we crash and burn on multiple EFI32 tablets querying
the time.

Alan
