From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: Linux kernel EFI stub bug?
Date: Wed, 09 Jul 2014 08:49:21 -0700
Message-ID: <53BD6481.4050208@zytor.com>
References: <53BD6040.2040006@fensystems.co.uk> <53BD61AF.4090307@zytor.com> <53BD634B.9000709@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BD634B.9000709-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 07/09/2014 08:44 AM, Michael Brown wrote:
> 
> It is possible to create a .bss section in the PE/COFF header: iPXE does
> this.  For example:
> 
>   objdump -x bin-x86_64-efi/ipxe.efi
> 
>    Sections:
>    Idx Name   Size      VMA               LMA               File off  Algn
>    0 .text    00081948  0000000000001000  0000000000001000  000002c0  2**4
>               CONTENTS, ALLOC, LOAD, READONLY, CODE
>    1 .rodata  0002bf5e  0000000000082960  0000000000082960  00081c20  2**2
>               CONTENTS, ALLOC, LOAD, DATA
>    2 .data    0001fdf0  00000000000ae8c0  00000000000ae8c0  000adb80  2**4
>               CONTENTS, ALLOC, LOAD, DATA
>    3 .bss     000a27ac  00000000000ce700  00000000000ce700  00000000  2**4
>               ALLOC
>    4 .reloc   00001388  0000000000170ec0  0000000000170ec0  000cd980  2**2
>               CONTENTS, ALLOC, LOAD, READONLY, DATA
>    5 .debug   00000040  0000000000172260  0000000000172260  000ced20  2**0
>               CONTENTS, READONLY, DEBUGGING
> 
> If the bootloader is using the EFI handover protocol (rather than
> calling the PE entry point), how is it (currently) supposed to know how
> much memory to provide beyond the end of the bzImage file?
> 

Since that means you are "bzImage aware" you can look at the fields for
this in the bzImage header: init_size, kernel_alignment,
relocatable_kernel, min_alignment, and pref_address.

(init_size is the important one, obviously, but a misaligned kernel may
require additional space for adjustment.)

	-hpa
