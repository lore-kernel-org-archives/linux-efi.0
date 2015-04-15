From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: stub: use a pool allocation for the cmdline
Date: Wed, 15 Apr 2015 10:55:06 +0100
Message-ID: <20150415095506.GA4804@codeblueprint.co.uk>
References: <1428670569-23089-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAFECyb9efREE=BU5RGSbzAGHqi5CkivUuTf=BRdq02GvFqJaOA@mail.gmail.com>
 <CAKv+Gu-KHpSWLKOgA7UW8C6L1-K3dOieNmF2=qq_t5N73u3Spg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-KHpSWLKOgA7UW8C6L1-K3dOieNmF2=qq_t5N73u3Spg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 10 Apr, at 07:14:34PM, Ard Biesheuvel wrote:
> 
> It is not such a big deal: the memory is reclaimed anyway, I was just
> trying to reduce the fragmentation a bit, and trying to avoid
> efi_xxx_alloc() which are substantially heavier than calling
> allocate_pool() or allocate_pages() directly.

Out of curiosity, do you have any runtime numbers to backup the claim
that allocate_*() is substantially more lightweight?

-- 
Matt Fleming, Intel Open Source Technology Center
