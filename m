From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 2/4] x86: efi: break efi_lookup_mapped_addr out to
 generic code
Date: Wed, 26 Jun 2013 14:32:17 +0100
Message-ID: <20130626133217.GO22026@console-pimps.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-3-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1372183863-11333-3-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 25 Jun, at 07:11:01PM, Leif Lindholm wrote:
> efi_lookup_mapped_addr is a handy helper function for translating
> a physical address to the corresponding virtual one by scanning
> through memmap.map.
> 
> This patch breaks it out into a new file for use elsewhere.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c       |   28 ----------------------------
>  drivers/firmware/efi/Makefile     |    2 +-
>  drivers/firmware/efi/efi-helper.c |   33 +++++++++++++++++++++++++++++++++
>  3 files changed, 34 insertions(+), 29 deletions(-)
>  create mode 100644 drivers/firmware/efi/efi-helper.c

I'm not sure this function needs its own file. drivers/firmware/efi/efi.c
is a suitable place for this.

-- 
Matt Fleming, Intel Open Source Technology Center
