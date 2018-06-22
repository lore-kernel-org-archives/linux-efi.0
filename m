From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v6 3/3] x86: paravirt: make native_save_fl extern inline
Date: Fri, 22 Jun 2018 10:10:16 -0700
Message-ID: <CAKwvOdn5gnB5cK=cy6weKyxAn4SNEdZTT_MtT_D_nHRG5EDZ4g@mail.gmail.com>
References: <20180621162324.36656-1-ndesaulniers@google.com>
 <20180621162324.36656-4-ndesaulniers@google.com> <20180622022402.GA24194@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180622022402.GA24194@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com, linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, virtualization@lists.linux-foundation.org, Alistair Strachan <astrachan@google.com>, Manoj Gupta <manojgupta@google.com>, Greg Hackmann <ghackmann@google.com>, sedat.dilek@gmail.com, tstellar@redhat.com, Kees Cook <keescook@google.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, geert@linux-m68k.org, Will Deacon <will.deacon@arm.com>, mawilcox@microsoft.com, Arnd Bergmann <arnd@arndb.de>, David Rientjes <rientjes@google.com>, acme@redhat.com, Philippe Ombredanne <pombredanne@nexb.c>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 21, 2018 at 7:24 PM Ingo Molnar <mingo@kernel.org> wrote:
> * Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> > native_save_fl() is marked static inline, but by using it as
> > a function pointer in arch/x86/kernel/paravirt.c, it MUST be outlined.
>
> > --- a/arch/x86/include/asm/irqflags.h
> > +++ b/arch/x86/include/asm/irqflags.h
> > @@ -13,7 +13,7 @@
> >   * Interrupt control:
> >   */
> >
> > -static inline unsigned long native_save_fl(void)
> > +extern inline unsigned long native_save_fl(void)
> >  {
> >       unsigned long flags;
> >
>
> What's the code generation effect of this on say a defconfig kernel vmlinux with
> paravirt enabled?

Starting with this patch set applied:
$ make CC=gcc-8 -j46
$ objdump -d vmlinux | grep native_save_fl --context=3
ffffffff81059140 <native_save_fl>:
ffffffff81059140: 9c                    pushfq
ffffffff81059141: 58                    pop    %rax
ffffffff81059142: c3                    retq
$ git checkout HEAD~3
$ make CC=gcc-8 -j46
$ objdump -d vmlinux | grep native_save_fl --context=3
ffffffff81079410 <native_save_fl>:
ffffffff81079410: 9c                    pushfq
ffffffff81079411: 58                    pop    %rax
ffffffff81079412: c3                    retq

Mainly, this is to prevent the compiler from adding a stack protector
to the outlined version, as the stack protector clobbers %rcx, but
paravirt expects %rcx to be preserved. More info can be found:
https://lkml.org/lkml/2018/5/24/1242--
Thanks,
~Nick Desaulniers
