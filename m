From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2 3/3] x86: Make the GDT remapping read-only on 64 bit
Date: Wed, 1 Feb 2017 21:14:26 -0800
Message-ID: <CALCETrU=KY7QgdLWm43LA=_jpu_oXJgGLqv0yUVr4vR7ROYh0Q@mail.gmail.com>
References: <20170126165940.30799-1-thgarnie@google.com> <20170126165940.30799-3-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6222-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170126165940.30799-3-thgarnie@google.com>
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Christian Borntraeger <borntraeger@de.ibm.com>, Fenghua Yu <fenghua.yu@intel.com>, He Chen <he.chen@linux.intel.com>, Brian
List-Id: linux-efi@vger.kernel.org

On Thu, Jan 26, 2017 at 8:59 AM, Thomas Garnier <thgarnie@google.com> wrote:
> This patch makes the GDT remapped pages read-only to prevent corruption.
> This change is done only on 64 bit.
>
> The native_load_tr_desc function was adapted to correctly handle a
> read-only GDT. The LTR instruction always writes to the GDT TSS entry.
> This generates a page fault if the GDT is read-only. This change checks
> if the current GDT is a remap and swap GDTs as needed. This function was
> tested by booting multiple machines and checking hibernation works
> properly.
>
> KVM SVM and VMX were adapted to use the writeable GDT. On VMX, the
> per-cpu variable was removed for functions to fetch the original GDT.
> Instead of reloading the previous GDT, VMX will reload the fixmap GDT as
> expected. For testing, VMs were started and restored on multiple
> configurations.
>
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
> Based on next-20170125
> ---
>  arch/x86/include/asm/desc.h      | 46 +++++++++++++++++++++++++++++++++++-----
>  arch/x86/include/asm/processor.h |  1 +
>  arch/x86/kernel/cpu/common.c     | 28 ++++++++++++++++++------
>  arch/x86/kvm/svm.c               |  4 +---
>  arch/x86/kvm/vmx.c               | 15 +++++--------
>  5 files changed, 70 insertions(+), 24 deletions(-)
>
> diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
> index 4cc176f57b78..ca7b2224fcb4 100644
> --- a/arch/x86/include/asm/desc.h
> +++ b/arch/x86/include/asm/desc.h
> @@ -52,6 +52,12 @@ static inline struct desc_struct *get_cpu_direct_gdt(unsigned int cpu)
>         return per_cpu(gdt_page, cpu).gdt;
>  }
>
> +/* Provide the current original GDT */
> +static inline struct desc_struct *get_current_direct_gdt(void)
> +{
> +       return this_cpu_ptr(&gdt_page)->gdt;
> +}

I'm assuming that the reason that this isn't part of patch 2 and used
instead of the version that takes cpu as a parameter is that TLS
doesn't work until the GDT is set up.  If so, perhaps that's worthy of
a comment in patch 2.

But give this_cpu_read(gdt_page.gdt) a try, please.

> +/*
> + * The LTR instruction marks the TSS GDT entry as busy. In 64bit, the GDT is
> + * a read-only remapping. To prevent a page fault, the GDT is switched to the
> + * original writeable version when needed.
> + */
> +#ifdef CONFIG_X86_64
> +static inline void native_load_tr_desc(void)
> +{
> +       struct desc_ptr gdt;
> +       int cpu = raw_smp_processor_id();
> +       bool restore = false;
> +       struct desc_struct *fixmap_gdt;
> +
> +       native_store_gdt(&gdt);

Off the top of my head, this is something like 10 cycles.  IMO that's
fast enough not to worry about the regression this will cause to KVM
exits.  In any event, we'll get that back and *much* more when we do
the optimizations that this series enables.
