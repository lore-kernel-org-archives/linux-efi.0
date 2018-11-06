From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] efi/libstub: Disable some warnings for x86{,_64}
Date: Tue, 6 Nov 2018 14:15:03 +0100
Message-ID: <CA+icZUUK_B-_Brdr7LpiexEHJTytquhKN+4uidc+GmyMkJN8Og@mail.gmail.com>
References: <20181013010348.6740-1-natechancellor@gmail.com>
 <20181023175309.GA3384@flashbox> <CA+icZUXsS53RANWBNWw7_HcRRGyzVW1EepBU-K1pumrue6bYtg@mail.gmail.com>
 <CAKv+Gu8eJxLcNkvSzzKf0P+gjhtGRdLQW9J+gcDRhhGCi-pHJg@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8eJxLcNkvSzzKf0P+gjhtGRdLQW9J+gcDRhhGCi-pHJg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ard.biesheuvel@linaro.org
Cc: natechancellor@gmail.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 5, 2018 at 1:52 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On 24 October 2018 at 09:22, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > On Tue, Oct 23, 2018 at 7:53 PM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> >>
> >> On Fri, Oct 12, 2018 at 06:03:49PM -0700, Nathan Chancellor wrote:
> >> > When building the kernel with Clang, some disabled warnings appear
> >> > because this Makefile overrides KBUILD_CFLAGS for x86{,_64}. Add them to
> >> > this list so that the build is clean again.
> >> >
> >> > -Wpointer-sign was disabled for the whole kernel before the beginning
> >> > of git history.
> >> >
> >> > -Waddress-of-packed-member was disabled for the whole kernel in
> >> > commit bfb38988c51e ("kbuild: clang: Disable 'address-of-packed-member'
> >> > warning") and for x86/boot/compressed in commit 20c6c1890455 ("x86/boot:
> >> > Disable the address-of-packed-member compiler warning").
> >> >
> >> > -Wgnu was disabled for the whole kernel in commit 61163efae020 ("kbuild:
> >> > LLVMLinux: Add Kbuild support for building kernel with Clang") and for
> >> > x86/boot/compressed in commit 6c3b56b19730 ("x86/boot: Disable Clang
> >> > warnings about GNU extensions").
> >> >
> >> > Link: https://github.com/ClangBuiltLinux/linux/issues/112
> >> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> >> > ---
> >> >
> >> > Nick expressed concern that this Makefile is overwriting KBUILD_CFLAGS
> >> > and suggested potentially rewriting the x86 portion of this Makefile to
> >> > behave like the arm/arm64 one where problematic flags are filtered out.
> >> > While that comes to fruition, it would be nice for this folder to behave
> >> > like the rest of the kernel when it comes to this warnings so that the
> >> > build is cleaner, thus this patch.
> >> >
> >> >  drivers/firmware/efi/libstub/Makefile | 5 ++++-
> >> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> >> > index c51627660dbb..d9845099635e 100644
> >> > --- a/drivers/firmware/efi/libstub/Makefile
> >> > +++ b/drivers/firmware/efi/libstub/Makefile
> >> > @@ -9,7 +9,10 @@ cflags-$(CONFIG_X86_32)              := -march=i386
> >> >  cflags-$(CONFIG_X86_64)              := -mcmodel=small
> >> >  cflags-$(CONFIG_X86)         += -m$(BITS) -D__KERNEL__ -O2 \
> >> >                                  -fPIC -fno-strict-aliasing -mno-red-zone \
> >> > -                                -mno-mmx -mno-sse -fshort-wchar
> >> > +                                -mno-mmx -mno-sse -fshort-wchar \
> >> > +                                -Wno-pointer-sign \
> >> > +                                $(call cc-disable-warning, address-of-packed-member) \
> >> > +                                $(call cc-disable-warning, gnu)
> >> >
> >> >  # arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
> >> >  # disable the stackleak plugin
> >> > --
> >> > 2.19.1
> >> >
> >>
> >> + Sedat for review/testing.
> >
> > Thanks Nathan.
> >
> > Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
> > Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > [ Reported-by: Sedat Dilek <sedat.dilek@gmail.com> ]
> > [ See duplicate "arch/x86/include/asm/processor.h: Warning
> > -Waddress-of-packed-member "
> > <https://github.com/ClangBuiltLinux/linux/issues/234> ]
> >
>
> Queued in efi/next
>

Thanks Ard.
This means efi-for-4.21 / efi-for-5.0?

- Sedat -
