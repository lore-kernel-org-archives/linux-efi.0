From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi/libstub: refactor cmd_stubcopy
Date: Fri, 15 Feb 2019 09:25:38 +0100
Message-ID: <CAKv+Gu8k63Fj2aPbQPLLvBXvJrdcu5NrODXuZKkb2n21AUM70Q@mail.gmail.com>
References: <1549943095-10956-1-git-send-email-yamada.masahiro@socionext.com>
 <CAKv+Gu8yLY+c6jNmHYkvP3n=xiojF7dcKBHmeGibUW2FUrEczA@mail.gmail.com> <CAK7LNASoyeFW=j9R=M2vaoLK_Gms1Z6hA_yKLyVSY=g5ALUi8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK7LNASoyeFW=j9R=M2vaoLK_Gms1Z6hA_yKLyVSY=g5ALUi8A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-efi <linux-efi@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Alistair Strachan <astrachan@google.com>, Laura Abbott <labbott@redhat.com>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Fri, 15 Feb 2019 at 06:49, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> On Tue, Feb 12, 2019 at 4:26 PM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > On Tue, 12 Feb 2019 at 04:45, Masahiro Yamada
> > <yamada.masahiro@socionext.com> wrote:
> > >
> > > It took me a while to understand what is going on in the nested
> > > if-blocks.
> > >
> > > Simplify it by removing unneeded code.
> > >
> > >   - if_changed automatically adds 'set -e', so any failure in the
> > >     series of commands makes it immediately fail as a whole.
> > >     So, the outer if block is entirely redundant.
> > >
> > >   - Since commit 9c2af1c7377a ("kbuild: add .DELETE_ON_ERROR special
> > >     target"), GNU Make automatically deletes the target on any failure
> > >     in its recipe. The explicit 'rm -f $@' is redundant.
> > >
> > >   - surrounding commands with ( ) will spawn a subshell to execute them
> > >     in it, but it is rarely useful to do so.
> > >
> > > Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> >
> > Assuming that it still works as expected:
> >
> > Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >
> > You can test this by adding a statically initialized global function
> > pointer to any of the libstub source files that get built for ARM.
> >
> > Thanks!
>
>
> I tried that, and it failed as expected.
>

Great, thanks for double checking.

Are you taking this directly, or do you want me to take it via the EFI
tree? Either is fine with me


>
> $ git diff
> diff --git a/drivers/firmware/efi/libstub/arm32-stub.c
> b/drivers/firmware/efi/libstub/arm32-stub.c
> index becbda4..5ad7bbd 100644
> --- a/drivers/firmware/efi/libstub/arm32-stub.c
> +++ b/drivers/firmware/efi/libstub/arm32-stub.c
> @@ -28,6 +28,8 @@ efi_status_t
> check_platform_features(efi_system_table_t *sys_table_arg)
>         return EFI_SUCCESS;
>  }
>
> +void * foo = (void *)check_platform_features;
> +
>  static efi_guid_t screen_info_guid = LINUX_EFI_ARM_SCREEN_INFO_TABLE_GUID;
>
>  struct screen_info *alloc_screen_info(efi_system_table_t *sys_table_arg)
> $ make ARCH=arm  CROSS_COMPILE=arm-linux-gnueabihf- defconfig
> drivers/firmware/efi/libstub/
> *** Default configuration is based on 'multi_v7_defconfig'
> #
> # configuration written to .config
> #
> scripts/kconfig/conf  --syncconfig Kconfig
>   CALL    scripts/checksyscalls.sh
>   CC      drivers/firmware/efi/libstub/arm32-stub.o
>   STUBCPY drivers/firmware/efi/libstub/arm32-stub.stub.o
> 00000000 R_ARM_ABS32       check_platform_features
> drivers/firmware/efi/libstub/arm32-stub.stub.o: absolute symbol
> references not allowed in the EFI stub
> drivers/firmware/efi/libstub/Makefile:80: recipe for target
> 'drivers/firmware/efi/libstub/arm32-stub.stub.o' failed
> make[3]: *** [drivers/firmware/efi/libstub/arm32-stub.stub.o] Error 1
> make[3]: *** Deleting file 'drivers/firmware/efi/libstub/arm32-stub.stub.o'
> Makefile:1705: recipe for target 'drivers/firmware/efi/libstub/' failed
> make[2]: *** [drivers/firmware/efi/libstub/] Error 2
> /home/masahiro/workspace/bsp/linux/Makefile:300: recipe for target
> '__build_one_by_one' failed
> make[1]: *** [__build_one_by_one] Error 2
> Makefile:160: recipe for target 'sub-make' failed
> make: *** [sub-make] Error 2
>
>
>
>
>
> --
> Best Regards
> Masahiro Yamada
