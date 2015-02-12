From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: get_memory_map: add sufficient slack for memory
 descriptors
Date: Thu, 12 Feb 2015 14:47:27 +0000
Message-ID: <20150212144727.GD4665@codeblueprint.co.uk>
References: <1423718659-795-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150212102226.GB1245@leverpostej>
 <CAKv+Gu88vzPpXoSEs1ZSQbO7wsqh7NRSZc=iSpC9D6vzus7f8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu88vzPpXoSEs1ZSQbO7wsqh7NRSZc=iSpC9D6vzus7f8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 12 Feb, at 06:39:46PM, Ard Biesheuvel wrote:
> 
> I don't see how doing a single allocation could result in a single
> free region to be split into more than 1 occupied region + 2 free
> regions.
> So no, I don't think it is ...

I don't think that's a guarantee we can make, nor is it something we
should rely upon.

Please explain the user-visible failure that this patch fixes. Does your
machine refuse to boot? Why is the 'goto again' loop insufficient in
handling this scenario?

-- 
Matt Fleming, Intel Open Source Technology Center
