From: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v2] arm64/efi: prefer AllocatePages() over efi_low_alloc()
 for vmlinux
Date: Tue, 27 Oct 2015 16:15:45 -0500
Message-ID: <CAOZdJXWgJKb7S0_3AJ4oT-gbgzMRYXydOoByh7chuervwJN1sw@mail.gmail.com>
References: <1437737907-10477-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437737907-10477-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jul 24, 2015 at 6:38 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
> +               /*
> +                * First, try a straight allocation at the preferred offset.
> +                * This will work around the issue where, if dram_base == 0x0,
> +                * efi_low_alloc() refuses to allocate at 0x0 (to prevent the
> +                * address of the allocation to be mistaken for a FAIL return
> +                * value or a NULL pointer). It will also ensure that, on
> +                * platforms where the [dram_base, dram_base + TEXT_OFFSET)
> +                * interval is partially occupied by the firmware (like on APM
> +                * Mustang), we can still place the kernel at the address
> +                * 'dram_base + TEXT_OFFSET'.
> +                */
> +               *image_addr = *reserve_addr = dram_base + TEXT_OFFSET;
> +               nr_pages = round_up(kernel_memsize, EFI_ALLOC_ALIGN) /
> +                          EFI_PAGE_SIZE;
> +               status = efi_call_early(allocate_pages, EFI_ALLOCATE_ADDRESS,
> +                                       EFI_LOADER_DATA, nr_pages,
> +                                       (efi_physical_addr_t *)reserve_addr);

This causes our kernel to crash, because on our system, dram_base is
not 2MB aligned.  I'll be posting a patch soon that fixes this.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
