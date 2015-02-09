From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86, boot: Allow 64bit EFI kernel to be loaded above 4G
Date: Mon, 9 Feb 2015 18:27:42 +0000
Message-ID: <20150209182742.GQ6461@codeblueprint.co.uk>
References: <1423015400-12629-1-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1423015400-12629-1-git-send-email-yinghai@kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt.fleming@intel.com>, Kees Cook <keescook@chromium.org>, Junjie Mao <eternal.n08@gmail.com>, linux-doc@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, 03 Feb, at 06:03:20PM, Yinghai Lu wrote:
> Now could use kexec to place kernel/boot_params/cmd_line/initrd
> above 4G, but that is with legacy interface with startup_64 directly.
> 
> This patch will allow 64bit EFI kernel to be loaded above 4G
> and use EFI HANDOVER PROTOCOL to start the kernel.
> 
> Current code32_start is used for passing around loading address,
> so it will overflow when kernel is loaded abover 4G.
> 
> The patch mainly add ext_code32_start to take address high 32bit.
> 
> After this patch, could use patched grub2-x86_64.efi to place
> kernel/boot_params/cmd_line/initrd all above 4G and execute the kernel
> above 4G.
 
The first thing that comes to mind is the issues we experienced last
year when adding support for loading initrds above 4GB to the EFI boot
stub, c.f. commit 47226ad4f4cf ("x86/efi: Only load initrd above 4g on
second try").

Are things going to work correctly this time?

> Index: linux-2.6/arch/x86/boot/compressed/eboot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/boot/compressed/eboot.c
> +++ linux-2.6/arch/x86/boot/compressed/eboot.c
> @@ -1389,6 +1389,7 @@ struct boot_params *efi_main(struct efi_
>  	void *handle;
>  	efi_system_table_t *_table;
>  	bool is64;
> +	unsigned long loaded_addr;
>  
>  	efi_early = c;
>  
> @@ -1430,9 +1431,12 @@ struct boot_params *efi_main(struct efi_
>  	 * If the kernel isn't already loaded at the preferred load
>  	 * address, relocate it.
>  	 */
> -	if (hdr->pref_address != hdr->code32_start) {
> -		unsigned long bzimage_addr = hdr->code32_start;
> -		status = efi_relocate_kernel(sys_table, &bzimage_addr,
> +	loaded_addr = hdr->code32_start;
> +	loaded_addr |= (unsigned long)hdr->ext_code32_start << 32;

Please compile this for CONFIG_X86_32 and fix any compiler warnings.

> @@ -738,6 +742,13 @@ Offset/size:	0x264/4
>  
>    See EFI HANDOVER PROTOCOL below for more details.
>  
> +Field name:	ext_code32_start
> +Type:		modify (optional, reloc)
> +Offset/size:	0x268/4
> +Protocol:	2.14+
> +
> +  The address is used with code32_start to compare pref_address
> +  to support EFI 64bit kernel get loaded above 4G.

It would be good to mention that this new field contains the upper
32-bits of the 64-bit address.

-- 
Matt Fleming, Intel Open Source Technology Center
