From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 4/5] arm: Add [U]EFI runtime services support
Date: Mon, 13 Jan 2014 19:43:09 +0100
Message-ID: <201401131943.10352.arnd@arndb.de>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-5-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1389445524-30623-5-git-send-email-leif.lindholm@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: roy.franz@linaro.org, linux-efi@vger.kernel.org, linux@arm.linux.org.uk, patches@linaro.org, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, grant.likely@secretlab.ca, matt.fleming@intel.com, msalter@redhat.com
List-Id: linux-efi@vger.kernel.org

On Saturday 11 January 2014, Leif Lindholm wrote:
> This patch implements basic support for UEFI runtime services in the
> ARM architecture - a requirement for using efibootmgr to read and update
> the system boot configuration.
> 
> It uses the generic configuration table scanning to populate ACPI and
> SMBIOS pointers.

As far as I'm concerned there are no plans to have ACPI support on ARM32,
so I wonder what the code to populate the ACPI tables is about. Can
you clarify this?
 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 78a79a6a..1ab24cc 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1853,6 +1853,20 @@ config EARLY_IOREMAP
>  	  the same virtual memory range as kmap so all early mappings must
>  	  be unapped before paging_init() is called.
>  
> +config EFI
> +	bool "UEFI runtime service support"
> +	depends on OF && !CPU_BIG_ENDIAN

What is the dependency on !CPU_BIG_ENDIAN? We try hard to have
all kernel code support both big-endian and little-endian, and
I'm guessing there is a significant overlap between the people
that want UEFI support and those that want big-endian kernels.

> +struct efi_memory_map memmap;

"memmap" is not a good name for a global identifier, particularly because
it's easily confused with the well-known "mem_map" array. This
wants namespace prefix like you other variable, or a "static" tag,
preferably both.

> +/*
> + * This function switches the UEFI runtime services to virtual mode.
> + * This operation must be performed only once in the system's lifetime,
> + * including any kecec calls.

                   kexec

> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index fa7d950..afaeb85 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -664,7 +664,7 @@ extern int __init efi_setup_pcdp_console(char *);
>  #define EFI_64BIT		5	/* Is the firmware 64-bit? */
>  
>  #ifdef CONFIG_EFI
> -# ifdef CONFIG_X86
> +# if defined(CONFIG_X86) || defined(CONFIG_ARM)
>  extern int efi_enabled(int facility);
>  # else
>  static inline int efi_enabled(int facility)

Maybe better #ifndef CONFIG_IA64? It seems that is the odd one out and
all possible future architectures would be like x86 and ARM.

	Arnd
