From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 06/22] Add helper functions used by arm/arm64
Date: Mon, 3 Mar 2014 14:08:11 +0000
Message-ID: <20140303140811.GA18828@console-pimps.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
 <1391619853-10601-7-git-send-email-leif.lindholm@linaro.org>
 <20140213112606.GF20717@console-pimps.org>
 <CAFECyb_wUphr4XOyW9tC-Rw5Py3m39e6GQorCtFGtSXTUTBnFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFECyb_wUphr4XOyW9tC-Rw5Py3m39e6GQorCtFGtSXTUTBnFQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Patch Tracking <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 14 Feb, at 11:02:49AM, Roy Franz wrote:
> 
> The get_dram_base() function is only used by arm/arm64, but
> there is nothing architecture specific about it, which is why I put it
> here to begin with.  I don't feel strongly about this either way.

Sorry Roy, I just realised that you probably wanted a response from me
about this last point.

OK, leaving get_dram_base() in efi-stub-helper.c is fine.

FYI, "NUL" isn't a typo,

> -	options_size++;  /* NUL termination */
[...]
> +	options_size++;  /* NULL termination */

http://en.wikipedia.org/wiki/Null_character

-- 
Matt Fleming, Intel Open Source Technology Center
