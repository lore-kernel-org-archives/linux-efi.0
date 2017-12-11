From: Pravin Shedge <pravin.shedge4linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 41/45] arch/x86: remove duplicate includes
Date: Tue, 12 Dec 2017 02:12:31 +0530
Message-ID: <1513024951-9221-1-git-send-email-pravin.shedge4linux@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, jgross-IBi9RG/b67k@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: pravin.shedge4linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

These duplicate includes have been found with scripts/checkincludes.pl but
they have been removed manually to avoid removing false positives.

Signed-off-by: Pravin Shedge <pravin.shedge4linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 arch/x86/kernel/itmt.c         | 1 -
 arch/x86/kernel/process.c      | 1 -
 arch/x86/kernel/setup.c        | 1 -
 arch/x86/kernel/smpboot.c      | 1 -
 arch/x86/platform/efi/efi_64.c | 1 -
 arch/x86/xen/spinlock.c        | 2 --
 6 files changed, 7 deletions(-)

diff --git a/arch/x86/kernel/itmt.c b/arch/x86/kernel/itmt.c
index f73f475..d177940 100644
--- a/arch/x86/kernel/itmt.c
+++ b/arch/x86/kernel/itmt.c
@@ -24,7 +24,6 @@
 #include <linux/cpumask.h>
 #include <linux/cpuset.h>
 #include <linux/mutex.h>
-#include <linux/sched.h>
 #include <linux/sysctl.h>
 #include <linux/nodemask.h>
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 97fb3e5..9824553 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -21,7 +21,6 @@
 #include <linux/dmi.h>
 #include <linux/utsname.h>
 #include <linux/stackprotector.h>
-#include <linux/tick.h>
 #include <linux/cpuidle.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 8af2e8d..c8e0447 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -114,7 +114,6 @@
 #include <asm/alternative.h>
 #include <asm/prom.h>
 #include <asm/microcode.h>
-#include <asm/mmu_context.h>
 #include <asm/kaslr.h>
 #include <asm/unwind.h>
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3d01df7..8dd0f51 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -75,7 +75,6 @@
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
 #include <asm/i8259.h>
-#include <asm/realmode.h>
 #include <asm/misc.h>
 #include <asm/qspinlock.h>
 
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 6a151ce..1e5184d 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -25,7 +25,6 @@
 #include <linux/spinlock.h>
 #include <linux/bootmem.h>
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/mc146818rtc.h>
 #include <linux/efi.h>
 #include <linux/uaccess.h>
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 02f3445..cd97a62 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -23,8 +23,6 @@ static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
 static DEFINE_PER_CPU(char *, irq_name);
 static bool xen_pvspin = true;
 
-#include <asm/qspinlock.h>
-
 static void xen_qlock_kick(int cpu)
 {
 	int irq = per_cpu(lock_kicker_irq, cpu);
-- 
2.7.4
