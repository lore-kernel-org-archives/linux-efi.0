From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v2 1/2] compiler-gcc.h: add gnu_inline to all inline declarations
Date: Thu, 7 Jun 2018 10:26:10 -0700
Message-ID: <CAKwvOdkUk7ZL8tXgBs0Y+0Y5NVebgAYne_qgdSWWDOvQaWFPhw@mail.gmail.com>
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
>
> On Tue, 2018-06-05 at 10:05 -0700, Nick Desaulniers wrote:
> > Functions marked extern inline do not emit an externally visible
> > function when the gnu89 C standard is used. Some KBUILD Makefiles
> > overwrite KBUILD_CFLAGS. This is an issue for GCC 5.1+ users as without
> > an explicit C standard specified, the default is gnu11. Since c99, the
> > semantics of extern inline have changed such that an externally visible
> > function is always emitted. This can lead to multiple definition errors
> > of extern inline functions at link time of compilation units whose build
> > files have removed an explicit C standard compiler flag for users of GCC
> > 5.1+ or Clang.
> []
> > diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> []
> > @@ -72,17 +72,24 @@
> >   * -Wunused-function.  This turns out to avoid the need for complex #ifdef
> >   * directives.  Suppress the warning in clang as well by using "unused"
> >   * function attribute, which is redundant but not harmful for gcc.
> > + * Prefer gnu_inline, so that extern inline functions do not emit an
> > + * externally visible function. This makes extern inline behave as per gnu89
> > + * semantics rather than c99. This prevents multiple symbol definition errors
> > + * of extern inline functions at link time.
> >   */
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

Working on this now, going to push v3 soon.  I was wondering more
about these definitions of inline.

Probably want:

#define __inline__ __inline__ inline
#define __inline __inline inline

These are the only references I found to:

__inline__: https://gcc.gnu.org/onlinedocs/gcc/Inline.html
__inline: http://www.keil.com/support/man/docs/armcc/armcc_chr1359124967692.htm

The commit that introduced them was:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a1365647022eb05a5993f270a78e9bef3bf554eb
which was an interesting read.

I get the feeling that the use of __inline__ or __inline (vs inline)
in the kernel may be wrong and their use should be eradicated in the
follow up patch set, but it would be cool if others have additional
insight.

This code in Clang seems to treat them all as the same:
https://github.com/llvm-mirror/clang/blob/1a597eeed3579b4320b62ff55150195482545992/lib/Lex/PPDirectives.cpp#L2285

-- 
Thanks,
~Nick Desaulniers
