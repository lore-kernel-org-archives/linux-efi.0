From: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Date: Thu, 13 Mar 2014 21:24:50 +0000
Message-ID: <20140313212450.67f1de8e@alan.etchedpixels.co.uk>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	<alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	<1394686919.25122.2.camel@x230>
	<CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	<alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	<1394726363.25122.16.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1394726363.25122.16.camel@x230>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org" <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 13 Mar 2014 15:59:24 +0000
Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:

> On Thu, 2014-03-13 at 20:33 +1100, James Morris wrote:
>=20
> > I'll take it, but there's unanswered review feedback (your response=
 to the=20
> > first question), and Alan raised some doubts about the patches whic=
h I'm=20
> > not sure have been resolved.
>=20
> The remaining opens seem to be CAP_SYS_RAWIO and firmware signing?
> Ironically, disabling CAP_SYS_RAWIO disables firmware loading=E2=80=A6
>=20
> The problem with CAP_SYS_RAWIO is that its semantics were never
> sufficiently well documented, and as a result it's a mixture of "This=
 is
> incredibly dangerous" and "We replaced a check for uid 0 with whichev=
er
> capability seemed to have the most appropriate name". I've gone throu=
gh
> all the uses of CAP_SYS_RAWIO and added additional checks to the gene=
ric
> ones that seem appropriate. There's a couple of old drivers that use =
it
> to gate access to features that potentially allow arbitrary DMA and i=
t
> might be worth cleaning those up, but the only general case I haven't
> modified is the ability to send arbitrary SCSI commands from userspac=
e.
> My understanding is that endpoints aren't going to be able to DMA to
> arbitrary addresses, so that doesn't seem like a problem.
>=20
> On the other hand, disabling CAP_SYS_RAWIO *definitely* breaks expect=
ed
> functionality - firmware loading and the fibmap ioctl are probably th=
e
> most obvious. And changing the use of CAP_SYS_RAWIO potentially break=
s
> userspace expectations, so we're kind of stuck there.

If I have CAP_SYS_RAWIO I can make arbitary ring 0 calls from userspace=
,
trivially and in a fashion well known and documented.

So if that isn't sufficient then we need to sort CAP_foo out first.

You've missed a few others too - mem=3D (especially with exactmap) for
example.

Alan
