From: Guo Chao <yan-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] efi: Make 'efi_enabled' a function to
Date: Sat, 5 Jan 2013 11:28:09 +0800
Message-ID: <20130105032809.GA15166@yanx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

query EFI facilities
Reply-To: <1357219085-4312-2-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> 
In-Reply-To: <1357219085-4312-2-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> 

> diff --git a/init/main.c b/init/main.c
> index e33e09d..e71d924 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -604,7 +604,7 @@ asmlinkage void __init start_kernel(void)
>  	pidmap_init();
>  	anon_vma_init();
>  #ifdef CONFIG_X86
> -	if (efi_enabled)
> +	if (efi_enabled(EFI_RUNTIME_SERVICES))
>  		efi_enter_virtual_mode();
>  #endif
>  	thread_info_cache_init();
> @@ -632,7 +632,7 @@ asmlinkage void __init start_kernel(void)
>  	acpi_early_init(); /* before LAPIC and SMP init */
>  	sfi_init_late();
> 
> -	if (efi_enabled) {
> +	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
>  		efi_late_init();
>  		efi_free_boot_services();
>  	}

I just wonder why we compile efi code away explicitly by CONFIG_X86 in
one place and implicitly by if (0) in another place, in the same
function.

Thanks,
Guo Chao
