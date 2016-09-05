From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 2/2] x86/efi: Allow invocation of arbitrary boot services
Date: Mon, 5 Sep 2016 14:02:47 +0100
Message-ID: <20160905130247.GG32579@codeblueprint.co.uk>
References: <188ea850c957034d482576dfdcf8c8a2536460cf.1471823100.git.lukas@wunner.de>
 <19e0ac48c448dabbed8ed87bf872a39d1e7ea3b2.1471823100.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19e0ac48c448dabbed8ed87bf872a39d1e7ea3b2.1471823100.git.lukas@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-efi@vger.kernel.org, Andreas Noever <andreas.noever@gmail.com>, linux-kernel@vger.kernel.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, 22 Aug, at 12:01:21PM, Lukas Wunner wrote:
> We currently allow invocation of 8 boot services with efi_call_early().
> Not included are LocateHandleBuffer and LocateProtocol in particular.
> For graphics output or to retrieve PCI ROMs and Apple device properties,
> we're thus forced to use the LocateHandle + AllocatePool + LocateHandle
> combo, which is cumbersome and needs more code.
> 
> The ARM folks allow invocation of the full set of boot services but are
> restricted to our 8 boot services in functions shared across arches.
> 
> Thus, rather than adding just LocateHandleBuffer and LocateProtocol to
> struct efi_config, let's rework efi_call_early() to allow invocation of
> arbitrary boot services by selecting the 64 bit vs 32 bit code path in
> the macro itself.
> 
> When compiling for 32 bit or for 64 bit without mixed mode, the unused
> code path is optimized away and the binary code is the same as before.
> But on 64 bit with mixed mode enabled, this commit adds one compare
> instruction to each invocation of a boot service and, depending on the
> code path selected, two jump instructions. (Most of the time gcc
> arranges the jumps in the 32 bit code path.) The result is a minuscule
> performance penalty and the binary code becomes slightly larger and more
> difficult to read when disassembled. This isn't a hot path, so these
> drawbacks are arguably outweighed by the attainable simplification of
> the C code. We have some overhead anyway for thunking or conversion
> between calling conventions.
> 
> The 8 boot services can consequently be removed from struct efi_config.
> 
> No functional change intended (for now).
> 
> Example -- invocation of free_pool before (64 bit code path):
> 0x2d4      movq  %ds:efi_early, %rdx          ; efi_early
> 0x2db      movq  %ss:arg_0-0x20(%rsp), %rsi
> 0x2e0      xorl  %eax, %eax
> 0x2e2      movq  %ds:0x28(%rdx), %rdi         ; efi_early->free_pool
> 0x2e6      callq *%ds:0x58(%rdx)              ; efi_early->call()
> 
> Example -- invocation of free_pool after (64 / 32 bit mixed code path):
> 0x0dc      movq  %ds:efi_early, %rax          ; efi_early
> 0x0e3      cmpb  $0, %ds:0x28(%rax)           ; !efi_early->is64 ?
> 0x0e7      movq  %ds:0x20(%rax), %rdx         ; efi_early->call()
> 0x0eb      movq  %ds:0x10(%rax), %rax         ; efi_early->boot_services
> 0x0ef      je    $0x150
> 0x0f1      movq  %ds:0x48(%rax), %rdi         ; free_pool (64 bit)
> 0x0f5      xorl  %eax, %eax
> 0x0f7      callq *%rdx
> ...
> 0x150      movl  %ds:0x30(%rax), %edi         ; free_pool (32 bit)
> 0x153      jmp   $0x0f5
> 
> Size of eboot.o text section:
> CONFIG_X86_32:                         6464 before, 6318 after
> CONFIG_X86_64 && !CONFIG_EFI_MIXED:    7670 before, 7573 after
> CONFIG_X86_64 &&  CONFIG_EFI_MIXED:    7670 before, 8319 after
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> ---
>  arch/x86/boot/compressed/eboot.c   | 13 +------------
>  arch/x86/boot/compressed/head_32.S |  6 +++---
>  arch/x86/boot/compressed/head_64.S |  8 ++++----
>  arch/x86/include/asm/efi.h         | 15 ++++++---------
>  4 files changed, 14 insertions(+), 28 deletions(-)

Nice, I like this. Applied pending the update to the first patch.
