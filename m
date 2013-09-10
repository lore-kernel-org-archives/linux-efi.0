From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Date: Tue, 10 Sep 2013 19:43:21 -0400
Message-ID: <1378856601.2257.208.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1378767723.17982.27.camel@x230.lan>
	 <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
	 <1378774394.17982.36.camel@x230.lan>
	 <alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz>
	 <1378781715.17982.42.camel@x230.lan>
	 <alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz>
	 <1378785208.17982.54.camel@x230.lan>
	 <20130910172318.GB21530@khazad-dum.debian.net>
	 <1378837571.17615.0.camel@x230.lan> <522F6519.4030004@zytor.com>
	 <20130910185149.GC5559@kroah.com>
	 <CAGXu5j+3oKC-tQe8z43bG8wTpURD4FFCi+A1t9mSN_Bfzh8e8Q@mail.gmail.com>
	 <alpine.DEB.2.02.1309101217150.10412@nftneq.ynat.uz>
	 <522F768F.1000101@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <522F768F.1000101-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: David Lang <david-gFPdbfVZQbY@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Henrique de Moraes Holschuh <hmh-N3TV7GIv+o9fyO9Q7EP/yw@public.gmane.org>, "Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org" <Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-09-10 at 12:44 -0700, H. Peter Anvin wrote:
> On 09/10/2013 12:17 PM, David Lang wrote:
> >>
> >> In theory these blobs are traceable to a manufacturer. It's not really
> >> an indication that it's "safe" more than it's an indication that it
> >> hasn't been changed. But I haven't chased this very hard yet because
> >> of below...
> > 
> > well, not if you are trying to defend against root breaking in to the
> > machine.
> > 
> 
> And we have at least some drivers where we even have the firmware in the
> Linux kernel tree, and thus aren't opaque blobs at all.
> 
> I suspect we'll need, at some point, a way for vendors that aren't
> already doing signatures on their firmware in a device-specific way to
> do so in a kernel-supported way.  The easiest (in terms of getting
> vendors to play along, not necessarily technically) might be a PGP
> signature (either inline or standalone) and have the public key as part
> of the driver?

Why invent yet another method of verifying the integrity of a file based
on a signature?  Why not use the existing method for appraising files?
Just create a new integrity hook at the appropriate place.

Mimi
