From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 6/6] efi: Add EFI_SECURE_BOOT bit
Date: Tue, 22 Nov 2016 14:04:52 +0100
Message-ID: <20161122130452.GB1657@wunner.de>
References: <20161117123731.GA11573@wunner.de>
 <147977473590.6360.6303661595805578599.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147977473590.6360.6303661595805578599.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 22, 2016 at 12:32:15AM +0000, David Howells wrote:
> From: Josh Boyer <jwboyer@fedoraproject.org>
> 
> UEFI machines can be booted in Secure Boot mode.  Add a EFI_SECURE_BOOT bit
> for use with efi_enabled.

Please add an explanation what you plan to do with this bit going forward.

Thanks,

Lukas

> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  arch/x86/kernel/setup.c |    5 +++++
>  include/linux/efi.h     |    1 +
>  2 files changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 9c337b0e8ba7..a197221a451b 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1160,6 +1160,11 @@ void __init setup_arch(char **cmdline_p)
>  
>  	io_delay_init();
>  
> +	if (boot_params.secure_boot) {
> +		set_bit(EFI_SECURE_BOOT, &efi.flags);
> +		pr_info("Secure boot enabled\n");
> +	}
> +
>  	/*
>  	 * Parse the ACPI tables for possible boot-time SMP configuration.
>  	 */
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 615d8704f048..3864de3b40ad 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1066,6 +1066,7 @@ extern int __init efi_setup_pcdp_console(char *);
>  #define EFI_ARCH_1		7	/* First arch-specific bit */
>  #define EFI_DBG			8	/* Print additional debug info at runtime */
>  #define EFI_NX_PE_DATA		9	/* Can runtime data regions be mapped non-executable? */
> +#define EFI_SECURE_BOOT		10	/* Are we in Secure Boot mode? */
>  
>  #ifdef CONFIG_EFI
>  /*
> 
