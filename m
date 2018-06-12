From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v4 1/3] compiler-gcc.h: add gnu_inline to all inline declarations
Date: Tue, 12 Jun 2018 11:33:14 -0700
Message-ID: <CAKwvOdmxFHfkj81YAXa8fE86fC+k+KvqMvgk4=e62pNCcXbKOg@mail.gmail.com>
References: <20180607204927.219329-1-ndesaulniers@google.com>
 <20180607204927.219329-2-ndesaulniers@google.com> <CAK8P3a0yi+MrOS=+pjCeUu==YBE_AppB8vfqdsQS-1NpSO2c4A@mail.gmail.com>
 <CA+icZUXDoeo5ktZZPFcFyLzk3xthM-98N88QJFzesg6t+Vr5cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+icZUXDoeo5ktZZPFcFyLzk3xthM-98N88QJFzesg6t+Vr5cQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: sedat.dilek@gmail.com, Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com, mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, virtualization@lists.linux-foundation.org, Alistair Strachan <astrachan@google.com>, Manoj Gupta <manojgupta@google.com>, Greg Hackmann <ghackmann@google.com>, tstellar@redhat.com, Kees Cook <keescook@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, geert@linux-m68k.org, Will Deacon <will.deacon@arm.com>, mawilcox@microsoft.com, David Rientjes <rientjes@google.com>, acme@redhat.com, Philippe Ombredanne <pombredanne@nexb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 8, 2018 at 3:04 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Fri, Jun 8, 2018 at 9:59 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thu, Jun 7, 2018 at 10:49 PM, Nick Desaulniers
> > <ndesaulniers@google.com> wrote:
> >> Functions marked extern inline do not emit an externally visible
> >> function when the gnu89 C standard is used. Some KBUILD Makefiles
> >> overwrite KBUILD_CFLAGS. This is an issue for GCC 5.1+ users as without
> >> an explicit C standard specified, the default is gnu11. Since c99, the
> >> semantics of extern inline have changed such that an externally visible
> >> function is always emitted. This can lead to multiple definition errors
> >> of extern inline functions at link time of compilation units whose build
> >> files have removed an explicit C standard compiler flag for users of GCC
> >> 5.1+ or Clang.
> >>
> >> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> >> Suggested-by: H. Peter Anvin <hpa@zytor.com>
> >> Suggested-by: Joe Perches <joe@perches.com>
> >
> > I suspect this will break Geert's gcc-4.1.2, which I think doesn't have that
> > attribute yet (4.1.3 or higher have it according to the documentation.
> >
> > It wouldn't be hard to work around that if we want to keep that version
> > working, or we could decide that it's time to officially stop supporting
> > that version, but we should probably decide on one or the other.

Heh, so earlier we decided against compiler flags (-std=gnu89 or
-fgnu89-inline) in preference to function attributes.  The function
attribute is preferable as some of the Makefiles [accidentally?]
overwrite KBUILD_CFLAGS, which is problematic for gcc 5.1 users as the
implicit c standard used was changed to gnu11 from gnu89.  What's nice
is that to support gcc 4.1 users, we simply don't need to add any
attribute, as their implicit c standard is gnu89 which has the
semantics for extern inline that we want.  I have a simple change to
this patch that can support users of various gcc versions, see below:

> Good point.
> What is the minimum requirement of GCC version currently?
> AFAICS x86/asm-goto support requires GCC >= 4.5?

Yes, but that's only for x86, IIUC.  It seems the kernel may have
different minimum required versions of GCC based on arch then?  That
may be ok, but I'm not sure that's easy to keep track of without
having it explicitly stated somewhere like the docs perhaps?

> Just FYI...
> ...saw the last days in upstream commits that kbuild/kconfig for
> 4.18-rc1 offers possibilities to check for cc-version dependencies.

Those will be helpful.  If we want to pursue compiler flags, which get
set some Makefiles, then yes.  But I think a simpler change to my
patch would be as below.

It seems gcc did not get __has_attribute [0] until 5.1, but will
define __GNUC_GNU_INLINE__ if supported. [1]  Unfortunately, Clang
does not define __GNUC_GNU_INLINE__ [2].  So a proper feature test
might look like:

```
#ifndef __has_attribute
#define __has_attribute(x) 0
#endif

#if defined(__GNUC_GNU_INLINE__) || __has_attribute(gnu_inline)
#define __gnu_inline __attribute__(gnu_inline)
#endif

#define inline inline __attribute__((always_inline, unused)) notrace
__gnu_inline
```

Thoughts on this approach? I can send a v5 tomorrow if there's no
major issues.  Feedback appreciated, as always.

[0] https://clang.llvm.org/docs/LanguageExtensions.html#has-attribute
[1] https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#Common-Function-Attributes
[2] https://bugs.llvm.org/show_bug.cgi?id=37784
-- 
Thanks,
~Nick Desaulniers
