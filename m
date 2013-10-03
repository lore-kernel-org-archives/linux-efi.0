From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 2/6] Add shared update_fdt() function for ARM/ARM64
Date: Thu, 3 Oct 2013 22:07:15 +0100
Message-ID: <20131003210715.GD2781@console-pimps.org>
References: <1380385403-31904-1-git-send-email-roy.franz@linaro.org>
 <1380385403-31904-3-git-send-email-roy.franz@linaro.org>
 <20131003095224.GX21381@console-pimps.org>
 <1380807804.17503.9.camel@deneb.redhat.com>
 <20131003142721.GB2781@console-pimps.org>
 <CAFECyb-=2osh_j_9FCnWjAjLX-xbzanQeFjCLNTz4JKAk5d30w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFECyb-=2osh_j_9FCnWjAjLX-xbzanQeFjCLNTz4JKAk5d30w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Martin <dave.martin-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 03 Oct, at 12:28:03PM, Roy Franz wrote:
> Hi Matt,
> 
>    This  function is shared between ARM and ARM64, which are separate
> architectures so to keep this in arch code would require it to be
> duplicated for ARM/ARM64.  Would moving this function to a new
> "efi-stub-fdt.c" file be satisfactory?  This file would just be used
> the ARM and ARM64, so this would remove
> the need for the top-level #ifdefs.

Fair enough, move it to drivers/firmware/efi/fdt.c - there's no need to
prefix it with "efi-" (efi-pstore.c has historic baggage).

-- 
Matt Fleming, Intel Open Source Technology Center
