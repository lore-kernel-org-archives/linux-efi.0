From: Yi Wang <wang.yi59@zte.com.cn>
Subject: [PATCH] x86: fix -Wmissing-prototypes warning
Date: Thu, 22 Nov 2018 10:04:09 +0800
Message-ID: <1542852249-19820-1-git-send-email-wang.yi59@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <jailhouse-dev+bncBAABBTM43DPQKGQEFMLX7LY@googlegroups.com>
Sender: jailhouse-dev@googlegroups.com
List-Post: <https://groups.google.com/group/jailhouse-dev/post>, <mailto:jailhouse-dev@googlegroups.com>
List-Help: <https://groups.google.com/support/>, <mailto:jailhouse-dev+help@googlegroups.com>
List-Archive: <https://groups.google.com/group/jailhouse-dev
List-Subscribe: <https://groups.google.com/group/jailhouse-dev/subscribe>, <mailto:jailhouse-dev+subscribe@googlegroups.com>
List-Unsubscribe: <mailto:googlegroups-manage+175645748590+unsubscribe@googlegroups.com>,
 <https://groups.google.com/group/jailhouse-dev/subscribe>
To: tglx@linutronix.de
Cc: mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, wang.yi59@zte.com.cn, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org, jgross@suse.com, akataria@vmware.com, virtualization@lists.linux-foundation.org, m.mizuma@jp.fujitsu.com, peterz@infradead.org, prarit@redhat.com, douly.fnst@cn.fujitsu.com, dwmw@amazon.co.uk, luto@kernel.org, pasha.tatashin@oracle.com, rajvi.jingar@intel.com, zhe.he@windriver.com, akpm@linux-foundation.org, dyoung@redhat.com, takahiro.akashi@linaro.org, ebiederm@xmission.com, bhe@redhat.com, ivan.gorinov@intel.com, robh@kernel.org, andy.shevchenko@gmail.com, frank.rowand@sony.com, jan.kiszka@siemens.com, jailhouse-dev@googlegroups.com, konrad.wilk@oracle
List-Id: linux-efi@vger.kernel.org

We may get -Wmissing-prototypes warnings when building
kernel with W=3D1, it's better to fix them as global function
signature can be changed and caller who use the old unchanged
prototypes will be hosed.

This patch fixes most of -Wmissing-prototypes warnings which
are in the root directory of arch/x86/kernel, not including
the subdirectories.

These are the warnings fixed in this patch:
arch/x86/kernel/signal.c:865:17: warning: no previous prototype for =E2=80=
=98sys32_x32_rt_sigreturn=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/signal_compat.c:164:6: warning: no previous prototype for =
=E2=80=98sigaction_compat_abi=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/traps.c:625:46: warning: no previous prototype for =E2=80=
=98sync_regs=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/traps.c:640:24: warning: no previous prototype for =E2=80=
=98fixup_bad_iret=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/traps.c:929:13: warning: no previous prototype for =E2=80=
=98trap_init=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/irq.c:270:28: warning: no previous prototype for =E2=80=98s=
mp_x86_platform_ipi=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/irq.c:301:16: warning: no previous prototype for =E2=80=98s=
mp_kvm_posted_intr_ipi=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/irq.c:314:16: warning: no previous prototype for =E2=80=98s=
mp_kvm_posted_intr_wakeup_ipi=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/irq.c:328:16: warning: no previous prototype for =E2=80=98s=
mp_kvm_posted_intr_nested_ipi=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/irq_work.c:16:28: warning: no previous prototype for =E2=80=
=98smp_irq_work_interrupt=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/irqinit.c:79:13: warning: no previous prototype for =E2=80=
=98init_IRQ=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/quirks.c:672:13: warning: no previous prototype for =E2=80=
=98early_platform_quirks=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/tsc.c:1499:15: warning: no previous prototype for =E2=80=98=
calibrate_delay_is_known=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/process.c:653:13: warning: no previous prototype for =E2=80=
=98arch_post_acpi_subsys_init=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/process.c:717:15: warning: no previous prototype for =E2=80=
=98arch_randomize_brk=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/process.c:784:6: warning: no previous prototype for =E2=80=
=98do_arch_prctl_common=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/reboot.c:869:6: warning: no previous prototype for =E2=80=
=98nmi_panic_self_stop=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/smp.c:176:27: warning: no previous prototype for =E2=80=98s=
mp_reboot_interrupt=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/smp.c:260:28: warning: no previous prototype for =E2=80=98s=
mp_reschedule_interrupt=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/smp.c:281:28: warning: no previous prototype for =E2=80=98s=
mp_call_function_interrupt=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/smp.c:291:28: warning: no previous prototype for =E2=80=98s=
mp_call_function_single_interrupt=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/ftrace.c:840:6: warning: no previous prototype for =E2=80=
=98arch_ftrace_update_trampoline=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/ftrace.c:934:7: warning: no previous prototype for =E2=80=
=98arch_ftrace_trampoline_func=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/ftrace.c:946:6: warning: no previous prototype for =E2=80=
=98arch_ftrace_trampoline_free=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/crash.c:114:6: warning: no previous prototype for =E2=80=98=
crash_smp_send_stop=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/crash.c:351:5: warning: no previous prototype for =E2=80=98=
crash_setup_memmap_entries=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/crash.c:424:5: warning: no previous prototype for =E2=80=98=
crash_load_segments=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/machine_kexec_64.c:372:7: warning: no previous prototype fo=
r =E2=80=98arch_kexec_kernel_image_load=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/paravirt-spinlocks.c:12:16: warning: no previous prototype =
for =E2=80=98__native_queued_spin_unlock=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/paravirt-spinlocks.c:18:6: warning: no previous prototype f=
or =E2=80=98pv_is_native_spin_unlock=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/paravirt-spinlocks.c:24:16: warning: no previous prototype =
for =E2=80=98__native_vcpu_is_preempted=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/paravirt-spinlocks.c:30:6: warning: no previous prototype f=
or =E2=80=98pv_is_native_vcpu_is_preempted=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/kvm.c:258:1: warning: no previous prototype for =E2=80=98do=
_async_page_fault=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/jailhouse.c:200:6: warning: no previous prototype for =E2=
=80=98jailhouse_paravirt=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/check.c:91:13: warning: no previous prototype for =E2=80=98=
setup_bios_corruption_check=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/check.c:139:6: warning: no previous prototype for =E2=80=98=
check_for_bios_corruption=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/devicetree.c:32:13: warning: no previous prototype for =E2=
=80=98early_init_dt_scan_chosen_arch=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/devicetree.c:42:13: warning: no previous prototype for =E2=
=80=98add_dtb=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/devicetree.c:108:6: warning: no previous prototype for =E2=
=80=98x86_of_pci_init=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/devicetree.c:314:13: warning: no previous prototype for =E2=
=80=98x86_dtb_init=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/tracepoint.c:16:5: warning: no previous prototype for =E2=
=80=98trace_pagefault_reg=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/tracepoint.c:22:6: warning: no previous prototype for =E2=
=80=98trace_pagefault_unreg=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/head64.c:113:22: warning: no previous prototype for =E2=80=
=98__startup_64=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/head64.c:262:15: warning: no previous prototype for =E2=80=
=98__startup_secondary_64=E2=80=99 [-Wmissing-prototypes]
arch/x86/kernel/head64.c:350:12: warning: no previous prototype for =E2=80=
=98early_make_pgtable=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 arch/x86/include/asm/crash.h       | 1 +
 arch/x86/include/asm/efi.h         | 2 --
 arch/x86/include/asm/irq.h         | 7 +++++++
 arch/x86/include/asm/irq_work.h    | 1 +
 arch/x86/include/asm/kvm_para.h    | 1 +
 arch/x86/include/asm/paravirt.h    | 5 +++++
 arch/x86/include/asm/reboot.h      | 1 +
 arch/x86/include/asm/setup.h       | 5 +++++
 arch/x86/include/asm/sighandling.h | 5 +++++
 arch/x86/include/asm/smp.h         | 6 ++++++
 arch/x86/include/asm/traps.h       | 4 ++++
 arch/x86/include/asm/tsc.h         | 1 +
 arch/x86/kernel/check.c            | 3 ++-
 arch/x86/kernel/crash.c            | 1 +
 arch/x86/kernel/devicetree.c       | 1 +
 arch/x86/kernel/jailhouse.c        | 1 +
 arch/x86/kernel/process.c          | 3 +++
 arch/x86/kernel/quirks.c           | 1 +
 arch/x86/kernel/tracepoint.c       | 1 +
 include/linux/efi.h                | 2 ++
 include/linux/ftrace.h             | 3 +++
 include/linux/kexec.h              | 1 +
 include/linux/of_fdt.h             | 1 +
 include/linux/ptrace.h             | 1 +
 24 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/crash.h b/arch/x86/include/asm/crash.h
index a7adb2bfb..0acf5ee 100644
--- a/arch/x86/include/asm/crash.h
+++ b/arch/x86/include/asm/crash.h
@@ -6,5 +6,6 @@
 int crash_copy_backup_region(struct kimage *image);
 int crash_setup_memmap_entries(struct kimage *image,
 		struct boot_params *params);
+void crash_smp_send_stop(void);
=20
 #endif /* _ASM_X86_CRASH_H */
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index eea40d5..063f1d4 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -173,8 +173,6 @@ static inline bool efi_runtime_supported(void)
 extern struct console early_efi_console;
 extern void parse_efi_setup(u64 phys_addr, u32 data_len);
=20
-extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
-
 #ifdef CONFIG_EFI_MIXED
 extern void efi_thunk_runtime_setup(void);
 extern efi_status_t efi_thunk_set_virtual_address_map(
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 2395bb7..fbb16e6 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -30,6 +30,9 @@ static inline int irq_canonicalize(int irq)
=20
 #ifdef CONFIG_HAVE_KVM
 extern void kvm_set_posted_intr_wakeup_handler(void (*handler)(void));
+extern __visible void smp_kvm_posted_intr_ipi(struct pt_regs *regs);
+extern __visible void smp_kvm_posted_intr_wakeup_ipi(struct pt_regs *regs)=
;
+extern __visible void smp_kvm_posted_intr_nested_ipi(struct pt_regs *regs)=
;
 #endif
=20
 extern void (*x86_platform_ipi_callback)(void);
@@ -41,9 +44,13 @@ static inline int irq_canonicalize(int irq)
=20
 extern void init_ISA_irqs(void);
=20
+extern void __init init_IRQ(void);
+
 #ifdef CONFIG_X86_LOCAL_APIC
 void arch_trigger_cpumask_backtrace(const struct cpumask *mask,
 				    bool exclude_self);
+
+extern __visible void smp_x86_platform_ipi(struct pt_regs *regs);
 #define arch_trigger_cpumask_backtrace arch_trigger_cpumask_backtrace
 #endif
=20
diff --git a/arch/x86/include/asm/irq_work.h b/arch/x86/include/asm/irq_wor=
k.h
index 800ffce..80b35e3 100644
--- a/arch/x86/include/asm/irq_work.h
+++ b/arch/x86/include/asm/irq_work.h
@@ -10,6 +10,7 @@ static inline bool arch_irq_work_has_interrupt(void)
 	return boot_cpu_has(X86_FEATURE_APIC);
 }
 extern void arch_irq_work_raise(void);
+extern __visible void smp_irq_work_interrupt(struct pt_regs *regs);
 #else
 static inline bool arch_irq_work_has_interrupt(void)
 {
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_par=
a.h
index 4c72363..5ed3cf1 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -92,6 +92,7 @@ static inline long kvm_hypercall4(unsigned int nr, unsign=
ed long p1,
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
 extern void kvm_disable_steal_time(void);
+void do_async_page_fault(struct pt_regs *regs, unsigned long error_code);
=20
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 void __init kvm_spinlock_init(void);
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravir=
t.h
index 4bf42f9..a97f28d 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -26,6 +26,11 @@ static inline unsigned long long paravirt_sched_clock(vo=
id)
 extern struct static_key paravirt_steal_enabled;
 extern struct static_key paravirt_steal_rq_enabled;
=20
+__visible void __native_queued_spin_unlock(struct qspinlock *lock);
+bool pv_is_native_spin_unlock(void);
+__visible bool __native_vcpu_is_preempted(long cpu);
+bool pv_is_native_vcpu_is_preempted(void);
+
 static inline u64 paravirt_steal_clock(int cpu)
 {
 	return PVOP_CALL1(u64, time.steal_clock, cpu);
diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index a671a11..04c17be 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -26,6 +26,7 @@ struct machine_ops {
 #define MRR_APM		1
=20
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
+void nmi_panic_self_stop(struct pt_regs *regs);
 void nmi_shootdown_cpus(nmi_shootdown_cb callback);
 void run_crash_ipi_callback(struct pt_regs *regs);
=20
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index ae13bc9..d85f5fa 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -26,6 +26,11 @@
 #define OLD_CL_ADDRESS		0x020	/* Relative to real mode data */
 #define NEW_CL_POINTER		0x228	/* Relative to real mode data */
=20
+
+unsigned long __startup_64(unsigned long physaddr, struct boot_params *bp)=
;
+unsigned long __startup_secondary_64(void);
+int __init early_make_pgtable(unsigned long address);
+
 #ifndef __ASSEMBLY__
 #include <asm/bootparam.h>
 #include <asm/x86_init.h>
diff --git a/arch/x86/include/asm/sighandling.h b/arch/x86/include/asm/sigh=
andling.h
index bd26834..2fcbd6f 100644
--- a/arch/x86/include/asm/sighandling.h
+++ b/arch/x86/include/asm/sighandling.h
@@ -17,4 +17,9 @@
 int setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 		     struct pt_regs *regs, unsigned long mask);
=20
+
+#ifdef CONFIG_X86_X32_ABI
+asmlinkage long sys32_x32_rt_sigreturn(void);
+#endif
+
 #endif /* _ASM_X86_SIGHANDLING_H */
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 547c4fe..2e95b6c 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -148,6 +148,12 @@ static inline void arch_send_call_function_ipi_mask(co=
nst struct cpumask *mask)
=20
 void smp_store_boot_cpu_info(void);
 void smp_store_cpu_info(int id);
+
+asmlinkage __visible void smp_reboot_interrupt(void);
+__visible void smp_reschedule_interrupt(struct pt_regs *regs);
+__visible void smp_call_function_interrupt(struct pt_regs *regs);
+__visible void smp_call_function_single_interrupt(struct pt_regs *r);
+
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
 #define cpu_acpi_id(cpu)	per_cpu(x86_cpu_to_acpiid, cpu)
=20
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 7a4db72..c950d3d 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -75,6 +75,10 @@
 dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)=
;
 #ifdef CONFIG_X86_64
 dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code);
+asmlinkage __visible notrace struct pt_regs *sync_regs(struct pt_regs *ere=
gs);
+asmlinkage __visible notrace
+struct bad_iret_stack *fixup_bad_iret(struct bad_iret_stack *s);
+void __init trap_init(void);
 #endif
 dotraplinkage void do_general_protection(struct pt_regs *regs, long error_=
code);
 dotraplinkage void do_page_fault(struct pt_regs *regs, unsigned long error=
_code);
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index eb5bbfe..8a0c25c 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -35,6 +35,7 @@ static inline cycles_t get_cycles(void)
=20
 extern void tsc_early_init(void);
 extern void tsc_init(void);
+extern unsigned long calibrate_delay_is_known(void);
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
 extern int check_tsc_unstable(void);
diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index 1979a76..5136e68 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -9,6 +9,7 @@
 #include <linux/memblock.h>
=20
 #include <asm/proto.h>
+#include <asm/setup.h>
=20
 /*
  * Some BIOSes seem to corrupt the low 64k of memory during events
@@ -136,7 +137,7 @@ void __init setup_bios_corruption_check(void)
 }
=20
=20
-void check_for_bios_corruption(void)
+static void check_for_bios_corruption(void)
 {
 	int i;
 	int corruption =3D 0;
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index f631a3f..c8b07d8 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -37,6 +37,7 @@
 #include <asm/reboot.h>
 #include <asm/virtext.h>
 #include <asm/intel_pt.h>
+#include <asm/crash.h>
=20
 /* Used while preparing memory map entries for second kernel */
 struct crash_memmap_data {
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 7299dcb..8d85e00 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -23,6 +23,7 @@
 #include <asm/pci_x86.h>
 #include <asm/setup.h>
 #include <asm/i8259.h>
+#include <asm/prom.h>
=20
 __initdata u64 initial_dtb;
 char __initdata cmd_line[COMMAND_LINE_SIZE];
diff --git a/arch/x86/kernel/jailhouse.c b/arch/x86/kernel/jailhouse.c
index 108c48d..1b2ee55 100644
--- a/arch/x86/kernel/jailhouse.c
+++ b/arch/x86/kernel/jailhouse.c
@@ -19,6 +19,7 @@
 #include <asm/pci_x86.h>
 #include <asm/reboot.h>
 #include <asm/setup.h>
+#include <asm/jailhouse_para.h>
=20
 static __initdata struct jailhouse_setup_data setup_data;
 static unsigned int precalibrated_tsc_khz;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c93fcfd..8a33d4a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -22,6 +22,8 @@
 #include <linux/utsname.h>
 #include <linux/stackprotector.h>
 #include <linux/cpuidle.h>
+#include <linux/acpi.h>
+#include <linux/elf-randomize.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
 #include <asm/cpu.h>
@@ -39,6 +41,7 @@
 #include <asm/desc.h>
 #include <asm/prctl.h>
 #include <asm/spec-ctrl.h>
+#include <asm/proto.h>
=20
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 736348e..8451f38 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -7,6 +7,7 @@
 #include <linux/irq.h>
=20
 #include <asm/hpet.h>
+#include <asm/setup.h>
=20
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_P=
CI)
=20
diff --git a/arch/x86/kernel/tracepoint.c b/arch/x86/kernel/tracepoint.c
index 5bd30c4..2e85f4d 100644
--- a/arch/x86/kernel/tracepoint.c
+++ b/arch/x86/kernel/tracepoint.c
@@ -10,6 +10,7 @@
=20
 #include <asm/hw_irq.h>
 #include <asm/desc.h>
+#include <asm/trace/exceptions.h>
=20
 DEFINE_STATIC_KEY_FALSE(trace_pagefault_key);
=20
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 845174e..890c4cb 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1053,6 +1053,8 @@ extern void efi_initialize_iomem_resources(struct res=
ource *code_resource,
 extern int efi_reboot_quirk_mode;
 extern bool efi_poweroff_required(void);
=20
+extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
+
 #ifdef CONFIG_EFI_FAKE_MEMMAP
 extern void __init efi_fake_memmap(void);
 #else
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index a397907..182d669 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -420,6 +420,9 @@ enum {
 };
=20
 void arch_ftrace_update_code(int command);
+void arch_ftrace_update_trampoline(struct ftrace_ops *ops);
+void *arch_ftrace_trampoline_func(struct ftrace_ops *ops, struct dyn_ftrac=
e *rec);
+void arch_ftrace_trampoline_free(struct ftrace_ops *ops);
=20
 struct ftrace_rec_iter;
=20
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 9e4e638..53efeda 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -174,6 +174,7 @@ int kexec_purgatory_get_set_symbol(struct kimage *image=
, const char *name,
 				   bool get_value);
 void *kexec_purgatory_get_symbol_addr(struct kimage *image, const char *na=
me);
=20
+void * __weak arch_kexec_kernel_image_load(struct kimage *image);
 int __weak arch_kexec_apply_relocations_add(struct purgatory_info *pi,
 					    Elf_Shdr *section,
 					    const Elf_Shdr *relsec,
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index b9cd9eb..a713e5d 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -76,6 +76,7 @@ extern int early_init_dt_scan_memory(unsigned long node, =
const char *uname,
 extern int early_init_dt_scan_chosen_stdout(void);
 extern void early_init_fdt_scan_reserved_mem(void);
 extern void early_init_fdt_reserve_self(void);
+extern void __init early_init_dt_scan_chosen_arch(unsigned long node);
 extern void early_init_dt_add_memory_arch(u64 base, u64 size);
 extern int early_init_dt_mark_hotplug_memory_arch(u64 base, u64 size);
 extern int early_init_dt_reserve_memory_arch(phys_addr_t base, phys_addr_t=
 size,
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 6c2ffed..a37d7c0 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -428,4 +428,5 @@ extern int task_current_syscall(struct task_struct *tar=
get, long *callno,
 				unsigned long args[6], unsigned int maxargs,
 				unsigned long *sp, unsigned long *pc);
=20
+extern void sigaction_compat_abi(struct k_sigaction *act, struct k_sigacti=
on *oact);
 #endif
--=20
1.8.3.1

--=20
You received this message because you are subscribed to the Google Groups "=
Jailhouse" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to jailhouse-dev+unsubscribe@googlegroups.com.
For more options, visit https://groups.google.com/d/optout.
