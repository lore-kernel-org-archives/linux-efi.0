From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 4/4] x86/efi: print size and base in binary units in
 efi_print_memmap
Date: Wed, 23 Dec 2015 15:52:55 +0000
Message-ID: <20151223155255.GD2471@codeblueprint.co.uk>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
 <1450402114-3606-5-git-send-email-elliott@hpe.com>
 <20151221161629.GG4227@codeblueprint.co.uk>
 <94D0CD8314A33A4D9D801C0FE68B40295BEC79CB@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295BEC79CB-W1gbDvblbosSZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>
Cc: "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 23 Dec, at 12:11:56AM, Elliott, Robert (Persistent Memory) wrote:
> 
> I was trying to make it resemble the memmap=size@address 
> kernel parameter format for creating e820 entries, which
> does accept abbreviations in addition to hex values:
> 	memmap=nn[KMG]@ss[KMG] for usable DRAM
> 	memmap=nn[KMG]#ss[KMG] for ACPI data
> 	memmap=nn[KMG]$ss[KMG] for reserved
> 	memmap=nn[KMG]!ss[KMG] for persistent memory
> 
> Mapping the UEFI type to the corresponding @, #, $, or ! was
> more than I wanted to tackle, so it's not a drop-in
> replacement string.
> 
> memparse() also accepts T, P, and E units; I guess those
> need to be added to Documentation/kernel-parameters.txt.
 
I think the value of the "@ address" portion of the string is
questionable.

> Thanks for the pointer; I wondered if there was a similar
> function somewhere.  However, that function throws away
> precision in favor of printing just 3 significant digits;
> I think that's dangerous.  Its non-integer output is not
> supported by memmap=, and the function appears to use
> assembly code to get CPU divide instructions, losing the
> ability to use shifts for these power of two divisions.
> 
> Example results...
> 
> efi: mem01:... range=[0x0000000000093000-0x0000000000093fff] (4 KiB @ 588 KiB)
> efi: mem01:... range=[0x0000000000093000-0x0000000000093fff] (4.00 KiB @ 588 KiB) SGS
> 
> efi: mem03:... range=[0x0000000000100000-0x00000000013e8fff] (19364 KiB @ 1 MiB)
> efi: mem03:... range=[0x0000000000100000-0x00000000013e8fff] (18.9 MiB @ 1.00 MiB) SGS
> (example of lost precision: 19364 KiB is really 18.91015625 MiB)
> 
> efi: mem04:... range=[0x00000000013e9000-0x0000000001ffffff] (12380 KiB @ 20388 KiB)
> efi: mem04:... range=[0x00000000013e9000-0x0000000001ffffff] (12.0 MiB @ 19.9 MiB) SGS
> 
> efi: mem28:... range=[0x00000000717c2000-0x0000000072acafff] (19492 KiB @ 1859336 KiB)
> efi: mem28:... range=[0x00000000717c2000-0x0000000072acafff] (19.0 MiB @ 1.77 GiB) SGS
> 
> efi: mem57:... range=[0x0000000880000000-0x0000000e7fffffff] (24 GiB @ 34 GiB)
> efi: mem57:... range=[0x0000000880000000-0x0000000e7fffffff] (24.0 GiB @ 34.0 GiB) SGS

Good points! I agree that string_get_size() (unfortunately) doesn't
look useful in this scenario. The code in efi_size_format() looks
fine.
