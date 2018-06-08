From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH v4 1/3] compiler-gcc.h: add gnu_inline to all inline declarations
Date: Fri, 8 Jun 2018 14:29:35 +0200
Message-ID: <CA+icZUV0uJEDj0Y0rMNCp0tUTgv0wN-CL-Uynuoni0D4oUZJow@mail.gmail.com>
References: <20180607204927.219329-1-ndesaulniers@google.com>
 <20180607204927.219329-2-ndesaulniers@google.com> <CAK8P3a0yi+MrOS=+pjCeUu==YBE_AppB8vfqdsQS-1NpSO2c4A@mail.gmail.com>
 <CA+icZUXDoeo5ktZZPFcFyLzk3xthM-98N88QJFzesg6t+Vr5cQ@mail.gmail.com> <20180608112826.GA7484@andrea>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180608112826.GA7484@andrea>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Parri <andrea.parri@amarulasolutions.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Nick Desaulniers <ndesaulniers@google.com>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, virtualization@lists.linux-foundation.org, astrachan@google.com, Manoj Gupta <manojgupta@google.com>, Greg Hackmann <ghackmann@google.com>, tstellar@redhat.com, Kees Cook <keescook@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 8, 2018 at 1:28 PM, Andrea Parri
<andrea.parri@amarulasolutions.com> wrote:
> On Fri, Jun 08, 2018 at 12:04:36PM +0200, Sedat Dilek wrote:
>> On Fri, Jun 8, 2018 at 9:59 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Thu, Jun 7, 2018 at 10:49 PM, Nick Desaulniers
>> > <ndesaulniers@google.com> wrote:
>> >> Functions marked extern inline do not emit an externally visible
>> >> function when the gnu89 C standard is used. Some KBUILD Makefiles
>> >> overwrite KBUILD_CFLAGS. This is an issue for GCC 5.1+ users as without
>> >> an explicit C standard specified, the default is gnu11. Since c99, the
>> >> semantics of extern inline have changed such that an externally visible
>> >> function is always emitted. This can lead to multiple definition errors
>> >> of extern inline functions at link time of compilation units whose build
>> >> files have removed an explicit C standard compiler flag for users of GCC
>> >> 5.1+ or Clang.
>> >>
>> >> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
>> >> Suggested-by: H. Peter Anvin <hpa@zytor.com>
>> >> Suggested-by: Joe Perches <joe@perches.com>
>> >
>> > I suspect this will break Geert's gcc-4.1.2, which I think doesn't have that
>> > attribute yet (4.1.3 or higher have it according to the documentation.
>> >
>> > It wouldn't be hard to work around that if we want to keep that version
>> > working, or we could decide that it's time to officially stop supporting
>> > that version, but we should probably decide on one or the other.
>> >
>>
>> Good point.
>> What is the minimum requirement of GCC version currently?
>
> Good question ;-)  (I recently had the impression that
> Documentation/process/changes.rst was making fun of me ;-)
>
>
>> AFAICS x86/asm-goto support requires GCC >= 4.5?
>>
>> Just FYI...
>> ...saw the last days in upstream commits that kbuild/kconfig for
>> 4.18-rc1 offers possibilities to check for cc-version dependencies.
>
> Good to know!  Mind retrieving/sharing the commit id(s)
> or links to the corresponding discussion on LKML?
>

Sorry, it is not yet in Linus upstream. see [1].

Documentation: kconfig: add recommended way to describe compiler support
kconfig: add CC_IS_CLANG and CLANG_VERSION
kconfig: add CC_IS_GCC and GCC_VERSION

- sed@ -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git/log/?h=kbuild
