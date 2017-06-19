From: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 0/2] Add EFI capsule pstore backend support
Date: Tue, 20 Jun 2017 01:54:04 +0800
Message-ID: <20170619175404.56069-1-qiuxu.zhuo@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Change Log v2->v3:
 - Get rid of 'capsule' in efi structure, and add 'nr_config_table' in efi structure for iterating over configuration table array.
 - Move efi_capsule_lookup() from capsule.c to capsule-pstore.c, and extract capsule with any GUID by iterating over the configuration table array.
 - Add PMSG support.
 - Reduce debug/info message.
 - Include a file header comment for new file capsuel-pstore.c.
 - Some bug fix and code cleanup.

Qiuxu Zhuo (2):
  efi: Add 'nr_config_table' variable in efi structure
  eif/capsule-pstore: Add capsule pstore backend

 arch/x86/platform/efi/efi.c           |   1 +
 drivers/firmware/efi/Kconfig          |  21 ++
 drivers/firmware/efi/Makefile         |   1 +
 drivers/firmware/efi/capsule-pstore.c | 667 ++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/efi.c            |   1 +
 include/linux/efi.h                   |   1 +
 6 files changed, 692 insertions(+)
 create mode 100644 drivers/firmware/efi/capsule-pstore.c

-- 
2.9.0.GIT
