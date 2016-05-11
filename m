From: Alex Thorlton <athorlton@sgi.com>
Subject: [RFC PATCH 0/2] Fix EFI runtime calls on SGI UV
Date: Wed, 11 May 2016 14:55:43 -0500
Message-ID: <1462996545-98387-1-git-send-email-athorlton@sgi.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, Russ Anderson <rja@sgi.com>, Mike Travis <travis@sgi.com>, Matt Fleming <matt@codeblueprint.co.uk>, Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

These patches make the necessary changes to get SGI UVs working with the
latest EFI memory mapping code.  The motivation behind the changes is
fairly simple:

Patch 1: The current efi_call_virt macro will not work with function
	 pointers that don't live in efi.systab->runtime
Patch 2: The efi_call assembly code incorrectly puts the return address
	 from the current stack frame into the space reserved for the
	 arguments in the stack frame that we're setting up for our EFI
	 runtime call, instead of the 7th argument to efi_call.

I'm pretty sure that the second patch should be fine in its current
state, but there will likely need to be some discussion about how to
properly handle the stuff I'm doing in the first patch.  I know we need
to do something kind of like what I did, but I know my copied/pasted
UV-specific macros are not how we'll want to implement this in the end.

Please note that, as requested, these patches apply to the current
tip/master branch, but they will not apply out-of-the-box to
linus/master.

Let me know what everybody thinks!

Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-efi@vger.kernel.org

Alex Thorlton (2):
  Create UV efi_call macros
  Fix efi_call

 arch/x86/include/asm/efi.h              |  3 ++
 arch/x86/platform/efi/efi_stub_64.S     |  2 +-
 arch/x86/platform/uv/bios_uv.c          |  3 +-
 drivers/firmware/efi/runtime-wrappers.c | 44 +-------------------------
 include/linux/efi.h                     | 55 +++++++++++++++++++++++++++++++++
 5 files changed, 61 insertions(+), 46 deletions(-)

-- 
1.8.5.6
