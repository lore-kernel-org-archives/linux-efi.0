From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/2] x86/efi: don't allocate memmap through memblock
 after mm_init()
Date: Wed, 4 Jan 2017 10:40:09 -0800
Message-ID: <CAA9_cmeL502TrUm5eT8EmyHqGwi=7t9QbM-vykPJ-81o1Z60GQ@mail.gmail.com>
References: <20161222102340.2689-1-nicstange@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222102340.2689-1-nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Dec 22, 2016 at 2:23 AM, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
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
> Signed-off-by: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Tested-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This addresses the v4.9 boot regression I reported:

http://marc.info/?l=linux-kernel&m=148349836923836&w=2
