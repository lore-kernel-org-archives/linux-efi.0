From: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Subject: Re: Linux kernel EFI stub bug?
Date: Wed, 09 Jul 2014 16:44:11 +0100
Message-ID: <53BD634B.9000709@fensystems.co.uk>
References: <53BD6040.2040006@fensystems.co.uk> <53BD61AF.4090307@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BD61AF.4090307-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 09/07/14 16:37, H. Peter Anvin wrote:
>> As far as I can tell, the underlying problem is that .bss variables in
>> eboot.o end up with addresses beyond the end of the loaded kernel.
>
> I would think we need to have an unallocated section -- as is typical
> for a .bss section -- so the image loader knows how much memory we are
> going to use.  This could be complicated, as we export a whole lot of
> memory management information in the bzImage format, but I'm not sure if
> we can easily convey the same in PE/COFF.  Does anyone know if very
> large aligments (2^21 bytes) is handled by existing pecoff loaders?

It is possible to create a .bss section in the PE/COFF header: iPXE does 
this.  For example:

   objdump -x bin-x86_64-efi/ipxe.efi

    Sections:
    Idx Name   Size      VMA               LMA               File off  Algn
    0 .text    00081948  0000000000001000  0000000000001000  000002c0  2**4
               CONTENTS, ALLOC, LOAD, READONLY, CODE
    1 .rodata  0002bf5e  0000000000082960  0000000000082960  00081c20  2**2
               CONTENTS, ALLOC, LOAD, DATA
    2 .data    0001fdf0  00000000000ae8c0  00000000000ae8c0  000adb80  2**4
               CONTENTS, ALLOC, LOAD, DATA
    3 .bss     000a27ac  00000000000ce700  00000000000ce700  00000000  2**4
               ALLOC
    4 .reloc   00001388  0000000000170ec0  0000000000170ec0  000cd980  2**2
               CONTENTS, ALLOC, LOAD, READONLY, DATA
    5 .debug   00000040  0000000000172260  0000000000172260  000ced20  2**0
               CONTENTS, READONLY, DEBUGGING

If the bootloader is using the EFI handover protocol (rather than 
calling the PE entry point), how is it (currently) supposed to know how 
much memory to provide beyond the end of the bzImage file?

Michael
