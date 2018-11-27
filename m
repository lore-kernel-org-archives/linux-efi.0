From: Jeremy Linton <jeremy.linton@arm.com>
Subject: Re: [PATCH 5/5] efi: permit calling efi_mem_reserve_persistent from
 atomic context
Date: Tue, 27 Nov 2018 12:59:46 -0600
Message-ID: <a8346212-70cb-0bbb-9e29-e21fa2ee5040@arm.com>
References: <20181114175544.12860-1-ard.biesheuvel@linaro.org>
 <20181114175544.12860-6-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181114175544.12860-6-ard.biesheuvel@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi Ard,


On 11/14/2018 11:55 AM, Ard Biesheuvel wrote:
> Currently, efi_mem_reserve_persistent() may not be called from atomic
> context, since both the kmalloc() call and the memremap() call may
> sleep.
> 
> The kmalloc() call is easy enough to fix, but the memremap() call
> needs to be moved into an init hook since we cannot control the
> memory allocation behavior of memremap() at the call site.

So, at first glance this looks correct until I noticed that 
its_cpu_init_lpis() is being called before the early_initcalls are run.

This results in the WARN_ON triggering with the following backtrace:

[    0.000000]  its_cpu_init_lpis+0x1d4/0x2e0
[    0.000000]  its_cpu_init+0x78/0x1b4
[    0.000000]  gic_init_bases+0x2c4/0x2e0
[    0.000000]  gic_acpi_init+0x158/0x270
[    0.000000]  acpi_match_madt+0x4c/0x84
[    0.000000]  acpi_table_parse_entries_array+0x140/0x218
[    0.000000]  acpi_table_parse_entries+0x70/0x98
[    0.000000]  acpi_table_parse_madt+0x40/0x50
[    0.000000]  __acpi_probe_device_table+0x88/0xe0
[    0.000000]  irqchip_init+0x38/0x40
[    0.000000]  init_IRQ+0xfc/0x130
[    0.000000]  start_kernel+0x344/0x4cc

due to the efi_memreserve_root not yet being set.



> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>   drivers/firmware/efi/efi.c | 31 +++++++++++++++++++------------
>   1 file changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 72a4da76d274..fad7c62cfc0e 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -967,36 +967,43 @@ bool efi_is_table_address(unsigned long phys_addr)
>   }
>   
>   static DEFINE_SPINLOCK(efi_mem_reserve_persistent_lock);
> +static struct linux_efi_memreserve *efi_memreserve_root __ro_after_init;
>   
>   int efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
>   {
> -	struct linux_efi_memreserve *rsv, *parent;
> +	struct linux_efi_memreserve *rsv;
>   
> -	if (efi.mem_reserve == EFI_INVALID_TABLE_ADDR)
> +	if (!efi_memreserve_root)
>   		return -ENODEV;
>   
> -	rsv = kmalloc(sizeof(*rsv), GFP_KERNEL);
> +	rsv = kmalloc(sizeof(*rsv), GFP_ATOMIC);
>   	if (!rsv)
>   		return -ENOMEM;
>   
> -	parent = memremap(efi.mem_reserve, sizeof(*rsv), MEMREMAP_WB);
> -	if (!parent) {
> -		kfree(rsv);
> -		return -ENOMEM;
> -	}
> -
>   	rsv->base = addr;
>   	rsv->size = size;
>   
>   	spin_lock(&efi_mem_reserve_persistent_lock);
> -	rsv->next = parent->next;
> -	parent->next = __pa(rsv);
> +	rsv->next = efi_memreserve_root->next;
> +	efi_memreserve_root->next = __pa(rsv);
>   	spin_unlock(&efi_mem_reserve_persistent_lock);
>   
> -	memunmap(parent);
> +	return 0;
> +}
>   
> +static int __init efi_memreserve_root_init(void)
> +{
> +	if (efi.mem_reserve == EFI_INVALID_TABLE_ADDR)
> +		return -ENODEV;
> +
> +	efi_memreserve_root = memremap(efi.mem_reserve,
> +				       sizeof(*efi_memreserve_root),
> +				       MEMREMAP_WB);
> +	if (!efi_memreserve_root)
> +		return -ENOMEM;
>   	return 0;
>   }
> +early_initcall(efi_memreserve_root_init);
>   
>   #ifdef CONFIG_KEXEC
>   static int update_efi_random_seed(struct notifier_block *nb,
> 
