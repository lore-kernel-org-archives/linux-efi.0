From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] arm64/efi: prefer AllocatePages() over
 efi_low_alloc() for vmlinux
Date: Tue, 28 Jul 2015 22:17:52 +0100
Message-ID: <20150728211752.GE2773@codeblueprint.co.uk>
References: <1437737907-10477-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437737907-10477-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 24 Jul, at 01:38:27PM, Ard Biesheuvel wrote:
> When allocating memory for the kernel image, try the AllocatePages()
> boot service to obtain memory at the preferred offset of
> 'dram_base + TEXT_OFFSET', and only revert to efi_low_alloc() if that
> fails. This is the only way to allocate at the base of DRAM if DRAM
> starts at 0x0, since efi_low_alloc() refuses to allocate at 0x0.
> 
> Tested-by: Haojian Zhuang <haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> v2:
> - reshuffle code flow to make it more logical, and have only a single
>   memcpy() invocation at the end of the function
> ---
>  arch/arm64/kernel/efi-stub.c | 41 ++++++++++++++++++++++++++++++++---------
>  1 file changed, 32 insertions(+), 9 deletions(-)

Would it be easier if we allow efi_low_alloc() to return 0x0 for some
uses? If you don't need the preference for low allocations, probably
not, but I don't want to see us working around limitations in
efi_low_alloc() instead of just fixing it.

-- 
Matt Fleming, Intel Open Source Technology Center
