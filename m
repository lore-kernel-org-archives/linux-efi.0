From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/6] arm64/ARM pt dumper changes
Date: Fri, 22 Apr 2016 18:48:02 +0200
Message-ID: <1461343688-8552-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: will.deacon-5wv7dgnIgG8@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This series updates the kernel page table dumper to:
- not initialize the vmemmap region markers dynamically
- show region boundaries for the kasan shadow region
- include the UEFI runtime services mappings

Changes since v1:
- incorporated Mark Rutland's patches to split into separate sysfs files
- give ARM the same treatment so that we can export the UEFI page tables in
  code that is shared between ARM and arm64
- added file to use char arrays rather than char pointer in the marker and
  prot_bits arrays (arm64)

Ard Biesheuvel (4):
  arm64: ptdump: use static initializers for vmemmap region boundaries
  arm64: ptdump: add region marker for kasan shadow region
  arm64: ptdump: fold string literals into address_markers[] and
    pte_bits[]
  arm: mm: dump: make page table dumping reusable

Mark Rutland (2):
  arm64: mm: dump: make page table dumping reusable
  efi/arm*: add support to dump the EFI page tables

 arch/arm/include/asm/ptdump.h      | 44 +++++++++
 arch/arm/mm/dump.c                 | 60 ++++++++-----
 arch/arm64/include/asm/ptdump.h    | 44 +++++++++
 arch/arm64/mm/dump.c               | 94 +++++++++-----------
 drivers/firmware/efi/arm-runtime.c | 21 +++++
 5 files changed, 188 insertions(+), 75 deletions(-)
 create mode 100644 arch/arm/include/asm/ptdump.h
 create mode 100644 arch/arm64/include/asm/ptdump.h

-- 
2.7.4
