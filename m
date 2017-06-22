From: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 0/2] Add EFI capsule pstore backend support
Date: Fri, 23 Jun 2017 00:34:34 +0800
Message-ID: <20170622163434.95704-1-qiuxu.zhuo@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
Cc: tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Change Log v3->v4:
 - Add comment 'the number of config tables' for 'nr_config_table' in efi structure
 - Initialize 'efi.nr_config_table' to 0 in default
 - Set 'efi.nr_config_table' to 'efi.systab->nr_tables' in drivers/firmware/efi/arm-init.c -> uefi_init()
 - Mark 'efi_capsule_pstore_disable' as __ro_after_init
 - Use timestamp value passed from pstore API rather than using get_seconds() 
 - Pass page physcial addresses rather than struct page pointers to efi_capsule_update()

Qiuxu Zhuo (2):
  efi: Add 'nr_config_table' variable in efi structure
  eif/capsule-pstore: Add capsule pstore backend

 arch/x86/platform/efi/efi.c           |   1 +
 drivers/firmware/efi/Kconfig          |  21 ++
 drivers/firmware/efi/Makefile         |   1 +
 drivers/firmware/efi/arm-init.c       |   4 +-
 drivers/firmware/efi/capsule-pstore.c | 679 ++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/efi.c            |   1 +
 include/linux/efi.h                   |   1 +
 7 files changed, 707 insertions(+), 1 deletion(-)
 create mode 100644 drivers/firmware/efi/capsule-pstore.c

-- 
2.9.0.GIT
