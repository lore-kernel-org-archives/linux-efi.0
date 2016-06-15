From: Alex Thorlton <athorlton@sgi.com>
Subject: [PATCHv2 0/3] x86/UV, x86/efi: Re-factor efi_call_virt for general use
Date: Wed, 15 Jun 2016 14:04:12 -0500
Message-ID: <1466017455-236934-1-git-send-email-athorlton@sgi.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Matt Fleming <matt@codeblueprint.co.uk>, Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Roy Franz <roy.franz@linaro.org>, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, x86@kernel.org
List-Id: linux-efi@vger.kernel.org

Hey guys,

This patchset creates a general purpose version of the efi_call_virt
macro that does not assume that the function pointer being passed in is
inside of efi.systab->runtime.  It also fixes up uv_bios_call to use the
new functionality, and does a bit of cleanup in the efi_thunk macro.

Quick breakdown of the patches:

Patch 1) Move necessary macros to locations where we can access them.
	 Remove hard-coded efi.systab reference from efi_call_virt.
	 Rename/create new macros as needed.
Patch 2) Simple change to allow UV code to utilize the new
	 functionality.  Included a detailed explanation of how we got
	 here.
Patch 3) Replace a few bits of the efi_thunk macro with the
	 arch_efi_call_setup/teardown macros.

The first two have been tested on simulators and hardware, but the third
has only been compile-tested.  I don't have any hardware to test that
on.

Updates for v2:

- Fix up arm and arm64 versions of arch_efi_call_virt.  I missed these
  on my first pass 
- Add some more detail to the commit message for the uv_bios_call fix.
- Change the third patch to use the arch_efi_call_setup/teardown macros
  inside of the efi_thunk macro, instead of replacing efi_thunk entirely
  for the CONFIG_EFI_MIXED case.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Russ Anderson <rja@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Roy Franz <roy.franz@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org
Cc: x86@kernel.org

Alex Thorlton (3):
  Convert efi_call_virt to efi_call_virt_pointer
  Update uv_bios_call to use efi_call_virt_pointer
  Update efi_thunk to use the the arch_efi_call_virt* macros

 arch/arm/include/asm/efi.h              |  4 +--
 arch/arm64/include/asm/efi.h            |  4 +--
 arch/x86/include/asm/efi.h              |  9 +++---
 arch/x86/platform/efi/efi_64.c          | 11 ++-----
 arch/x86/platform/uv/bios_uv.c          |  3 +-
 drivers/firmware/efi/runtime-wrappers.c | 53 +++++++--------------------------
 include/linux/efi.h                     | 51 +++++++++++++++++++++++++++++++
 7 files changed, 73 insertions(+), 62 deletions(-)

-- 
1.8.5.6
