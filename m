From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: add support for EFI_MEMORY_RO attribute introduced
 by UEFIv2.5
Date: Sun, 28 Jun 2015 15:35:41 +0100
Message-ID: <20150628143541.GC28334@codeblueprint.co.uk>
References: <1435142544-10014-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435142544-10014-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 24 Jun, at 12:42:24PM, Ard Biesheuvel wrote:
> The UEFI spec v2.5 introduces a new memory attribute EFI_MEMORY_RO,
> which is now the preferred attribute to convey that the nature of
> the contents of such a region allows it to be mapped read-only
> (i.e., it contains .text and .rodata only). The specification of
> the existing EFI_MEMORY_WP attribute has been updated to align
> more closely with its common use as a cacheability attribute rather
> than a permission attribute.
> 
> Add the #define and add the attribute to the memory map dumping
> routine.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c | 8 +++++---
>  include/linux/efi.h        | 1 +
>  2 files changed, 6 insertions(+), 3 deletions(-)

Thanks Ard, applied.

-- 
Matt Fleming, Intel Open Source Technology Center
