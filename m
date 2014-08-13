From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 4/5] efi x86: clear EFI_RUNTIME_SERVICES bit in case
 failures other than SetVirtualAddressMap
Date: Wed, 13 Aug 2014 15:27:48 +0100
Message-ID: <20140813142748.GS15082@console-pimps.org>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
 <1407823822-23829-4-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1407823822-23829-4-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 12 Aug, at 02:10:21PM, Dave Young wrote:
> If enter virtual mode failed due to some reason other than the efi call
> the EFI_RUNTIME_SERVICES bit in efi.flags should be cleared thus users
> of efi runtime services can check the bit and handle the case instead of
> assume efi runtime is ok.
> 
> Per Matt, if efi call SetVirtualAddressMap fails we will be not sure it's safe
> to make any assumptions about the state of the system. so kernel panics instead
> of clears EFI_RUNTIME_SERVICES bit.
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

[...]

> @@ -882,8 +886,10 @@ static void __init __efi_enter_virtual_mode(void)
>  
>  void __init efi_enter_virtual_mode(void)
>  {
> -	if (efi_enabled(EFI_PARAVIRT))
> +	if (efi_enabled(EFI_PARAVIRT)) {
> +		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>  		return;
> +	}

The EFI_PARAVIRT folks purposely do not set this bit, so there should be
no reason to clear it here.

-- 
Matt Fleming, Intel Open Source Technology Center
