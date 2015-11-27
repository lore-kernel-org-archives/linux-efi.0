From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/6] x86/efi: PFN_ALIGN() _text and _end when calculating
 number of pages
Date: Fri, 27 Nov 2015 21:05:52 +0000
Message-ID: <20151127210552.GA13918@codeblueprint.co.uk>
References: <1448285594-17617-1-git-send-email-matt@codeblueprint.co.uk>
 <1448285594-17617-2-git-send-email-matt@codeblueprint.co.uk>
 <20151124082323.GA23451@gmail.com>
 <20151124105556.GA2460@codeblueprint.co.uk>
 <20151126111323.GA22863@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151126111323.GA22863-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 26 Nov, at 12:13:23PM, Ingo Molnar wrote:
> 
> As far as backporting goes, it would generally be _safer_ to backport the linker 
> script fix, in case there are other unrealized alignment bugs in the kernel. 
> Especially if upstream does the same.

OK, I'll respin this series and replace this patch with the linker
script fix.
