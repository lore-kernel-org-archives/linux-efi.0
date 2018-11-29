From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 4.9 39/92] efi/arm: Revert deferred unmap of early memmap mapping
Date: Thu, 29 Nov 2018 15:28:44 +0100
Message-ID: <CAKv+Gu8cPOQaYY_KH3dq+2U517z7j67Od+Cxe+wB4gkEOqnQTA@mail.gmail.com>
References: <20181129140106.520639693@linuxfoundation.org> <20181129140109.438834361@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181129140109.438834361@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi <linux-efi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, sashal@kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 29 Nov 2018 at 15:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 4.9-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> [ Upstream commit 33412b8673135b18ea42beb7f5117ed0091798b6 ]
>
> Commit:
>
>   3ea86495aef2 ("efi/arm: preserve early mapping of UEFI memory map longer for BGRT")
>
> deferred the unmap of the early mapping of the UEFI memory map to
> accommodate the ACPI BGRT code, which looks up the memory type that
> backs the BGRT table to validate it against the requirements of the UEFI spec.
>
> Unfortunately, this causes problems on ARM, which does not permit
> early mappings to persist after paging_init() is called, resulting
> in a WARN() splat. Since we don't support the BGRT table on ARM anway,
> let's revert ARM to the old behaviour, which is to take down the
> early mapping at the end of efi_init().
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-efi@vger.kernel.org
> Fixes: 3ea86495aef2 ("efi/arm: preserve early mapping of UEFI memory ...")

This commit is only in v4.19 as far as I know. Does it even apply?


> Link: http://lkml.kernel.org/r/20181114175544.12860-3-ard.biesheuvel@linaro.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/firmware/efi/arm-init.c    | 4 ++++
>  drivers/firmware/efi/arm-runtime.c | 2 +-
>  drivers/firmware/efi/memmap.c      | 3 +++
>  3 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
> index 1d1c9693ebfb..8ee91777abce 100644
> --- a/drivers/firmware/efi/arm-init.c
> +++ b/drivers/firmware/efi/arm-init.c
> @@ -256,6 +256,10 @@ void __init efi_init(void)
>                                     (params.mmap & ~PAGE_MASK)));
>
>         init_screen_info();
> +
> +       /* ARM does not permit early mappings to persist across paging_init() */
> +       if (IS_ENABLED(CONFIG_ARM))
> +               efi_memmap_unmap();
>  }
>
>  static int __init register_gop_device(void)
> diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
> index 4d788e0debfe..069c5a4479e6 100644
> --- a/drivers/firmware/efi/arm-runtime.c
> +++ b/drivers/firmware/efi/arm-runtime.c
> @@ -118,7 +118,7 @@ static int __init arm_enable_runtime_services(void)
>  {
>         u64 mapsize;
>
> -       if (!efi_enabled(EFI_BOOT) || !efi_enabled(EFI_MEMMAP)) {
> +       if (!efi_enabled(EFI_BOOT)) {
>                 pr_info("EFI services will not be available.\n");
>                 return 0;
>         }
> diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
> index 78686443cb37..3fd2b450c649 100644
> --- a/drivers/firmware/efi/memmap.c
> +++ b/drivers/firmware/efi/memmap.c
> @@ -117,6 +117,9 @@ int __init efi_memmap_init_early(struct efi_memory_map_data *data)
>
>  void __init efi_memmap_unmap(void)
>  {
> +       if (!efi_enabled(EFI_MEMMAP))
> +               return;
> +
>         if (!efi.memmap.late) {
>                 unsigned long size;
>
> --
> 2.17.1
>
>
>
