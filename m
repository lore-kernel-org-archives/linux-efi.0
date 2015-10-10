From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v4 1/3] arm64/efi: remove
 /chosen/linux,uefi-stub-kern-ver DT property
Date: Sat, 10 Oct 2015 23:31:36 +0100
Message-ID: <20151010223136.GI2723@codeblueprint.co.uk>
References: <1444330924-17830-1-git-send-email-ard.biesheuvel@linaro.org>
 <1444330924-17830-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444330924-17830-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 08 Oct, at 08:02:02PM, Ard Biesheuvel wrote:
> With the stub to kernel interface being promoted to a proper interface
> so that other agents than the stub can boot the kernel proper in EFI
> mode, we can remove the linux,uefi-stub-kern-ver field, considering
> that its original purpose was to prevent this from happening in the
> first place.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  Documentation/arm/uefi.txt         | 2 --
>  drivers/firmware/efi/libstub/fdt.c | 9 ---------
>  2 files changed, 11 deletions(-)

Good riddance ;-)

Reviewed-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

-- 
Matt Fleming, Intel Open Source Technology Center
