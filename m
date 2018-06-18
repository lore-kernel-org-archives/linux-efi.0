From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] x86/efi: Free allocated memory if remap fails
Date: Mon, 18 Jun 2018 19:25:05 +0200
Message-ID: <CAKv+Gu9-YrLPuduh3YH67Fk0+tL1AfAveguu+mPjBwEBNU+==Q@mail.gmail.com>
References: <1529111365-32295-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <CAKv+Gu-L=UMkzet7s1rUEYMYZxtoE1M_Qa1dqKo134S_hoZWuw@mail.gmail.com> <1529342439.2333.60.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529342439.2333.60.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On 18 June 2018 at 19:20, Sai Praneeth Prakhya
<sai.praneeth.prakhya@intel.com> wrote:
>
>> > It's a fact that memremap() and early_memremap() might never fail and
>> > this code might never get a chance to run but to maintain good kernel
>> > programming semantics, we might need this patch.
>> >
>> > Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
>> > Reviewed-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
>> Please don't include tags for reviews that did not happen on-list.
>>
>
> Sure! Thanks for letting me know.
>
>> > @@ -450,10 +451,11 @@ void __init efi_free_boot_services(void)
>> >
>> >         memunmap(new);
>> >
>> > -       if (efi_memmap_install(new_phys, num_entries)) {
>> > +       if (efi_memmap_install(new_phys, num_entries))
>> >                 pr_err("Could not install new EFI memmap\n");
>> > -               return;
>> > -       }
>> > +
>> > +free_mem:
>> > +       efi_memmap_free(new_phys, num_entries);
>> Doesn't this free the memory map that you just installed?
>>
>
> That's true! It's a bug. I will fix it.
>
>> >
>> >  }
>> >
>> >  /**
>> > + * efi_memmap_free - Free memory allocated by efi_memmap_alloc()
>> > + * @mem: Physical address allocated by efi_memmap_alloc()
>> > + * @num_entries: Number of entries in the allocated map.
>> > + *
>> > + * efi_memmap_alloc() allocates memory depending on whether mm_init()
>> > + * has already been invoked or not. It uses either memblock or "normal"
>> > + * page allocation. Use this function to free the memory allocated by
>> > + * efi_memmap_alloc(). Since the allocation is done in two different
>> > + * ways, similarly, we free it in two different ways.
>> > + *
>> > + */
>> > +void __init efi_memmap_free(phys_addr_t mem, unsigned int num_entries)
>> > +{
>> > +       unsigned long size = num_entries * efi.memmap.desc_size;
>> > +       unsigned int order = get_order(size);
>> > +       phys_addr_t end = mem + size - 1;
>> > +
>> > +       if (slab_is_available()) {
>> > +               __free_pages(pfn_to_page(PHYS_PFN(mem)), order);
>> How do you know that the memory you are freeing was allocated when
>> slab_is_available() was already true?
>>
>
> efi_memmap_free() should be used *only* in conjunction
> with efi_memmap_alloc()(As I explicitly didn't mention this, maybe it might
> have confused you).
>
> When allocating memory efi_memmap_alloc() does similar check
> for slab_is_available() and if so, it allocates memory using alloc_pages().
> So, to free pages allocated using alloc_pages(), efi_memmap_free()
> uses __free_pages().
>

I understand that. But by abstracting away the free() routine as well
as the alloc() routine, you are hiding this fact.

What is preventing me from using efi_memmap_alloc() to allocate space
for the memmap, and using efi_memmap_free() in another place? How are
you preventing that this does not happen in a way where mm_init() may
be called in the mean time?

Whether __free_pages() should be used or memblock_free() is a property
of the *allocation* itself, not of whether mm_init() has already been
called. So if (!slab_is_available()), you can use memblock_free().
However, if (slab_is_available()), you cannot use __free_pages()
because the allocation could have been made before mm_init() was
called.


>> >
>> > +               return;
>> > +       }
>> > +
>> > +       if (memblock_free(mem, size))
>> > +               pr_err("Failed to free mem from %pa to %pa\n", &mem,
>> > &end);
>> > +}
>> > +
>
> Regards,
> Sai
