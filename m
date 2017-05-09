From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] x86/boot/32: Fix UP boot on Quark and possibly other platforms
Date: Mon,  8 May 2017 17:09:10 -0700
Message-ID: <d29a8f1882e796b95e9d514c5bb2e9b7dc28792c.1494288438.git.luto@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This partially reverts commit
23b2a4ddebdd17fad265b4bb77256c2e4ec37dee ("x86/boot/32: Defer
resyncing initial_page_table until per-cpu is set up").

That commit had one definite bug and one potential bug.  The
definite bug is that setup_per_cpu_areas() uses a differnet generic
implementation on UP kernels, so initial_page_table never got
resynced.  This was fine for access to percpu data (it's in the
identity map on UP), but it breaks other users of
initial_page_table.  The potential bug is that helpers like
efi_init() would be called before the tables were synced.

Avoid both problems by just syncing the page tables in setup_arch()
*and* setup_per_cpu_areas().

Reported-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---

Jan, can you test this on your Quark system?

 arch/x86/kernel/setup.c        | 15 +++++++++++++++
 arch/x86/kernel/setup_percpu.c | 10 +++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 603a1669a2ec..0b4d3c686b1e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1225,6 +1225,21 @@ void __init setup_arch(char **cmdline_p)
 
 	kasan_init();
 
+#ifdef CONFIG_X86_32
+	/* sync back kernel address range */
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
+
 	tboot_probe();
 
 	map_vsyscall();
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index bb1e8cc0bc84..10edd1e69a68 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -291,11 +291,11 @@ void __init setup_per_cpu_areas(void)
 
 #ifdef CONFIG_X86_32
 	/*
-	 * Sync back kernel address range.  We want to make sure that
-	 * all kernel mappings, including percpu mappings, are available
-	 * in the smpboot asm.  We can't reliably pick up percpu
-	 * mappings using vmalloc_fault(), because exception dispatch
-	 * needs percpu data.
+	 * Sync back kernel address range again.  We already did this in
+	 * setup_arch(), but percpu data also needs to be available in
+	 * the smpboot asm.  We can't reliably pick up percpu mappings
+	 * using vmalloc_fault(), because exception dispatch needs
+	 * percpu data.
 	 */
 	clone_pgd_range(initial_page_table + KERNEL_PGD_BOUNDARY,
 			swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
-- 
2.9.3
