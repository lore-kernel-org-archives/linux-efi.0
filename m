From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/6] x86/efi: PFN_ALIGN() _text and _end when calculating
 number of pages
Date: Thu, 26 Nov 2015 12:13:23 +0100
Message-ID: <20151126111323.GA22863@gmail.com>
References: <1448285594-17617-1-git-send-email-matt@codeblueprint.co.uk>
 <1448285594-17617-2-git-send-email-matt@codeblueprint.co.uk>
 <20151124082323.GA23451@gmail.com>
 <20151124105556.GA2460@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151124105556.GA2460-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> On Tue, 24 Nov, at 09:23:23AM, Ingo Molnar wrote:
> > 
> > Didn't we want to do the _end alignment linker script fix instead?
>  
> I think we should do both. This patch is tagged for stable because it
> fixes a bug in the existing code. It's obvious and it's explicit and
> it's much easier to know when someone might want to backport it.
> 
> Changing the linker script which indirectly fixes the above bug is a
> much more subtle solution, with much larger potential for fallout
> because it affects multiple chunks of kernel code.
> 
> > Alignment assumptions are easy to make when symbols are well aligned typically (as 
> > in this case), so we should guarantee the alignment property instead of 
> > complicating the code.
> 
> I don't agree that sprinkling PFN_ALIGN() complicates the code, it's a
> minimal change with a well known kernel idiom. But yes, aligning these
> symbols in the linker script is generally a good idea.
> 
> The two patches are worthwhile, for different reasons; let's do both.

I disagree, this form:

        npages = (_end - _text) >> PAGE_SHIFT;

is a lot clearer to read than:

        npages = (PFN_ALIGN(_end) - PFN_ALIGN(_text)) >> PAGE_SHIFT;

especially once we ensure that _end and _text are page aligned. The latter form 
will only result in cargo-cult carrying over of unnecessary PFN_ALIGN() 
operations.

Section boundaries of the kernel should generally be page aligned, this is useful 
for a number of other reasons as well.

As far as backporting goes, it would generally be _safer_ to backport the linker 
script fix, in case there are other unrealized alignment bugs in the kernel. 
Especially if upstream does the same.

Thanks,

	Ingo
