From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 3/3] x86: Make the GDT remapping read-only on 64 bit
Date: Thu, 2 Feb 2017 08:12:25 +0100
Message-ID: <20170202071225.GB2368@gmail.com>
References: <20170126165940.30799-1-thgarnie@google.com>
 <20170126165940.30799-3-thgarnie@google.com>
 <20170201091534.GA25025@gmail.com>
 <CALCETrU_WPm+HonkiRtaO0kTTqkfAcyhANp22yPGiSAPkNsRGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-6224-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Content-Disposition: inline
In-Reply-To: <CALCETrU_WPm+HonkiRtaO0kTTqkfAcyhANp22yPGiSAPkNsRGQ@mail.gmail.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Arjan van de Ven <arjan@linux.intel.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Christian Borntraeger <borntraeger@de.ibm.com>, Fenghua Yu <fenghua.yu@intel.com>, He Chen <he.chen@linux.intel.com>Br
List-Id: linux-efi@vger.kernel.org


* Andy Lutomirski <luto@kernel.org> wrote:

> On Wed, Feb 1, 2017 at 1:15 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Thomas Garnier <thgarnie@google.com> wrote:
> >
> >> This patch makes the GDT remapped pages read-only to prevent corruption.
> >> This change is done only on 64 bit.
> >
> 
> 
> >>
> >> -     table_base = gdt->address;
> >> +     table_base = (unsigned long)get_current_direct_gdt();
> >
> > Instead of spreading these type casts far and wide please introduce another
> > accessor the returns 'unsigned long':
> >
> >         get_cpu_gdt_rw_vaddr()
> >
> 
> That whole function is an abomination.  How about replacing 'unsigned
> long table_base' with 'struct desc_struct *table'?  If you're feeling
> really adventurous, *delete* that function and replace all of its
> users with something sane.

Yeah, even better!

Thanks,

	Ingo
