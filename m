From: Alex Thorlton <athorlton@sgi.com>
Subject: [RFC PATCH 0/3] x86/UV, x86/efi: Re-factor efi_call_virt for general use
Date: Wed, 18 May 2016 14:11:38 -0500
Message-ID: <1463598701-178201-1-git-send-email-athorlton@sgi.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Matt Fleming <matt@codeblueprint.co.uk>, Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>, Russ Anderson <rja@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hey guys,

This patchset creates a general purpose version of the efi_call_virt
macro that does not assume that the function pointer being passed in is
inside of efi.systab->runtime.  It also fixes up a few potentional users
of that new functionality, namely the SGI UV, and the CONFIG_EFI_MIXED
code paths.

Quick breakdown of the patches:

Patch 1) Move necessary macros to locations where we can access them.
	 Remove hard-coded efi.systab reference from efi_call_virt.
	 Rename/create new macros as needed.
Patch 2) Simple change to allow UV code to utilize the new
	 functionality.  Included a detailed explanation of how we got
	 here.
Patch 3) This is the one I'm most looking for input on.  I merge the
	 efi_thunk code in with the new efi_call_virt scheme (giving it
	 it's own arch_efi_call_* macros, conditionally defined for
	 EFI_MIXED) and then use efi_thunk as a wrapper for
	 efi_call_virt_generic.

The first two have been tested on simulators and hardware, but the third
has only been compile-tested.  I don't have any hardware to test that
on.  I'm sure I could set up a VM with OVMF, but I haven't taken the
time yet :)

A few notes/concerns that I had about the patches:

1) I could have created more specific names for the individual uses of
   efi_call_virt instead of using the originals as wrappers for
   efi_call_virt_generic.
   * Would be easy enough to do, but would need to update all the
     original callers of the function.  Not difficult, just different.
2) I'm not sure if each macro really needs to have the same args
   implemented.  Could be simplified a bit if we didn't use "p" on the
   EFI_MIXED side.
   * I did this for consistency, but I suppose it's not explicitly
     necessary.
3) It wouldn't be too hard to add an efi_thunk_generic function that
   would just expect a 32-bit pointer, and then have an
   efi_thunk_runtime to wrap that and handle the call to
   runtime_service32 for us, so that the efi.systab pointer doesn't have
   to be hard-coded into the EFI_MIXED version of efi_call_virt_generic.
   * This would only be to cover a hypothetical situation where there
     was code that needed to use a function pointer outside of
     efi.systab->runtime, running with CONFIG_EFI_MIXED enabled.

I'm still playing around with some of this to see how it could be
cleaned up, but wanted to get something out there so people could see
how I'm thinking about handling this.

Let me know what everybody thinks!

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: x86@kernel.org
Cc: linux-efi@vger.kernel.org

Alex Thorlton (3):
  Convert efi_call_virt to efi_call_virt_generic
  Update uv_bios_call to use efi_call_virt_generic
  Update efi_thunk to use efi_call_virt_generic

 arch/x86/include/asm/efi.h              | 51 +++++++++++++++++++++++++++++--
 arch/x86/platform/efi/efi_64.c          | 49 +++++++-----------------------
 arch/x86/platform/uv/bios_uv.c          |  3 +-
 drivers/firmware/efi/runtime-wrappers.c | 53 +++++++--------------------------
 include/linux/efi.h                     | 51 +++++++++++++++++++++++++++++++
 5 files changed, 122 insertions(+), 85 deletions(-)

-- 
1.8.5.6
