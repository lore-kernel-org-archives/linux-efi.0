From: Baoquan He <bhe@redhat.com>
Subject: [PATCH v9 0/2] x86/boot/KASLR: Restrict kernel to be randomized in mirror regions
Date: Mon, 14 Aug 2017 22:54:22 +0800
Message-ID: <1502722464-20614-1-git-send-email-bhe@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mingo@kernel.org, matt@codeblueprint.co.uk
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org, tglx@linutronix.de, hpa@zytor.com, izumi.taku@jp.fujitsu.com, fanc.fnst@cn.fujitsu.com, thgarnie@google.com, n-horiguchi@ah.jp.nec.com, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, x86@kernel.org, Baoquan He <bhe@redhat.com>
List-Id: linux-efi@vger.kernel.org

Patch 1/2 is added to add efi_early_memdesc_ptr helper to wrap the open
code which gets the start of efi memmap descriptor and also explain why
it need be done like that, Ingo suggested it.

And also replace several places of the open code with efi_early_memdesc_ptr
helper.

And also use efi_early_memdesc_ptr in process_efi_entries() which handle efi
mirror issue during KASLR.


Change:
v8->v9:
    Matt suggested that an 'early' should be included in the name of
    the helper to make its name as efi_early_memdesc_ptr. That can help
    denote the helper should only be used in early bootup stage, after
    that for_each_efi_memory_*() API is suggested.

v7->v8:
    Add efi_memdesc_ptr helper to wrap the open code which gets the
    start of map descriptor according to Ingo's suggestion.

v6->v7:
  Ingo pointed out several incorrect line break issues and unclear
  description of patch log. Correct them and rewrite patch log.

  And also rewrite the EFI warning message that if EFI memmap is above
  4G in 32bit system since 32bit system can not handle data above 4G at
  kernel decompression stage. This is suggested by Ingo too.

v5->v6:
  Code style issue fix according to Kees's comment.

  This is based on tip/x86/boot, patch 1,2,3/4 in v5 post has
  been put into tip/x86/boot now.

Baoquan He (2):
  efi: Introduce efi_early_memdesc_ptr to get pointer to memmap
    descriptor
  x86/boot/KASLR: Restrict kernel to be randomized in mirror regions

 arch/x86/boot/compressed/eboot.c               |  2 +-
 arch/x86/boot/compressed/kaslr.c               | 68 +++++++++++++++++++++++++-
 drivers/firmware/efi/libstub/efi-stub-helper.c |  4 +-
 include/linux/efi.h                            | 21 ++++++++
 4 files changed, 90 insertions(+), 5 deletions(-)

-- 
2.5.5
