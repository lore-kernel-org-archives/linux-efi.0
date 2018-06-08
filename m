From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 1/3] compiler-gcc.h: add gnu_inline to all inline declarations
Date: Fri, 8 Jun 2018 09:59:54 +0200
Message-ID: <CAK8P3a0yi+MrOS=+pjCeUu==YBE_AppB8vfqdsQS-1NpSO2c4A@mail.gmail.com>
References: <20180607204927.219329-1-ndesaulniers@google.com> <20180607204927.219329-2-ndesaulniers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180607204927.219329-2-ndesaulniers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, virtualization@lists.linux-foundation.org, astrachan@google.com, Manoj Gupta <manojgupta@google.com>, Greg Hackmann <ghackmann@google.com>, sedat.dilek@gmail.com, tstellar@redhat.com, Kees Cook <keescook@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Will Deacon <will.deacon@arm.com>, mawilcox@microsoft.com, David Rientjes <rientjes@google.c>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 7, 2018 at 10:49 PM, Nick Desaulniers
<ndesaulniers@google.com> wrote:
> Functions marked extern inline do not emit an externally visible
> function when the gnu89 C standard is used. Some KBUILD Makefiles
> overwrite KBUILD_CFLAGS. This is an issue for GCC 5.1+ users as without
> an explicit C standard specified, the default is gnu11. Since c99, the
> semantics of extern inline have changed such that an externally visible
> function is always emitted. This can lead to multiple definition errors
> of extern inline functions at link time of compilation units whose build
> files have removed an explicit C standard compiler flag for users of GCC
> 5.1+ or Clang.
>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> Suggested-by: H. Peter Anvin <hpa@zytor.com>
> Suggested-by: Joe Perches <joe@perches.com>

I suspect this will break Geert's gcc-4.1.2, which I think doesn't have that
attribute yet (4.1.3 or higher have it according to the documentation.

It wouldn't be hard to work around that if we want to keep that version
working, or we could decide that it's time to officially stop supporting
that version, but we should probably decide on one or the other.

        Arnd
