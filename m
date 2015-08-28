From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/4] x86, efi, kasan: #undef memset/memcpy/memmove per
 arch.
Date: Fri, 28 Aug 2015 08:27:45 +0200
Message-ID: <20150828062745.GB1928@gmail.com>
References: <1440605707-8325-1-git-send-email-ryabinin.a.a@gmail.com>
 <1440605707-8325-2-git-send-email-ryabinin.a.a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1440605707-8325-2-git-send-email-ryabinin.a.a@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: linux-efi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Linus Walleij <linus.walleij@linaro.org>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org


* Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:

> In not-instrumented code KASAN replaces instrumented
> memset/memcpy/memmove with not-instrumented analogues
> __memset/__memcpy/__memove.
> However, on x86 EFI stub is not linked with kernel.

s/with the kernel

> It uses not-instrumented mem*() functions from
> arch/x86/boot/compressed/string.c
> So we don't replace them with __mem*() variants in EFI stub.
> 
> In ARM64 EFI stub is linked with the kernel, so we should

s/In ARM64 EFI stub/On ARM64 the EFI stub/.

> replace mem*() functions with __mem*(), because EFI stub

s/the EFI stub

> runs before KASAN setup early shadow.

s/before KASAN sets up the early shadow

?

> So let's move these #undef mem* into arch's asm/efi.h which is

s/lets

> also included by EFI stub.

s/by the EFI stub

> 
> Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> ---
>  arch/x86/include/asm/efi.h             | 8 ++++++++
>  drivers/firmware/efi/libstub/efistub.h | 4 ----
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 155162e..d821ce2 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -25,6 +25,14 @@
>  #define EFI32_LOADER_SIGNATURE	"EL32"
>  #define EFI64_LOADER_SIGNATURE	"EL64"
>  
> +/*
> + * Use memcpy/memset from arch/x86/boot/compressed/string.c
> + * for EFI stub.
> + */
> +#undef memcpy
> +#undef memset
> +#undef memmove

This comment should also mention why it's done, not what is done.

Also:

    s/for EFI stub/for the EFI stub

Thanks,

	Ingo
