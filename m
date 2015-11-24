From: Robert Richter <robert.richter@caviumnetworks.com>
Subject: Re: [PATCH v4 3/3] arm64/efi: isolate EFI stub from the kernel proper
Date: Tue, 24 Nov 2015 10:34:38 +0100
Message-ID: <20151124093438.GA31343@rric.localdomain>
References: <1444330924-17830-1-git-send-email-ard.biesheuvel@linaro.org>
 <1444330924-17830-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1444330924-17830-4-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: mark.rutland@arm.com, linux-efi@vger.kernel.org, ryabinin.a.a@gmail.com, catalin.marinas@arm.com, will.deacon@arm.com, leif.lindholm@linaro.org, matt.fleming@intel.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Ard,

On 08.10.15 20:02:04, Ard Biesheuvel wrote:
> +quiet_cmd_stubcopy = STUBCPY $@
> +      cmd_stubcopy = if $(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@; then	\
> +		     $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y)	\
> +		     && (echo >&2 "$@: absolute symbol references not allowed in the EFI stub"; \
> +			 rm -f $@; /bin/false); else /bin/false; fi

This one is causing some more build errors for my setup. Any hint how
to fix that?

Thanks,

-Robert


  STUBCPY drivers/firmware/efi/libstub/arm-stub.stub.o
0000000000000006 R_AARCH64_ABS32   .debug_abbrev
000000000000000c R_AARCH64_ABS32   .debug_str+0x0000000000000890
0000000000000011 R_AARCH64_ABS32   .debug_str+0x0000000000004ecd
0000000000000015 R_AARCH64_ABS32   .debug_str+0x0000000000000bb1
0000000000000019 R_AARCH64_ABS64   .init.text
0000000000000021 R_AARCH64_ABS64   .init.text+0x00000000000008cc
0000000000000029 R_AARCH64_ABS32   .debug_line
0000000000000030 R_AARCH64_ABS32   .debug_str+0x00000000000000eb
0000000000000047 R_AARCH64_ABS32   .debug_str+0x0000000000003ca8
0000000000000059 R_AARCH64_ABS32   .debug_str+0x0000000000004798
0000000000000060 R_AARCH64_ABS32   .debug_str+0x0000000000005008
...
000000000000a4bb R_AARCH64_ABS32   .debug_str+0x0000000000004a75
000000000000a4da R_AARCH64_ABS32   .debug_str+0x00000000000029ee
000000000000a4f7 R_AARCH64_ABS32   .debug_str+0x0000000000001d95
000000000000a519 R_AARCH64_ABS32   .debug_str+0x0000000000000773
0000000000000006 R_AARCH64_ABS32   .debug_info
0000000000000010 R_AARCH64_ABS64   .init.text
0000000000000623 R_AARCH64_ABS64   .init.text
0000000000000014 R_AARCH64_ABS32   .debug_frame
0000000000000018 R_AARCH64_ABS64   .init.text
000000000000002c R_AARCH64_ABS32   .debug_frame
0000000000000030 R_AARCH64_ABS64   .init.text+0x0000000000000018
0000000000000074 R_AARCH64_ABS32   .debug_frame
0000000000000078 R_AARCH64_ABS64   .init.text+0x0000000000000140
000000000000009c R_AARCH64_ABS32   .debug_frame
00000000000000a0 R_AARCH64_ABS64   .init.text+0x0000000000000158
00000000000000c4 R_AARCH64_ABS32   .debug_frame
00000000000000c8 R_AARCH64_ABS64   .init.text+0x0000000000000170
000000000000012c R_AARCH64_ABS32   .debug_frame
0000000000000130 R_AARCH64_ABS64   .init.text+0x0000000000000390
0000000000000154 R_AARCH64_ABS32   .debug_frame
0000000000000158 R_AARCH64_ABS64   .init.text+0x00000000000003b0
00000000000001a4 R_AARCH64_ABS32   .debug_frame
00000000000001a8 R_AARCH64_ABS64   .init.text+0x0000000000000780
drivers/firmware/efi/libstub/arm-stub.stub.o: absolute symbol references not allowed in the EFI stub
