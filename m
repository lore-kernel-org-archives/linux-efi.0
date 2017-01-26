From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v2 2/3] x86: Remap GDT tables in the Fixmap section
Date: Thu, 26 Jan 2017 11:10:23 -0800
Message-ID: <CAJcbSZE7jnzdDSjOb7MsZZrO9UYRrhmUxwvNknhBkWiPBnvTDw@mail.gmail.com>
References: <20170126165940.30799-1-thgarnie@google.com> <20170126165940.30799-2-thgarnie@google.com>
 <CALCETrVCM5Ex2HWh64Lc8=jEyTCA4h9JiB0pMuZdZBEkjbChUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6178-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrVCM5Ex2HWh64Lc8=jEyTCA4h9JiB0pMuZdZBEkjbChUw@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Christian Borntraeger <borntraeger@de.ibm.com>, Fenghua Yu <fenghua.yu@intel.com>, He Chen <he.chen@linux.intel.com>, Brian
List-Id: linux-efi@vger.kernel.org

On Thu, Jan 26, 2017 at 10:52 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Jan 26, 2017 at 8:59 AM, Thomas Garnier <thgarnie@google.com> wrote:
>> Each processor holds a GDT in its per-cpu structure. The sgdt
>> instruction gives the base address of the current GDT. This address can
>> be used to bypass KASLR memory randomization. With another bug, an
>> attacker could target other per-cpu structures or deduce the base of
>> the main memory section (PAGE_OFFSET).
>>
>> This patch relocates the GDT table for each processor inside the
>> Fixmap section. The space is reserved based on number of supported
>> processors.
>>
>> For consistency, the remapping is done by default on 32 and 64 bit.
>>
>> Each processor switches to its remapped GDT at the end of
>> initialization. For hibernation, the main processor returns with the
>> original GDT and switches back to the remapping at completion.
>>
>> This patch was tested on both architectures. Hibernation and KVM were
>> both tested specially for their usage of the GDT.
>
> I like this version much better.  Thanks!

Thanks for the feedback! I like this version better too.

>
> --Andy



-- 
Thomas
