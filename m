From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH] x86/efi: Setup separate EFI page tables in kexec paths
Date: Thu, 21 Jan 2016 14:11:59 +0000
Message-ID: <1453385519-11477-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Srikar Dronamraju <srikar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The switch to using a new dedicated page table for EFI runtime calls
in commit commit 67a9108ed431 ("x86/efi: Build our own page table
structures") failed to take into account changes required for the
kexec code paths, which are unfortunately duplicated in the EFI code.

Call the allocation and setup functions in kexec_enter_virtual_mode()
just like we do for __efi_enter_virtual_mode() to avoid hitting
NULL-pointer dereferences when making EFI runtime calls.

At the very least, the call to efi_setup_page_tables() should have
existed for kexec before commit 67a9108ed431. Things just magically
worked because we were actually using the kernel's page tables that
contained the required mappings.

Reported-by: Srikar Dronamraju <srikar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

Folks, please apply this to the queue of EFI patches sitting in
tip/x86/efi.

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3c1f3cd7b2ba..2aedee71f965 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -815,6 +815,7 @@ static void __init kexec_enter_virtual_mode(void)
 {
 #ifdef CONFIG_KEXEC_CORE
 	efi_memory_desc_t *md;
+	unsigned num_pages;
 	void *p;
 
 	efi.systab = NULL;
@@ -829,6 +830,12 @@ static void __init kexec_enter_virtual_mode(void)
 		return;
 	}
 
+	if (efi_alloc_page_tables()) {
+		pr_err("Failed to allocate EFI page tables\n");
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+		return;
+	}
+
 	/*
 	* Map efi regions which were passed via setup_data. The virt_addr is a
 	* fixed addr which was used in first kernel of a kexec boot.
@@ -843,6 +850,14 @@ static void __init kexec_enter_virtual_mode(void)
 
 	BUG_ON(!efi.systab);
 
+	num_pages = ALIGN(memmap.nr_map * memmap.desc_size, PAGE_SIZE);
+	num_pages >>= PAGE_SHIFT;
+
+	if (efi_setup_page_tables(memmap.phys_map, num_pages)) {
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+		return;
+	}
+
 	efi_sync_low_kernel_mappings();
 
 	/*
-- 
2.6.2
