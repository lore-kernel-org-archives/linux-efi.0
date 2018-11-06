From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/4] efi/arm: defer persistent reservations until after
 paging_init()
Date: Tue, 6 Nov 2018 20:02:58 +0100
Message-ID: <CAKv+Gu8OsFb7a5UTovN1yBXtSSY=ZtUBYUvNa_bPmcZGknNYQA@mail.gmail.com>
References: <20181106113732.16351-1-ard.biesheuvel@linaro.org>
 <20181106113732.16351-3-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181106113732.16351-3-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-efi <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>
List-Id: linux-efi@vger.kernel.org

On 6 November 2018 at 12:37, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> The new memory EFI reservation feature we introduced to allow memory
> reservations to persist across kexec may trigger an unbounded number
> of calls to memblock_reserve(). The memblock subsystem can deal with
> this fine, but not before memblock resizing is enabled, which we can
> only do after paging_init(), when the memory we reallocate the array
> into is actually mapped.
>
> So break out the memreserve table processing into a separate function
> and call if after paging_init() on both arm64 and ARM.
>
> Cc: Russell King <linux@armlinux.org.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Russell,

If you are ok with this patch, may I have your ack please? I would
like to send it out before the end of the week.

Thanks,

> ---
>  arch/arm/kernel/setup.c    | 1 +
>  arch/arm64/kernel/setup.c  | 1 +
>  drivers/firmware/efi/efi.c | 8 ++++++--
>  include/linux/efi.h        | 7 +++++++
>  4 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index ac7e08886863..e99f12eaf390 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -1117,6 +1117,7 @@ void __init setup_arch(char **cmdline_p)
>         early_ioremap_reset();
>
>         paging_init(mdesc);
> +       efi_apply_persistent_mem_reservations();
>         request_standard_resources(mdesc);
>
>         if (mdesc->restart)
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index 953e316521fc..f4fc1e0544b7 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -313,6 +313,7 @@ void __init setup_arch(char **cmdline_p)
>         arm64_memblock_init();
>
>         paging_init();
> +       efi_apply_persistent_mem_reservations();
>
>         acpi_table_upgrade();
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 249eb70691b0..55e4ea20bdc3 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -592,7 +592,11 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
>
>                 early_memunmap(tbl, sizeof(*tbl));
>         }
> +       return 0;
> +}
>
> +int __init efi_apply_persistent_mem_reservations(void)
> +{
>         if (efi.mem_reserve != EFI_INVALID_TABLE_ADDR) {
>                 unsigned long prsv = efi.mem_reserve;
>
> @@ -602,7 +606,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
>                         /* reserve the entry itself */
>                         memblock_reserve(prsv, sizeof(*rsv));
>
> -                       rsv = early_memremap(prsv, sizeof(*rsv));
> +                       rsv = memremap(prsv, sizeof(*rsv), MEMREMAP_WB);
>                         if (rsv == NULL) {
>                                 pr_err("Could not map UEFI memreserve entry!\n");
>                                 return -ENOMEM;
> @@ -612,7 +616,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
>                                 memblock_reserve(rsv->base, rsv->size);
>
>                         prsv = rsv->next;
> -                       early_memunmap(rsv, sizeof(*rsv));
> +                       memunmap(rsv);
>                 }
>         }
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 845174e113ce..100ce4a4aff6 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1167,6 +1167,8 @@ static inline bool efi_enabled(int feature)
>  extern void efi_reboot(enum reboot_mode reboot_mode, const char *__unused);
>
>  extern bool efi_is_table_address(unsigned long phys_addr);
> +
> +extern int efi_apply_persistent_mem_reservations(void);
>  #else
>  static inline bool efi_enabled(int feature)
>  {
> @@ -1185,6 +1187,11 @@ static inline bool efi_is_table_address(unsigned long phys_addr)
>  {
>         return false;
>  }
> +
> +static inline int efi_apply_persistent_mem_reservations(void)
> +{
> +       return 0;
> +}
>  #endif
>
>  extern int efi_status_to_err(efi_status_t status);
> --
> 2.19.1
>
