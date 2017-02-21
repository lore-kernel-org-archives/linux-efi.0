From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 4/4] KVM: VMX: Simplify segment_base
Date: Tue, 21 Feb 2017 09:03:32 +0100
Message-ID: <20170221080332.GB3125@gmail.com>
References: <20170214194259.75960-1-thgarnie@google.com>
 <20170214194259.75960-4-thgarnie@google.com>
 <CALMp9eT_G_Mhsk1k7Xc8L+bnpFwTUoC=ae4LhB1ppqKynKEQ9g@mail.gmail.com>
 <CAJcbSZESdSQncHeKNVzHO90W7UJUKxKGy-h+rM82OhBc-Nh=cg@mail.gmail.com>
 <CALMp9eQAZchjpgmqP1=qj-FXka8+Xbwqiu3xDz9KoLQ60nh-UQ@mail.gmail.com>
 <CAJcbSZEkqFPVNzygmAjkyxNssZxnJTYBYuMbvjms+3ZGcCY_sQ@mail.gmail.com>
 <CALCETrV4JqVfHQhz4EuFKfHXK=zABsmwZpgz4ijz89O8v4GdfA@mail.gmail.com>
 <CAJcbSZHh+q-hSk9XHZuEfE9VWUTdNZHFEbf68=Qk4uPhB2jhoQ@mail.gmail.com>
 <CAJcbSZEPHBK5FfbU5uorQVkpVbENG0ZBdiA=acJ10rqtLn+TwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-6793-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJcbSZEPHBK5FfbU5uorQVkpVbENG0ZBdiA=acJ10rqtLn+TwQ@mail.gmail.com>
To: Thomas Garnier <thgarnie@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Jim Mattson <jmattson@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Paul Gortmaker <paul.gortmaker@windriver.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Lui
List-Id: linux-efi@vger.kernel.org


* Thomas Garnier <thgarnie@google.com> wrote:

> > Okay, I guess I will have to wait for it to be integrated to
> > linux-next then. Or would you rather to it after this patch set is
> > added?
> 
> Read your summary for the patchset of KVM cleanup, I will wait for it to reach 
> linux-next to rebase and send the new iteration.

Note that to be able to apply your readonly-GDT series to the x86 tree I'll need a 
stable SHA1 to base it on.

Paolo, how stable, non-rebasing are the KVM tree commits? Once Andy's patches hit 
the KVM tree I could pull from you and order it so that I'd send it to Linus only 
after you sent your bits upstream. That would save us 3 months of patch 
propagation latency.

Or should we keep Andy's KVM patches together with the GDT patches? Either 
workflow works for me - it's your call as these are predominantly KVM changes.

Thanks,

	Ingo
