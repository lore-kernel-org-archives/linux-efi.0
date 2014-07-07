From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3 0/2] efi/arm64: FP/SIMD preserve/restore during UEFI
 Runtime Services
Date: Mon, 7 Jul 2014 20:15:37 +0100
Message-ID: <20140707191537.GC2914@console-pimps.org>
References: <1404495713-10338-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404495713-10338-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 04 Jul, at 07:41:51PM, Ard Biesheuvel wrote:
> Two patches to add FP/SIMD preserve/restore to UEFI Runtime Services:
> - patch #1 moves runtime services wrappers to generic code so we can reuse them
>   for arm64
> - patch #2 enables the wrappers for arm64 and inserts calls to kernel_neon_begin
>   and kernel_neon_end
> 
> @Matt: please queue up for 3.17

Thanks Ard, applied.

FYI that "please queue up for 3.17" message is super helpful when I'm
trying to figure out what branch to apply this to.

-- 
Matt Fleming, Intel Open Source Technology Center
