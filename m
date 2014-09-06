From: Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Date: Sat, 6 Sep 2014 21:05:35 +0200
Message-ID: <20140906190534.GA4767@ad.chargestorm.se>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
 <20140904100137.GK3001@console-pimps.org>
 <5408D299.5000300@zytor.com>
 <20140905221616.GP3001@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140905221616.GP3001-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

* Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> [140906 00:16]:

> On Thu, 04 Sep, at 01:59:05PM, H. Peter Anvin wrote:

> > I am fine with this patch, but at the same time I do want to note that
> > there is an alternative to double-buffer the patch and/or (if that
> > applies to the buggy BIOS) round up the size of the target buffer.

> I took a whack at the double-buffer strategy, and I think the patch is
> conceptually pretty straight forward.

> Could someone try out the following patch? It works around the problem
> on my ASUS machine.

Your patch works around the problem on my Dell machine also. With that
one applied, it boots fine!

Thus, 

Tested-by: Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>

Cheers,
Anders

-- 
All the troubles you have will pass away very quickly.
