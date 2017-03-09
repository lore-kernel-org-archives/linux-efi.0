From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v5 3/3] x86: Make the GDT remapping read-only on 64-bit
Date: Thu, 9 Mar 2017 13:35:13 -0800
Message-ID: <CALCETrWx9tzmBUthonB_OwMrL6xGd_RbVu+L0v0ohS-kzcBbtw@mail.gmail.com>
References: <20170306220348.79702-1-thgarnie@google.com> <20170306220348.79702-3-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170306220348.79702-3-thgarnie@google.com>
Sender: owner-linux-mm@kvack.org
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Juergen Gross <jgross@suse.com>, Lorenzo Stoakes <lstoakes@gmail.com>, Andy Lutomirski <luto@kernel.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, zijun_hu <zijun_hu@htc.com>, Chris Wilson <chris@chris-wilson.co.uk>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.os>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 6, 2017 at 2:03 PM, Thomas Garnier <thgarnie@google.com> wrote:
> This patch makes the GDT remapped pages read-only to prevent corruption.
> This change is done only on 64-bit.
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

I like this patch.

> +
> +/*
> + * The LTR instruction marks the TSS GDT entry as busy. On 64-bit, the GDT is
> + * a read-only remapping. To prevent a page fault, the GDT is switched to the
> + * original writeable version when needed.
> + */
> +#ifdef CONFIG_X86_64
>  static inline void native_load_tr_desc(void)
>  {
> +       struct desc_ptr gdt;
> +       int cpu = raw_smp_processor_id();
> +       bool restore = 0;
> +       struct desc_struct *fixmap_gdt;
> +
> +       native_store_gdt(&gdt);

This part will slow this function down considerably, but with the
recent KVM improvements, I think that there are no callers left that
care about performance, so this should be fine.

--Andy

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
