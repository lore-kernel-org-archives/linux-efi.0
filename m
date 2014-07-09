From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: Linux kernel EFI stub bug?
Date: Wed, 09 Jul 2014 08:37:19 -0700
Message-ID: <53BD61AF.4090307@zytor.com>
References: <53BD6040.2040006@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BD6040.2040006-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 07/09/2014 08:31 AM, Michael Brown wrote:
> I think I've found a bug in the kernel's EFI boot stub.  Specifically,
> in arch/x86/boot/compressed/eboot.c, in make_boot_params():
> 
>    sys_table = (efi_system_table_t *)(unsigned long)efi_early->table;
> 
> This compiles and links (on my system) to
> 
>    mov    %rdi,0xe658(%rip)        # 0x3d16f0
> 
> The problem is that address 0x3d16f0 is beyond the end of the loaded
> kernel image:
> 
>    objdump -x shows:
> 
>     Sections:
>     Idx Name   Size      VMA               LMA               File off  Algn
>     0 .setup   000041e0  0000000000000200  0000000000000200  00000200  2**4
>                CONTENTS, ALLOC, LOAD, READONLY, CODE
>     1 .reloc   00000020  00000000000043e0  00000000000043e0  000043e0  2**0
>                CONTENTS, ALLOC, LOAD, READONLY, DATA
>     2 .text    003c0e90  0000000000004400  0000000000004400  00004400  2**4
>                CONTENTS, ALLOC, LOAD, READONLY, CODE
> 
> giving an image end address of 0x4400+0x3c0e90=0x3c5290 (which matches
> the size of the bzImage file).
> 
> The upshot is that the kernel writes beyond the end of allocated memory,
> producing undefined behaviour.  (In my test case, it ends up corrupting
> the initramfs image, resulting in an unbootable kernel.)
> 
> The same problem seems to exist in efi_main():
> 
>    sys_table = _table;
> 
>    mov    %rdi,0xe1bb(%rip)        # 0x3d16f0
> 
> As far as I can tell, the underlying problem is that .bss variables in
> eboot.o end up with addresses beyond the end of the loaded kernel.
> 

I would think we need to have an unallocated section -- as is typical
for a .bss section -- so the image loader knows how much memory we are
going to use.  This could be complicated, as we export a whole lot of
memory management information in the bzImage format, but I'm not sure if
we can easily convey the same in PE/COFF.  Does anyone know if very
large aligments (2^21 bytes) is handled by existing pecoff loaders?

	-hpa
