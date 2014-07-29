From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] arm64: spin-table: handle unmapped cpu-release-addrs
Date: Tue, 29 Jul 2014 11:15:45 -0400
Message-ID: <1406646945.753.5.camel@deneb.redhat.com>
References: <1406630950-32432-1-git-send-email-ard.biesheuvel@linaro.org>
	 <1406630950-32432-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406630950-32432-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2014-07-29 at 12:49 +0200, Ard Biesheuvel wrote:
> From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> 
> In certain cases the cpu-release-addr of a CPU may not fall in the
> linear mapping (e.g. when the kernel is loaded above this address due to
> the presence of other images in memory). This is problematic for the
> spin-table code as it assumes that it can trivially convert a
> cpu-release-addr to a valid VA in the linear map.
> 
> This patch modifies the spin-table code to use a temporary cached
> mapping to write to a given cpu-release-addr, enabling us to support
> addresses regardless of whether they are covered by the linear mapping.
> 
> Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> ---
>  arch/arm64/kernel/smp_spin_table.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kernel/smp_spin_table.c b/arch/arm64/kernel/smp_spin_table.c
> index 0347d38eea29..70181c1bf42d 100644
> --- a/arch/arm64/kernel/smp_spin_table.c
> +++ b/arch/arm64/kernel/smp_spin_table.c
> @@ -20,6 +20,7 @@
>  #include <linux/init.h>
>  #include <linux/of.h>
>  #include <linux/smp.h>
> +#include <linux/types.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/cpu_ops.h>
> @@ -65,12 +66,21 @@ static int smp_spin_table_cpu_init(struct device_node *dn, unsigned int cpu)
>  
>  static int smp_spin_table_cpu_prepare(unsigned int cpu)
>  {
> -	void **release_addr;
> +	__le64 __iomem *release_addr;
>  
>  	if (!cpu_release_addr[cpu])
>  		return -ENODEV;
>  
> -	release_addr = __va(cpu_release_addr[cpu]);
> +	/*
> +	 * The cpu-release-addr may or may not be inside the linear mapping.
> +	 * As ioremap_cache will either give us a new mapping or reuse the
> +	 * existing linear mapping, we can use it to cover both cases. In
> +	 * either case the memory will be MT_NORMAL.
> +	 */
> +	release_addr = ioremap_cache(cpu_release_addr[cpu],
> +				     sizeof(*release_addr));
> +	if (!release_addr)
> +		return -ENOMEM;
>  
>  	/*
>  	 * We write the release address as LE regardless of the native
> @@ -79,15 +89,16 @@ static int smp_spin_table_cpu_prepare(unsigned int cpu)
>  	 * boot-loader's endianess before jumping. This is mandated by
>  	 * the boot protocol.
>  	 */
> -	release_addr[0] = (void *) cpu_to_le64(__pa(secondary_holding_pen));
> -
> -	__flush_dcache_area(release_addr, sizeof(release_addr[0]));
> +	writeq_relaxed(__pa(secondary_holding_pen), release_addr);
> +	__flush_dcache_area(release_addr, sizeof(*release_addr));

       __flush_dcache_area((__force void *)release_addr, ... 

to avoid sparse warning.

>  
>  	/*
>  	 * Send an event to wake up the secondary CPU.
>  	 */
>  	sev();
>  
> +	iounmap(release_addr);
> +
>  	return 0;
>  }
>  
