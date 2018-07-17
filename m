From: Dmitry Safonov <dima@arista.com>
Subject: [RFC 1/2] x86/compat: Adjust in_compat_syscall() to generic code under !COMPAT
Date: Tue, 17 Jul 2018 01:50:03 +0100
Message-ID: <20180717005004.25984-2-dima@arista.com>
References: <20180717005004.25984-1-dima@arista.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717005004.25984-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <dima@arista.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>, Steffen Klassert <steffen.klassert@secunet.com>, Stephen Boyd <sboyd@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, linux-efi@vger.kernel.org, netdev@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>
List-Id: linux-efi@vger.kernel.org

The result of in_compat_syscall() can be pictured as:

x86 platform:
    ---------------------------------------------------
    |  Arch\syscall  |  64-bit  |   ia32   |   x32    |
    |-------------------------------------------------|
    |     x86_64     |  false   |   true   |   true   |
    |-------------------------------------------------|
    |      i686      |  false   |  <true>  |   false  |
    ---------------------------------------------------

Other platforms:
    ------------------------------------------------
    |  Arch\syscall  |  64-bit  |   compat (32?)   |
    |----------------------------------------------|
    |     64-bit     |  false   |       true       |
    |----------------------------------------------|
    |    32-bit(?)   |  false   |     <false>      |
    ------------------------------------------------

As it seen, the result of in_compat_syscall() on generic 32-bit platform
differs from i686.

There is no reason for in_compat_syscall() == true on native i686.
It also easy to misread code if the result on native 32-bit platform
differs between arches.
Because of that non arch-specific code has many places with:
    if (IS_ENABLED(CONFIG_COMPAT) && in_compat_syscall())
in different variations.

It looks-like the only non-x86 code which uses in_compat_syscall() not
under CONFIG_COMPAT guard is in amd/amdkfd. But according to
the commit a18069c132cb ("amdkfd: Disable support for 32-bit user
processes"), it actually should be disabled on native i686.

Rename in_compat_syscall() to in_32bit_syscall() for x86-specific code
and make in_compat_syscall() false under !CONFIG_COMPAT.

With a following patch I'll clean generic users which were forced
to check IS_ENABLED(CONFIG_COMPAT) with in_compat_syscall().

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/include/asm/compat.h |  9 ++++++++-
 arch/x86/include/asm/ftrace.h |  4 +---
 arch/x86/kernel/process_64.c  |  4 ++--
 arch/x86/kernel/sys_x86_64.c  | 11 ++++++-----
 arch/x86/mm/hugetlbpage.c     |  4 ++--
 arch/x86/mm/mmap.c            |  2 +-
 include/linux/compat.h        |  4 ++--
 7 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index fb97cf7c4137..626bcf1d037d 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -232,11 +232,18 @@ static inline bool in_x32_syscall(void)
 	return false;
 }
 
-static inline bool in_compat_syscall(void)
+static inline bool in_32bit_syscall(void)
 {
 	return in_ia32_syscall() || in_x32_syscall();
 }
+
+#ifdef CONFIG_COMPAT
+static inline bool in_compat_syscall(void)
+{
+	return in_32bit_syscall();
+}
 #define in_compat_syscall in_compat_syscall	/* override the generic impl */
+#endif
 
 struct compat_siginfo;
 int __copy_siginfo_to_user32(struct compat_siginfo __user *to,
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index c18ed65287d5..cf350639e76d 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -76,9 +76,7 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 #define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS 1
 static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
 {
-	if (in_compat_syscall())
-		return true;
-	return false;
+	return in_32bit_syscall();
 }
 #endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_IA32_EMULATION */
 #endif /* !COMPILE_OFFSETS */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 12bb445fb98d..3a6f3cf27808 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -564,10 +564,10 @@ static void __set_personality_x32(void)
 		current->mm->context.ia32_compat = TIF_X32;
 	current->personality &= ~READ_IMPLIES_EXEC;
 	/*
-	 * in_compat_syscall() uses the presence of the x32 syscall bit
+	 * in_32bit_syscall() uses the presence of the x32 syscall bit
 	 * flag to determine compat status.  The x86 mmap() code relies on
 	 * the syscall bitness so set x32 syscall bit right here to make
-	 * in_compat_syscall() work during exec().
+	 * in_32bit_syscall() work during exec().
 	 *
 	 * Pretend to come from a x32 execve.
 	 */
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 6a78d4b36a79..f7476ce23b6e 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -105,7 +105,7 @@ SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 static void find_start_end(unsigned long addr, unsigned long flags,
 		unsigned long *begin, unsigned long *end)
 {
-	if (!in_compat_syscall() && (flags & MAP_32BIT)) {
+	if (!in_32bit_syscall() && (flags & MAP_32BIT)) {
 		/* This is usually used needed to map code in small
 		   model, so it needs to be in the first 31bit. Limit
 		   it to that.  This means we need to move the
@@ -122,7 +122,7 @@ static void find_start_end(unsigned long addr, unsigned long flags,
 	}
 
 	*begin	= get_mmap_base(1);
-	if (in_compat_syscall())
+	if (in_32bit_syscall())
 		*end = task_size_32bit();
 	else
 		*end = task_size_64bit(addr > DEFAULT_MAP_WINDOW);
@@ -193,7 +193,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 		return addr;
 
 	/* for MAP_32BIT mappings we force the legacy mmap base */
-	if (!in_compat_syscall() && (flags & MAP_32BIT))
+	if (!in_32bit_syscall() && (flags & MAP_32BIT))
 		goto bottomup;
 
 	/* requesting a specific address */
@@ -217,9 +217,10 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	 * If hint address is above DEFAULT_MAP_WINDOW, look for unmapped area
 	 * in the full address space.
 	 *
-	 * !in_compat_syscall() check to avoid high addresses for x32.
+	 * !in_32bit_syscall() check to avoid high addresses for x32
+	 * (and make it no op on native i386).
 	 */
-	if (addr > DEFAULT_MAP_WINDOW && !in_compat_syscall())
+	if (addr > DEFAULT_MAP_WINDOW && !in_32bit_syscall())
 		info.high_limit += TASK_SIZE_MAX - DEFAULT_MAP_WINDOW;
 
 	info.align_mask = 0;
diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 00b296617ca4..92e4c4b85bba 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -92,7 +92,7 @@ static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
 	 * If hint address is above DEFAULT_MAP_WINDOW, look for unmapped area
 	 * in the full address space.
 	 */
-	info.high_limit = in_compat_syscall() ?
+	info.high_limit = in_32bit_syscall() ?
 		task_size_32bit() : task_size_64bit(addr > DEFAULT_MAP_WINDOW);
 
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
@@ -116,7 +116,7 @@ static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
 	 * If hint address is above DEFAULT_MAP_WINDOW, look for unmapped area
 	 * in the full address space.
 	 */
-	if (addr > DEFAULT_MAP_WINDOW && !in_compat_syscall())
+	if (addr > DEFAULT_MAP_WINDOW && !in_32bit_syscall())
 		info.high_limit += TASK_SIZE_MAX - DEFAULT_MAP_WINDOW;
 
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 48c591251600..36334ce78be8 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -166,7 +166,7 @@ unsigned long get_mmap_base(int is_legacy)
 	struct mm_struct *mm = current->mm;
 
 #ifdef CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES
-	if (in_compat_syscall()) {
+	if (in_32bit_syscall()) {
 		return is_legacy ? mm->mmap_compat_legacy_base
 				 : mm->mmap_compat_base;
 	}
diff --git a/include/linux/compat.h b/include/linux/compat.h
index c68acc47da57..4dd4b00407ab 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -1031,9 +1031,9 @@ static inline struct compat_timeval ns_to_compat_timeval(s64 nsec)
 #else /* !CONFIG_COMPAT */
 
 #define is_compat_task() (0)
-#ifndef in_compat_syscall
+/* Ensure no one redefines in_compat_syscall() under !CONFIG_COMPAT */
+#define in_compat_syscall in_compat_syscall
 static inline bool in_compat_syscall(void) { return false; }
-#endif
 
 #endif /* CONFIG_COMPAT */
 
-- 
2.13.6
