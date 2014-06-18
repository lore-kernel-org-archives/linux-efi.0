From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi/arm64: efistub: remove local copy of linux_banner
Date: Wed, 18 Jun 2014 10:25:02 +0100
Message-ID: <20140618092502.GD24049@console-pimps.org>
References: <1402657911-7779-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140618085059.GB24049@console-pimps.org>
 <CAKv+Gu8auFu=rxtDpZy4tkfPiZK7ERUeRDvymzQYi9AhVUxW+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8auFu=rxtDpZy4tkfPiZK7ERUeRDvymzQYi9AhVUxW+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 18 Jun, at 11:12:28AM, Ard Biesheuvel wrote:
> 
> This just removes the duplicate definition of linux_banner, *not* the
> reference to it a couple of lines down. IOW, the DT bindings and
> everything behind it are not affected at all by this patch.
> The reason it works fine for arm64 is that its stub is part of the
> kernel proper, so the reference will bind to the global definition
> instead.
 
Aha, thanks.

> What will be affected is 32-bit ARM, as its stub is not part of the
> kernel proper. In this case, we will propose an alternative [and
> better] way of allowing the stub to reference linux_banner, i.e.,
> without having to redefine it at the C level. We will take this into
> account when we propose the next round of efistub patches for ARM.

No complaints from me.

-- 
Matt Fleming, Intel Open Source Technology Center
