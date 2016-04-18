From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: ARM: avoid warning about phys_addr_t cast
Date: Mon, 18 Apr 2016 10:36:21 +0200
Message-ID: <CAKv+Gu_1o+Jmc244F5byphMue+pHSP4T8wEMohHL64NU1_sChg@mail.gmail.com>
References: <1460968481-169298-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460968481-169298-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Steve Capper <steve.capper@arm.com>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Dan Williams <dan.j.williams@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 18 April 2016 at 10:34, Arnd Bergmann <arnd@arndb.de> wrote:
> memblock_remove() takes a phys_addr_t, which may be narrower than 64 bits,
> causing a harmless warning:
>
> drivers/firmware/efi/arm-init.c: In function 'reserve_regions':
> include/linux/kernel.h:29:20: error: large integer implicitly truncated to unsigned type [-Werror=overflow]
>  #define ULLONG_MAX (~0ULL)
>                     ^
> drivers/firmware/efi/arm-init.c:152:21: note: in expansion of macro 'ULLONG_MAX'
>   memblock_remove(0, ULLONG_MAX);
>
> This adds an explicit typecast to avoid the warning
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 500899c2cc3e ("efi: ARM/arm64: ignore DT memory nodes instead of removing them")

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/firmware/efi/arm-init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
> index 434dd6065935..fac567c3b66a 100644
> --- a/drivers/firmware/efi/arm-init.c
> +++ b/drivers/firmware/efi/arm-init.c
> @@ -149,7 +149,7 @@ static __init void reserve_regions(void)
>          * uses its own memory map instead.
>          */
>         memblock_dump_all();
> -       memblock_remove(0, ULLONG_MAX);
> +       memblock_remove(0, (phys_addr_t)ULLONG_MAX);
>
>         for_each_efi_memory_desc(&memmap, md) {
>                 paddr = md->phys_addr;
> --
> 2.7.0
>
