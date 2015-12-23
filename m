From: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>
Subject: RE: [PATCH 4/4] x86/efi: print size and base in binary units in
 efi_print_memmap
Date: Wed, 23 Dec 2015 00:11:56 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BEC79CB@G9W0745.americas.hpqcorp.net>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
 <1450402114-3606-5-git-send-email-elliott@hpe.com>
 <20151221161629.GG4227@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151221161629.GG4227-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


> -----Original Message-----
> From: Matt Fleming [mailto:matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org]
> Sent: Monday, December 21, 2015 10:16 AM
> To: Elliott, Robert (Persistent Memory) <elliott-ZPxbGqLxI0U@public.gmane.org>
> Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org; mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org; x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 4/4] x86/efi: print size and base in binary units in
> efi_print_memmap
> 
> On Thu, 17 Dec, at 07:28:34PM, Robert Elliott wrote:
> > Print the base address for each range in decimal alongside the size.
> > Use a "(size @ base)" format similar to the fake_memmap kernel
> parameter.
> >
> > Print the range and base in the best-fit B, KiB, MiB, etc. units rather
> > than always MiB.  This avoids rounding, which can be misleading.
> >
> > Use proper IEC binary units (KiB, MiB, etc.) rather than misuse SI
> > decimal units (KB, MB, etc.).
> >
> > old:
> >     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC]
> range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)
> >
> > new:
> >     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC]
> range=[0x0000000880000000-0x0000000c7fffffff] (16 GiB @ 34 GiB)
> >
> > Signed-off-by: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
> > ---
> >  arch/x86/platform/efi/efi.c | 27 ++++++++++++++++++++++++---
> >  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> I'm not at all sure of the value of printing the physical address as a
> size. I would have thought that you'd have to convert it back to an
> address whenever you wanted to use it anyway.

I was trying to make it resemble the memmap=size@address 
kernel parameter format for creating e820 entries, which
does accept abbreviations in addition to hex values:
	memmap=nn[KMG]@ss[KMG] for usable DRAM
	memmap=nn[KMG]#ss[KMG] for ACPI data
	memmap=nn[KMG]$ss[KMG] for reserved
	memmap=nn[KMG]!ss[KMG] for persistent memory

Mapping the UEFI type to the corresponding @, #, $, or ! was
more than I wanted to tackle, so it's not a drop-in
replacement string.

memparse() also accepts T, P, and E units; I guess those
need to be added to Documentation/kernel-parameters.txt.

> > diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> > index 635a955..030ba91 100644
> > --- a/arch/x86/platform/efi/efi.c
> > +++ b/arch/x86/platform/efi/efi.c
> > @@ -222,6 +222,25 @@ int __init efi_memblock_x86_reserve_range(void)
> >  	return 0;
> >  }
> >
> > +char * __init efi_size_format(char *buf, size_t size, u64 bytes)
> > +{
> > +	if (!bytes || (bytes & 0x3ff))
> > +		snprintf(buf, size, "%llu B", bytes);
> > +	else if (bytes & 0xfffff)
> > +		snprintf(buf, size, "%llu KiB", bytes >> 10);
> > +	else if (bytes & 0x3fffffff)
> > +		snprintf(buf, size, "%llu MiB", bytes >> 20);
> > +	else if (bytes & 0xffffffffff)
> > +		snprintf(buf, size, "%llu GiB", bytes >> 30);
> > +	else if (bytes & 0x3ffffffffffff)
> > +		snprintf(buf, size, "%llu TiB", bytes >> 40);
> > +	else if (bytes & 0xfffffffffffffff)
> > +		snprintf(buf, size, "%llu PiB", bytes >> 50);
> > +	else
> > +		snprintf(buf, size, "%llu EiB", bytes >> 60);
> > +	return buf;
> > +}
> > +
> 
> Can we use string_get_size() instead of rolling our own function?

Thanks for the pointer; I wondered if there was a similar
function somewhere.  However, that function throws away
precision in favor of printing just 3 significant digits;
I think that's dangerous.  Its non-integer output is not
supported by memmap=, and the function appears to use
assembly code to get CPU divide instructions, losing the
ability to use shifts for these power of two divisions.

Example results...

efi: mem01:... range=[0x0000000000093000-0x0000000000093fff] (4 KiB @ 588 KiB)
efi: mem01:... range=[0x0000000000093000-0x0000000000093fff] (4.00 KiB @ 588 KiB) SGS

efi: mem03:... range=[0x0000000000100000-0x00000000013e8fff] (19364 KiB @ 1 MiB)
efi: mem03:... range=[0x0000000000100000-0x00000000013e8fff] (18.9 MiB @ 1.00 MiB) SGS
(example of lost precision: 19364 KiB is really 18.91015625 MiB)

efi: mem04:... range=[0x00000000013e9000-0x0000000001ffffff] (12380 KiB @ 20388 KiB)
efi: mem04:... range=[0x00000000013e9000-0x0000000001ffffff] (12.0 MiB @ 19.9 MiB) SGS

efi: mem28:... range=[0x00000000717c2000-0x0000000072acafff] (19492 KiB @ 1859336 KiB)
efi: mem28:... range=[0x00000000717c2000-0x0000000072acafff] (19.0 MiB @ 1.77 GiB) SGS

efi: mem57:... range=[0x0000000880000000-0x0000000e7fffffff] (24 GiB @ 34 GiB)
efi: mem57:... range=[0x0000000880000000-0x0000000e7fffffff] (24.0 GiB @ 34.0 GiB) SGS

---
Robert Elliott, HPE Persistent Memory
