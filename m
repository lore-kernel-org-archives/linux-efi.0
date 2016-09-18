From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [tip regression]  efi: Allow drivers to reserve boot services
 forever == toxic
Date: Sun, 18 Sep 2016 08:09:32 +0200
Message-ID: <1474178972.3817.2.camel@gmail.com>
References: <1474005912.3930.10.camel@gmail.com>
         <20160916093149.GC16797@codeblueprint.co.uk>
         <1474020059.3881.3.camel@gmail.com>
         <20160916143007.GF16797@codeblueprint.co.uk>
         <1474043695.3854.3.camel@gmail.com>
         <20160917195853.GG16797@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160917195853.GG16797-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 2016-09-17 at 20:58 +0100, Matt Fleming wrote:

> These addresses are pretty low. Can you try the hacky patch plus
> Ricardo's change in commit 3dad6f7f6975 ("x86/efi: Defer efi_esrt_init
> until after memblock_x86_fill"). He fixed a bug where it's possible to
> run out of memblock regions.

---
 arch/x86/platform/efi/quirks.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -201,8 +201,12 @@ void __init efi_arch_mem_reserve(phys_ad
 		return;
 	}
 
+//XXX	size += addr % EFI_PAGE_SIZE;
+//MATT	size = round_up(size, EFI_PAGE_SIZE);
+//XXX	addr = round_down(addr, EFI_PAGE_SIZE);
+
 	mr.range.start = addr;
-	mr.range.end = addr + size;
+	mr.range.end = addr + size;//MATT - 1;
 	mr.attribute = md.attribute | EFI_MEMORY_RUNTIME;
 
 	num_entries = efi_memmap_split_count(&md, &mr.range);
@@ -225,7 +229,12 @@ void __init efi_arch_mem_reserve(phys_ad
 	efi_memmap_insert(&efi.memmap, new, &mr);
 	early_memunmap(new, new_size);
 
+#if 0
 	efi_memmap_install(new_phys, num_entries);
+#endif
+	printk(KERN_DEBUG "MIKE md.phys_addr:0x%Lx  md.virt_addr:0x%Lx  md.num_pages:%Ld\n", md.phys_addr, md.virt_addr, md.num_pages);
+	printk(KERN_DEBUG "MIKE mr.range.start:0x%Lx  mr.range.end:0x%Lx\n", mr.range.start, mr.range.end);
+	printk(KERN_DEBUG "MIKE efi_memmap_install(0x%Lx, %d);\n", new_phys, num_entries);
 }
 
 /*

tip v4.8-rc6-654-g0d941b5745e4

virgin
[    0.000000] MIKE md.phys_addr:0xded81000  md.virt_addr:0x0  md.num_pages:520
[    0.000000] MIKE mr.range.start:0xdef87998  mr.range.end:0xdef879d0
[    0.000000] MIKE efi_memmap_install(0x9d640, 51);

+MATT changes
[    0.000000] MIKE md.phys_addr:0xded81000  md.virt_addr:0x0  md.num_pages:520
[    0.000000] MIKE mr.range.start:0xdef87998  mr.range.end:0xdef88997
[    0.000000] MIKE efi_memmap_install(0x9d600, 53);

+MATT changes + XXX changes (boots/works without #if 0)
[    0.000000] MIKE md.phys_addr:0xded81000  md.virt_addr:0x0  md.num_pages:520
[    0.000000] MIKE mr.range.start:0xdef87000  mr.range.end:0xdef87fff
[    0.000000] MIKE efi_memmap_install(0x9d640, 51);
