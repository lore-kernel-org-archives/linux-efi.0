From: Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
Date: Tue, 2 Sep 2014 08:57:53 +0200
Message-ID: <20140902065752.GA5634@ad.chargestorm.se>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
 <20140827105901.GC28116@console-pimps.org>
 <CAE9FiQWrPtEe3tkJjgOzyJJPPzX=AtMYgR4c91pDHL3q3ZLLKQ@mail.gmail.com>
 <20140830112426.GA2911@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140830112426.GA2911-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Harald Hoyer <harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

* Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> [140830 13:24]:
> On Wed, 27 Aug, at 10:13:22AM, Yinghai Lu wrote:
> > How about adding more info print out like:
> >   "Try to load initrd file to higher address..."

> Yeah, that could work, at least we've had some debugging information to
> go on if people start reporting hangs, though I'd suggest using "Trying"
> or "Attempting".

That should be fine. That would at least give the user something easy to
search for (both web and source), and thus make it possible to at least
get an idea of why the boot is hanging for the few people that's going
to hit this.

For most systems, the default to load the initrd/initramfs below 4G (and
only load it above on the second attempt) will handle our buggy EFI's...

To me this sounds like something that should work.

Cheers,
Anders

-- 
Option Paralysis:
	The tendency, when given unlimited choices, to make none.
		-- Douglas Coupland, "Generation X: Tales for an Accelerated
		   Culture"
