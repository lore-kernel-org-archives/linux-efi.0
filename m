From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [GIT PULL] EFI fix
Date: Fri, 11 Jan 2019 15:22:35 +0100
Message-ID: <CAKv+Gu8oY6VFeuH3T0FU452W-rKGGQk3top5kEbuP2aCxzJTCQ@mail.gmail.com>
References: <20190111074614.GA68053@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190111074614.GA68053@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 11 Jan 2019 at 08:46, Ingo Molnar <mingo@kernel.org> wrote:
>
> Linus,
>
> Please pull the latest efi-urgent-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-urgent-for-linus
>
>    # HEAD: b12f5440d8ca02e8f9ab4f1461f9214295cc4f66 Merge branch 'linus' into efi/urgent, to resolve conflict
>
> A single fix that adds an annotation to resolve a kmemleak false
> positive.
>
>  Thanks,
>
>         Ingo
>
> ------------------>
> Qian Cai (1):
>       efi: Let kmemleak ignore false positives
>
>
>  drivers/firmware/efi/efi.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 4c46ff6f2242..7ac09dd8f268 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -31,6 +31,7 @@
>  #include <linux/acpi.h>
>  #include <linux/ucs2_string.h>
>  #include <linux/memblock.h>
> +#include <linux/kmemleak.h>
>
>  #include <asm/early_ioremap.h>
>
> @@ -1026,6 +1027,8 @@ int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
>         if (!rsv)
>                 return -ENOMEM;
>
> +       kmemleak_ignore(rsv);
> +
>         rsv->size = EFI_MEMRESERVE_COUNT(PAGE_SIZE);
>         atomic_set(&rsv->count, 1);
>         rsv->entry[0].base = addr;

I was hoping we could merge this patch (so we can backport it), but
resolve the conflict by dropping the kmemleak_ignore() again, since it
will now complain since the kmalloc() has been replaced with a
__get_free_page() in the mean time (if that makes sense)
