From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Sat, 26 Sep 2015 14:43:29 +0100
Message-ID: <20150926134329.GA3144@codeblueprint.co.uk>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk>
 <20150926055643.GA25877@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150926055643.GA25877@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@Odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Dave Young <dyoung@redhat.com>, stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 26 Sep, at 07:56:43AM, Ingo Molnar wrote:
> 
> So this commit worries me.
> 
> This bug is a good find, and the fix is obviously needed and urgent, but I'm not 
> sure about the implementation at all. (I've Cc:-ed a few more x86 low level 
> gents.)
 
Thanks, the more the merrier.

> * Matt Fleming <matt@codeblueprint.co.uk> wrote:
> 
> >  /*
> > + * Iterate the EFI memory map in reverse order because the regions
> > + * will be mapped top-down. The end result is the same as if we had
> > + * mapped things forward, but doesn't require us to change the
> > + * existing implementation of efi_map_region().
> > + */
> > +static inline void *efi_map_next_entry_reverse(void *entry)
> > +{
> > +	/* Initial call */
> > +	if (!entry)
> > +		return memmap.map_end - memmap.desc_size;
> > +
> > +	entry -= memmap.desc_size;
> > +	if (entry < memmap.map)
> > +		return NULL;
> > +
> > +	return entry;
> > +}
> > +
> > +/*
> > + * efi_map_next_entry - Return the next EFI memory map descriptor
> > + * @entry: Previous EFI memory map descriptor
> > + *
> > + * This is a helper function to iterate over the EFI memory map, which
> > + * we do in different orders depending on the current configuration.
> > + *
> > + * To begin traversing the memory map @entry must be %NULL.
> > + *
> > + * Returns %NULL when we reach the end of the memory map.
> > + */
> > +static void *efi_map_next_entry(void *entry)
> > +{
> > +	if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {
> > +		/*
> > +		 * Starting in UEFI v2.5 the EFI_PROPERTIES_TABLE
> > +		 * config table feature requires us to map all entries
> > +		 * in the same order as they appear in the EFI memory
> > +		 * map. That is to say, entry N must have a lower
> > +		 * virtual address than entry N+1. This is because the
> > +		 * firmware toolchain leaves relative references in
> > +		 * the code/data sections, which are split and become
> > +		 * separate EFI memory regions. Mapping things
> > +		 * out-of-order leads to the firmware accessing
> > +		 * unmapped addresses.
> > +		 *
> > +		 * Since we need to map things this way whether or not
> > +		 * the kernel actually makes use of
> > +		 * EFI_PROPERTIES_TABLE, let's just switch to this
> > +		 * scheme by default for 64-bit.
> 
> The thing is, if relative accesses between these 'sections' do happen then the 
> requirement is much stronger than just 'ordered by addresses' - then we must map 
> them continuously and as a single block!
> 
> So at minimum the comment should say that. But I think we want more:
 
Well, the firmware doesn't place arbitrary gaps between these runtime
image sections in memory, they still get loaded into memory by the
firmware the old-fashioned way (as one contiguous blob). It's just
that we've now got two memory map entries for the single PE/COFF
image. Also, it's only sections from the same PE/COFF image that
reference each other (but like Ard said, we can't tell from the memmap
which entries are for a single PE/COFF image).

Because EFI memory map entries that are part of the same PE/COFF image
will be at consecutive addresses, we'll also map them contiguously in
the kernel virtual address space, because that's how the current code
works - it's just that the current code maps them backwards.

Yeah, I'm completely in favour of improving any of the comments. 
 
> > +		 */
> > +		return efi_map_next_entry_reverse(entry);
> > +	}
> > +
> > +	/* Initial call */
> > +	if (!entry)
> > +		return memmap.map;
> > +
> > +	entry += memmap.desc_size;
> > +	if (entry >= memmap.map_end)
> > +		return NULL;
> > +
> > +	return entry;
> > +}
> > +
> > +/*
> >   * Map the efi memory ranges of the runtime services and update new_mmap with
> >   * virtual addresses.
> >   */
> > @@ -714,7 +778,8 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
> >  	unsigned long left = 0;
> >  	efi_memory_desc_t *md;
> >  
> > -	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> > +	p = NULL;
> > +	while ((p = efi_map_next_entry(p))) {
> >  		md = p;
> >  		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
> 
> So why is this 64-bit only? Is 32-bit not affected because there we allocate 
> virtual addresses bottom-up?
 
32-bit would potentially be effected if 32-bit firmware ever enabled
the EFI_PROPERTIES_TABLE feature. Whether or not it worked would
depend on the fragemntation of the virtual memory space when we map
the EFI regions.

But I'm not aware of any 32-bit firmware shipping with Properties
Table support, and fixing it in the kernel like we do for x86-64 would
require changing the EFI region mapping code. That's something I
wanted to avoid for this patch since it needs to be applied to stable,
and especially when we haven't seen the feature being used in the
wild.

> This would be a lot clearer if we just mapped the entries in order, no questions 
> asked. Conditions like this:
> 
> > +	if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {
> 
> ... just invite confusion and possible corner cases where we end up mapping them 
> wrong.
 
When we introduced the top-down scheme in commit d2f7cbe7b26a
("x86/efi: Runtime services virtual mapping") we also introduced the
"efi=old_map" kernel parameter to force the old virtual address
allocation scheme exactly because we were concerned we might run into
firmware "issues" with the way we mapped things.

That concern hasn't gone away now - it's intensified.

The above conditional just codifies a config combination that we've
always treated differently, and the conditional logic is only
necessary because this is generic x86 code.

I agree that it would be nicer without the conditional code, but
forcing the same allocation scheme across 32-bit and 64-bit is a
*much* bigger change than what is proposed here. Not just in terms of
patch size, but also in terms of risk.

> So could we make the whole code obviously bottom-up? Such as first calculating the 
> size of virtual memory needed, then allocating a _single_, obviously continuous 
> mapping, and then doing a very clear in-order mapping within that window? That 
> would remove any bitness and legacy dependencies.
 
So, we could, and in fact the first version of this patch did just
that. You can find it here,

  https://lkml.kernel.org/r/1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk

But Ard suggested re-using the existing code and simply changing the
order we map the memmap entries in. And given the constraint for a
small patch for backporting, I think it's a better solution. The
actual virtual addresses we pick are exactly the same with the two
patches.

-- 
Matt Fleming, Intel Open Source Technology Center
