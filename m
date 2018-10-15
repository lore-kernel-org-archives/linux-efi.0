From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] efi/libstub: Disable some warnings for x86{,_64}
Date: Mon, 15 Oct 2018 12:46:50 -0700
Message-ID: <20181015194650.GA11458@flashbox>
References: <20181013010348.6740-1-natechancellor@gmail.com>
 <CAKwvOdk8HGTtQ=qb2THgRb3B6O=iErXFyrbKVoGDkMeFAdD3kA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwvOdk8HGTtQ=qb2THgRb3B6O=iErXFyrbKVoGDkMeFAdD3kA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 15, 2018 at 12:40:36PM -0700, Nick Desaulniers wrote:
> On Fri, Oct 12, 2018 at 6:06 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > When building the kernel with Clang, some disabled warnings appear
> > because this Makefile overrides KBUILD_CFLAGS for x86{,_64}. Add them to
> > this list so that the build is clean again.
> >
> > -Wpointer-sign was disabled for the whole kernel before the beginning
> > of git history.
> >
> > -Waddress-of-packed-member was disabled for the whole kernel in
> > commit bfb38988c51e ("kbuild: clang: Disable 'address-of-packed-member'
> > warning") and for x86/boot/compressed in commit 20c6c1890455 ("x86/boot:
> > Disable the address-of-packed-member compiler warning").
> >
> > -Wgnu was disabled for the whole kernel in commit 61163efae020 ("kbuild:
> > LLVMLinux: Add Kbuild support for building kernel with Clang") and for
> > x86/boot/compressed in commit 6c3b56b19730 ("x86/boot: Disable Clang
> > warnings about GNU extensions").
> >
> > Link: https://github.com/ClangBuiltLinux/linux/issues/112
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >
> > Nick expressed concern that this Makefile is overwriting KBUILD_CFLAGS
> > and suggested potentially rewriting the x86 portion of this Makefile to
> > behave like the arm/arm64 one where problematic flags are filtered out.
> > While that comes to fruition, it would be nice for this folder to behave
> > like the rest of the kernel when it comes to this warnings so that the
> > build is cleaner, thus this patch.
> >
> >  drivers/firmware/efi/libstub/Makefile | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> > index c51627660dbb..d9845099635e 100644
> > --- a/drivers/firmware/efi/libstub/Makefile
> > +++ b/drivers/firmware/efi/libstub/Makefile
> > @@ -9,7 +9,10 @@ cflags-$(CONFIG_X86_32)                := -march=i386
> >  cflags-$(CONFIG_X86_64)                := -mcmodel=small
> >  cflags-$(CONFIG_X86)           += -m$(BITS) -D__KERNEL__ -O2 \
> >                                    -fPIC -fno-strict-aliasing -mno-red-zone \
> > -                                  -mno-mmx -mno-sse -fshort-wchar
> > +                                  -mno-mmx -mno-sse -fshort-wchar \
> > +                                  -Wno-pointer-sign \
> 
> Hi Nathan, thanks for this patch.
> 
> Should this be:
> $(call cc-disable-warning, pointer-sign)
> as well?
> 

According to commit 1d6bf3a9a546 ("kbuild: add -Wno-pointer-sign flag
unconditionally") in -next, all supported compilers recognize the flag
so I don't think it's necessary.

> > +                                  $(call cc-disable-warning, address-of-packed-member) \
> > +                                  $(call cc-disable-warning, gnu)
> >
> >  # arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
> >  # disable the stackleak plugin
> > --
> > 2.19.1
> >
> 
> 
> -- 
> Thanks,
> ~Nick Desaulniers

Thanks for the review!
Nathan
