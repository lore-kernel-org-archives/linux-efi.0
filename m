From: Bart Kuivenhoven <bemk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] x86 efi: bugfix interrupt disabling sequence
Date: Wed, 18 Sep 2013 19:28:53 +0200
Message-ID: <1379525333-4373-1-git-send-email-bemk@redhat.com>
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

This patch fixes this by clearing the interrupt bit before the lidt
instruction.

Signed-off-by: Bart Kuivenhoven <bemk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b7388a4..100b812 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1267,11 +1267,11 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 	desc->base2 = 0x00;
 #endif /* CONFIG_X86_64 */
 
+	asm volatile("cli");
+
 	asm volatile ("lidt %0" : : "m" (*idt));
 	asm volatile ("lgdt %0" : : "m" (*gdt));
 
-	asm volatile("cli");
-
 	return boot_params;
 fail:
 	return NULL;
-- 
1.8.4
