From: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv3 0/4] WX checking for arm64
Date: Tue, 18 Oct 2016 15:01:27 -0700
Message-ID: <1476828091-17802-1-git-send-email-labbott@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, David Brown <david.brown-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

This is v3 of the implementation to check for writable and executable pages on
arm64. This is a basically a rebase + acks.

Laura Abbott (4):
  arm64: dump: Make ptdump debugfs a separate option
  arm64: dump: Make the page table dumping seq_file optional
  arm64: dump: Remove max_addr
  arm64: dump: Add checking for writable and exectuable pages

 arch/arm64/Kconfig.debug           |  35 ++++++++++++-
 arch/arm64/include/asm/ptdump.h    |  22 +++++---
 arch/arm64/mm/Makefile             |   3 +-
 arch/arm64/mm/dump.c               | 104 +++++++++++++++++++++++++++----------
 arch/arm64/mm/mmu.c                |   2 +
 arch/arm64/mm/ptdump_debugfs.c     |  31 +++++++++++
 drivers/firmware/efi/arm-runtime.c |   5 +-
 7 files changed, 163 insertions(+), 39 deletions(-)
 create mode 100644 arch/arm64/mm/ptdump_debugfs.c

-- 
2.7.4
