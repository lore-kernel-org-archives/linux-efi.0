From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v4 1/3] compiler-gcc.h: add gnu_inline to all inline declarations
Date: Tue, 12 Jun 2018 13:19:58 -0700
Message-ID: <CAKwvOdkeEqb0HnHoggpwmHiKtDo06VN0N_r9ffv0rzigNLvXUg@mail.gmail.com>
References: <20180607204927.219329-1-ndesaulniers@google.com>
 <20180607204927.219329-2-ndesaulniers@google.com> <CAK8P3a0yi+MrOS=+pjCeUu==YBE_AppB8vfqdsQS-1NpSO2c4A@mail.gmail.com>
 <CA+icZUXDoeo5ktZZPFcFyLzk3xthM-98N88QJFzesg6t+Vr5cQ@mail.gmail.com>
 <CAKwvOdmxFHfkj81YAXa8fE86fC+k+KvqMvgk4=e62pNCcXbKOg@mail.gmail.com> <201806121851.w5CIpTY7134381@mail.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201806121851.w5CIpTY7134381@mail.zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: hpa@zytor.com
Cc: sedat.dilek@gmail.com, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, virtualization@lists.linux-foundation.org, Alistair Strachan <astrachan@google.com>, Manoj Gupta <manojgupta@google.com>, Greg Hackmann <ghackmann@google.com>, tstellar@redhat.com, Kees Cook <keescook@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, geert@linux-m68k.org, Will Deacon <will.deacon@arm.com>, mawilcox@microsoft.com, David Rientjes <rientjes@google.com>, acme@redhat.com, Philippe Ombredanne <pombredanne@nexb.com>An
List-Id: linux-efi@vger.kernel.org

On Tue, Jun 12, 2018 at 11:51 AM H. Peter Anvin <hpa@zytor.com> wrote:
>
> <caoj.fnst@cn.fujitsu.com>,Greg KH <gregkh@linuxfoundation.org>,jarkko.sa=
kkinen@linux.intel.com,jgross@suse.com,Josh Poimboeuf <jpoimboe@redhat.com>=
,Matthias Kaehlcke <mka@chromium.org>,thomas.lendacky@amd.com,Thiebaud Weks=
teen <tweek@google.com>,mjg59@google.com,joe@perches.com
> From: hpa@zytor.com
> Message-ID: <191E4EBE-4CB2-4C8B-AB61-689A91FFE7A8@zytor.com>
>
> On June 12, 2018 11:33:14 AM PDT, Nick Desaulniers <ndesaulniers@google.c=
om> wrote:
> >On Fri, Jun 8, 2018 at 3:04 AM Sedat Dilek <sedat.dilek@gmail.com>
> >wrote:
> >>
> >> On Fri, Jun 8, 2018 at 9:59 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > On Thu, Jun 7, 2018 at 10:49 PM, Nick Desaulniers
> >> > <ndesaulniers@google.com> wrote:
> >> >> Functions marked extern inline do not emit an externally visible
> >> >> function when the gnu89 C standard is used. Some KBUILD Makefiles
> >> >> overwrite KBUILD_CFLAGS. This is an issue for GCC 5.1+ users as
> >without
> >> >> an explicit C standard specified, the default is gnu11. Since c99,
> >the
> >> >> semantics of extern inline have changed such that an externally
> >visible
> >> >> function is always emitted. This can lead to multiple definition
> >errors
> >> >> of extern inline functions at link time of compilation units whose
> >build
> >> >> files have removed an explicit C standard compiler flag for users
> >of GCC
> >> >> 5.1+ or Clang.
> >> >>
> >> >> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> >> >> Suggested-by: H. Peter Anvin <hpa@zytor.com>
> >> >> Suggested-by: Joe Perches <joe@perches.com>
> >> >
> >> > I suspect this will break Geert's gcc-4.1.2, which I think doesn't
> >have that
> >> > attribute yet (4.1.3 or higher have it according to the
> >documentation.
> >> >
> >> > It wouldn't be hard to work around that if we want to keep that
> >version
> >> > working, or we could decide that it's time to officially stop
> >supporting
> >> > that version, but we should probably decide on one or the other.
> >
> >Heh, so earlier we decided against compiler flags (-std=3Dgnu89 or
> >-fgnu89-inline) in preference to function attributes.  The function
> >attribute is preferable as some of the Makefiles [accidentally?]
> >overwrite KBUILD_CFLAGS, which is problematic for gcc 5.1 users as the
> >implicit c standard used was changed to gnu11 from gnu89.  What's nice
> >is that to support gcc 4.1 users, we simply don't need to add any
> >attribute, as their implicit c standard is gnu89 which has the
> >semantics for extern inline that we want.  I have a simple change to
> >this patch that can support users of various gcc versions, see below:
> >
> >> Good point.
> >> What is the minimum requirement of GCC version currently?
> >> AFAICS x86/asm-goto support requires GCC >=3D 4.5?
> >
> >Yes, but that's only for x86, IIUC.  It seems the kernel may have
> >different minimum required versions of GCC based on arch then?  That
> >may be ok, but I'm not sure that's easy to keep track of without
> >having it explicitly stated somewhere like the docs perhaps?
> >
> >> Just FYI...
> >> ...saw the last days in upstream commits that kbuild/kconfig for
> >> 4.18-rc1 offers possibilities to check for cc-version dependencies.
> >
> >Those will be helpful.  If we want to pursue compiler flags, which get
> >set some Makefiles, then yes.  But I think a simpler change to my
> >patch would be as below.
> >
> >It seems gcc did not get __has_attribute [0] until 5.1, but will
> >define __GNUC_GNU_INLINE__ if supported. [1]  Unfortunately, Clang
> >does not define __GNUC_GNU_INLINE__ [2].  So a proper feature test
> >might look like:
> >
> >```
> >#ifndef __has_attribute
> >#define __has_attribute(x) 0
> >#endif
> >
> >#if defined(__GNUC_GNU_INLINE__) || __has_attribute(gnu_inline)
> >#define __gnu_inline __attribute__(gnu_inline)
> >#endif
> >
> >#define inline inline __attribute__((always_inline, unused)) notrace
> >__gnu_inline
> >```
> >
> >Thoughts on this approach? I can send a v5 tomorrow if there's no
> >major issues.  Feedback appreciated, as always.
> >
> >[0] https://clang.llvm.org/docs/LanguageExtensions.html#has-attribute
> >[1]
> >https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#Commo=
n-Function-Attributes
> >[2] https://bugs.llvm.org/show_bug.cgi?id=3D37784
>
> Please fix clang. It isn't all that hard to fix.
>
> However, __GCC_GNU_INLINE__ means you are in GNU mode by default, on gcc'=
s new enough to have multiple misses.
>
> The right thing to look for is __GCC_STDC_INLINE__ in which case you need=
 the attribute.

Oh, by [0] __GCC_STDC_INLINE__ is indeed actually the correct symbol
to check for.  Clang does support that, so nothing to fix there.

> By the way, you should check clang against gcc's predefined macros by doi=
ng:
>
> gcc [options] -x c -Wp,-dM -E /dev/null | sort
>
> Options can change the predefined macros substantially, especially the, -=
std=3D, arch and -O options. -x c can be replaced with e.g. -x c++, objecti=
ve-c, assembler-with-cpp etc.

Neat, I'll have to bookmark that incantation.  I can s/gcc/clang/ to
get a similar list (which is how I know it supports
__GCC_STDC_INLINE__).

Patch now becomes something like:

#ifdef __GNUC_GNU_INLINE__
#define __gnu_inline __attribute__((gnu_inline))
#else
#define __gnu_inline
#endif

#define inline inline __attribute__((always_inline, unused)) notrace
__gnu_inline
...

Issues with that approach?

[0] https://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html
--=20
Thanks,
~Nick Desaulniers
