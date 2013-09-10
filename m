From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Date: Tue, 10 Sep 2013 11:48:06 -0700
Message-ID: <CAGXu5jKKG3tpNWJkLkQbGThku6Lpg8ZPuCaXCZ4F76gk14W-Ow@mail.gmail.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	<19562.1378747124@turing-police.cc.vt.edu>
	<alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	<1378767723.17982.27.camel@x230.lan>
	<alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
	<1378774394.17982.36.camel@x230.lan>
	<alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz>
	<1378781715.17982.42.camel@x230.lan>
	<alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz>
	<1378785208.17982.54.camel@x230.lan>
	<20130910172318.GB21530@khazad-dum.debian.net>
	<1378837571.17615.0.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378837571.17615.0.camel-+5W/JHIUVxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Henrique de Moraes Holschuh <hmh-N3TV7GIv+o9fyO9Q7EP/yw@public.gmane.org>, David Lang <david-gFPdbfVZQbY@public.gmane.org>, "Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org" <Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 10, 2013 at 11:26 AM, Matthew Garrett
<matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 2013-09-10 at 14:23 -0300, Henrique de Moraes Holschuh wrote:
>> On Tue, 10 Sep 2013, Matthew Garrett wrote:
>> > That's why modern systems require signed firmware updates.
>>
>> Linux doesn't.  Is someone working on adding signature support to the
>> runtime firmware loader?

I feel like there was maybe confusion here between "boot loader"
firmware (PC-BIOS, UEFI, etc), and device (maybe "component" is a
better term to distinguish this?) firmware (network cards, hard
drives, etc). Boot loader firmware has been moving rapidly toward
verified updates. This is true in many many shipping systems. It is
much less true for component firmware.

> It'd be simple to do so, but so far the model appears to be that devices
> that expect signed firmware enforce that themselves.

Yeah, the unfortunately reality is that for full sanity, it is
components themselves that need to be doing this signature validation.
That said, adding signature (or similar "origin" verification) to the
kernel is a good first step to move the trust from uid-0 up to ring-0.
I've had this on my TODO list for a while now. It remains a potential
hole, but since a solution doesn't exist today, it's outside of what
Matthew's patch series does. I would, however, expect that in the
future when component firmware loading includes origin verification,
it would become required when running with the "lock down the world"
setting.

-Kees

-- 
Kees Cook
Chrome OS Security
