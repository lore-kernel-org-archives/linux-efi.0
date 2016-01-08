From: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>
Subject: RE: [PATCH 4/4] x86/efi: print size and base in binary units in
 efi_print_memmap
Date: Fri, 8 Jan 2016 16:38:17 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BF07E19@G4W3202.americas.hpqcorp.net>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
 <1450402114-3606-5-git-send-email-elliott@hpe.com>
 <20151221161629.GG4227@codeblueprint.co.uk>
 <CAHp75VffR6FO=s5JeVPUPepVRyn-mwXF=juf+y1j44J69i3RKw@mail.gmail.com>
 <20160108121921.GI2532@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160108121921.GI2532-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: Matt Fleming [mailto:matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org]
> Sent: Friday, January 8, 2016 6:19 AM
> To: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Elliott, Robert (Persistent Memory) <elliott-ZPxbGqLxI0U@public.gmane.org>; Thomas Gleixner
> <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>; Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; H. Peter Anvin
> <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>; x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 4/4] x86/efi: print size and base in binary units in
> efi_print_memmap
> 
> On Sun, 27 Dec, at 04:35:12PM, Andy Shevchenko wrote:
> > On Mon, Dec 21, 2015 at 6:16 PM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> wrote:
> > >> diff --git a/arch/x86/platform/efi/efi.c
> b/arch/x86/platform/efi/efi.c
> > >> index 635a955..030ba91 100644
> > >> --- a/arch/x86/platform/efi/efi.c
> > >> +++ b/arch/x86/platform/efi/efi.c
> > >> @@ -222,6 +222,25 @@ int __init efi_memblock_x86_reserve_range(void)
> > >>       return 0;
> > >>  }
> > >>
> > >> +char * __init efi_size_format(char *buf, size_t size, u64 bytes)
> > >> +{
> > >> +     if (!bytes || (bytes & 0x3ff))
> > >> +             snprintf(buf, size, "%llu B", bytes);
> > >> +     else if (bytes & 0xfffff)
> > >> +             snprintf(buf, size, "%llu KiB", bytes >> 10);
> > >> +     else if (bytes & 0x3fffffff)
> > >> +             snprintf(buf, size, "%llu MiB", bytes >> 20);
> > >> +     else if (bytes & 0xffffffffff)
> > >> +             snprintf(buf, size, "%llu GiB", bytes >> 30);
> > >> +     else if (bytes & 0x3ffffffffffff)
> > >> +             snprintf(buf, size, "%llu TiB", bytes >> 40);
> > >> +     else if (bytes & 0xfffffffffffffff)
> > >> +             snprintf(buf, size, "%llu PiB", bytes >> 50);
> > >> +     else
> > >> +             snprintf(buf, size, "%llu EiB", bytes >> 60);
> > >> +     return buf;
> >
> > For me it looks like ffs with name in the table can be used.
> 
> Could you provide a patch?

I think this is functionally equivalent:
#include <string.h>

char * efi_size_format_ffsl(char *buf, size_t size, u64 bytes)
{
	if (!bytes || ffsl(bytes) < 10)
		snprintf(buf, size, "%llu B", bytes);
	else if (ffsl(bytes) < 20)
		snprintf(buf, size, "%llu KiB", bytes >> 10);
	else if (ffsl(bytes) < 30)
		snprintf(buf, size, "%llu MiB", bytes >> 20);
	else if (ffsl(bytes) < 40)
		snprintf(buf, size, "%llu GiB", bytes >> 30);
	else if (ffsl(bytes) < 50)
		snprintf(buf, size, "%llu TiB", bytes >> 40);
	else if (ffsl(bytes) < 60)
		snprintf(buf, size, "%llu PiB", bytes >> 50);
	else
		snprintf(buf, size, "%llu EiB", bytes >> 60);
	return buf;
}

Compiled as a user program with gcc -O2, the original results
in mov and testq instructions:
        movq    %rdi, %rbx
        je      .L2
        testl   $1023, %edx
        jne     .L2
        testl   $1048575, %edx
        jne     .L15
        testl   $1073741823, %edx
        jne     .L16
        movabsq $1099511627775, %rax
        testq   %rax, %rdx
        jne     .L17
        movabsq $1125899906842623, %rax
        testq   %rax, %rdx
        jne     .L18
        movabsq $1152921504606846975, %rax
        movq    %rdx, %rcx
        testq   %rax, %rdx
        jne     .L19

while the ffs version uses bit scan forward (bsfq)
and only needs cmpl instructions since the values 
are smaller:
        movq    %rdi, %rbx
        je      .L21
        bsfq    %rdx, %rcx
        addq    $1, %rcx
        cmpl    $9, %ecx
        jle     .L21
        cmpl    $19, %ecx
        jle     .L33
        cmpl    $29, %ecx
        jle     .L34
        cmpl    $39, %ecx
        .p2align 4,,2
        jle     .L35
        cmpl    $49, %ecx
        .p2align 4,,2
        jle     .L36
        cmpl    $59, %ecx
        .p2align 4,,2
        jle     .L37

The kernel offers ffs(int x) but not ffsl(), and it 
uses inline assembly for one of these:
	bsfl 
	bsfl, cmovzl
	bsfl, jnz, movl

I don't know which code is the most efficient.
---
Robert Elliott, HPE Persistent Memory
