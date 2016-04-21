From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv2 0/5] efi: detect erroneous firmware IRQ manipulation
Date: Thu, 21 Apr 2016 12:47:37 +0100
Message-ID: <20160421114737.GQ2904@bivouac.eciton.net>
References: <1461238529-12810-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461238529-12810-1-git-send-email-mark.rutland-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 21, 2016 at 12:35:24PM +0100, Mark Rutland wrote:
> Some firmware erroneously unmask IRQs (and potentially other architecture
> specific exceptions) during runtime services functions, in violation of both
> common sense and the UEFI specification. This can result in a number of issues
> if said exceptions are taken when they are expected to be masked, and
> additionally can confuse IRQ tracing if the original mask state is not
> restored prior to returning from firmware.
> 
> In practice it's difficult to check that firmware never unmasks exceptions, but
> we can at least check that the IRQ flags are at least consistent upon entry to
> and return from a runtime services function call. This series implements said
> check in the shared EFI runtime wrappers code, after an initial round of
> refactoring such that this can be generic.
> 
> I have left ia64 as-is, without this check, as ia64 has many special cases for
> the runtime calls which don't fit well with the generic code, and I don't
> expect a new, buggy ia64 firmware to appear soon.
> 
> The first time corruption of the IRQ flags is detected, we dump a stack trace,
> and set TAINT_FIRMWARE_WORKAROUND. Additionally, and in all subsequent cases,
> we log (with ratelimiting) the specific corruption of the flags, and restore
> the expected flags to avoid redundant warnings elsewhere.
> 
> For example, if the firmware on an arm64 system erroneously unmasked IRQ+FIQ,
> we would see warnings in dmesg of the form:
> 
> [    5.639616] ------------[ cut here ]------------
> [    5.644233] WARNING: CPU: 3 PID: 1120 at drivers/firmware/efi/runtime-wrappers.c:57 efi_call_virt_check_flags+0x84/0x90
> [    5.655001] Modules linked in:
> [    5.658046] 
> [    5.659528] CPU: 3 PID: 1120 Comm: mount Not tainted 4.6.0-rc4+ #6
> [    5.674293] task: ffffffc3ecbcc800 ti: ffffffc0fa498000 task.ti: ffffffc0fa498000
> [    5.681763] PC is at efi_call_virt_check_flags+0x84/0x90
> [    5.687063] LR is at virt_efi_get_next_variable+0x74/0xa0
> [    5.692449] pc : [<ffffff8008618ccc>] lr : [<ffffff8008618f2c>] pstate: 20000105
> [    5.699831] sp : ffffffc0fa49bbd0
> [    5.703133] x29: ffffffc0fa49bbd0 x28: ffffffc0fa498000 
> [    5.708436] x27: ffffff8008776000 x26: 0000000000000001 
> [    5.713739] x25: ffffff8008bf2000 x24: 0000000000000000 
> [    5.719042] x23: ffffffc0fa49bcc0 x22: ffffffc3eb84d400 
> [    5.724344] x21: 00000000000001c0 x20: 0000000000000100 
> [    5.729646] x19: ffffff8008bf2a20 x18: 0000007fc1f31aa0 
> [    5.734948] x17: 0000000000425060 x16: ffffff80081e4578 
> [    5.740251] x15: ffffffffffffffff x14: 0000000000000000 
> [    5.745553] x13: 0000000000000000 x12: 0000000000000000 
> [    5.750855] x11: 0101010101010101 x10: 7f7f7f7f7f7f7f7f 
> [    5.756157] x9 : 0000000000000000 x8 : 0000000000000000 
> [    5.761459] x7 : 0000000000000000 x6 : 0000000000000001 
> [    5.766761] x5 : 00000000220e94ba x4 : 0000000022c61190 
> [    5.772063] x3 : 0000000000000001 x2 : ffffff8008bc0000 
> [    5.777366] x1 : ffffff80089d9d10 x0 : 00000000000001c0 
> [    5.782667] 
> [    5.784147] ---[ end trace b1612054aa2afdce ]---
> [    5.788751] Call trace:
> [    5.791186] Exception stack(0xffffffc0fa49ba10 to 0xffffffc0fa49bb30)
> [    5.797614] ba00:                                   ffffff8008bf2a20 0000000000000100
> [    5.805430] ba20: ffffffc0fa49bbd0 ffffff8008618ccc ffffffc0fa49ba60 00000000220e94be
> [    5.813247] ba40: ffffffc0fa49ba70 0000000022c5a208 ffffffc0fa49ba80 0000000000000010
> [    5.821063] ba60: 0000000022168ff8 ffffffc0fa49bcc0 ffffffc0fa49baa0 0000000022c4d440
> [    5.828880] ba80: ffffffc0fa49baa0 0000000000000010 0000000022168ff8 ffffffc0fa49bcc0
> [    5.836696] baa0: ffffffc0fa49bb10 0000000022c4db50 00000000000001c0 ffffff80089d9d10
> [    5.844512] bac0: ffffff8008bc0000 0000000000000001 0000000022c61190 00000000220e94ba
> [    5.852329] bae0: 0000000000000001 0000000000000000 0000000000000000 0000000000000000
> [    5.860145] bb00: 7f7f7f7f7f7f7f7f 0101010101010101 0000000000000000 0000000000000000
> [    5.867961] bb20: 0000000000000000 ffffffffffffffff
> [    5.872826] [<ffffff8008618ccc>] efi_call_virt_check_flags+0x84/0x90
> [    5.879168] [<ffffff8008618f2c>] virt_efi_get_next_variable+0x74/0xa0
> [    5.885596] [<ffffff80086182a4>] efivar_init+0x7c/0x2a0
> [    5.890810] [<ffffff80082f7c7c>] efivarfs_fill_super+0xac/0xe8
> [    5.896633] [<ffffff80081c5e34>] mount_single+0x8c/0xb8
> [    5.901846] [<ffffff80082f7bc8>] efivarfs_mount+0x18/0x20
> [    5.907232] [<ffffff80081c5f0c>] mount_fs+0x4c/0x168
> [    5.912184] [<ffffff80081e0f38>] vfs_kern_mount+0x50/0x118
> [    5.917658] [<ffffff80081e3890>] do_mount+0x208/0xc08
> [    5.922697] [<ffffff80081e4608>] SyS_mount+0x90/0xf8
> [    5.927649] [<ffffff8008085e70>] el0_svc_naked+0x24/0x28
> [    5.932960] Disabling lock debugging due to kernel taint
> [    5.938263] [Firmware Bug]: IRQ flags corrupted (0x000001c0=>0x00000100) by EFI get_next_variable
> 
> Then subsequently:
> 
> [    5.938263] [Firmware Bug]: IRQ flags corrupted (0x000001c0=>0x00000100) by EFI get_next_variable
> [    5.947143] [Firmware Bug]: IRQ flags corrupted (0x000001c0=>0x00000100) by EFI get_variable

So, I think this is a good thing, but the diffs end up being quite
hard to deciphre. Is there any non-insane shuffling around of things
that can make the changeset more clear?

/
    Leif

> Thanks,
> Mark.
> 
> Mark Rutland (5):
>   efi/runtime-wrappers: add {__,}efi_call_virt templates
>   arm64/efi: move to generic {__,}efi_call_virt
>   arm/efi: move to generic {__,}efi_call_virt
>   x86/efi: move to generic {__,}efi_call_virt
>   efi/runtime-wrappers: detect FW irq flag corruption
> 
>  arch/arm/include/asm/efi.h              | 20 +++------------
>  arch/arm64/include/asm/efi.h            | 21 ++++++----------
>  arch/x86/include/asm/efi.h              | 41 +++++++++----------------------
>  drivers/firmware/efi/runtime-wrappers.c | 43 +++++++++++++++++++++++++++++++++
>  4 files changed, 66 insertions(+), 59 deletions(-)
> 
> -- 
> 1.9.1
> 
