From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 0/5] Non-ARM-specific EFI patches needed for ARM ports
Date: Mon, 7 Apr 2014 14:22:51 +0100
Message-ID: <20140407132251.GH5222@console-pimps.org>
References: <1396614350-20889-1-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1396614350-20889-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 04 Apr, at 01:25:45PM, Leif Lindholm wrote:
> This is the set of patches from the arm/arm64 UEFI support that are not
> in fact architecture specific. This set depends on other EFI patches
> already in linux-next.
> 
> H. Peter Anvin (1):
>   efi: x86: Improve cmdline conversion
> 
> Leif Lindholm (1):
>   efi: efi-stub-helper cleanup
> 
> Mark Salter (1):
>   efi: create memory map iteration helper
> 
> Roy Franz (2):
>   efi: Add shared printk wrapper for consistent prefixing
>   efi: Add get_dram_base() helper function
> 
>  arch/x86/boot/compressed/eboot.c       |    3 +-
>  drivers/firmware/efi/efi-stub-helper.c |  148 +++++++++++++++++++++++---------
>  include/linux/efi.h                    |    6 ++
>  3 files changed, 116 insertions(+), 41 deletions(-)

Thanks Leif, I'll pick these up once the comments to PATCH 3 and PATCH 4
(from Joe) are addressed. Otherwise they look fine.

-- 
Matt Fleming, Intel Open Source Technology Center
