From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v4 1/3] compiler-gcc.h: add gnu_inline to all inline declarations
Date: Tue, 12 Jun 2018 14:36:19 -0700
Message-ID: <CAKwvOdksGzdeFOAiYRNahFqxRoYoTMGkTeprfP4oZPzdF94WLA@mail.gmail.com>
References: <20180607204927.219329-1-ndesaulniers@google.com>
 <20180607204927.219329-2-ndesaulniers@google.com> <CAK8P3a0yi+MrOS=+pjCeUu==YBE_AppB8vfqdsQS-1NpSO2c4A@mail.gmail.com>
 <CA+icZUXDoeo5ktZZPFcFyLzk3xthM-98N88QJFzesg6t+Vr5cQ@mail.gmail.com>
 <CAKwvOdmxFHfkj81YAXa8fE86fC+k+KvqMvgk4=e62pNCcXbKOg@mail.gmail.com>
 <201806121851.w5CIpTY7134381@mail.zytor.com> <CAKwvOdkeEqb0HnHoggpwmHiKtDo06VN0N_r9ffv0rzigNLvXUg@mail.gmail.com>
 <7e375fab-f8ad-705a-dd04-f7e18952bd0c@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7e375fab-f8ad-705a-dd04-f7e18952bd0c@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: hpa@zytor.com
Cc: sedat.dilek@gmail.com, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, virtualization@lists.linux-foundation.org, Alistair Strachan <astrachan@google.com>, Manoj Gupta <manojgupta@google.com>, Greg Hackmann <ghackmann@google.com>, tstellar@redhat.com, Kees Cook <keescook@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, geert@linux-m68k.org, Will Deacon <will.deacon@arm.com>, mawilcox@microsoft.com, David Rientjes <rientjes@google.com>, acme@redhat.com, Philippe Ombredanne <pombredanne@nexb.com>An
List-Id: linux-efi@vger.kernel.org

On Tue, Jun 12, 2018 at 2:31 PM H. Peter Anvin <hpa@zytor.com> wrote:
>
> On 06/12/18 13:19, Nick Desaulniers wrote:
> >
> > Oh, by [0] __GCC_STDC_INLINE__ is indeed actually the correct symbol
> > to check for.  Clang does support that, so nothing to fix there.
> >
> >> By the way, you should check clang against gcc's predefined macros by doing:
> >>
> >> gcc [options] -x c -Wp,-dM -E /dev/null | sort
> >>
> >> Options can change the predefined macros substantially, especially the, -std=, arch and -O options. -x c can be replaced with e.g. -x c++, objective-c, assembler-with-cpp etc.
> >
> > Neat, I'll have to bookmark that incantation.  I can s/gcc/clang/ to
> > get a similar list (which is how I know it supports
> > __GCC_STDC_INLINE__).>
>
> I bet that if you add -fgnu89-inlines then it *does* define
> __GNUC_GNU_INLINE__.

Indeed! I see what you mean about [options] changing the predefined symbol list.

> > Patch now becomes something like:
> >
> > #ifdef __GNUC_GNU_INLINE__
> > #define __gnu_inline __attribute__((gnu_inline))
> > #else
> > #define __gnu_inline
> > #endif
> >
> > #define inline inline __attribute__((always_inline, unused)) notrace
> > __gnu_inline
> > ...
> >
> > Issues with that approach?
> >
>
> s/__GNUC_GNU_INLINE__/__GNUC_STDC_INLINE__/

Oops, sorry, yes good catch.

-- 
Thanks,
~Nick Desaulniers
