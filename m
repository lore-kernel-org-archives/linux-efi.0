From: "Cohen, Eugene" <eugene@hp.com>
Subject: RE: [RFC PATCH 1/2] efi: libstub: preserve .debug sections after
 absolute relocation check
Date: Wed, 19 Oct 2016 12:55:03 +0000
Message-ID: <AT5PR84MB02917D53223005D45C59BA98B4D20@AT5PR84MB0291.NAMPRD84.PROD.OUTLOOK.COM>
References: <1476877232-24308-1-git-send-email-ard.biesheuvel@linaro.org>
 <1476877232-24308-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1476877232-24308-2-git-send-email-ard.biesheuvel@linaro.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: "mark.rutland@arm.com" <mark.rutland@arm.com>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>
List-Id: linux-efi@vger.kernel.org

I was literally just looking at this.  I originally commented out the removal of debug (which I though was really annoying) but ran into the absolute relocations warning for symbols that it need not apply to.  Your two-pass solution is a nice one.

> -----Original Message-----
> From: Ard Biesheuvel [mailto:ard.biesheuvel@linaro.org]
> Sent: Wednesday, October 19, 2016 5:41 AM
> To: linux-efi@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Cc: mark.rutland@arm.com; leif.lindholm@linaro.org; Cohen, Eugene
> <eugene@hp.com>; matt@codeblueprint.co.uk; Ard Biesheuvel
> <ard.biesheuvel@linaro.org>
> Subject: [RFC PATCH 1/2] efi: libstub: preserve .debug sections after absolute
> relocation check
> 
> The build commands for the ARM and arm64 EFI stubs strips the .debug
> sections and other sections that my legally contain absolute relocations,
> in order to inspect the remaining sections for the presence of such
> relocations.
> 
> This leaves us without debugging symbols in the stub for no good reason,
> given that these sections are omitted from the kernel binary, and that
> these relocations are thus only interpreted by the debugger.
> 
> So if the relocation check succeeds, invoke objcopy again, but this time,
> leave the .debug sections in place. Note that these sections may refer
> to ksymtab/kcrctab contents, so leave those in place as well.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Eugene Cohen <eugene@hp.com>

> ---
>  drivers/firmware/efi/libstub/Makefile | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/firmware/efi/libstub/Makefile
> b/drivers/firmware/efi/libstub/Makefile
> index c06945160a41..66584f173123 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -60,7 +60,7 @@ CFLAGS_arm64-stub.o 		:= -
> DTEXT_OFFSET=$(TEXT_OFFSET)
>  extra-$(CONFIG_EFI_ARMSTUB)	:= $(lib-y)
>  lib-$(CONFIG_EFI_ARMSTUB)	:= $(patsubst %.o,%.stub.o,$(lib-y))
> 
> -STUBCOPY_FLAGS-y		:= -R .debug* -R *ksymtab* -R *kcrctab*
> +STUBCOPY_RM			:= -R .debug* -R *ksymtab* -R *kcrctab*
>  STUBCOPY_FLAGS-$(CONFIG_ARM64)	+= --prefix-alloc-sections=.init \
>  				   --prefix-symbols=__efistub_
>  STUBCOPY_RELOC-$(CONFIG_ARM64)	:= R_AARCH64_ABS
> @@ -68,11 +68,20 @@ STUBCOPY_RELOC-$(CONFIG_ARM64)	:=
> R_AARCH64_ABS
>  $(obj)/%.stub.o: $(obj)/%.o FORCE
>  	$(call if_changed,stubcopy)
> 
> +#
> +# This calls objcopy twice: the first time it includes STUBCOPY_RM, and inspects
> +# the result to ensure that the actual code itself does not contain any absolute
> +# references. If this succeeds, the objcopy is performed a second time, but this
> +# time the .debug and other sections are retained, given that we know that the
> +# absolute relocations they may contain are harmless.
> +#
>  quiet_cmd_stubcopy = STUBCPY $@
> -      cmd_stubcopy = if $(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@; then	\
> -		     $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y)	\
> -		     && (echo >&2 "$@: absolute symbol references not allowed in
> the EFI stub"; \
> -			 rm -f $@; /bin/false); else /bin/false; fi
> +      cmd_stubcopy = if $(OBJCOPY) $(STUBCOPY_FLAGS-y) $(STUBCOPY_RM) $<
> $@; \
> +		     then if $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y);    \
> +		     then (echo >&2 "$@: absolute symbol references not allowed
> in the EFI stub"; \
> +			 rm -f $@; /bin/false); 			     \
> +		     else $(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@; fi	     \
> +		     else /bin/false; fi
> 
>  #
>  # ARM discards the .data section because it disallows r/w data in the
> --
> 2.7.4
