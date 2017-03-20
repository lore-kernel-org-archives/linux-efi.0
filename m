From: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v2 2/2] efi: arm-stub: Round up FDT allocation to mapping size
Date: Mon, 20 Mar 2017 18:25:26 -0500
Message-ID: <CAOZdJXVrpKQOigp9uDMJ=wW=j_y4XzNf+Ham9huFUTbc6UxDSw@mail.gmail.com>
References: <1486676573-19237-1-git-send-email-ard.biesheuvel@linaro.org> <1486676573-19237-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486676573-19237-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 9, 2017 at 3:42 PM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
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

This patch is over a month old, and it's been reviewed and tested.  We
really need this in 4.11.  Please get this merged into 4.11-rc4.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
