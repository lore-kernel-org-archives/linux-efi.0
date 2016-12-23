From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v2 1/2] x86/efi: don't allocate memmap through memblock
 after mm_init()
Date: Fri, 23 Dec 2016 14:52:06 +0000
Message-ID: <20161223145206.GC16838@codeblueprint.co.uk>
References: <20161222102340.2689-1-nicstange@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161222102340.2689-1-nicstange@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 22 Dec, at 11:23:39AM, Nicolai Stange wrote:
> With commit 4bc9f92e64c8 ("x86/efi-bgrt: Use efi_mem_reserve() to avoid
> copying image data"), efi_bgrt_init() calls into the memblock allocator
> through efi_mem_reserve() => efi_arch_mem_reserve() *after* mm_init()
> has been called.
> 
> Indeed, KASAN reports a bad read access later on in
> efi_free_boot_services():
> 
>   BUG: KASAN: use-after-free in efi_free_boot_services+0xae/0x24c
>             at addr ffff88022de12740
>   Read of size 4 by task swapper/0/0
>   page:ffffea0008b78480 count:0 mapcount:-127
>   mapping:          (null) index:0x1 flags: 0x5fff8000000000()
>   [...]
>   Call Trace:
>    dump_stack+0x68/0x9f
>    kasan_report_error+0x4c8/0x500
>    kasan_report+0x58/0x60
>    __asan_load4+0x61/0x80
>    efi_free_boot_services+0xae/0x24c
>    start_kernel+0x527/0x562
>    x86_64_start_reservations+0x24/0x26
>    x86_64_start_kernel+0x157/0x17a
>    start_cpu+0x5/0x14
> 
> The instruction at the given address is the first read from the memmap's
> memory, i.e. the read of md->type in efi_free_boot_services().
> 
> Note that the writes earlier in efi_arch_mem_reserve() don't splat because
> they're done through early_memremap()ed addresses.
> 
> So, after memblock is gone, allocations should be done through the "normal"
> page allocator. Introduce a helper, efi_memmap_alloc() for this. Use
> it from efi_arch_mem_reserve() and from efi_free_boot_services() as well.
> 
> Fixes: 4bc9f92e64c8 ("x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data")
> Signed-off-by: Nicolai Stange <nicstange@gmail.com>
> ---
>  arch/x86/platform/efi/quirks.c |  4 ++--
>  drivers/firmware/efi/memmap.c  | 38 ++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h            |  1 +
>  3 files changed, 41 insertions(+), 2 deletions(-)

Nice catch. Could you also modify efi_fake_memmap() to use your new
efi_memmap_alloc() function for consistency (note that all
memblock_alloc()s should probably be PAGE_SIZE aligned like the
fakemem code)?
