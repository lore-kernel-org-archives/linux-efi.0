From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Sat, 26 Sep 2015 07:56:43 +0200
Message-ID: <20150926055643.GA25877@gmail.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443218539-7610-2-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


So this commit worries me.

This bug is a good find, and the fix is obviously needed and urgent, but I'm not 
sure about the implementation at all. (I've Cc:-ed a few more x86 low level 
gents.)

* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

>  /*
> + * Iterate the EFI memory map in reverse order because the regions
> + * will be mapped top-down. The end result is the same as if we had
> + * mapped things forward, but doesn't require us to change the
> + * existing implementation of efi_map_region().
> + */
> +static inline void *efi_map_next_entry_reverse(void *entry)
> +{
> +	/* Initial call */
> +	if (!entry)
> +		return memmap.map_end - memmap.desc_size;
> +
> +	entry -= memmap.desc_size;
> +	if (entry < memmap.map)
> +		return NULL;
> +
> +	return entry;
> +}
> +
> +/*
> + * efi_map_next_entry - Return the next EFI memory map descriptor
> + * @entry: Previous EFI memory map descriptor
> + *
> + * This is a helper function to iterate over the EFI memory map, which
> + * we do in different orders depending on the current configuration.
> + *
> + * To begin traversing the memory map @entry must be %NULL.
> + *
> + * Returns %NULL when we reach the end of the memory map.
> + */
> +static void *efi_map_next_entry(void *entry)
> +{
> +	if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {
> +		/*
> +		 * Starting in UEFI v2.5 the EFI_PROPERTIES_TABLE
> +		 * config table feature requires us to map all entries
> +		 * in the same order as they appear in the EFI memory
> +		 * map. That is to say, entry N must have a lower
> +		 * virtual address than entry N+1. This is because the
> +		 * firmware toolchain leaves relative references in
> +		 * the code/data sections, which are split and become
> +		 * separate EFI memory regions. Mapping things
> +		 * out-of-order leads to the firmware accessing
> +		 * unmapped addresses.
> +		 *
> +		 * Since we need to map things this way whether or not
> +		 * the kernel actually makes use of
> +		 * EFI_PROPERTIES_TABLE, let's just switch to this
> +		 * scheme by default for 64-bit.

The thing is, if relative accesses between these 'sections' do happen then the 
requirement is much stronger than just 'ordered by addresses' - then we must map 
them continuously and as a single block!

So at minimum the comment should say that. But I think we want more:


> +		 */
> +		return efi_map_next_entry_reverse(entry);
> +	}
> +
> +	/* Initial call */
> +	if (!entry)
> +		return memmap.map;
> +
> +	entry += memmap.desc_size;
> +	if (entry >= memmap.map_end)
> +		return NULL;
> +
> +	return entry;
> +}
> +
> +/*
>   * Map the efi memory ranges of the runtime services and update new_mmap with
>   * virtual addresses.
>   */
> @@ -714,7 +778,8 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
>  	unsigned long left = 0;
>  	efi_memory_desc_t *md;
>  
> -	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> +	p = NULL;
> +	while ((p = efi_map_next_entry(p))) {
>  		md = p;
>  		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {

So why is this 64-bit only? Is 32-bit not affected because there we allocate 
virtual addresses bottom-up?

This would be a lot clearer if we just mapped the entries in order, no questions 
asked. Conditions like this:

> +	if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {

... just invite confusion and possible corner cases where we end up mapping them 
wrong.

So could we make the whole code obviously bottom-up? Such as first calculating the 
size of virtual memory needed, then allocating a _single_, obviously continuous 
mapping, and then doing a very clear in-order mapping within that window? That 
would remove any bitness and legacy dependencies.

Good virtual memory layout is so critical for any third party code that this 
should be the central property of the whole approach, not just some side condition 
somewhere in an iteration loop.

Thanks,

	Ingo
