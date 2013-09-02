From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH V3 RFC 00/16] EFI stub for ARM
Date: Mon, 2 Sep 2013 11:33:10 +0100
Message-ID: <20130902103310.GF28598@console-pimps.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
 <CAFECyb_OMY6eEbkbYTC4sE56Za0rC+KFNFRbGWb2ECEqhiKbTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFECyb_OMY6eEbkbYTC4sE56Za0rC+KFNFRbGWb2ECEqhiKbTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Martin <dave.martin-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 13 Aug, at 10:58:16AM, Roy Franz wrote:
> Hi Matt,
> 
>    Do you have any more feedback on the X86 and common code (patches
> 1-13) that needs to be addressed?  Mark Salter has a working ARM64 EFI
> stub implemented based on these patches, so the common code has now
> been tested with another architecture, and he has acked these patches.
> If the current patches are OK, can this be queued for 3.12? (and into
> linux-next, if appropriate)
> The ARM portion may take a little longer based on the EFI runtime
> services patch dependencies, but getting the common code merged would
> allow the ARM64 EFI stub work to go forward independently.
> 
> I can resend patches 1-13 as a new series of x86/common only changes
> if you would like.

I think resending the common patches as a new series, including Acked-by
and Reviewed-by tags, and after addressing Grant's comments is the best
idea.

We've missed the v3.12 merge window now, but we can certainly get these
into linux-next for some testing.

-- 
Matt Fleming, Intel Open Source Technology Center
