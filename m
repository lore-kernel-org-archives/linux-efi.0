From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2 4/5] efi: efistub: refactor stub components
Date: Tue, 1 Jul 2014 17:22:21 +0100
Message-ID: <20140701162221.GG7539@console-pimps.org>
References: <1403792617-25792-1-git-send-email-ard.biesheuvel@linaro.org>
 <1403792617-25792-5-git-send-email-ard.biesheuvel@linaro.org>
 <20140701151130.GF7539@console-pimps.org>
 <CAKv+Gu9tY7RqVXdWejwOPnpBTX0S5M9QxBH2te71kpysOV3vWA@mail.gmail.com>
 <CAKv+Gu8sHpHNEJhDrrJcN12rVrhRgprzmNeJ_BoMCbL+Gh2-NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8sHpHNEJhDrrJcN12rVrhRgprzmNeJ_BoMCbL+Gh2-NQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 01 Jul, at 05:20:21PM, Ard Biesheuvel wrote:
> 
> ... but that wasn't your question ....
> 
> The reason this can't live in "efistub.h" is that it gets included by
> bits under arch/xxx
> So perhaps moving the local "efistub.h" to <linux/efistub.h> would be
> appropriate, yes.

I didn't mean that we should add include/linux/efistub.h, rather that we
should try adding them to efistub.h or asm/efi.h.

But I see that isn't going to work too well and there's no easy fix.
Let's just leave things as they are for now.

Long term, I've been thinking of splitting up include/linux/efi.h. It's
currently weighing in at 1208 lines and contains pieces for all sorts of
different chunks of EFI code, 32-bit and 64-bit versions of data
structures, etc.

-- 
Matt Fleming, Intel Open Source Technology Center
