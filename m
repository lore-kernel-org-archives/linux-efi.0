From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 19/27] x86: assembly, make some functions local
Date: Mon, 2 Oct 2017 13:48:26 +0100
Message-ID: <CAKv+Gu9C88ToAx+8KcGacUECo7ExnTTBmibEjpB2WkfFvjoZvw@mail.gmail.com>
References: <20171002091246.28432-1-jslaby@suse.cz> <20171002091246.28432-19-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002091246.28432-19-jslaby-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Cc: "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xen-devel <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2 October 2017 at 10:12, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org> wrote:
> There is a couple of assembly functions, which are invoked only locally
> in the file they are defined. In C, we mark them "static". In assembly,
> annotate them using SYM_{FUNC,CODE}_START_LOCAL (and switch their
> ENDPROC to SYM_{FUNC,CODE}_END too). Whether FUNC or CODE depends on
> ENDPROC/END for a particular function (C or non-C).
>

I wasn't cc'ed on the cover letter, so I am missing the rationale of
replacing ENTRY/ENDPROC with other macros.


> Signed-off-by: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
> ---
>  arch/x86/boot/compressed/efi_thunk_64.S |  8 ++++----
>  arch/x86/entry/entry_64.S               | 25 +++++++++++++------------
>  arch/x86/lib/copy_page_64.S             |  4 ++--
>  arch/x86/lib/memcpy_64.S                | 12 ++++++------
>  arch/x86/lib/memset_64.S                |  8 ++++----
>  arch/x86/platform/efi/efi_thunk_64.S    | 12 ++++++------
>  arch/x86/xen/xen-pvh.S                  |  4 ++--
>  7 files changed, 37 insertions(+), 36 deletions(-)
>
> diff --git a/arch/x86/boot/compressed/efi_thunk_64.S b/arch/x86/boot/compressed/efi_thunk_64.S
> index 86528f120962..c072711d8d62 100644
> --- a/arch/x86/boot/compressed/efi_thunk_64.S
> +++ b/arch/x86/boot/compressed/efi_thunk_64.S
> @@ -98,12 +98,12 @@ ENTRY(efi64_thunk)
>         ret
>  ENDPROC(efi64_thunk)
>
> -ENTRY(efi_exit32)
> +SYM_FUNC_START_LOCAL(efi_exit32)
>         movq    func_rt_ptr(%rip), %rax
>         push    %rax
>         mov     %rdi, %rax
>         ret
> -ENDPROC(efi_exit32)
> +SYM_FUNC_END(efi_exit32)
>
>         .code32
>  /*
> @@ -111,7 +111,7 @@ ENDPROC(efi_exit32)
>   *
>   * The stack should represent the 32-bit calling convention.
>   */
> -ENTRY(efi_enter32)
> +SYM_FUNC_START_LOCAL(efi_enter32)
>         movl    $__KERNEL_DS, %eax
>         movl    %eax, %ds
>         movl    %eax, %es
> @@ -171,7 +171,7 @@ ENTRY(efi_enter32)
>         btsl    $X86_CR0_PG_BIT, %eax
>         movl    %eax, %cr0
>         lret
> -ENDPROC(efi_enter32)
> +SYM_FUNC_END(efi_enter32)
>
>         .data
>         .balign 8
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 509504db0e2a..ff4964dac2dc 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -324,7 +324,7 @@ opportunistic_sysret_failed:
>         jmp     restore_c_regs_and_iret
>  END(entry_SYSCALL_64)
>
> -ENTRY(stub_ptregs_64)
> +SYM_CODE_START_LOCAL(stub_ptregs_64)
>         /*
>          * Syscalls marked as needing ptregs land here.
>          * If we are on the fast path, we need to save the extra regs,
> @@ -349,7 +349,7 @@ ENTRY(stub_ptregs_64)
>
>  1:
>         jmp     *%rax                           /* Called from C */
> -END(stub_ptregs_64)
> +SYM_CODE_END(stub_ptregs_64)
>
>  .macro ptregs_stub func
>  ENTRY(ptregs_\func)
> @@ -976,7 +976,8 @@ idtentry hypervisor_callback xen_do_hypervisor_callback has_error_code=0
>   * existing activation in its critical region -- if so, we pop the current
>   * activation and restart the handler using the previous one.
>   */
> -ENTRY(xen_do_hypervisor_callback)              /* do_hypervisor_callback(struct *pt_regs) */
> +/* do_hypervisor_callback(struct *pt_regs) */
> +SYM_CODE_START_LOCAL(xen_do_hypervisor_callback)
>
>  /*
>   * Since we don't modify %rdi, evtchn_do_upall(struct *pt_regs) will
> @@ -994,7 +995,7 @@ ENTRY(xen_do_hypervisor_callback)           /* do_hypervisor_callback(struct *pt_regs) */
>         call    xen_maybe_preempt_hcall
>  #endif
>         jmp     error_exit
> -END(xen_do_hypervisor_callback)
> +SYM_CODE_END(xen_do_hypervisor_callback)
>
>  /*
>   * Hypervisor uses this for application faults while it executes.
> @@ -1078,7 +1079,7 @@ idtentry machine_check                                    has_error_code=0        paranoid=1 do_sym=*machine_check_vec
>   * Use slow, but surefire "are we in kernel?" check.
>   * Return: ebx=0: need swapgs on exit, ebx=1: otherwise
>   */
> -ENTRY(paranoid_entry)
> +SYM_CODE_START_LOCAL(paranoid_entry)
>         UNWIND_HINT_FUNC
>         cld
>         SAVE_C_REGS 8
> @@ -1092,7 +1093,7 @@ ENTRY(paranoid_entry)
>         SWAPGS
>         xorl    %ebx, %ebx
>  1:     ret
> -END(paranoid_entry)
> +SYM_CODE_END(paranoid_entry)
>
>  /*
>   * "Paranoid" exit path from exception stack.  This is invoked
> @@ -1106,7 +1107,7 @@ END(paranoid_entry)
>   *
>   * On entry, ebx is "no swapgs" flag (1: don't need swapgs, 0: need it)
>   */
> -ENTRY(paranoid_exit)
> +SYM_CODE_START_LOCAL(paranoid_exit)
>         UNWIND_HINT_REGS
>         DISABLE_INTERRUPTS(CLBR_ANY)
>         TRACE_IRQS_OFF_DEBUG
> @@ -1122,13 +1123,13 @@ paranoid_exit_restore:
>         RESTORE_C_REGS
>         REMOVE_PT_GPREGS_FROM_STACK 8
>         INTERRUPT_RETURN
> -END(paranoid_exit)
> +SYM_CODE_END(paranoid_exit)
>
>  /*
>   * Save all registers in pt_regs, and switch gs if needed.
>   * Return: EBX=0: came from user mode; EBX=1: otherwise
>   */
> -ENTRY(error_entry)
> +SYM_CODE_START_LOCAL(error_entry)
>         UNWIND_HINT_FUNC
>         cld
>         SAVE_C_REGS 8
> @@ -1205,7 +1206,7 @@ ENTRY(error_entry)
>         mov     %rax, %rsp
>         decl    %ebx
>         jmp     .Lerror_entry_from_usermode_after_swapgs
> -END(error_entry)
> +SYM_CODE_END(error_entry)
>
>
>  /*
> @@ -1213,14 +1214,14 @@ END(error_entry)
>   *   1: already in kernel mode, don't need SWAPGS
>   *   0: user gsbase is loaded, we need SWAPGS and standard preparation for return to usermode
>   */
> -ENTRY(error_exit)
> +SYM_CODE_START_LOCAL(error_exit)
>         UNWIND_HINT_REGS
>         DISABLE_INTERRUPTS(CLBR_ANY)
>         TRACE_IRQS_OFF
>         testl   %ebx, %ebx
>         jnz     retint_kernel
>         jmp     retint_user
> -END(error_exit)
> +SYM_CODE_END(error_exit)
>
>  /* Runs on exception stack */
>  /* XXX: broken on Xen PV */
> diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
> index e8508156c99d..e1ee50bc161a 100644
> --- a/arch/x86/lib/copy_page_64.S
> +++ b/arch/x86/lib/copy_page_64.S
> @@ -20,7 +20,7 @@ ENTRY(copy_page)
>  ENDPROC(copy_page)
>  EXPORT_SYMBOL(copy_page)
>
> -ENTRY(copy_page_regs)
> +SYM_FUNC_START_LOCAL(copy_page_regs)
>         subq    $2*8,   %rsp
>         movq    %rbx,   (%rsp)
>         movq    %r12,   1*8(%rsp)
> @@ -85,4 +85,4 @@ ENTRY(copy_page_regs)
>         movq    1*8(%rsp), %r12
>         addq    $2*8, %rsp
>         ret
> -ENDPROC(copy_page_regs)
> +SYM_FUNC_END(copy_page_regs)
> diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
> index 4911b1c61aa8..728703c47d58 100644
> --- a/arch/x86/lib/memcpy_64.S
> +++ b/arch/x86/lib/memcpy_64.S
> @@ -27,7 +27,7 @@
>   * rax original destination
>   */
>  SYM_FUNC_START_ALIAS(__memcpy)
> -ENTRY(memcpy)
> +SYM_FUNC_START_LOCAL(memcpy)
>         ALTERNATIVE_2 "jmp memcpy_orig", "", X86_FEATURE_REP_GOOD, \
>                       "jmp memcpy_erms", X86_FEATURE_ERMS
>
> @@ -39,7 +39,7 @@ ENTRY(memcpy)
>         movl %edx, %ecx
>         rep movsb
>         ret
> -ENDPROC(memcpy)
> +SYM_FUNC_END(memcpy)
>  SYM_FUNC_END_ALIAS(__memcpy)
>  EXPORT_SYMBOL(memcpy)
>  EXPORT_SYMBOL(__memcpy)
> @@ -48,14 +48,14 @@ EXPORT_SYMBOL(__memcpy)
>   * memcpy_erms() - enhanced fast string memcpy. This is faster and
>   * simpler than memcpy. Use memcpy_erms when possible.
>   */
> -ENTRY(memcpy_erms)
> +SYM_FUNC_START_LOCAL(memcpy_erms)
>         movq %rdi, %rax
>         movq %rdx, %rcx
>         rep movsb
>         ret
> -ENDPROC(memcpy_erms)
> +SYM_FUNC_END(memcpy_erms)
>
> -ENTRY(memcpy_orig)
> +SYM_FUNC_START_LOCAL(memcpy_orig)
>         movq %rdi, %rax
>
>         cmpq $0x20, %rdx
> @@ -180,7 +180,7 @@ ENTRY(memcpy_orig)
>
>  .Lend:
>         retq
> -ENDPROC(memcpy_orig)
> +SYM_FUNC_END(memcpy_orig)
>
>  #ifndef CONFIG_UML
>  /*
> diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
> index 0d3a1d341e60..c63ae9987612 100644
> --- a/arch/x86/lib/memset_64.S
> +++ b/arch/x86/lib/memset_64.S
> @@ -58,16 +58,16 @@ EXPORT_SYMBOL(__memset)
>   *
>   * rax   original destination
>   */
> -ENTRY(memset_erms)
> +SYM_FUNC_START_LOCAL(memset_erms)
>         movq %rdi,%r9
>         movb %sil,%al
>         movq %rdx,%rcx
>         rep stosb
>         movq %r9,%rax
>         ret
> -ENDPROC(memset_erms)
> +SYM_FUNC_END(memset_erms)
>
> -ENTRY(memset_orig)
> +SYM_FUNC_START_LOCAL(memset_orig)
>         movq %rdi,%r10
>
>         /* expand byte value  */
> @@ -138,4 +138,4 @@ ENTRY(memset_orig)
>         subq %r8,%rdx
>         jmp .Lafter_bad_alignment
>  .Lfinal:
> -ENDPROC(memset_orig)
> +SYM_FUNC_END(memset_orig)
> diff --git a/arch/x86/platform/efi/efi_thunk_64.S b/arch/x86/platform/efi/efi_thunk_64.S
> index ff85d28c50f2..d18697df1fe9 100644
> --- a/arch/x86/platform/efi/efi_thunk_64.S
> +++ b/arch/x86/platform/efi/efi_thunk_64.S
> @@ -66,7 +66,7 @@ ENDPROC(efi64_thunk)
>   *
>   * This function must be invoked with a 1:1 mapped stack.
>   */
> -ENTRY(__efi64_thunk)
> +SYM_FUNC_START_LOCAL(__efi64_thunk)
>         movl    %ds, %eax
>         push    %rax
>         movl    %es, %eax
> @@ -113,14 +113,14 @@ ENTRY(__efi64_thunk)
>         or      %rcx, %rax
>  1:
>         ret
> -ENDPROC(__efi64_thunk)
> +SYM_FUNC_END(__efi64_thunk)
>
> -ENTRY(efi_exit32)
> +SYM_FUNC_START_LOCAL(efi_exit32)
>         movq    func_rt_ptr(%rip), %rax
>         push    %rax
>         mov     %rdi, %rax
>         ret
> -ENDPROC(efi_exit32)
> +SYM_FUNC_END(efi_exit32)
>
>         .code32
>  /*
> @@ -128,7 +128,7 @@ ENDPROC(efi_exit32)
>   *
>   * The stack should represent the 32-bit calling convention.
>   */
> -ENTRY(efi_enter32)
> +SYM_FUNC_START_LOCAL(efi_enter32)
>         movl    $__KERNEL_DS, %eax
>         movl    %eax, %ds
>         movl    %eax, %es
> @@ -144,7 +144,7 @@ ENTRY(efi_enter32)
>         pushl   %eax
>
>         lret
> -ENDPROC(efi_enter32)
> +SYM_FUNC_END(efi_enter32)
>
>         .data
>         .balign 8
> diff --git a/arch/x86/xen/xen-pvh.S b/arch/x86/xen/xen-pvh.S
> index 1b78837bad06..ba5aad3b3d6a 100644
> --- a/arch/x86/xen/xen-pvh.S
> +++ b/arch/x86/xen/xen-pvh.S
> @@ -54,7 +54,7 @@
>   * charge of setting up it's own stack, GDT and IDT.
>   */
>
> -ENTRY(pvh_start_xen)
> +SYM_CODE_START_LOCAL(pvh_start_xen)
>         cld
>
>         lgdt (_pa(gdt))
> @@ -133,7 +133,7 @@ ENTRY(pvh_start_xen)
>
>         ljmp $__BOOT_CS, $_pa(startup_32)
>  #endif
> -END(pvh_start_xen)
> +SYM_CODE_END(pvh_start_xen)
>
>         .section ".init.data","aw"
>         .balign 8
> --
> 2.14.2
>
