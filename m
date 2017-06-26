From: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v5 0/2] Add EFI capsule pstore backend support
Date: Mon, 26 Jun 2017 23:38:59 +0800
Message-ID: <20170626153859.36880-1-qiuxu.zhuo@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
Cc: tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Change Log v4->v5:
 - 0001 patch: No change.
 - 0002 patch: Fix up all "line over 80 characters" warnings reported by checkpatch.pl tool.

Qiuxu Zhuo (2):
  efi: Add 'nr_config_table' variable in efi structure
  eif/capsule-pstore: Add capsule pstore backend

 arch/x86/platform/efi/efi.c           |   1 +
 drivers/firmware/efi/Kconfig          |  21 +
 drivers/firmware/efi/Makefile         |   1 +
 drivers/firmware/efi/arm-init.c       |   4 +-
 drivers/firmware/efi/capsule-pstore.c | 698 ++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/efi.c            |   1 +
 include/linux/efi.h                   |   1 +
 7 files changed, 726 insertions(+), 1 deletion(-)
 create mode 100644 drivers/firmware/efi/capsule-pstore.c

-- 
2.9.0.GIT
