From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Fri, 25 Sep 2015 23:44:18 -0700
Message-ID: <CAKv+Gu_C-QxtMmpDsNtbFTqR+4X4bZ08L5+vNK8zsexUjvcvXg@mail.gmail.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
	<1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk>
	<20150926055643.GA25877@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150926055643.GA25877-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-wo1vFcy6AUs@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 25 September 2015 at 22:56, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> So this commit worries me.
>
> This bug is a good find, and the fix is obviously needed and urgent, but I'm not
> sure about the implementation at all. (I've Cc:-ed a few more x86 low level
> gents.)
>
> * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>
>>  /*
>> + * Iterate the EFI memory map in reverse order because the regions
>> + * will be mapped top-down. The end result is the same as if we had
>> + * mapped things forward, but doesn't require us to change the
>> + * existing implementation of efi_map_region().
>> + */
>> +static inline void *efi_map_next_entry_reverse(void *entry)
>> +{
>> +     /* Initial call */
>> +     if (!entry)
>> +             return memmap.map_end - memmap.desc_size;
>> +
>> +     entry -= memmap.desc_size;
>> +     if (entry < memmap.map)
>> +             return NULL;
>> +
>> +     return entry;
>> +}
>> +
>> +/*
>> + * efi_map_next_entry - Return the next EFI memory map descriptor
>> + * @entry: Previous EFI memory map descriptor
>> + *
>> + * This is a helper function to iterate over the EFI memory map, which
>> + * we do in different orders depending on the current configuration.
>> + *
>> + * To begin traversing the memory map @entry must be %NULL.
>> + *
>> + * Returns %NULL when we reach the end of the memory map.
>> + */
>> +static void *efi_map_next_entry(void *entry)
>> +{
>> +     if (!efi_enabled(EFI_OLD_MEMMAP) && efi_enabled(EFI_64BIT)) {
>> +             /*
>> +              * Starting in UEFI v2.5 the EFI_PROPERTIES_TABLE
>> +              * config table feature requires us to map all entries
>> +              * in the same order as they appear in the EFI memory
>> +              * map. That is to say, entry N must have a lower
>> +              * virtual address than entry N+1. This is because the
>> +              * firmware toolchain leaves relative references in
>> +              * the code/data sections, which are split and become
>> +              * separate EFI memory regions. Mapping things
>> +              * out-of-order leads to the firmware accessing
>> +              * unmapped addresses.
>> +              *
>> +              * Since we need to map things this way whether or not
>> +              * the kernel actually makes use of
>> +              * EFI_PROPERTIES_TABLE, let's just switch to this
>> +              * scheme by default for 64-bit.
>
> The thing is, if relative accesses between these 'sections' do happen then the
> requirement is much stronger than just 'ordered by addresses' - then we must map
> them continuously and as a single block!
>

The primary difference between pre-2.5 and 2.5 with this feature
enabled is that formerly, each PE/COFF image in memory would be
covered by at most a single EfiRuntimeServicesCode region, and now, a
single PE/COFF image may be split into different regions. It is only
relative references *inside* such a PE/COFF image that we are
concerned about, since no symbol references exist between separate
ones.

Also, it is not only relative references inside the PE/COFF image that
cause the problem. Another aspect is that the offset that is applied
to all absolute references at relocation time is derived from the
offset of the base of the PE/COFF image. If part of the PE/COFF image
(the .data section) is moved relatively to the code section, these
absolute references are fixed up incorrectly. This is actually a
problem that we could solve at the firmware side, but since PE/COFF
does not really tolerate being split up like that, the correct fix is
to keep all regions belonging to a single PE/COFF image adjacent.
Since we can't tell which those regions are, the next best approach is
to keep all adjacent regions with the EFI_MEMORY_RUNTIME attribute
adjacent in the VA mapping.

-- 
Ard.
