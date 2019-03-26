From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi/libstub: refactor cmd_stubcopy
Date: Tue, 26 Mar 2019 08:54:25 +0100
Message-ID: <CAKv+Gu_i=cWfzf2fLchY-M1wWYh-wz4AMyDJBsT4Emg=4XqPcA@mail.gmail.com>
References: <1549943095-10956-1-git-send-email-yamada.masahiro@socionext.com>
 <CAKv+Gu8yLY+c6jNmHYkvP3n=xiojF7dcKBHmeGibUW2FUrEczA@mail.gmail.com>
 <CAK7LNASoyeFW=j9R=M2vaoLK_Gms1Z6hA_yKLyVSY=g5ALUi8A@mail.gmail.com>
 <CAKv+Gu8k63Fj2aPbQPLLvBXvJrdcu5NrODXuZKkb2n21AUM70Q@mail.gmail.com>
 <CAK7LNARd6R31QyGn4MZdDeTfUVGhF7bOx+5ZyuY-c7kZ6fETsA@mail.gmail.com> <CAK7LNASGFinR5EALd-2V-jezC+H5f+tw24NBBtfsUfxLBirwRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK7LNASGFinR5EALd-2V-jezC+H5f+tw24NBBtfsUfxLBirwRw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-efi <linux-efi@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Alistair Strachan <astrachan@google.com>, Laura Abbott <labbott@redhat.com>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Tue, 26 Mar 2019 at 07:06, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> Hi Ard,
>
>
>
> On Sat, Feb 16, 2019 at 11:07 AM Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
> >
> > On Sat, Feb 16, 2019 at 12:38 AM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> > >
> > > On Fri, 15 Feb 2019 at 06:49, Masahiro Yamada
> > > <yamada.masahiro@socionext.com> wrote:
> > > >
> > > > On Tue, Feb 12, 2019 at 4:26 PM Ard Biesheuvel
> > > > <ard.biesheuvel@linaro.org> wrote:
> > > > >
> > > > > On Tue, 12 Feb 2019 at 04:45, Masahiro Yamada
> > > > > <yamada.masahiro@socionext.com> wrote:
> > > > > >
> > > > > > It took me a while to understand what is going on in the nested
> > > > > > if-blocks.
> > > > > >
> > > > > > Simplify it by removing unneeded code.
> > > > > >
> > > > > >   - if_changed automatically adds 'set -e', so any failure in the
> > > > > >     series of commands makes it immediately fail as a whole.
> > > > > >     So, the outer if block is entirely redundant.
> > > > > >
> > > > > >   - Since commit 9c2af1c7377a ("kbuild: add .DELETE_ON_ERROR special
> > > > > >     target"), GNU Make automatically deletes the target on any failure
> > > > > >     in its recipe. The explicit 'rm -f $@' is redundant.
> > > > > >
> > > > > >   - surrounding commands with ( ) will spawn a subshell to execute them
> > > > > >     in it, but it is rarely useful to do so.
> > > > > >
> > > > > > Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> > > > >
> > > > > Assuming that it still works as expected:
> > > > >
> > > > > Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > > >
> > > > > You can test this by adding a statically initialized global function
> > > > > pointer to any of the libstub source files that get built for ARM.
> > > > >
> > > > > Thanks!
> > > >
> > > >
> > > > I tried that, and it failed as expected.
> > > >
> > >
> > > Great, thanks for double checking.
> > >
> > > Are you taking this directly, or do you want me to take it via the EFI
> > > tree? Either is fine with me
> > >
> > >
> >
> > Could you apply it to your EFI tree?
> > Thanks.
>
>
>
> Will you pick it up?
>

Yes, it's on my list for v5.2
