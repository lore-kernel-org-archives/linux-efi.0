From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi/libstub: refactor cmd_stubcopy
Date: Tue, 12 Feb 2019 08:23:37 +0100
Message-ID: <CAKv+Gu8yLY+c6jNmHYkvP3n=xiojF7dcKBHmeGibUW2FUrEczA@mail.gmail.com>
References: <1549943095-10956-1-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1549943095-10956-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-efi <linux-efi@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Alistair Strachan <astrachan@google.com>, Laura Abbott <labbott@redhat.com>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Tue, 12 Feb 2019 at 04:45, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> It took me a while to understand what is going on in the nested
> if-blocks.
>
> Simplify it by removing unneeded code.
>
>   - if_changed automatically adds 'set -e', so any failure in the
>     series of commands makes it immediately fail as a whole.
>     So, the outer if block is entirely redundant.
>
>   - Since commit 9c2af1c7377a ("kbuild: add .DELETE_ON_ERROR special
>     target"), GNU Make automatically deletes the target on any failure
>     in its recipe. The explicit 'rm -f $@' is redundant.
>
>   - surrounding commands with ( ) will spawn a subshell to execute them
>     in it, but it is rarely useful to do so.
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>

Assuming that it still works as expected:

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

You can test this by adding a statically initialized global function
pointer to any of the libstub source files that get built for ARM.

Thanks!

> ---
>
>  drivers/firmware/efi/libstub/Makefile | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index d984509..7788e8a 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -86,12 +86,13 @@ $(obj)/%.stub.o: $(obj)/%.o FORCE
>  # this time, use objcopy and leave all sections in place.
>  #
>  quiet_cmd_stubcopy = STUBCPY $@
> -      cmd_stubcopy = if $(STRIP) --strip-debug $(STUBCOPY_RM-y) -o $@ $<; \
> -                    then if $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y); \
> -                    then (echo >&2 "$@: absolute symbol references not allowed in the EFI stub"; \
> -                          rm -f $@; /bin/false);                         \
> -                    else $(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@; fi        \
> -                    else /bin/false; fi
> +      cmd_stubcopy =                                                   \
> +       $(STRIP) --strip-debug $(STUBCOPY_RM-y) -o $@ $<;               \
> +       if $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y); then            \
> +               echo "$@: absolute symbol references not allowed in the EFI stub" >&2; \
> +               /bin/false;                                             \
> +       fi;                                                             \
> +       $(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@
>
>  #
>  # ARM discards the .data section because it disallows r/w data in the
> --
> 2.7.4
>
