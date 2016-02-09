From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/14] x86/efi: Print size in binary units in
 efi_print_memmap
Date: Tue, 9 Feb 2016 13:53:58 +0100
Message-ID: <56B9E166.6030405@redhat.com>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
 <1454364428-494-15-git-send-email-matt@codeblueprint.co.uk>
 <56B0756E.9010603@redhat.com> <20160203104045.GB7310@gmail.com>
 <20160203112829.GC2597@codeblueprint.co.uk>
 <94D0CD8314A33A4D9D801C0FE68B40295BF72A9F@G4W3202.americas.hpqcorp.net>
 <20160209122018.GA4178@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160209122018.GA4178-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/09/16 13:20, Ingo Molnar wrote:
> 
> * Elliott, Robert (Persistent Memory) <elliott-ZPxbGqLxI0U@public.gmane.org> wrote:
> 
>>
>>> -----Original Message-----
>>> From: Matt Fleming [mailto:matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org]
>>> Sent: Wednesday, February 3, 2016 5:28 AM
>>> To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> Cc: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; H . Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>;
>>> Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>; linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
>>> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Elliott, Robert (Persistent Memory)
>>> <elliott-ZPxbGqLxI0U@public.gmane.org>; Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>;
>>> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>; Taku Izumi
>>> <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>; Linus Torvalds <torvalds@linux-
>>> foundation.org>; Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>>> Subject: Re: [PATCH 14/14] x86/efi: Print size in binary units in
>>> efi_print_memmap
>> ...
>>> OK, this patch has caused enough headaches. Let's drop it from this
>>> series.
>>>
>>> Robert, Andy, feel free to resubmit it after you've addressed
>>> everyone's concerns and we can discuss it in isolation.
>>
>> We could just delete the size print altogether - better to print
>> nothing than a silently rounded number.  The end address already
>> communicates the size - it's just not as readable.  
>>
>> The e820 table prints don't bother with a size print. 
>>
>> That would also shorten these extremely wide prints to 116
>> characters (131 if printk time is enabled).
>>
>> [    0.000000] BIOS-e820: [mem 0x0000001880000000-0x000000207fffffff] reserved
>> vs.
>> [    0.000000] efi: mem62: [Reserved           |   |  |NV|  |  |  |  |   |WB|WT|WC|UC] range=[0x0000001880000000-0x000000207fffffff] (32 GiB)
> 
> So I find the latter a lot more readable - my terminals are wide enough ;-)
> 
> Humans are also rather bad at parsing 64-bit hexa address ranges at a glance, so 
> the size display is very useful.
> 
> But the flags portion should be shortened via appropriately chosen 
> single-character abbreviations for the flags. Anyone deeply intimate with the code 
> will recognize the flags - others won't care one way or another.
> 
> plus there's no need to write out 'range='.
>   
> ... and please keep the size and just use GB/TB for chrissake.
> 
> I.e. something like this would work for me:
> 
>> [    0.000000] efi: mem62: 0x0000001880000000-0x000000207fffffff (  32 GB) .N....BTCU "Reserved"

Sorry to disagree :), but I count myself somewhat intimate with UEFI
(albeit more from the edk2 side), and while I can make sense of

  |NV|  |  |  |  |   |WB|WT|WC|UC]

I find

  .N....BTCU

mostly undecipherable. :)

My original goal with this printout was to (a) provide a good impression
of the entire UEFI memmap, at a glance, (b) provide sufficient detail
per-entry, if necessary.

(I don't exactly recall why I was staring at the UEFI memmap dump at
that time, maybe I was working on S3 in OVMF which took a lot of memmap
massaging, or debugging some bug; either way my eyes were bleeding
trying to decode the numeric attributes.)

My xterm, maximized, has 239 columns, which I think counts as pretty low
for today's resolutions. It is nonetheless plenty wide for the current
output. Given that we print this stuff only when debugging information
is requested, I feel that the value of the current columnar output, in
which I can follow a single attribute with my eye across all entries,
should not be diminished, by compressing the columns.

I'm not a wide screen maniac; for example I insist on source code being
wrapped at 79 characters, commit messages at 74, emails at 72 (except
diagrams and log excerpts), and so on. But debug output is different.

My 2 cents, of course...

Thanks
Laszlo
