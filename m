From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] efi: arm-stub: Round up FDT allocation to mapping size
Date: Fri, 10 Feb 2017 14:18:02 +0000
Message-ID: <CAKv+Gu_GKYTCfMfutg2mCnYBF5V1HeJBdS8EVW1hC_xMAbKn6Q@mail.gmail.com>
References: <1486676573-19237-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486676573-19237-2-git-send-email-ard.biesheuvel@linaro.org> <a25905bb-5ad5-e10e-c14a-f01313eace2d@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a25905bb-5ad5-e10e-c14a-f01313eace2d-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ruigrok, Richard" <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Jeff Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10 February 2017 at 00:40, Ruigrok, Richard <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
>
>
> On 2/9/2017 2:42 PM, Ard Biesheuvel wrote:
>
> The FDT is mapped via a fixmap entry that is at least 2 MB in size and
> 2 MB aligned on 4 KB page size kernels.
>
> On UEFI systems, the FDT allocation may share this 2 MB block with a
> reserved region, or another memory region that we should never map,
> unless we account for this in the size of the allocation (the alignment
> is already 2 MB)
>
> So instead of taking guesses at the needed space, simply allocate 2 MB
> immediately. The allocation will be recorded as a EFI_LOADER_DATA, and
> the kernel only memblock_reserve()'s the actual size of the FDT, so the
> unused space will be released to the kernel.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/include/asm/efi.h       |  1 +
>  drivers/firmware/efi/libstub/fdt.c | 57 +++++++++-----------
>  2 files changed, 25 insertions(+), 33 deletions(-)
>
[..]
> Tested successfully on our QDT2400 system on which we were seeing a failure
> to allocate memory for initrd.
>
> Tested-by: Richard Ruigrok <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>

Thanks
