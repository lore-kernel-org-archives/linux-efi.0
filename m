From: Sasha Levin <Alexander.Levin@microsoft.com>
Subject: [PATCH AUTOSEL for 4.9 054/219] x86/boot/32: Defer resyncing
 initial_page_table until per-cpu is set up
Date: Sat, 3 Mar 2018 22:28:27 +0000
Message-ID: <20180303222716.26640-54-alexander.levin@microsoft.com>
References: <20180303222716.26640-1-alexander.levin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180303222716.26640-1-alexander.levin@microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, Denys Vlasenko <dvlasenk@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Zijlstra <peterz@infradead.org>, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Sasha Levin <Alexander.Levin@microsoft.com>
List-Id: linux-efi@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

[ Upstream commit 23b2a4ddebdd17fad265b4bb77256c2e4ec37dee ]

The x86 smpboot trampoline expects initial_page_table to have the
GDT mapped.  If the GDT ends up in a virtually mapped per-cpu page,
then it won't be in the page tables at all until perc-pu areas are
set up.  The result will be a triple fault the first time that the
CPU attempts to access the GDT after LGDT loads the perc-pu GDT.

This appears to be an old bug, but somehow the GDT fixmap rework
is triggering it.  This seems to have something to do with the
memory layout.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/a553264a5972c6a86f9b5caac237470a0c74a720.149=
0218061.git.luto@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 arch/x86/kernel/setup.c        | 15 ---------------
 arch/x86/kernel/setup_percpu.c | 21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 6b55012d02a3..d1a214287fe3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1200,21 +1200,6 @@ void __init setup_arch(char **cmdline_p)
=20
 	kasan_init();
=20
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
=20
 	map_vsyscall();
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.=
c
index 2bbd27f89802..bbba27269fdd 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -287,4 +287,25 @@ void __init setup_per_cpu_areas(void)
=20
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
--=20
2.14.1
