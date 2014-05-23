From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: EFI_STUB fails to boot non-EFI on arm64
Date: Fri, 23 May 2014 14:24:57 +0100
Message-ID: <20140523132457.GA23963@console-pimps.org>
References: <20140523094513.GC9252@arm.com>
 <20140523131656.GR4179@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140523131656.GR4179-t77nlHhSwNqAroYi2ySoxKxOck334EZe@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 23 May, at 02:16:56PM, Leif Lindholm wrote:
> On Fri, May 23, 2014 at 10:45:13AM +0100, Catalin Marinas wrote:
> > As the EFI_STUB for arm64 got into tip and soon into -next, I thought
> > about giving it a try (tip/arm64/efi). Using my boot-wrapper (non-EFI)
> > is still supposed to work but I get the trace below. It looks like
> > memmap.map is NULL but the code still assumes the kernel was started as
> > an EFI app.
> > 
> > Have you guys tested these patches properly?
> 
> Apparently not sufficuently...
> Sorry about that.
> 
> Fix appended:

This looks pretty straight forward. I've picked it up and shoved it on
my arm64-efi branch.

-- 
Matt Fleming, Intel Open Source Technology Center
