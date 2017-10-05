From: kernel test robot <fengguang.wu@intel.com>
Subject: 24e700e291 ("Merge branch 'x86-apic-for-linus' of .."):  WARNING: kernel stack regs at 979f9f70 in kworker/u4:1:648 has bad 'bp' value   (null)
Date: Fri, 06 Oct 2017 04:37:08 +0800
Message-ID: <59d697f4.wtJTZKd6xpKQ0cyN%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_59d697f4.0IyfdABWy5NB6mNRQpz8V8cBt2Lirg5vs+pWvKW27hY6jtbE"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKP <lkp@01.org>, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>LKML <linux-kernel@vger.kernel.org>, wfg@linux.intel.com
List-Id: linux-efi@vger.kernel.org

This is a multi-part message in MIME format.

--=_59d697f4.0IyfdABWy5NB6mNRQpz8V8cBt2Lirg5vs+pWvKW27hY6jtbE
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

commit 24e700e291d52bd200212487e2b654c0aa3f07a2
Merge: f57091767add2 c6ef89421e236
Author:     Linus Torvalds <torvalds@linux-foundation.org>
AuthorDate: Mon Sep 4 17:43:56 2017 -0700
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Mon Sep 4 17:43:56 2017 -0700

    Merge branch 'x86-apic-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull x86 apic updates from Thomas Gleixner:
     "This update provides:
    
       - Cleanup of the IDT management including the removal of the extra
         tracing IDT. A first step to cleanup the vector management code.
    
       - The removal of the paravirt op adjust_exception_frame. This is a
         XEN specific issue, but merged through this branch to avoid nasty
         merge collisions
    
       - Prevent dmesg spam about the TSC DEADLINE bug, when the CPU has
         disabled the TSC DEADLINE timer in CPUID.
    
       - Adjust a debug message in the ioapic code to print out the
         information correctly"
    
    * 'x86-apic-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip: (51 commits)
      x86/idt: Fix the X86_TRAP_BP gate
      x86/xen: Get rid of paravirt op adjust_exception_frame
      x86/eisa: Add missing include
      x86/idt: Remove superfluous ALIGNment
      x86/apic: Silence "FW_BUG TSC_DEADLINE disabled due to Errata" on CPUs without the feature
      x86/idt: Remove the tracing IDT leftovers
      x86/idt: Hide set_intr_gate()
      x86/idt: Simplify alloc_intr_gate()
      x86/idt: Deinline setup functions
      x86/idt: Remove unused functions/inlines
      x86/idt: Move interrupt gate initialization to IDT code
      x86/idt: Move APIC gate initialization to tables
      x86/idt: Move regular trap init to tables
      x86/idt: Move IST stack based traps to table init
      x86/idt: Move debug stack init to table based
      x86/idt: Switch early trap init to IDT tables
      x86/idt: Prepare for table based init
      x86/idt: Move early IDT setup out of 32-bit asm
      x86/idt: Move early IDT handler setup to IDT code
      x86/idt: Consolidate IDT invalidation
      ...

f57091767a  Merge branch 'x86-cache-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
c6ef89421e  x86/idt: Fix the X86_TRAP_BP gate
24e700e291  Merge branch 'x86-apic-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
0f380715e5  Merge tag 'sound-4.14-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
1418b85217  Add linux-next specific files for 20170929
+----------------------+------------+------------+------------+------------+---------------+
|                      | f57091767a | c6ef89421e | 24e700e291 | 0f380715e5 | next-20170929 |
+----------------------+------------+------------+------------+------------+---------------+
| boot_successes       | 320        | 320        | 101        | 28         | 5             |
| boot_failures        | 0          | 0          | 15         | 2          | 1             |
| WARNING:kernel_stack | 0          | 0          | 15         | 2          | 1             |
+----------------------+------------+------------+------------+------------+---------------+

[   18.114577] init: tty6 main process (334) terminated with status 1
[   18.115792] init: tty6 main process ended, respawning
[init] Using pid_max = 4096
[init] Started watchdog process, PID is 559
[main] Main thread is alive.
[   20.993350] WARNING: kernel stack regs at 979f9f70 in kworker/u4:1:648 has bad 'bp' value   (null)
[   20.993353] unwind stack type:0 next_sp:  (null) mask:0x2 graph_idx:0
[   20.993355] 979f9e14: 00000000 ...
[   20.993359] 979f9e18: 979f9e64 (0x979f9e64)
[   20.993366] 979f9e1c: 9462d75f (__save_stack_trace+0x112/0x11c)
[   20.993369] 979f9e20: 009f9e2c (0x9f9e2c)

                                                          # HH:MM RESULT GOOD BAD GOOD_BUT_DIRTY DIRTY_NOT_BAD
git bisect start 045c5205823fc3cd4e5cafdedb2cc7d434424909 v4.13 --
git bisect  bad e77d3b0c4a6a973872652601aae35d4ab1785fb4  # 16:56  B     15     3   15  17  Merge branch 'irq-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 42c8e86c9c3e15ac653c31d57b2f985579c2991d  # 17:21  B     36     2   36  38  Merge tag 'trace-v4.14' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect  bad 77d0ab600af4bf5152bc98d0ac1edbc34c1e5fdf  # 17:34  B      5     1    0   0  Merge tag 'gfs2-4.14.fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2
git bisect good 93cc1228b4a60584f3dadbd84f19f365bb945acb  # 18:22  G    106     0    1   1  Merge branch 'irq-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad bf1d6b2c76eda86159519bf5c427b1fa8f51f733  # 18:34  B     13     4    0   0  Merge tag 'staging-4.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect  bad f32c9e059eb6c12a4296003489b167f8eef9d201  # 18:56  B      7     1    0   0  Merge branch 'parisc-4.14-1' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux
git bisect good f57091767add2b79d76aac41b83b192d8ba1dce7  # 20:01  G    106     0    0   0  Merge branch 'x86-cache-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 24e700e291d52bd200212487e2b654c0aa3f07a2  # 20:15  B      5     2    0   0  Merge branch 'x86-apic-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 87cc037674342cbf6213829b2cc59bb71be60777  # 21:00  G    106     0    0   0  x86/ldttss: Clean up 32-bit descriptors
git bisect good 636a7598f65938e1dbacafec74c2e3acdc66bd4d  # 21:24  G    108     0    0   0  x86/idt: Move APIC gate initialization to tables
git bisect good 1d792a678c759b3b06af197c2c250cea13f9c57b  # 00:05  G    109     0    0   0  x86/idt: Remove the tracing IDT leftovers
git bisect good ef1d4deab953ecb1dfcf9f167043bda8b3f14a11  # 00:43  G    111     0    0   0  x86/eisa: Add missing include
git bisect good 5878d5d6fdef6447d73b0acc121ba445bef37f53  # 01:23  G    111     0    0   0  x86/xen: Get rid of paravirt op adjust_exception_frame
git bisect good c6ef89421e236d75693ae968d80d44a52409889d  # 02:00  G    112     0    0   0  x86/idt: Fix the X86_TRAP_BP gate
# first bad commit: [24e700e291d52bd200212487e2b654c0aa3f07a2] Merge branch 'x86-apic-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good f57091767add2b79d76aac41b83b192d8ba1dce7  # 03:29  G    311     0    0   0  Merge branch 'x86-cache-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good c6ef89421e236d75693ae968d80d44a52409889d  # 03:53  G    316     0    0   0  x86/idt: Fix the X86_TRAP_BP gate
# extra tests with CONFIG_DEBUG_INFO_REDUCED
git bisect  bad 24e700e291d52bd200212487e2b654c0aa3f07a2  # 04:11  B     15     5    0   0  Merge branch 'x86-apic-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
# extra tests on HEAD of linux-devel/devel-catchup-201710021123
git bisect  bad d2625554b1ebf980a064d9b3d577da4c28a7bd84  # 04:11  B     43     2    0   0  0day head guard for 'devel-catchup-201710021123'
# extra tests on tree/branch linus/master
git bisect  bad 0f380715e51f5ff418cfccb4cd0d4fe4c48c3241  # 04:33  B     18     1    0   0  Merge tag 'sound-4.14-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
# extra tests on tree/branch linux-next/master
git bisect  bad 1418b852174ad50b3cb4738b8801626aefdc0bd9  # 04:34  B      0     1   15   0  Add linux-next specific files for 20170929

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/lkp                          Intel Corporation

--=_59d697f4.0IyfdABWy5NB6mNRQpz8V8cBt2Lirg5vs+pWvKW27hY6jtbE
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg-quantal-kbuild-15:20171005203249:i386-randconfig-h0-10021052:4.13.0-02324-g24e700e:1.gz"

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

--=_59d697f4.0IyfdABWy5NB6mNRQpz8V8cBt2Lirg5vs+pWvKW27hY6jtbE
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reproduce-quantal-kbuild-15:20171005203249:i386-randconfig-h0-10021052:4.13.0-02324-g24e700e:1"

#!/bin/bash

kernel=$1
initrd=quantal-core-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu kvm64
	-kernel $kernel
	-initrd $initrd
	-m 512
	-smp 2
	-device e1000,netdev=net0
	-netdev user,id=net0
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-watchdog-action debug
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null
)

append=(
	root=/dev/ram0
	hung_task_panic=1
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	net.ifnames=0
	printk.devkmsg=on
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	drbd.minor_count=8
	systemd.log_level=err
	ignore_loglevel
	console=tty0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	vga=normal
	rw
	drbd.minor_count=8
)

"${kvm[@]}" -append "${append[*]}"

--=_59d697f4.0IyfdABWy5NB6mNRQpz8V8cBt2Lirg5vs+pWvKW27hY6jtbE
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-4.13.0-02324-g24e700e"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 4.13.0 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_BITS_MAX=16
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=2
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_DEBUGFS=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_RCU_NOCB_CPU=y
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CPUSETS is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_SOCK_CGROUP_DATA is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
# CONFIG_SGETMASK_SYSCALL is not set
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_POSIX_TIMERS=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_ABSOLUTE_PERCPU is not set
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_BPF_SYSCALL is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_USERFAULTFD=y
CONFIG_PCI_QUIRKS=y
# CONFIG_MEMBARRIER is not set
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_SLUB_DEBUG is not set
CONFIG_SLUB_MEMCG_SYSFS_ON=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLAB_MERGE_DEFAULT is not set
CONFIG_SLAB_FREELIST_RANDOM=y
# CONFIG_SLUB_CPU_PARTIAL is not set
# CONFIG_SYSTEM_DATA_VERIFICATION is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_GCC_PLUGINS=y
# CONFIG_GCC_PLUGINS is not set
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_THIN_ARCHIVES=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=8
CONFIG_HAVE_COPY_THREAD_TLS=y
# CONFIG_HAVE_ARCH_HASH is not set
CONFIG_ISA_BUS_API=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y
# CONFIG_CPU_NO_EFFICIENT_FFS is not set
# CONFIG_HAVE_ARCH_VMAP_STACK is not set
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX is not set
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
# CONFIG_REFCOUNT_FULL is not set

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_MODULE_COMPRESS=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
CONFIG_MODULE_COMPRESS_XZ=y
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
# CONFIG_BLOCK is not set
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_FAST_FEATURE_TESTS=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
# CONFIG_GOLDFISH is not set
CONFIG_INTEL_RDT=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
# CONFIG_X86_INTEL_QUARK is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
CONFIG_IOSF_MBI_DEBUG=y
# CONFIG_X86_RDC321X is not set
CONFIG_X86_32_NON_STANDARD=y
CONFIG_STA2X11=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
CONFIG_MVIAC7=y
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
# CONFIG_PERF_EVENTS_INTEL_RAPL is not set
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# CONFIG_X86_LEGACY_VM86 is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=m
CONFIG_I8K=m
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_2G_OPT=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x78000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_HAVE_GENERIC_GUP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_ARCH_WANTS_THP_SWAP is not set
CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_AREAS=7
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_Z3FOLD=y
CONFIG_ZSMALLOC=m
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_ZSMALLOC_STAT=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_FRAME_VECTOR=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_X86_INTEL_MPX is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
# CONFIG_MODIFY_LDT_SYSCALL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_CLK=y
CONFIG_PM_GENERIC_DOMAINS=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_PM_GENERIC_DOMAINS_OF=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR_CSTATE=y
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_REDUCED_HARDWARE_ONLY=y
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
CONFIG_DPTF_POWER=y
CONFIG_ACPI_WATCHDOG=y
CONFIG_PMIC_OPREGION=y
CONFIG_CRC_PMIC_OPREGION=y
CONFIG_XPOWER_PMIC_OPREGION=y
CONFIG_BXT_WC_PMIC_OPREGION=y
# CONFIG_CHT_WC_PMIC_OPREGION is not set
CONFIG_ACPI_CONFIGFS=y
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set

#
# CPU frequency scaling drivers
#
# CONFIG_CPUFREQ_DT is not set
# CONFIG_X86_INTEL_PSTATE is not set
CONFIG_X86_POWERNOW_K6=m
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_GX_SUSPMOD=m
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=m
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=m
CONFIG_X86_LONGRUN=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_POWER_SUPERSAVE=y
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCIE_DPC=y
# CONFIG_PCIE_PTM is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=m
CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
CONFIG_HOTPLUG_PCI_IBM=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=m

#
# DesignWare PCI Core Support
#

#
# PCI host controller drivers
#

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
CONFIG_ISA_BUS=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
# CONFIG_EISA_PCI_EISA is not set
CONFIG_EISA_VIRTUAL_ROOT=y
CONFIG_EISA_NAMES=y
CONFIG_SCx200=m
# CONFIG_SCx200HR_TIMER is not set
CONFIG_OLPC=y
CONFIG_OLPC_XO15_SCI=y
# CONFIG_ALIX is not set
CONFIG_NET5501=y
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=m
# CONFIG_YENTA_O2 is not set
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
# CONFIG_I82092 is not set
CONFIG_I82365=m
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
# CONFIG_RAPIDIO_ENUM_BASIC is not set
CONFIG_RAPIDIO_CHMAN=m
CONFIG_RAPIDIO_MPORT_CDEV=m

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_RAPIDIO_RXS_GEN3=y
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=m
# CONFIG_COREDUMP is not set
CONFIG_COMPAT_32=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_X86_DMA_REMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_MPLS is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_STREAM_PARSER is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
# CONFIG_PSAMPLE is not set
# CONFIG_NET_IFE is not set
# CONFIG_LWTUNNEL is not set
# CONFIG_DST_CACHE is not set
# CONFIG_GRO_CELLS is not set
# CONFIG_NET_DEVLINK is not set
CONFIG_MAY_USE_DEVLINK=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_ALLOW_DEV_COREDUMP is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_FENCE_TRACE=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8

#
# Bus devices
#
CONFIG_SIMPLE_PM_BUS=y
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=m
# CONFIG_MTD_OF_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# Partition parsers
#

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y
CONFIG_MTD_PARTITIONED_MASTER=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=m
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_PHYSMAP_OF is not set
CONFIG_MTD_SCx200_DOCFLASH=m
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=y
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
CONFIG_MTD_PCI=y
# CONFIG_MTD_PCMCIA is not set
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_DTC=y
CONFIG_OF=y
CONFIG_OF_UNITTEST=y
CONFIG_OF_FLATTREE=y
CONFIG_OF_EARLY_FLATTREE=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_DYNAMIC=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_RESOLVE=y
# CONFIG_OF_OVERLAY is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=m
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_CS5535_MFGPT=m
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
CONFIG_PCI_ENDPOINT_TEST=m
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_IDT_89HPESX=m
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
# CONFIG_INTEL_MEI_ME is not set
CONFIG_INTEL_MEI_TXE=m
CONFIG_VMWARE_VMCI=m

#
# Intel MIC Bus Driver
#

#
# SCIF Bus Driver
#

#
# VOP Bus Driver
#

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#

#
# VOP Driver
#
# CONFIG_ECHO is not set
# CONFIG_CXL_BASE is not set
# CONFIG_CXL_AFU_DRIVER_OPS is not set
# CONFIG_CXL_LIB is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_NOSY=y
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=m
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CAP11XX is not set
# CONFIG_KEYBOARD_BCM is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
# CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS is not set
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_PS2_OLPC is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
# CONFIG_MOUSE_PS2_VMMOUSE is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_ELAN_I2C=m
# CONFIG_MOUSE_ELAN_I2C_I2C is not set
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_INPORT=m
CONFIG_MOUSE_ATIXL=y
CONFIG_MOUSE_LOGIBM=m
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_JOYSTICK_XPAD_LEDS is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_PROPERTIES=y
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
CONFIG_TOUCHSCREEN_AR1021_I2C=m
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CHIPONE_ICN8318=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9034=m
CONFIG_TOUCHSCREEN_DA9052=m
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_EGALAX=m
CONFIG_TOUCHSCREEN_EGALAX_SERIAL=m
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GOODIX=m
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_EKTF2127 is not set
# CONFIG_TOUCHSCREEN_ELAN is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=m
CONFIG_TOUCHSCREEN_MELFAS_MIP4=m
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_IMX6UL_TSC=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_HTCPEN=m
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WDT87XX_I2C=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_MC13783=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
CONFIG_TOUCHSCREEN_USB_3M=y
# CONFIG_TOUCHSCREEN_USB_ITM is not set
# CONFIG_TOUCHSCREEN_USB_ETURBO is not set
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
# CONFIG_TOUCHSCREEN_USB_E2I is not set
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC200X_CORE=m
CONFIG_TOUCHSCREEN_TSC2004=m
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_RM_TS is not set
# CONFIG_TOUCHSCREEN_SILEAD is not set
CONFIG_TOUCHSCREEN_SIS_I2C=m
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_STMFTS=m
CONFIG_TOUCHSCREEN_STMPE=m
CONFIG_TOUCHSCREEN_SUR40=m
CONFIG_TOUCHSCREEN_SX8654=m
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZET6223 is not set
CONFIG_TOUCHSCREEN_ZFORCE=m
CONFIG_TOUCHSCREEN_COLIBRI_VF50=m
CONFIG_TOUCHSCREEN_ROHM_BU21023=m
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
CONFIG_RMI4_F54=y
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
# CONFIG_SERIO_APBPS2 is not set
CONFIG_SERIO_OLPC_APSP=y
# CONFIG_USERIO is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVMEM=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_ASPEED_VUART is not set
# CONFIG_SERIAL_8250_FSL is not set
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
# CONFIG_SERIAL_8250_MOXA is not set
# CONFIG_SERIAL_OF_PLATFORM is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_CONEXANT_DIGICOLOR is not set
# CONFIG_SERIAL_MEN_Z135 is not set
CONFIG_SERIAL_DEV_BUS=y
# CONFIG_SERIAL_DEV_CTRL_TTYPORT is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_DMI_DECODE=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=y
# CONFIG_IPMI_SSIF is not set
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=m
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
CONFIG_APPLICOM=m
CONFIG_SONYPI=m

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_SCR24X=m
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HPET_MMAP_DEFAULT=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS_CORE=m
CONFIG_TCG_TIS=m
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TCG_CRB=m
# CONFIG_TCG_VTPM_PROXY is not set
# CONFIG_TCG_TIS_ST33ZP24_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_XILLYBUS=y
CONFIG_XILLYBUS_OF=y

#
# I2C support
#
CONFIG_I2C=y
# CONFIG_ACPI_I2C_OPREGION is not set
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_ARB_GPIO_CHALLENGE=m
CONFIG_I2C_MUX_GPIO=m
# CONFIG_I2C_MUX_GPMUX is not set
CONFIG_I2C_MUX_LTC4306=m
CONFIG_I2C_MUX_PCA9541=m
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_MUX_PINCTRL=m
CONFIG_I2C_MUX_REG=m
# CONFIG_I2C_DEMUX_PINCTRL is not set
CONFIG_I2C_MUX_MLXCPLD=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
CONFIG_I2C_EG20T=m
CONFIG_I2C_EMEV2=y
CONFIG_I2C_GPIO=y
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RK3X=m
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_DLN2=m
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=m
CONFIG_SCx200_ACB=y
# CONFIG_I2C_STUB is not set
CONFIG_I2C_SLAVE=y
CONFIG_I2C_SLAVE_EEPROM=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=m
# CONFIG_PPS is not set

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_PINCTRL=y

#
# Pin controllers
#
CONFIG_GENERIC_PINCTRL_GROUPS=y
CONFIG_PINMUX=y
CONFIG_GENERIC_PINMUX_FUNCTIONS=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
CONFIG_DEBUG_PINCTRL=y
# CONFIG_PINCTRL_AS3722 is not set
CONFIG_PINCTRL_AMD=y
# CONFIG_PINCTRL_MCP23S08 is not set
CONFIG_PINCTRL_SINGLE=m
CONFIG_PINCTRL_SX150X=y
CONFIG_PINCTRL_MAX77620=y
# CONFIG_PINCTRL_BAYTRAIL is not set
CONFIG_PINCTRL_CHERRYVIEW=y
CONFIG_PINCTRL_INTEL=y
CONFIG_PINCTRL_BROXTON=m
CONFIG_PINCTRL_CANNONLAKE=y
CONFIG_PINCTRL_GEMINILAKE=m
CONFIG_PINCTRL_SUNRISEPOINT=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_74XX_MMIO=m
CONFIG_GPIO_ALTERA=m
# CONFIG_GPIO_AMDPT is not set
CONFIG_GPIO_AXP209=m
CONFIG_GPIO_DWAPB=y
# CONFIG_GPIO_EXAR is not set
CONFIG_GPIO_FTGPIO010=y
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_GRGPIO=y
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_LYNXPOINT is not set
# CONFIG_GPIO_MENZ127 is not set
# CONFIG_GPIO_MOCKUP is not set
# CONFIG_GPIO_STA2X11 is not set
CONFIG_GPIO_SYSCON=m
CONFIG_GPIO_VX855=m
# CONFIG_GPIO_XILINX is not set

#
# Port-mapped I/O GPIO drivers
#
CONFIG_GPIO_F7188X=m
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_SCH311X=m
CONFIG_GPIO_WS16C48=y

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
CONFIG_GPIO_ADNP=y
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TPIC2810=y

#
# MFD GPIO expanders
#
CONFIG_GPIO_ADP5520=m
# CONFIG_GPIO_CRYSTAL_COVE is not set
CONFIG_GPIO_CS5535=m
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=m
# CONFIG_GPIO_DLN2 is not set
# CONFIG_GPIO_JANZ_TTL is not set
CONFIG_GPIO_LP87565=m
CONFIG_GPIO_MAX77620=m
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_STMPE is not set
# CONFIG_GPIO_TC3589X is not set
# CONFIG_GPIO_TPS65086 is not set
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_WHISKEY_COVE is not set
CONFIG_GPIO_WM8994=m

#
# PCI GPIO expanders
#
CONFIG_GPIO_AMD8111=m
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_ML_IOH=m
CONFIG_GPIO_PCH=m
# CONFIG_GPIO_PCI_IDIO_16 is not set
CONFIG_GPIO_RDC321X=y
# CONFIG_GPIO_SODAVILLE is not set

#
# USB GPIO expanders
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2405=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2406=m
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2438=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_AVS=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_TEST_POWER=m
# CONFIG_BATTERY_ACT8945A is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_LEGO_EV3 is not set
CONFIG_BATTERY_OLPC=y
CONFIG_BATTERY_SBS=m
# CONFIG_CHARGER_SBS is not set
CONFIG_BATTERY_BQ27XXX=y
CONFIG_BATTERY_BQ27XXX_I2C=m
# CONFIG_BATTERY_BQ27XXX_DT_UPDATES_NVM is not set
# CONFIG_BATTERY_DA9030 is not set
CONFIG_BATTERY_DA9052=y
CONFIG_CHARGER_AXP20X=m
CONFIG_BATTERY_AXP20X=m
CONFIG_AXP20X_POWER=m
# CONFIG_AXP288_CHARGER is not set
CONFIG_AXP288_FUEL_GAUGE=m
CONFIG_BATTERY_MAX17040=m
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_BATTERY_TWL4030_MADC=m
CONFIG_CHARGER_PCF50633=m
# CONFIG_BATTERY_RX51 is not set
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=m
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_LTC3651 is not set
CONFIG_CHARGER_MAX14577=m
# CONFIG_CHARGER_DETECTOR_MAX14656 is not set
CONFIG_CHARGER_MAX8998=m
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24257=m
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_BQ25890=m
CONFIG_CHARGER_SMB347=y
# CONFIG_CHARGER_TPS65217 is not set
CONFIG_BATTERY_GAUGE_LTC2941=y
CONFIG_BATTERY_RT5033=m
# CONFIG_CHARGER_RT9455 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=m
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
CONFIG_SENSORS_DA9052_ADC=m
CONFIG_SENSORS_DA9055=m
CONFIG_SENSORS_I5K_AMB=m
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_FTSTEUTATES=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=m
CONFIG_SENSORS_I5500=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_POWR1220=m
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC2990=y
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4260=y
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MAX31790=y
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_TC654=m
CONFIG_SENSORS_MENF21BMC_HWMON=m
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_NCT6683=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_NCT7802 is not set
CONFIG_SENSORS_NCT7904=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_IR35221 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_LTC2978_REGULATOR=y
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_MAX16064 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX34440 is not set
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_PWM_FAN is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SHT3x=y
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=y
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_STTS751=m
CONFIG_SENSORS_SMM665=m
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=m
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_INA3221 is not set
CONFIG_SENSORS_TC74=y
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=m
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_OF is not set
CONFIG_THERMAL_WRITABLE_TRIPS=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
CONFIG_THERMAL_EMULATION=y
CONFIG_MAX77620_THERMAL=m
CONFIG_DA9062_THERMAL=m
CONFIG_INTEL_POWERCLAMP=m
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
CONFIG_INTEL_SOC_DTS_THERMAL=m

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# CONFIG_INTEL_BXT_PMIC_THERMAL is not set
# CONFIG_INTEL_PCH_THERMAL is not set
CONFIG_GENERIC_ADC_THERMAL=m
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y
# CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED is not set
CONFIG_WATCHDOG_SYSFS=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_DA9052_WATCHDOG is not set
CONFIG_DA9055_WATCHDOG=y
CONFIG_DA9063_WATCHDOG=m
CONFIG_DA9062_WATCHDOG=y
CONFIG_GPIO_WATCHDOG=y
# CONFIG_GPIO_WATCHDOG_ARCH_INITCALL is not set
# CONFIG_MENF21BMC_WATCHDOG is not set
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
CONFIG_ZIIRAVE_WATCHDOG=m
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_RN5T618_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=m
CONFIG_MAX63XX_WATCHDOG=m
# CONFIG_MAX77620_WATCHDOG is not set
CONFIG_RETU_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=y
CONFIG_EBC_C384_WDT=m
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
CONFIG_GEODE_WDT=m
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
CONFIG_SCx200_WDT=m
CONFIG_PC87413_WDT=m
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=m
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=m
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
# CONFIG_INTEL_MEI_WDT is not set
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
CONFIG_MIXCOMWD=y
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m

#
# Watchdog Pretimeout Governors
#
CONFIG_WATCHDOG_PRETIMEOUT_GOV=y
CONFIG_WATCHDOG_PRETIMEOUT_DEFAULT_GOV_NOOP=y
# CONFIG_WATCHDOG_PRETIMEOUT_DEFAULT_GOV_PANIC is not set
CONFIG_WATCHDOG_PRETIMEOUT_GOV_NOOP=y
# CONFIG_WATCHDOG_PRETIMEOUT_GOV_PANIC is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_PCI is not set
# CONFIG_BCMA_SFLASH is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=m
CONFIG_MFD_ACT8945A=y
# CONFIG_MFD_AS3711 is not set
CONFIG_MFD_AS3722=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_ATMEL_FLEXCOM=m
CONFIG_MFD_ATMEL_HLCDC=y
CONFIG_MFD_BCM590XX=m
CONFIG_MFD_AXP20X=y
CONFIG_MFD_AXP20X_I2C=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9062=y
CONFIG_MFD_DA9063=m
# CONFIG_MFD_DA9150 is not set
CONFIG_MFD_DLN2=m
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_MFD_HI6421_PMIC is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_MFD_INTEL_QUARK_I2C_GPIO=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
CONFIG_INTEL_SOC_PMIC=y
CONFIG_INTEL_SOC_PMIC_BXTWC=m
CONFIG_INTEL_SOC_PMIC_CHTWC=y
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
# CONFIG_MFD_INTEL_LPSS_PCI is not set
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=m
CONFIG_MFD_88PM805=m
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=m
CONFIG_MFD_MAX77620=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_MT6397 is not set
CONFIG_MFD_MENF21BMC=m
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=m
CONFIG_MFD_RT5033=y
CONFIG_MFD_RTSX_USB=m
CONFIG_MFD_RC5T583=y
CONFIG_MFD_RK808=y
CONFIG_MFD_RN5T618=m
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SKY81452 is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_MFD_STA2X11=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65086=m
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TI_LP873X is not set
CONFIG_MFD_TI_LP87565=m
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=m
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_88PM800 is not set
CONFIG_REGULATOR_ACT8865=m
CONFIG_REGULATOR_ACT8945A=y
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AS3722=y
# CONFIG_REGULATOR_AXP20X is not set
CONFIG_REGULATOR_BCM590XX=m
CONFIG_REGULATOR_DA903X=m
CONFIG_REGULATOR_DA9052=m
CONFIG_REGULATOR_DA9055=m
CONFIG_REGULATOR_DA9062=y
# CONFIG_REGULATOR_DA9063 is not set
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_DA9211=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_ISL9305=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_LP87565=m
CONFIG_REGULATOR_LTC3589=m
CONFIG_REGULATOR_LTC3676=y
CONFIG_REGULATOR_MAX14577=m
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX77620 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=m
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8998=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_MT6311=y
CONFIG_REGULATOR_PCF50633=y
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_PV88060=y
CONFIG_REGULATOR_PV88080=y
# CONFIG_REGULATOR_PV88090 is not set
CONFIG_REGULATOR_PWM=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_RK808=m
# CONFIG_REGULATOR_RN5T618 is not set
CONFIG_REGULATOR_RT5033=y
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
# CONFIG_REGULATOR_S5M8767 is not set
CONFIG_REGULATOR_TPS51632=m
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65086=m
# CONFIG_REGULATOR_TPS65132 is not set
CONFIG_REGULATOR_TPS65217=m
CONFIG_REGULATOR_TPS65912=m
CONFIG_REGULATOR_TPS80031=y
# CONFIG_REGULATOR_TWL4030 is not set
CONFIG_REGULATOR_VCTRL=m
# CONFIG_REGULATOR_WM8400 is not set
CONFIG_REGULATOR_WM8994=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_SDR_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CEC_SUPPORT=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_V4L2_FWNODE=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEOBUF2_DMA_SG=m
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Software defined radio USB devices
#
CONFIG_USB_AIRSPY=m
CONFIG_USB_HACKRF=m

#
# USB HDMI CEC adapters
#
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_CEC_PLATFORM_DRIVERS=y
CONFIG_SDR_PLATFORM_DRIVERS=y

#
# Supported MMC/SDIO adapters
#
# CONFIG_CYPRESS_FIRMWARE is not set

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# I2C Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
# CONFIG_VIDEO_TDA7432 is not set
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS3308=m
# CONFIG_VIDEO_CS5345 is not set
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_TLV320AIC23B=m
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
# CONFIG_VIDEO_VP27SMPX is not set
CONFIG_VIDEO_SONY_BTF_MPX=m

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
CONFIG_VIDEO_ADV7183=m
# CONFIG_VIDEO_BT819 is not set
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
CONFIG_VIDEO_TVP514X=m
CONFIG_VIDEO_TVP5150=m
# CONFIG_VIDEO_TVP7002 is not set
CONFIG_VIDEO_TW2804=m
CONFIG_VIDEO_TW9903=m
# CONFIG_VIDEO_TW9906 is not set
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
# CONFIG_VIDEO_CX25840 is not set

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
# CONFIG_VIDEO_ADV7343 is not set
CONFIG_VIDEO_ADV7393=m
CONFIG_VIDEO_AK881X=m
CONFIG_VIDEO_THS8200=m

#
# Camera sensor devices
#
CONFIG_VIDEO_MT9M111=m

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# SDR tuner chips
#
CONFIG_SDR_MAX2175=m

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=m
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#

#
# SPI helper chips
#
CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
# CONFIG_MEDIA_TUNER_TEA5767 is not set
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
# CONFIG_MEDIA_TUNER_FC0011 is not set
CONFIG_MEDIA_TUNER_FC0012=m
# CONFIG_MEDIA_TUNER_FC0013 is not set
# CONFIG_MEDIA_TUNER_TDA18212 is not set
# CONFIG_MEDIA_TUNER_E4000 is not set
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
# CONFIG_MEDIA_TUNER_IT913X is not set
CONFIG_MEDIA_TUNER_R820T=m
CONFIG_MEDIA_TUNER_MXL301RF=m
CONFIG_MEDIA_TUNER_QM1D1C0042=m

#
# Customise DVB Frontends
#

#
# Tools to develop new frontends
#

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=m
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_NVIDIA=m
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=m
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_DP_AUX_CHARDEV=y
CONFIG_DRM_DEBUG_MM_SELFTEST=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=m
CONFIG_DRM_GEM_CMA_HELPER=y
CONFIG_DRM_KMS_CMA_HELPER=y
CONFIG_DRM_VM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_USERPTR=y
CONFIG_DRM_AMDGPU=m
CONFIG_DRM_AMDGPU_SI=y
# CONFIG_DRM_AMDGPU_CIK is not set
CONFIG_DRM_AMDGPU_USERPTR=y
CONFIG_DRM_AMDGPU_GART_DEBUGFS=y

#
# ACP (Audio CoProcessor) Configuration
#
CONFIG_DRM_AMD_ACP=y
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_VGEM=m
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_RCAR_DW_HDMI=m
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
CONFIG_DRM_PANEL_LVDS=m
# CONFIG_DRM_PANEL_SIMPLE is not set
# CONFIG_DRM_PANEL_SAMSUNG_S6E8AA0 is not set
CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
CONFIG_DRM_ANALOGIX_ANX78XX=m
# CONFIG_DRM_DUMB_VGA_DAC is not set
CONFIG_DRM_LVDS_ENCODER=m
CONFIG_DRM_MEGACHIPS_STDPXXXX_GE_B850V3_FW=m
# CONFIG_DRM_NXP_PTN3460 is not set
CONFIG_DRM_PARADE_PS8622=m
CONFIG_DRM_SIL_SII8620=m
# CONFIG_DRM_SII902X is not set
CONFIG_DRM_TOSHIBA_TC358767=m
CONFIG_DRM_TI_TFP410=m
# CONFIG_DRM_I2C_ADV7511 is not set
CONFIG_DRM_DW_HDMI=m
# CONFIG_DRM_DW_HDMI_CEC is not set
CONFIG_DRM_ARCPGU=m
CONFIG_DRM_HISI_HIBMC=m
CONFIG_DRM_MXS=y
CONFIG_DRM_MXSFB=m
CONFIG_DRM_TINYDRM=m
CONFIG_DRM_LEGACY=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_LIB_RANDOM=y

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_PROVIDE_GET_FB_UNMAPPED_AREA is not set
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=m
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=m
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=m
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
# CONFIG_FB_GEODE_GX is not set
# CONFIG_FB_GEODE_GX1 is not set
CONFIG_FB_SM501=m
CONFIG_FB_SMSCUFX=m
CONFIG_FB_UDL=m
# CONFIG_FB_IBM_GXT4500 is not set
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_FB_SSD1307=m
CONFIG_FB_SM712=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_CARILLO_RANCH is not set
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=m
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_PM8941_WLED is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_PCF50633=m
CONFIG_BACKLIGHT_LM3630A=m
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_OT200=m
CONFIG_BACKLIGHT_PANDORA=m
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_GPIO=m
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=m
# CONFIG_BACKLIGHT_ARCXCNN is not set
CONFIG_VGASTATE=y
CONFIG_VIDEOMODE_HELPERS=y
CONFIG_HDMI=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=m
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_APPLEIR=m
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_BETOP_FF is not set
CONFIG_HID_CHERRY=m
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CORSAIR is not set
CONFIG_HID_CMEDIA=m
CONFIG_HID_CP2112=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
CONFIG_HID_ELO=m
CONFIG_HID_EZKEY=m
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
CONFIG_HID_HOLTEK=m
CONFIG_HOLTEK_FF=y
CONFIG_HID_GT683R=m
CONFIG_HID_KEYTOUCH=m
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MAYFLASH=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NTI is not set
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PLANTRONICS=m
CONFIG_HID_PRIMAX=m
CONFIG_HID_RETRODE=m
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=m
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=m
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_UDRAW_PS3=m
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set
CONFIG_HID_ALPS=m

#
# USB HID support
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m

#
# I2C HID support
#
CONFIG_I2C_HID=m
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
# CONFIG_USB_PCI is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_OTG_FSM=m
# CONFIG_USB_LEDS_TRIGGER_USBPORT is not set
CONFIG_USB_MON=m
CONFIG_USB_WUSB_CBAF=m
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_PLATFORM=m
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FOTG210_HCD=m
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=m
CONFIG_USB_U132_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_HCD_SSB=m
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
# CONFIG_USBIP_CORE is not set
CONFIG_USB_MUSB_HDRC=m
CONFIG_USB_MUSB_HOST=y

#
# Platform Glue Layer
#

#
# MUSB DMA mode
#
# CONFIG_MUSB_PIO_ONLY is not set
CONFIG_USB_DWC3=m
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
# CONFIG_USB_DWC3_OF_SIMPLE is not set
CONFIG_USB_DWC2=m
CONFIG_USB_DWC2_HOST=y

#
# Gadget/Dual-role mode requires USB Gadget support to be enabled
#
CONFIG_USB_DWC2_DEBUG=y
# CONFIG_USB_DWC2_VERBOSE is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_USB_DWC2_DEBUG_PERIODIC=y
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=m
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
CONFIG_USB_EHSET_TEST_FIXTURE=m
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_HSIC_USB4604=m
CONFIG_USB_LINK_LAYER_TEST=m
# CONFIG_USB_CHAOSKEY is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_USB_GPIO_VBUS=m
CONFIG_TAHVO_USB=m
# CONFIG_TAHVO_USB_HOST_BY_DEFAULT is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_GADGET is not set

#
# USB Power Delivery and Type-C drivers
#
# CONFIG_TYPEC_WCOVE is not set
# CONFIG_TYPEC_UCSI is not set
CONFIG_USB_LED_TRIG=y
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_PWRSEQ_EMMC is not set
CONFIG_PWRSEQ_SIMPLE=y
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SDRICOH_CS=m
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
CONFIG_MMC_USDHI6ROL0=m
CONFIG_MMC_REALTEK_PCI=m
CONFIG_MMC_REALTEK_USB=m
CONFIG_MMC_TOSHIBA_PCI=m
CONFIG_MMC_MTK=m
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_MEMSTICK_R592=m
CONFIG_MEMSTICK_REALTEK_PCI=m
CONFIG_MEMSTICK_REALTEK_USB=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
CONFIG_LEDS_BRIGHTNESS_HW_CHANGED=y

#
# LED drivers
#
CONFIG_LEDS_BCM6328=m
# CONFIG_LEDS_BCM6358 is not set
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=y
# CONFIG_LEDS_LP3952 is not set
CONFIG_LEDS_LP55XX_COMMON=m
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_LP8860=y
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA963X=m
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_TLC591XX=m
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_MENF21BMC=m
CONFIG_LEDS_IS31FL319X=y
CONFIG_LEDS_IS31FL32XX=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y
CONFIG_LEDS_SYSCON=y
CONFIG_LEDS_USER=m
# CONFIG_LEDS_NIC78BX is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_MTD=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=m
CONFIG_LEDS_TRIGGER_PANIC=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=m
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82875P=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
# CONFIG_EDAC_I3200 is not set
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I82860=m
CONFIG_EDAC_R82600=m
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
CONFIG_EDAC_I7300=m
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y
CONFIG_FSL_EDMA=y
CONFIG_INTEL_IDMA64=y
CONFIG_PCH_DMA=y
CONFIG_QCOM_HIDMA_MGMT=y
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
CONFIG_HSU_DMA=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
CONFIG_AUXDISPLAY=y
CONFIG_CHARLCD=m
CONFIG_HD44780=m
CONFIG_IMG_ASCII_LCD=y
# CONFIG_HT16K33 is not set
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_DMEM_GENIRQ=m
CONFIG_UIO_AEC=m
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=m
CONFIG_UIO_NETX=m
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
# CONFIG_VIRTIO_PCI_LEGACY is not set
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_INPUT is not set
CONFIG_VIRTIO_MMIO=m
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_HYPERV_TSCPAGE is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
# CONFIG_ACERHDF is not set
CONFIG_ALIENWARE_WMI=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
CONFIG_DELL_WMI_AIO=m
CONFIG_DELL_WMI_LED=m
CONFIG_DELL_SMO8800=y
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=m
# CONFIG_TC1100_WMI is not set
CONFIG_HP_ACCEL=m
# CONFIG_HP_WIRELESS is not set
CONFIG_HP_WMI=m
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
# CONFIG_THINKPAD_ACPI_VIDEO is not set
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_SENSORS_HDAPS is not set
CONFIG_EEEPC_LAPTOP=m
# CONFIG_ASUS_WMI is not set
CONFIG_ASUS_WIRELESS=m
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
CONFIG_MSI_WMI=m
CONFIG_PEAQ_WMI=m
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
CONFIG_TOSHIBA_WMI=m
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_CHT_INT33FE=m
CONFIG_INTEL_INT0002_VGPIO=m
CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
CONFIG_INTEL_IPS=y
CONFIG_INTEL_PMC_CORE=y
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=m
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=m
CONFIG_INTEL_RST=m
CONFIG_INTEL_SMARTCONNECT=m
# CONFIG_PVPANIC is not set
CONFIG_INTEL_PMC_IPC=m
CONFIG_INTEL_BXTWC_PMIC_TMU=m
CONFIG_SURFACE_PRO3_BUTTON=m
# CONFIG_INTEL_PUNIT_IPC is not set
CONFIG_MLX_CPLD_PLATFORM=y
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_MAX77686=y
CONFIG_COMMON_CLK_RK808=y
CONFIG_COMMON_CLK_SI5351=y
CONFIG_COMMON_CLK_SI514=m
CONFIG_COMMON_CLK_SI570=m
CONFIG_COMMON_CLK_CDCE706=m
CONFIG_COMMON_CLK_CDCE925=m
# CONFIG_COMMON_CLK_CS2000_CP is not set
CONFIG_COMMON_CLK_S2MPS11=m
# CONFIG_COMMON_CLK_NXP is not set
CONFIG_COMMON_CLK_PWM=m
# CONFIG_COMMON_CLK_PXA is not set
# CONFIG_COMMON_CLK_PIC32 is not set
CONFIG_COMMON_CLK_VC5=y
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#

#
# Broadcom SoC drivers
#

#
# i.MX SoC drivers
#
# CONFIG_SUNXI_SRAM is not set
# CONFIG_SOC_TI is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=m
CONFIG_DEVFREQ_GOV_USERSPACE=m
CONFIG_DEVFREQ_GOV_PASSIVE=y

#
# DEVFREQ Drivers
#
# CONFIG_PM_DEVFREQ_EVENT is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=m
CONFIG_EXTCON_AXP288=m
CONFIG_EXTCON_GPIO=m
CONFIG_EXTCON_INTEL_INT3496=m
CONFIG_EXTCON_INTEL_CHT_WC=y
CONFIG_EXTCON_MAX14577=m
# CONFIG_EXTCON_MAX3355 is not set
CONFIG_EXTCON_RT8973A=y
# CONFIG_EXTCON_SM5502 is not set
# CONFIG_EXTCON_USB_GPIO is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=m
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_CONFIGFS=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
CONFIG_IIO_SW_DEVICE=m
CONFIG_IIO_SW_TRIGGER=m

#
# Accelerometers
#
CONFIG_ADXL345=m
CONFIG_ADXL345_I2C=m
CONFIG_BMA180=m
CONFIG_BMC150_ACCEL=m
CONFIG_BMC150_ACCEL_I2C=m
CONFIG_DA280=m
CONFIG_DA311=m
CONFIG_DMARD06=m
CONFIG_DMARD09=m
CONFIG_DMARD10=m
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
# CONFIG_KXSD9 is not set
CONFIG_KXCJK1013=m
CONFIG_MC3230=m
# CONFIG_MMA7455_I2C is not set
CONFIG_MMA7660=m
# CONFIG_MMA8452 is not set
CONFIG_MMA9551_CORE=m
CONFIG_MMA9551=m
# CONFIG_MMA9553 is not set
CONFIG_MXC4005=m
CONFIG_MXC6255=m
CONFIG_STK8312=m
CONFIG_STK8BA50=m

#
# Analog to digital converters
#
CONFIG_AD7291=m
# CONFIG_AD799X is not set
CONFIG_AXP20X_ADC=m
# CONFIG_AXP288_ADC is not set
CONFIG_CC10001_ADC=m
# CONFIG_ENVELOPE_DETECTOR is not set
CONFIG_HX711=m
CONFIG_LTC2485=m
CONFIG_LTC2497=m
# CONFIG_MAX1363 is not set
CONFIG_MAX9611=m
# CONFIG_MCP3422 is not set
CONFIG_MEN_Z188_ADC=m
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
CONFIG_TI_ADS1015=m
CONFIG_TI_AM335X_ADC=m
CONFIG_TWL4030_MADC=m
CONFIG_TWL6030_GPADC=m
CONFIG_VF610_ADC=m

#
# Amplifiers
#

#
# Chemical Sensors
#
CONFIG_ATLAS_PH_SENSOR=m
CONFIG_IAQCORE=m
CONFIG_VZ89X=m

#
# Hid Sensor IIO Common
#
CONFIG_IIO_MS_SENSORS_I2C=m

#
# SSP Sensor Common
#
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Counters
#

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5380 is not set
CONFIG_AD5446=m
CONFIG_AD5592R_BASE=m
CONFIG_AD5593R=m
CONFIG_CIO_DAC=m
# CONFIG_DPOT_DAC is not set
CONFIG_M62332=m
CONFIG_MAX517=m
CONFIG_MAX5821=m
# CONFIG_MCP4725 is not set
CONFIG_VF610_DAC=m

#
# IIO dummy driver
#
CONFIG_IIO_DUMMY_EVGEN=m
CONFIG_IIO_SIMPLE_DUMMY=m
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
CONFIG_BMG160=m
CONFIG_BMG160_I2C=m
CONFIG_MPU3050=m
CONFIG_MPU3050_I2C=m
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=m

#
# Health Sensors
#

#
# Heart Rate Monitors
#
CONFIG_AFE4404=m
# CONFIG_MAX30100 is not set
CONFIG_MAX30102=m

#
# Humidity sensors
#
# CONFIG_AM2315 is not set
CONFIG_DHT11=m
# CONFIG_HDC100X is not set
# CONFIG_HTS221 is not set
CONFIG_HTU21=m
# CONFIG_SI7005 is not set
CONFIG_SI7020=m

#
# Inertial measurement units
#
# CONFIG_BMI160_I2C is not set
CONFIG_KMX61=m
CONFIG_INV_MPU6050_IIO=m
CONFIG_INV_MPU6050_I2C=m
# CONFIG_IIO_ST_LSM6DSX is not set

#
# Light sensors
#
CONFIG_ACPI_ALS=m
CONFIG_ADJD_S311=m
CONFIG_AL3320A=m
CONFIG_APDS9300=m
CONFIG_APDS9960=m
CONFIG_BH1750=m
# CONFIG_BH1780 is not set
CONFIG_CM32181=m
CONFIG_CM3232=m
CONFIG_CM3323=m
CONFIG_CM3605=m
# CONFIG_CM36651 is not set
# CONFIG_GP2AP020A00F is not set
CONFIG_SENSORS_ISL29018=m
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_ISL29125 is not set
CONFIG_JSA1212=m
CONFIG_RPR0521=m
CONFIG_SENSORS_LM3533=m
CONFIG_LTR501=m
CONFIG_MAX44000=m
CONFIG_OPT3001=m
CONFIG_PA12203001=m
# CONFIG_SI1145 is not set
CONFIG_STK3310=m
CONFIG_TCS3414=m
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL2583=m
CONFIG_TSL4531=m
CONFIG_US5182D=m
CONFIG_VCNL4000=m
# CONFIG_VEML6070 is not set
CONFIG_VL6180=m

#
# Magnetometer sensors
#
# CONFIG_AK8974 is not set
# CONFIG_AK8975 is not set
# CONFIG_AK09911 is not set
CONFIG_BMC150_MAGN=m
CONFIG_BMC150_MAGN_I2C=m
CONFIG_MAG3110=m
CONFIG_MMC35240=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m
# CONFIG_SENSORS_HMC5843_I2C is not set

#
# Multiplexers
#
CONFIG_IIO_MUX=m

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_HRTIMER_TRIGGER=m
CONFIG_IIO_INTERRUPT_TRIGGER=m
# CONFIG_IIO_TIGHTLOOP_TRIGGER is not set
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Digital potentiometers
#
# CONFIG_DS1803 is not set
CONFIG_MCP4531=m
CONFIG_TPL0102=m

#
# Digital potentiostats
#
CONFIG_LMP91000=m

#
# Pressure sensors
#
CONFIG_ABP060MG=m
CONFIG_BMP280=m
CONFIG_BMP280_I2C=m
CONFIG_HP03=m
# CONFIG_MPL115_I2C is not set
CONFIG_MPL3115=m
# CONFIG_MS5611 is not set
# CONFIG_MS5637 is not set
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m
CONFIG_T5403=m
# CONFIG_HP206C is not set
CONFIG_ZPA2326=m
CONFIG_ZPA2326_I2C=m

#
# Lightning sensors
#

#
# Proximity and distance sensors
#
# CONFIG_LIDAR_LITE_V2 is not set
# CONFIG_SRF04 is not set
# CONFIG_SX9500 is not set
CONFIG_SRF08=m

#
# Temperature sensors
#
CONFIG_MLX90614=m
CONFIG_TMP006=m
CONFIG_TMP007=m
CONFIG_TSYS01=m
CONFIG_TSYS02D=m
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
CONFIG_VME_TSI148=y
CONFIG_VME_FAKE=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=m

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_ATMEL_HLCDC_PWM=m
# CONFIG_PWM_CRC is not set
CONFIG_PWM_FSL_FTM=m
CONFIG_PWM_LPSS=y
CONFIG_PWM_LPSS_PCI=y
CONFIG_PWM_LPSS_PLATFORM=y
# CONFIG_PWM_PCA9685 is not set
# CONFIG_PWM_STMPE is not set
CONFIG_PWM_TWL=m
CONFIG_PWM_TWL_LED=y
CONFIG_IRQCHIP=y
CONFIG_ARM_GIC_MAX_NR=1
CONFIG_IPACK_BUS=m
CONFIG_BOARD_TPCI200=m
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_RESET_ATH79 is not set
# CONFIG_RESET_BERLIN is not set
# CONFIG_RESET_GEMINI is not set
# CONFIG_RESET_IMX7 is not set
# CONFIG_RESET_LPC18XX is not set
# CONFIG_RESET_MESON is not set
# CONFIG_RESET_PISTACHIO is not set
# CONFIG_RESET_SOCFPGA is not set
# CONFIG_RESET_STM32 is not set
# CONFIG_RESET_SUNXI is not set
CONFIG_RESET_TI_SYSCON=y
# CONFIG_RESET_ZYNQ is not set
# CONFIG_RESET_TEGRA_BPMP is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_PXA_28NM_HSIC=y
# CONFIG_PHY_PXA_28NM_USB2 is not set
CONFIG_PHY_CPCAP_USB=m
# CONFIG_PHY_SAMSUNG_USB2 is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
CONFIG_MCB=m
# CONFIG_MCB_PCI is not set
CONFIG_MCB_LPC=m

#
# Performance monitor support
#
CONFIG_RAS=y
CONFIG_THUNDERBOLT=y

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# CONFIG_DAX is not set
CONFIG_NVMEM=y
CONFIG_STM=y
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=y
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
CONFIG_INTEL_TH_DEBUG=y

#
# FPGA Configuration Support
#
CONFIG_FPGA=y
CONFIG_FPGA_REGION=m
CONFIG_FPGA_BRIDGE=m
CONFIG_ALTERA_PR_IP_CORE=m
# CONFIG_ALTERA_PR_IP_CORE_PLAT is not set
CONFIG_XILINX_PR_DECOUPLER=m

#
# FSI support
#
CONFIG_FSI=m
CONFIG_FSI_MASTER_GPIO=m
# CONFIG_FSI_MASTER_HUB is not set
CONFIG_FSI_SCOM=m
CONFIG_MULTIPLEXER=m

#
# Multiplexer drivers
#
CONFIG_MUX_ADG792A=m
CONFIG_MUX_GPIO=m
CONFIG_MUX_MMIO=m

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_FW_CFG_SYSFS is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
# CONFIG_EFI_RUNTIME_MAP is not set
CONFIG_EFI_FAKE_MEMMAP=y
CONFIG_EFI_MAX_FAKE_MEM=8
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
CONFIG_EFI_CAPSULE_LOADER=m
# CONFIG_EFI_CAPSULE_QUIRK_QUARK_CSH is not set
CONFIG_EFI_TEST=m
CONFIG_APPLE_PROPERTIES=y
CONFIG_EFI_DEV_PATH_PARSER=y

#
# Tegra firmware driver
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=m
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_OVERLAY_FS=y
CONFIG_OVERLAY_FS_REDIRECT_DIR=y
# CONFIG_OVERLAY_FS_INDEX is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=m
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_PAGE_OWNER=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
# CONFIG_SECTION_MISMATCH_WARN_ONLY is not set
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_PAGE_POISONING=y
CONFIG_PAGE_POISONING_NO_SANITY=y
CONFIG_PAGE_POISONING_ZERO=y
CONFIG_DEBUG_PAGE_REF=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_WQ_WATCHDOG=y
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHED_INFO is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_LOCKDEP_CROSSRELEASE=y
CONFIG_LOCKDEP_COMPLETIONS=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_WW_MUTEX_SELFTEST=m
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_PERF_TEST is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_RCU_EQS_DEBUG is not set
CONFIG_DEBUG_WQ_FORCE_RR_CPU=y
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_OF_RECONFIG_NOTIFIER_ERROR_INJECT=y
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_FUTEX is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_HWLAT_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_UPROBE_EVENTS is not set
# CONFIG_PROBE_EVENTS is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_TRACING_MAP=y
CONFIG_HIST_TRIGGERS=y
CONFIG_TRACEPOINT_BENCHMARK=y
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
CONFIG_TRACE_EVAL_MAP_FILE=y
CONFIG_TRACING_EVENTS_GPIO=y

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=m
CONFIG_TEST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=y
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_HEXDUMP=m
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_PRINTF is not set
CONFIG_TEST_BITMAP=m
CONFIG_TEST_UUID=y
CONFIG_TEST_RHASHTABLE=m
CONFIG_TEST_HASH=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_LKM is not set
CONFIG_TEST_USER_COPY=m
# CONFIG_TEST_BPF is not set
CONFIG_TEST_FIRMWARE=m
# CONFIG_TEST_SYSCTL is not set
# CONFIG_TEST_UDELAY is not set
CONFIG_MEMTEST=y
CONFIG_TEST_STATIC_KEYS=m
CONFIG_BUG_ON_DATA_CORRUPTION=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
# CONFIG_UBSAN is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP_CORE=y
# CONFIG_X86_PTDUMP is not set
CONFIG_EFI_PGT_DUMP=y
CONFIG_DEBUG_WX=y
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_ENTRY is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_FRAME_POINTER_UNWINDER=y
# CONFIG_GUESS_UNWINDER is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEY_DH_OPERATIONS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
# CONFIG_HARDENED_USERCOPY_PAGESPAN is not set
# CONFIG_FORTIFY_SOURCE is not set
CONFIG_STATIC_USERMODEHELPER=y
CONFIG_STATIC_USERMODEHELPER_PATH="/sbin/usermode-helper"
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_ECDH=m
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_MCRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ENGINE=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=m
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_KEYWRAP is not set

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=m
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=m
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=m
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_TI=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_SEED=m
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_842=m
CONFIG_CRYPTO_LZ4=m
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_USER_API_RNG is not set
# CONFIG_CRYPTO_USER_API_AEAD is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_QAT=y
CONFIG_CRYPTO_DEV_QAT_DH895xCC=y
# CONFIG_CRYPTO_DEV_QAT_C3XXX is not set
# CONFIG_CRYPTO_DEV_QAT_C62X is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCCVF is not set
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
CONFIG_CRYPTO_DEV_VIRTIO=m
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
CONFIG_SYSTEM_EXTRA_CERTIFICATE=y
CONFIG_SYSTEM_EXTRA_CERTIFICATE_SIZE=4096
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_CROSS_ENDIAN_LEGACY=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_HAVE_ARCH_BITREVERSE is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=m
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC4=m
CONFIG_CRC7=m
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_842_COMPRESS=m
CONFIG_842_DECOMPRESS=m
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_INTERVAL_TREE=y
CONFIG_RADIX_TREE_MULTIORDER=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
# CONFIG_DMA_NOOP_OPS is not set
# CONFIG_DMA_VIRT_OPS is not set
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
CONFIG_GLOB_SELFTEST=y
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
# CONFIG_IRQ_POLL is not set
CONFIG_MPILIB=y
CONFIG_LIBFDT=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
# CONFIG_SG_SPLIT is not set
# CONFIG_SG_POOL is not set
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_MMIO_FLUSH=y
CONFIG_STACKDEPOT=y
CONFIG_PRIME_NUMBERS=m

--=_59d697f4.0IyfdABWy5NB6mNRQpz8V8cBt2Lirg5vs+pWvKW27hY6jtbE--
