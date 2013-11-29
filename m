From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/3] (U)EFI runtime services for arm
Date: Fri, 29 Nov 2013 18:58:51 +0100
Message-ID: <20131129175850.GW24997@rocoto.smurfnet.nu>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
 <20131129115319.GC11775@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131129115319.GC11775-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linaro-uefi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 29, 2013 at 11:53:19AM +0000, Matt Fleming wrote:
> On Thu, 28 Nov, at 04:41:20PM, Leif Lindholm wrote:
> > In systems based on [U]EFI-conformant firmware, runtime services provide
> > a standardised way for the kernel to update firmware environment
> > variables. This is used for example by efibootmgr to update which image
> > should be loaded on next boot.
> > 
> > This patchset implements basic support for UEFI runtime services on ARM
> > platforms, as well as the basic underlying EFI support. It also defines
> > a mechanism by which the required information is passed from the
> > bootloader (the EFI stub submitted separately) to the kernel via FDT
> > entries.
> 
> This all looks pretty good to me. Is this series going through the ARM
> trees?

Thanks.
That's the plan.

/
    Leif
