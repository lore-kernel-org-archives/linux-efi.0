From: Zbigniew =?utf-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek-wrcVdnn0TatmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [systemd-devel] [PATCH] Add syste-firmware-efi-efivars.mount
 for support automount EFI variable filesystem
Date: Wed, 24 Oct 2012 14:23:37 +0200
Message-ID: <20121024122337.GV19454@in.waw.pl>
References: <1351075322-3824-1-git-send-email-jlee@suse.com>
 <20121024121246.GU19454@in.waw.pl>
 <CAPXgP10Jejdu6Q=4XDy0ujjX6kKX-efgCZxmPJJiV5YRfNCJ6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPXgP10Jejdu6Q=4XDy0ujjX6kKX-efgCZxmPJJiV5YRfNCJ6Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 24, 2012 at 02:17:39PM +0200, Kay Sievers wrote:
> On Wed, Oct 24, 2012 at 2:12 PM, Zbigniew J=C4=99drzejewski-Szmek
> <zbyszek-wrcVdnn0TatmR6Xm/wNWPw@public.gmane.org> wrote:
> > On Wed, Oct 24, 2012 at 06:42:02PM +0800, Lee, Chun-Yi wrote:
> >> Add units/sys-firmware-efi-efivars.mount rule for support automoun=
t EFI variable filesystem
> >> ---
> > Hi,
> >
> > in systemd parlance, automount means autofs mount, but to have that=
, a
> > second .automount unit is needed.  Please have a look at
> > http://cgit.freedesktop.org/systemd/systemd/tree/units/proc-sys-fs-=
binfmt_misc.automount
> > vs
> > http://cgit.freedesktop.org/systemd/systemd/tree/units/proc-sys-fs-=
binfmt_misc.mount .
> > Now the question is whether the loading of the fs is slow enough to
> > matter, ie. if it is actually beneficial to use automount instead o=
f
> > mounting directly.  Since the fs can be compiled as a module, than =
it
> > probably is.
> >
> > Also, would be nice to add a Documentation=3D line like in
> > proc-sys-fs-binfmt_misc.automount.
>=20
> It might all not be worth it, and we might just add it to the
> "unconditionally mounted" list in the compiled-in code (marked with
> allowed-to-fail). It seems like the better option than having a mount
> unit, and a module-load force option.
Probably should be measured by someone with UEFI. This will likely be
a very rarely used fs, so if the loading time is actually measureable,
than automount probably makes sense.

> The current mount unit would never trigger for modules, because the
> path will not exist. An internal API mount will cause a trransparent
> kernel-forked modprobe with the mount() syscall.
Yeah, the ConditionPathExists would have to be dropped.

Zbyszek
