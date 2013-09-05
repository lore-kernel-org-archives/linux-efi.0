From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH V3 11/11] Add option to automatically enforce module
 signatures when in Secure Boot mode
Date: Thu, 5 Sep 2013 11:16:49 +0100
Message-ID: <20130905101649.GL28598@console-pimps.org>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
 <1378252218-18798-12-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1378252218-18798-12-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 03 Sep, at 07:50:18PM, Matthew Garrett wrote:
> UEFI Secure Boot provides a mechanism for ensuring that the firmware will
> only load signed bootloaders and kernels. Certain use cases may also
> require that all kernel modules also be signed. Add a configuration option
> that enforces this automatically when enabled.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/x86/zero-page.txt       |  2 ++
>  arch/x86/Kconfig                      | 10 ++++++++++
>  arch/x86/boot/compressed/eboot.c      | 36 +++++++++++++++++++++++++++++++++++
>  arch/x86/include/uapi/asm/bootparam.h |  3 ++-
>  arch/x86/kernel/setup.c               |  6 ++++++
>  include/linux/module.h                |  6 ++++++
>  kernel/module.c                       |  7 +++++++
>  7 files changed, 69 insertions(+), 1 deletion(-)

[...]

> @@ -1129,6 +1129,12 @@ void __init setup_arch(char **cmdline_p)
>  
>  	io_delay_init();
>  
> +#ifdef CONFIG_EFI_SECURE_BOOT_SIG_ENFORCE
> +	if (boot_params.secure_boot) {
> +		enforce_signed_modules();
> +	}
> +#endif
> +

I'd advise checking efi_enabled(EFI_BOOT) along with .secure_boot to
guard against garbage values in boot_params.

-- 
Matt Fleming, Intel Open Source Technology Center
