From: Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>
Subject: Re: [PATCH -v4] x86: only load initrd above 4g on second try
Date: Fri, 5 Sep 2014 07:47:49 +0200
Message-ID: <20140905054749.GA4498@ad.chargestorm.se>
References: <1409806207-3992-1-git-send-email-yinghai@kernel.org>
 <20140904100137.GK3001@console-pimps.org>
 <5408D299.5000300@zytor.com>
 <20140904212925.GL3001@console-pimps.org>
 <CAE9FiQUDLoARj-Z3ipPTf2sZgGn71SxrxM+FqLE1Cyb-OEoP+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQUDLoARj-Z3ipPTf2sZgGn71SxrxM+FqLE1Cyb-OEoP+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

* Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> [140905 03:19]:


> On Thu, Sep 4, 2014 at 2:29 PM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> > On Thu, 04 Sep, at 01:59:05PM, H. Peter Anvin wrote:

> >> I am fine with this patch, but at the same time I do want to note that
> >> there is an alternative to double-buffer the patch and/or (if that
> >> applies to the buggy BIOS) round up the size of the target buffer.

> > I'm not sure that rounding up the size of the target buffer will
> > workaround this issue correctly.

> > As far as I know, the only thing that Mantas tried was rounding up the
> > size of the source file, by padding it.

> Can you try attached patch on top of linus tree?

I took the liberty to test the patch on my Dell XPS13 9333, and
unfortunately I got the old hang back. 

This was tested on the current Linus' tree.

Cheers,
Anders Darander

> -					chunksize = size;
> +					chunksize = round_up(size, EFI_PAGE_SIZE);



-- 
It usually takes more than three weeks to prepare a good impromptu speech.
		-- Mark Twain
