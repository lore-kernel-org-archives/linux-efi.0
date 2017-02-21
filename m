From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 4/4] KVM: VMX: Simplify segment_base
Date: Tue, 21 Feb 2017 05:28:18 -0500 (EST)
Message-ID: <211929849.24027362.1487672898147.JavaMail.zimbra@redhat.com>
References: <20170214194259.75960-1-thgarnie@google.com> <CAJcbSZESdSQncHeKNVzHO90W7UJUKxKGy-h+rM82OhBc-Nh=cg@mail.gmail.com> <CALMp9eQAZchjpgmqP1=qj-FXka8+Xbwqiu3xDz9KoLQ60nh-UQ@mail.gmail.com> <CAJcbSZEkqFPVNzygmAjkyxNssZxnJTYBYuMbvjms+3ZGcCY_sQ@mail.gmail.com> <CALCETrV4JqVfHQhz4EuFKfHXK=zABsmwZpgz4ijz89O8v4GdfA@mail.gmail.com> <CAJcbSZHh+q-hSk9XHZuEfE9VWUTdNZHFEbf68=Qk4uPhB2jhoQ@mail.gmail.com> <CAJcbSZEPHBK5FfbU5uorQVkpVbENG0ZBdiA=acJ10rqtLn+TwQ@mail.gmail.com> <20170221080332.GB3125@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-hardening-return-6794-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170221080332.GB3125@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@amacapital.net>, Jim Mattson <jmattson@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Paul Gortmaker <paul.gortmaker@windriver.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jg>
List-Id: linux-efi@vger.kernel.org


> Paolo, how stable, non-rebasing are the KVM tree commits?

Whatever ends in linux-next is stable.  I have a separate rebasing branch,
but it's not part of linux-next by design.

> Or should we keep Andy's KVM patches together with the GDT patches? Either
> workflow works for me - it's your call as these are predominantly KVM
> changes.

I'll delay my pull request to Linus a couple days so that I can test
Andy's 6 patches. Then you can just base your branch on Linus's tree.

Paolo
