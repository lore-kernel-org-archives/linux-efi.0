From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
Date: Mon, 10 Nov 2014 11:22:13 +0000
Message-ID: <1415618533.14686.239.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org>
	 <1412348517.5410.13.camel@deneb.redhat.com> <201411091837.47354@pali>
	 <20141109182231.GA29337@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141109182231.GA29337-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 2014-11-09 at 19:22 +0100, Borislav Petkov wrote:
> On Sun, Nov 09, 2014 at 06:37:46PM +0100, Pali Roh=C3=A1r wrote:
> > this patch totally disabled efi rfc driver on x86 machines at=20
> > compile time. But on some x86 machines it working without crash=20
> > and reading from file /sys/class/rtc/rtc*/since_epoch returns=20
> > correct information. So why to disable compiling driver on=20
> > machines where driver working?
>=20
> Sounds like we need an efi=3Drtc_enable knob for people who what to u=
se
> it...

I'm not so sure. By and large, the EFI runtime Time services just don't
work very well on x86. Just because they work sometimes, doesn't
actually mean it's a good idea to use them.

The one scenario where the time services are useful is early on during
boot when we want to get the timezone information. I have vague
recollections of someone working on that.
