From: Bart Kuivenhoven <bemk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] x86 efi: bugfix interrupt disabling sequence
Date: Mon, 23 Sep 2013 11:45:28 +0200
Message-ID: <1379929528-7534-1-git-send-email-bemk@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Bart Kuivenhoven <bemk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The problem in efi_main was that the idt was cleared before the
interrupts were disabled.

The UEFI spec states that interrupts aren't used so this shouldn't be
too much of a problem. Peripherals however don't necessarily know about
this and thus might cause interrupts to happen anyway. Even if
ExitBootServices() has been called.

This means there is a risk of an interrupt being triggered while the IDT
register is nullified and the interrupt bit hasn't been cleared,
allowing for a triple fault.

This patch disables the interrupt flag, while leaving the existing IDT
in place. The CPU won't care about the IDT at all as long as the
interrupt bit is off, so it's safe to leave it in place as nothing will
ever happen to it.

Signed-off-by: Bart Kuivenhoven <bemk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b7388a4..689b1ba 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1188,17 +1188,6 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 		goto fail;
 	}
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, sizeof(*idt),
-				(void **)&idt);
-	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc mem for idt structure\n");
-		goto fail;
-	}
-
-	idt->size = 0;
-	idt->address = 0;
-
 	/*
 	 * If the kernel isn't already loaded at the preferred load
 	 * address, relocate it.
@@ -1267,10 +1256,8 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 	desc->base2 = 0x00;
 #endif /* CONFIG_X86_64 */
 
-	asm volatile ("lidt %0" : : "m" (*idt));
-	asm volatile ("lgdt %0" : : "m" (*gdt));
-
 	asm volatile("cli");
+	asm volatile ("lgdt %0" : : "m" (*gdt));
 
 	return boot_params;
 fail:
-- 
1.8.4
