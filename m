From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: BGRT warns again on my system
Date: Sat, 28 May 2016 15:25:32 -0700
Message-ID: <20160528222531.GA10687@x>
References: <CALCETrUJ2QoUSYY82Q1BN3niasiunktnrmdE9Lmi2PZnCJRdag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUJ2QoUSYY82Q1BN3niasiunktnrmdE9Lmi2PZnCJRdag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?iso-8859-1?Q?M=F4she?= van der Sterre <me-A/3C56C7qwM@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, May 28, 2016 at 01:46:07PM -0700, Andy Lutomirski wrote:
> My garbage workstation splats like this on boot:
>=20
> [    0.160523] ioremap: invalid physical address d0c801800000001
>=20
> This was fixed for a while, but I think the problem was reintroduced =
by:
>=20
> commit 66dbe99cfe30e113d2e571e68b9b6a1a8985a157
> Author: M=F4she van der Sterre <me-A/3C56C7qwM@public.gmane.org>
> Date:   Mon Feb 1 22:07:03 2016 +0000
>=20
>     x86/efi/bgrt: Don't ignore the BGRT if the 'valid' bit is 0
>=20
> Is there any good way to fix this again?

This was the kind of concern I had about ignoring the valid bit.  I
supported this patch based on the statement that Windows 10 ignores the
valid bit as well.  Presumably either Windows has some way of detecting
this kind of problem, or it would break on that system.  If the former,
does anyone know what algorithm Windows uses to safely check for BGRT?

I can see two possible ways to fix this.  If we can detect in advance
that the address in the BGRT looks bogus (pointing to physical memory
that doesn't exist, for instance), then we could ignore it entirely
(without any warning if valid=3D=3D0, or with a warning if valid=3D=3D1=
).  If we
can't detect that in advance, then we need to revert this patch and go
back to respecting the valid bit.  (However, trying to check the addres=
s
in advance seems preferable given that some BIOS might have a bogus
address even with valid=3D=3D1.)
