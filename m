From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86: fix -Wmissing-prototypes warning
Date: Thu, 22 Nov 2018 09:48:15 +0100
Message-ID: <20181122084815.GA84118@gmail.com>
References: <1542852249-19820-1-git-send-email-wang.yi59@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <jailhouse-dev+bncBD7LZ45K3ECBBVW23HPQKGQEAC3JFXQ@googlegroups.com>
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Content-Disposition: inline
In-Reply-To: <1542852249-19820-1-git-send-email-wang.yi59@zte.com.cn>
List-Post: <https://groups.google.com/group/jailhouse-dev/post>, <mailto:jailhouse-dev@googlegroups.com>
List-Help: <https://groups.google.com/support/>, <mailto:jailhouse-dev+help@googlegroups.com>
List-Archive: <https://groups.google.com/group/jailhouse-dev
List-Subscribe: <https://groups.google.com/group/jailhouse-dev/subscribe>, <mailto:jailhouse-dev+subscribe@googlegroups.com>
List-Unsubscribe: <mailto:googlegroups-manage+175645748590+unsubscribe@googlegroups.com>,
 <https://groups.google.com/group/jailhouse-dev/subscribe>
To: Yi Wang <wang.yi59@zte.com.cn>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org, jgross@suse.com, akataria@vmware.com, virtualization@lists.linux-foundation.org, m.mizuma@jp.fujitsu.com, peterz@infradead.org, prarit@redhat.com, douly.fnst@cn.fujitsu.com, dwmw@amazon.co.uk, luto@kernel.org, pasha.tatashin@oracle.com, rajvi.jingar@intel.com, zhe.he@windriver.com, akpm@linux-foundation.org, dyoung@redhat.com, takahiro.akashi@linaro.org, ebiederm@xmission.com, bhe@redhat.com, ivan.gorinov@intel.com, robh@kernel.org, andy.shevchenko@gmail.com, frank.rowand@sony.com, jan.kiszka@siemens.com, jailhouse-dev@googlegroups.com, konrad.wilk@oracle.com, thomas.lendacky@amd.com, pravin.shedge4linux@gmail.com, namit@vmware.com, jroedel@sus
List-Id: linux-efi@vger.kernel.org


* Yi Wang <wang.yi59@zte.com.cn> wrote:

> We may get -Wmissing-prototypes warnings when building
> kernel with W=3D1, it's better to fix them as global function
> signature can be changed and caller who use the old unchanged
> prototypes will be hosed.
>=20
> This patch fixes most of -Wmissing-prototypes warnings which
> are in the root directory of arch/x86/kernel, not including
> the subdirectories.
>=20
> These are the warnings fixed in this patch:
> arch/x86/kernel/signal.c:865:17: warning: no previous prototype for =E2=
=80=98sys32_x32_rt_sigreturn=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/signal_compat.c:164:6: warning: no previous prototype for=
 =E2=80=98sigaction_compat_abi=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/traps.c:625:46: warning: no previous prototype for =E2=80=
=98sync_regs=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/traps.c:640:24: warning: no previous prototype for =E2=80=
=98fixup_bad_iret=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/traps.c:929:13: warning: no previous prototype for =E2=80=
=98trap_init=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/irq.c:270:28: warning: no previous prototype for =E2=80=
=98smp_x86_platform_ipi=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/irq.c:301:16: warning: no previous prototype for =E2=80=
=98smp_kvm_posted_intr_ipi=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/irq.c:314:16: warning: no previous prototype for =E2=80=
=98smp_kvm_posted_intr_wakeup_ipi=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/irq.c:328:16: warning: no previous prototype for =E2=80=
=98smp_kvm_posted_intr_nested_ipi=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/irq_work.c:16:28: warning: no previous prototype for =E2=
=80=98smp_irq_work_interrupt=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/irqinit.c:79:13: warning: no previous prototype for =E2=
=80=98init_IRQ=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/quirks.c:672:13: warning: no previous prototype for =E2=
=80=98early_platform_quirks=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/tsc.c:1499:15: warning: no previous prototype for =E2=80=
=98calibrate_delay_is_known=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/process.c:653:13: warning: no previous prototype for =E2=
=80=98arch_post_acpi_subsys_init=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/process.c:717:15: warning: no previous prototype for =E2=
=80=98arch_randomize_brk=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/process.c:784:6: warning: no previous prototype for =E2=
=80=98do_arch_prctl_common=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/reboot.c:869:6: warning: no previous prototype for =E2=80=
=98nmi_panic_self_stop=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/smp.c:176:27: warning: no previous prototype for =E2=80=
=98smp_reboot_interrupt=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/smp.c:260:28: warning: no previous prototype for =E2=80=
=98smp_reschedule_interrupt=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/smp.c:281:28: warning: no previous prototype for =E2=80=
=98smp_call_function_interrupt=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/smp.c:291:28: warning: no previous prototype for =E2=80=
=98smp_call_function_single_interrupt=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/ftrace.c:840:6: warning: no previous prototype for =E2=80=
=98arch_ftrace_update_trampoline=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/ftrace.c:934:7: warning: no previous prototype for =E2=80=
=98arch_ftrace_trampoline_func=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/ftrace.c:946:6: warning: no previous prototype for =E2=80=
=98arch_ftrace_trampoline_free=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/crash.c:114:6: warning: no previous prototype for =E2=80=
=98crash_smp_send_stop=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/crash.c:351:5: warning: no previous prototype for =E2=80=
=98crash_setup_memmap_entries=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/crash.c:424:5: warning: no previous prototype for =E2=80=
=98crash_load_segments=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/machine_kexec_64.c:372:7: warning: no previous prototype =
for =E2=80=98arch_kexec_kernel_image_load=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/paravirt-spinlocks.c:12:16: warning: no previous prototyp=
e for =E2=80=98__native_queued_spin_unlock=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/paravirt-spinlocks.c:18:6: warning: no previous prototype=
 for =E2=80=98pv_is_native_spin_unlock=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/paravirt-spinlocks.c:24:16: warning: no previous prototyp=
e for =E2=80=98__native_vcpu_is_preempted=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/paravirt-spinlocks.c:30:6: warning: no previous prototype=
 for =E2=80=98pv_is_native_vcpu_is_preempted=E2=80=99 [-Wmissing-prototypes=
]
> arch/x86/kernel/kvm.c:258:1: warning: no previous prototype for =E2=80=98=
do_async_page_fault=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/jailhouse.c:200:6: warning: no previous prototype for =E2=
=80=98jailhouse_paravirt=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/check.c:91:13: warning: no previous prototype for =E2=80=
=98setup_bios_corruption_check=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/check.c:139:6: warning: no previous prototype for =E2=80=
=98check_for_bios_corruption=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/devicetree.c:32:13: warning: no previous prototype for =
=E2=80=98early_init_dt_scan_chosen_arch=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/devicetree.c:42:13: warning: no previous prototype for =
=E2=80=98add_dtb=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/devicetree.c:108:6: warning: no previous prototype for =
=E2=80=98x86_of_pci_init=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/devicetree.c:314:13: warning: no previous prototype for =
=E2=80=98x86_dtb_init=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/tracepoint.c:16:5: warning: no previous prototype for =E2=
=80=98trace_pagefault_reg=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/tracepoint.c:22:6: warning: no previous prototype for =E2=
=80=98trace_pagefault_unreg=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/head64.c:113:22: warning: no previous prototype for =E2=
=80=98__startup_64=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/head64.c:262:15: warning: no previous prototype for =E2=
=80=98__startup_secondary_64=E2=80=99 [-Wmissing-prototypes]
> arch/x86/kernel/head64.c:350:12: warning: no previous prototype for =E2=
=80=98early_make_pgtable=E2=80=99 [-Wmissing-prototypes]
>=20
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> ---
>  arch/x86/include/asm/crash.h       | 1 +
>  arch/x86/include/asm/efi.h         | 2 --
>  arch/x86/include/asm/irq.h         | 7 +++++++
>  arch/x86/include/asm/irq_work.h    | 1 +
>  arch/x86/include/asm/kvm_para.h    | 1 +
>  arch/x86/include/asm/paravirt.h    | 5 +++++
>  arch/x86/include/asm/reboot.h      | 1 +
>  arch/x86/include/asm/setup.h       | 5 +++++
>  arch/x86/include/asm/sighandling.h | 5 +++++
>  arch/x86/include/asm/smp.h         | 6 ++++++
>  arch/x86/include/asm/traps.h       | 4 ++++
>  arch/x86/include/asm/tsc.h         | 1 +
>  arch/x86/kernel/check.c            | 3 ++-
>  arch/x86/kernel/crash.c            | 1 +
>  arch/x86/kernel/devicetree.c       | 1 +
>  arch/x86/kernel/jailhouse.c        | 1 +
>  arch/x86/kernel/process.c          | 3 +++
>  arch/x86/kernel/quirks.c           | 1 +
>  arch/x86/kernel/tracepoint.c       | 1 +
>  include/linux/efi.h                | 2 ++
>  include/linux/ftrace.h             | 3 +++
>  include/linux/kexec.h              | 1 +
>  include/linux/of_fdt.h             | 1 +
>  include/linux/ptrace.h             | 1 +
>  24 files changed, 55 insertions(+), 3 deletions(-)

Breaks 32-bit compilation:

./arch/x86/include/asm/setup.h: Assembler messages:
./arch/x86/include/asm/setup.h:30: Error: no such instruction: `unsigned lo=
ng __startup_64(unsigned long physaddr,struct boot_params *bp)'

I'll skip the setup.h bits - let's hope that's the only bug.

Thanks,

	Ingo

--=20
You received this message because you are subscribed to the Google Groups "=
Jailhouse" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to jailhouse-dev+unsubscribe@googlegroups.com.
For more options, visit https://groups.google.com/d/optout.
