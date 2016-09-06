From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi: Optimize away setup_gop32/64 if unused
Date: Tue, 6 Sep 2016 12:08:15 +0100
Message-ID: <20160906110815.GN32579@codeblueprint.co.uk>
References: <188ea850c957034d482576dfdcf8c8a2536460cf.1471823100.git.lukas@wunner.de>
 <f80213780594fdb86b3c1f7256b459856ee953be.1473140971.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f80213780594fdb86b3c1f7256b459856ee953be.1473140971.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 06 Sep, at 08:05:32AM, Lukas Wunner wrote:
> Commit 2c23b73c2d02 ("x86/efi: Prepare GOP handling code for reuse
> as generic code") introduced an efi_is_64bit() macro to x86 which
> previously only existed for arm arches.  The macro is used to
> choose between the 64 bit or 32 bit code path in gop.c at runtime.
> 
> However the code path that's going to be taken is known at compile
> time when compiling for x86_32 or for x86_64 with mixed mode disabled.
> Amend the macro to eliminate the unused code path in those cases.
> 
> Size of gop.o text section:
> CONFIG_X86_32:                         1758 before, 1299 after
> CONFIG_X86_64 && !CONFIG_EFI_MIXED:    2201 before, 1406 after
> CONFIG_X86_64 &&  CONFIG_EFI_MIXED:    2201 before and after
> 
> Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

Thanks Lukas. Both patches applied.
