From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 4/4] KVM: VMX: Simplify segment_base
Date: Tue, 14 Feb 2017 19:57:21 -0800
Message-ID: <CALCETrXDQaWyo02b2q7JN3W1frR0QAOy1Wj_ft5YpPbEbZEfPw@mail.gmail.com>
References: <20170214194259.75960-1-thgarnie@google.com> <20170214194259.75960-4-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6677-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170214194259.75960-4-thgarnie@google.com>
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Paul Gortmaker <paul.gortmaker@windriver.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Christian Borntraeger <borntraeger@de.ibm.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, He Chen <he.chen@linux.intel.com>B
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 14, 2017 at 11:42 AM, Thomas Garnier <thgarnie@google.com> wrote:
> The KVM segment_base function is confusing. This patch replaces integers
> with appropriate flags, simplify constructs and add comments.

It could pay to put this first in the series, but last is probably fine, too.

>
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
> Based on next-20170213
> ---
>  arch/x86/kvm/vmx.c | 26 ++++++++++++++++++--------
>  1 file changed, 18 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 99167f20bc34..edb8326108dd 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -2062,25 +2062,35 @@ static unsigned long segment_base(u16 selector)
>         struct desc_struct *d;
>         unsigned long table_base;

This should go away IMO.  It should be struct desc_struct *table;

> +               table_base = get_current_gdt_rw_vaddr();

Then this can go away, too, and you can stop having the silly
get_current_gdt_rw_vaddr() function at all.

> +       d = (struct desc_struct *)table_base + (selector >> 3);

And this cast goes away too.
