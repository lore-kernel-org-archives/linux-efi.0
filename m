From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCHv2 0/6] efi: detect erroneous firmware IRQ manipulation
Date: Fri, 22 Apr 2016 14:51:17 +0100
Message-ID: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Some firmware erroneously unmask IRQs (and potentially other architecture
specific exceptions) during runtime services functions, in violation of both
common sense and the UEFI specification. This can result in a number of issues
if said exceptions are taken when they are expected to be masked, and
additionally can confuse IRQ tracing if the original mask state is not
restored prior to returning from firmware.

In practice it's difficult to check that firmware never unmasks exceptions, but
we can at least check that the IRQ flags are at least consistent upon entry to
and return from a runtime services function call. This series implements said
check in the shared EFI runtime wrappers code, after an initial round of
refactoring such that this can be generic.

I have left ia64 as-is, without this check, as ia64 doesn't currently use the
generic runtime wrappers, has many special cases for the runtime calls which
don't fit well with the generic code, and I don't expect a new, buggy ia64
firmware to appear soon.

The first time corruption of the IRQ flags is detected, we dump a stack trace,
and set TAINT_FIRMWARE_WORKAROUND. Additionally, and in all subsequent cases,
we log (with ratelimiting) the specific corruption of the flags, and restore
the expected flags to avoid redundant warnings elsewhere.

Since v1 [1]:
* Fix thinko: s/local_irq_save/local_save_flags/
* Remove ifdefs after conversion
* Remove reundant semicolon from x86 patch
* Move efi_call_virt_check_flags before first use
* Add Acked-bys and Reviewed-bys

Ard, I assume that your Reviewed-by still stands for the final patch, even
though efi_call_virt_check_flags moved. Please shout if that's not the case!

Hopefully you're also happy to extend that to the new patch removing the
ifdefs once they become superfluous.

Thanks,
Mark.

[1] https://lkml.org/lkml/2016/4/21/260

Mark Rutland (6):
  efi/runtime-wrappers: add {__,}efi_call_virt templates
  arm64/efi: move to generic {__,}efi_call_virt
  arm/efi: move to generic {__,}efi_call_virt
  x86/efi: move to generic {__,}efi_call_virt
  efi/runtime-wrappers: remove redundant ifdefs
  efi/runtime-wrappers: detect FW irq flag corruption

 arch/arm/include/asm/efi.h              | 20 ++++------------
 arch/arm64/include/asm/efi.h            | 21 ++++++-----------
 arch/x86/include/asm/efi.h              | 41 ++++++++++-----------------------
 drivers/firmware/efi/runtime-wrappers.c | 38 ++++++++++++++++++++++++++++++
 4 files changed, 61 insertions(+), 59 deletions(-)

-- 
1.9.1
