From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v6 3/3] x86: paravirt: make native_save_fl extern inline
Date: Mon, 16 Jul 2018 10:27:04 -0700
Message-ID: <CAKwvOdmFVnSos71vAUnayuocBDhxLg76tvGF0y3sj+4+s7TCcw@mail.gmail.com>
References: <20180621162324.36656-1-ndesaulniers@google.com>
 <20180621162324.36656-4-ndesaulniers@google.com> <1e19dbef068b45a4a4e9eb4072e097be@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1e19dbef068b45a4a4e9eb4072e097be@AcuMS.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David.Laight@aculab.com
Cc: mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com, linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, virtualization@lists.linux-foundation.org, Alistair Strachan <astrachan@google.com>, Manoj Gupta <manojgupta@google.com>, Greg Hackmann <ghackmann@google.com>, sedat.dilek@gmail.com, tstellar@redhat.com, Kees Cook <keescook@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Will Deacon <will.deacon@arm.com>, mawilcox@microsoft.com, Arnd Bergmann <arnd@arndb.de>, David Rientjes <rientjes@google.com>, acme@redhat.com, Philippe
List-Id: linux-efi@vger.kernel.org

On Fri, Jul 13, 2018 at 3:15 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Nick Desaulniers
> > Sent: 21 June 2018 17:23
> >
> > native_save_fl() is marked static inline, but by using it as
> > a function pointer in arch/x86/kernel/paravirt.c, it MUST be outlined.
> >
> > paravirt's use of native_save_fl() also requires that no GPRs other than
> > %rax are clobbered.
> ...
> > diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
> > index 89f08955fff7..c4fc17220df9 100644
> > --- a/arch/x86/include/asm/irqflags.h
> > +++ b/arch/x86/include/asm/irqflags.h
> > @@ -13,7 +13,7 @@
> > * Interrupt control:
> > */
> >
> > -static inline unsigned long native_save_fl(void)
> > +extern inline unsigned long native_save_fl(void)
>
> This is generating a the compilation warning (that we treat as an error):
> "no previous prototype for 'native_save_fl".
> Fixable by replicating the line with an appended ;

Thanks for the report and sorry for breaking things for you.  Just
curious about more information to try to reproduce the issue to make
sure I fix the issue correctly:
* What compiler and compiler version are you using?
* Are you setting any configs or enabling any warning CFLAGS to see this?
* Do you see this warning for other `extern inline` functions? (It
seems like the few other ones in the kernel are for non-x86 archs)

I would have guessed that extern inline functions with gnu_inline
semantics (gnu89 behavior) should not have a previous declaration, but
it probably doesn't hurt to add it.
-- 
Thanks,
~Nick Desaulniers
