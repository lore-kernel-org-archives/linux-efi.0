From: Wang YanQing <udknight-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] x86/sysfb_efi: Fix valid BAR address range check
Date: Wed, 4 May 2016 23:43:47 +0800
Message-ID: <20160504154344.GA3146@udknight>
References: <1462303781-8686-1-git-send-email-matt@codeblueprint.co.uk>
 <1462303781-8686-3-git-send-email-matt@codeblueprint.co.uk>
 <20160504063524.GB12846@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160504063524.GB12846-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, May 04, 2016 at 08:35:24AM +0200, Ingo Molnar wrote:
> 
> * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> 
> > From: Wang YanQing <udknight-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > 
> > We can't just break out when meet start is equal to zero,
> 
> Hm, wot?
> 
> Thanks,
> 
> 	Ingo

Sorry for my poor English ,and poor commit message, this bring
trouble for more than one maintainer, I guess.

The old code use below comparion as condition to terminate valid 
range check without care whether there are more ranges in later
BARs:
"
        if (start == 0)
            break;
"

I guess original author think (or make a mistake) when we meet a 
address range begin from zero means it is a invalid address range, 
and no valid address ranges in remain BARs.

So I said:
We can't break the loop when meet range whose start address is zero,
without check it and remaining BARs' range.

Thanks.
