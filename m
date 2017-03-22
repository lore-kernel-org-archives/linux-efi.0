From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/7] x86/boot/32: Defer resyncing initial_page_table until percpu is set up
Date: Wed, 22 Mar 2017 14:32:32 -0700
Message-ID: <a553264a5972c6a86f9b5caac237470a0c74a720.1490218061.git.luto@kernel.org>
References: <cover.1490218061.git.luto@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1490218061.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <cover.1490218061.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
References: <cover.1490218061.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The x86 smpboot trampoline expects initial_page_table to have the
GDT mapped.  If the GDT ends up in a virtually mapped percpu page,
then it won't be in the page tables at all until percpu areas are
set up.  The result will be a triple fault the first time that the
CPU attempts to access the GDT after LGDT loads the percpu GDT.

This appears to be an old bug, but somehow the GDT fixmap rework
is triggering it.  This seems to have something to do with the
memory layout.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 arch/x86/kernel/setup.c        | 15 ---------------
 arch/x86/kernel/setup_percpu.c | 21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4bf0c8926a1c..56b1177155db 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1226,21 +1226,6 @@ void __init setup_arch(char **cmdline_p)
 
 	kasan_init();
 
-#ifdef CONFIG_X86_32
-	/* sync back kernel address range */
-	clone_pgd_range(initial_page_table + KERNEL_PGD_BOUNDARY,
-			swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
-			KERNEL_PGD_PTRS);
-
-	/*
-	 * sync back low identity map too.  It is used for example
-	 * in the 32-bit EFI stub.
-	 */
-	clone_pgd_range(initial_page_table,
-			swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
-			min(KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
-#endif
-
 	tboot_probe();
 
 	map_vsyscall();
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 11338b0b3ad2..bb1e8cc0bc84 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -288,4 +288,25 @@ void __init setup_per_cpu_areas(void)
 
 	/* Setup cpu initialized, callin, callout masks */
 	setup_cpu_local_masks();
+
+#ifdef CONFIG_X86_32
+	/*
+	 * Sync back kernel address range.  We want to make sure that
+	 * all kernel mappings, including percpu mappings, are available
+	 * in the smpboot asm.  We can't reliably pick up percpu
+	 * mappings using vmalloc_fault(), because exception dispatch
+	 * needs percpu data.
+	 */
+	clone_pgd_range(initial_page_table + KERNEL_PGD_BOUNDARY,
+			swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
+			KERNEL_PGD_PTRS);
+
+	/*
+	 * sync back low identity map too.  It is used for example
+	 * in the 32-bit EFI stub.
+	 */
+	clone_pgd_range(initial_page_table,
+			swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
+			min(KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
+#endif
 }
-- 
2.9.3
