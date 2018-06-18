From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: Re: [PATCH] x86/efi: Free allocated memory if remap fails
Date: Mon, 18 Jun 2018 10:41:48 -0700
Message-ID: <1529343708.2333.65.camel@intel.com>
References: <1529111365-32295-1-git-send-email-sai.praneeth.prakhya@intel.com>
         <CAKv+Gu-L=UMkzet7s1rUEYMYZxtoE1M_Qa1dqKo134S_hoZWuw@mail.gmail.com>
         <1529342439.2333.60.camel@intel.com>
         <CAKv+Gu9-YrLPuduh3YH67Fk0+tL1AfAveguu+mPjBwEBNU+==Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9-YrLPuduh3YH67Fk0+tL1AfAveguu+mPjBwEBNU+==Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org



> > > > +void __init efi_memmap_free(phys_addr_t mem, unsigned int
> > > > num_entries)
> > > > +{
> > > > +       unsigned long size = num_entries * efi.memmap.desc_size;
> > > > +       unsigned int order = get_order(size);
> > > > +       phys_addr_t end = mem + size - 1;
> > > > +
> > > > +       if (slab_is_available()) {
> > > > +               __free_pages(pfn_to_page(PHYS_PFN(mem)), order);
> > > How do you know that the memory you are freeing was allocated when
> > > slab_is_available() was already true?
> > > 
> > efi_memmap_free() should be used *only* in conjunction
> > with efi_memmap_alloc()(As I explicitly didn't mention this, maybe it
> > might
> > have confused you).
> > 
> > When allocating memory efi_memmap_alloc() does similar check
> > for slab_is_available() and if so, it allocates memory using
> > alloc_pages().
> > So, to free pages allocated using alloc_pages(), efi_memmap_free()
> > uses __free_pages().
> > 
> I understand that. But by abstracting away the free() routine as well
> as the alloc() routine, you are hiding this fact.
> 
> What is preventing me from using efi_memmap_alloc() to allocate space
> for the memmap, and using efi_memmap_free() in another place? How are
> you preventing that this does not happen in a way where mm_init() may
> be called in the mean time?
> 
> Whether __free_pages() should be used or memblock_free() is a property
> of the *allocation* itself, not of whether mm_init() has already been
> called. So if (!slab_is_available()), you can use memblock_free().
> However, if (slab_is_available()), you cannot use __free_pages()
> because the allocation could have been made before mm_init() was
> called.
> 

Aahh.. Thanks a lot! for making it clear. I see the bug now
(efi_memmap_alloc() could be called before mm_init() in which case it uses
memblock_alloc() where as efi_memmap_free() could be called after mm_init() in
which case it uses __free_pages()).

I will fix this.

Regards,
Sai
