From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v2 1/2] compiler-gcc.h: add gnu_inline to all inline declarations
Date: Tue, 5 Jun 2018 10:55:38 -0700
Message-ID: <CAKwvOdkkCxNHJKBVPJfixn1gO4PjT9VAynXX0m4KBD+YfLUo5Q@mail.gmail.com>
References: <20180605170532.170361-1-ndesaulniers@google.com>
 <20180605170532.170361-2-ndesaulniers@google.com> <202492204c2d5bd5ca27307cbca5e44673b739ed.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <202492204c2d5bd5ca27307cbca5e44673b739ed.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: joe@perches.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, akataria@vmware.com, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, Cao jin <caoj.fnst@cn.fujitsu.com>, Greg KH <gregkh@linuxfoundation.org>, hpa@zytor.com, "J. Kiszka" <jan.kiszka@siemens.com>, jarkko.sakkinen@linux.intel.com, jgross@suse.com, Josh Poimboeuf <jpoimboe@redhat.com>, kirill.shutemov@linux.intel.com, mingo@redhat.com, mjg59@google.com, Matthias Kaehlcke <mka@chromium.org>, Philippe Ombredanne <pombredanne@nexb.com>, rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>, thomas.lendacky@amd.com, Thiebaud Weksteen <tweek@google.com>, linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, virtua
List-Id: linux-efi@vger.kernel.org

On Tue, Jun 5, 2018 at 10:23 AM Joe Perches <joe@perches.com> wrote:
> On Tue, 2018-06-05 at 10:05 -0700, Nick Desaulniers wrote:
> >  #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) ||             \
> >      !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
> > -#define inline inline                __attribute__((always_inline,unused)) notrace
> > -#define __inline__ __inline__        __attribute__((always_inline,unused)) notrace
> > -#define __inline __inline    __attribute__((always_inline,unused)) notrace
> > +#define inline \
> > +     inline __attribute__((always_inline, unused, gnu_inline)) notrace
> > +#define __inline__ \
> > +     __inline__ __attribute__((always_inline, unused, gnu_inline)) notrace
> > +#define __inline \
> > +     __inline __attribute__((always_inline, unused, gnu_inline)) notrace
>
> Perhaps these are simpler as
>
> #define __inline__      inline
> #define __inline        inline
>
> >  #else
> >  /* A lot of inline functions can cause havoc with function tracing */
> > -#define inline inline                __attribute__((unused)) notrace
> > -#define __inline__ __inline__        __attribute__((unused)) notrace
> > -#define __inline __inline    __attribute__((unused)) notrace
> > +#define inline inline                __attribute__((unused, gnu_inline)) notrace
> > +#define __inline__ __inline__        __attribute__((unused, gnu_inline)) notrace
> > +#define __inline __inline    __attribute__((unused, gnu_inline)) notrace
> >  #endif
>
> And only set once along with:
>
> >  #define __always_inline      inline __attribute__((always_inline))
>
> And perhaps this __always_inline should be updated
> with gnu_inline as well
>

Great idea, I'll pick this up and add you to the Suggested-by: tag in
v3. Thanks Joe!
-- 
Thanks,
~Nick Desaulniers
