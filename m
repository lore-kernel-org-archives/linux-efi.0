From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2 0/5] efistub: convert into static library
Date: Tue, 1 Jul 2014 20:01:53 +0100
Message-ID: <20140701190153.GI7539@console-pimps.org>
References: <1403792617-25792-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140701183906.GH7539@console-pimps.org>
 <CAKv+Gu8eN4s9V6=mmQFpMDKuuMRE0y5T6pxk27=BLMFRX1O57w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8eN4s9V6=mmQFpMDKuuMRE0y5T6pxk27=BLMFRX1O57w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 01 Jul, at 08:55:20PM, Ard Biesheuvel wrote:
> 
> OK, thanks. One tiny snag that I would like to fix up once we have
> some Acks to add: I just noticed that i removed the 'static' from
> handle_kernel_image()'s definition from arm64 in 4/5, but removed it
> from the forward declaration in 5/5, which likely breaks bisect for
> arm64 if you happen to end up right in the middle.

Good catch.

I rebase 'next' pretty feely, so just remind me at some point in the
future and we can fix this up.

-- 
Matt Fleming, Intel Open Source Technology Center
