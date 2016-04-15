From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi/arm64: don't apply MEMBLOCK_NOMAP to UEFI memory map
 mapping
Date: Fri, 15 Apr 2016 23:15:16 +0100
Message-ID: <20160415221516.GU2829@codeblueprint.co.uk>
References: <1459323983-9120-1-git-send-email-ard.biesheuvel@linaro.org>
 <20160331203520.GB2736@codeblueprint.co.uk>
 <CAPvkgC0Dy1c78LOR53PgyTdDom=fWF9RurJHQ02RuMVj5Pch3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPvkgC0Dy1c78LOR53PgyTdDom=fWF9RurJHQ02RuMVj5Pch3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Capper <steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 15 Apr, at 05:44:02PM, Steve Capper wrote:
> 
> Hello,
> Is this going to make it in for 4.6?
> I ran into this issue the other day, and can confirm that Ard's patch
> is helpful.

Good question.

Ingo did you send the patch in the last EFI urgent pull request to
Linus yet? I can find it in tip/efi-urgent-for-linus but not in Linus'
tree.
