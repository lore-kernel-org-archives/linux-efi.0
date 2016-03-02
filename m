From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/5] ARM: efi: apply strict permissons for UEFI Runtime
 Services regions
Date: Wed, 2 Mar 2016 11:49:01 +0000
Message-ID: <20160302114901.GC2649@codeblueprint.co.uk>
References: <1456151158-25849-1-git-send-email-ard.biesheuvel@linaro.org>
 <1456151158-25849-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456151158-25849-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 22 Feb, at 03:25:54PM, Ard Biesheuvel wrote:
> Recent UEFI versions expose permission attributes for runtime services
> memory regions, either in the UEFI memory map or in the separate memory
> attributes table.  This allows the kernel to map these regions with
> stricter permissions, rather than the RWX permissions that are used by
> default. So wire this up in our mapping routine.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm/include/asm/efi.h |  1 +
>  arch/arm/kernel/efi.c      | 41 ++++++++++++++++++++
>  2 files changed, 42 insertions(+)

Looks fine from an EFI perspective, but it would be nice for somebody
else with ARM knowledge to ACK it.
