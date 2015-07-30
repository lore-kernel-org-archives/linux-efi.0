From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86_64/efi: Mapping Boot and Runtime EFI memory regions
 to different starting virtual address
Date: Thu, 30 Jul 2015 11:11:31 +0100
Message-ID: <20150730101131.GB2725@codeblueprint.co.uk>
References: <1438230757-30840-1-git-send-email-jlee@suse.com>
 <55B9D806.7030705@zytor.com>
 <20150730080323.GD8984@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150730080323.GD8984-K5JNixvcfoxupOikMc4+xw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 30 Jul, at 10:03:23AM, Borislav Petkov wrote:
> On Thu, Jul 30, 2015 at 12:53:42AM -0700, H. Peter Anvin wrote:
> > This changelog is at least partially incomprehensive. It also seems
> > more than a bit aggressive to expect that 1 GB will be sufficient
> > forever.
> 
> Right, before we do anything, I'd like for us to figure out first why
> this is a problem all of a sudden. And why should we even keep boot
> code/data, if it is fair game, once runtime services get enabled.
> 
> Matt, can you please chime in first before we even talk about a
> solution...

Yeah, I do not understand the issue properly.

Why do we care about EfiBoot* regions after hibernate? Surely we've
already freed those regions in efi_free_boot_services() during boot and
nobody should be touching them again? If the firmware does, that's a
whole new bug we've never encountered before.

And we obviously can't allow the runtime regions to move around during
hibernate/resume because we've already informed the firmware where those
regions live during SetVirtualAddressMap() at boot.

I admit that I haven't looked at the hibernate code paths. Let me go do
that now.

-- 
Matt Fleming, Intel Open Source Technology Center
