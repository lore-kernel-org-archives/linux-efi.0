From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v3 1/4] x86/mm: Adapt MODULES_END based on Fixmap section
 size
Date: Wed, 15 Feb 2017 16:49:21 +0100
Message-ID: <20170215154921.5xgrifrg54ssq7lr@pd.tnic>
References: <20170214194259.75960-1-thgarnie@google.com>
 <20170215135824.tflwuf3esu2npwwo@pd.tnic>
 <CAJcbSZEsCzBQEFELm1wbc4DP2=dZTCFYfsb-eX0ifoCKF4EQUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-6695-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <CAJcbSZEsCzBQEFELm1wbc4DP2=dZTCFYfsb-eX0ifoCKF4EQUw@mail.gmail.com>
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andy Lutomirski <luto@amacapital.net>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Christian Borntraeger <borntraeger@de.ibm.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, He Chen <he.chen@linux.inte>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 15, 2017 at 07:40:51AM -0800, Thomas Garnier wrote:
> Why do you think they rely on it being static? The VSYSCALL address is
> not changed for example.

I don't know, that's why I'm asking first. Userspace is known to pick
different aspects of the kernel and deciding to use them for whatever.
And once it relies on that, there's no changing it.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
