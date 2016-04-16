From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/arm64: don't apply MEMBLOCK_NOMAP to UEFI memory map
 mapping
Date: Sat, 16 Apr 2016 11:09:10 +0200
Message-ID: <20160416090910.GA30739@gmail.com>
References: <1459323983-9120-1-git-send-email-ard.biesheuvel@linaro.org>
 <20160331203520.GB2736@codeblueprint.co.uk>
 <CAPvkgC0Dy1c78LOR53PgyTdDom=fWF9RurJHQ02RuMVj5Pch3g@mail.gmail.com>
 <20160415221516.GU2829@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160415221516.GU2829-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Steve Capper <steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> On Fri, 15 Apr, at 05:44:02PM, Steve Capper wrote:
> > 
> > Hello,
> > Is this going to make it in for 4.6?
> > I ran into this issue the other day, and can confirm that Ard's patch
> > is helpful.
> 
> Good question.
> 
> Ingo did you send the patch in the last EFI urgent pull request to
> Linus yet? I can find it in tip/efi-urgent-for-linus but not in Linus'
> tree.

I just sent it to Linus.

It got delayed a bit because it had an x86/urgent dependency that had to be sent 
upstream first. (In the future you can avoid such delays by basing EFI urgent 
fixes on an upstream -rc kernel, not x86/urgent.)

Thanks,

	Ingo
