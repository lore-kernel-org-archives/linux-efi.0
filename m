From: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/2] capsule pstore backend
Date: Thu, 2 Mar 2017 01:59:41 +0800
Message-ID: <20170301175943.87444-1-qiuxu.zhuo@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

*** BLURB HERE ***

Qiuxu Zhuo (2):
  efi/capsule: Add 'capsule' lookup support
  efi: capsule pstore backend

 drivers/firmware/efi/Kconfig          |  21 ++
 drivers/firmware/efi/Makefile         |   1 +
 drivers/firmware/efi/capsule-pstore.c | 527 ++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/capsule.c        | 107 +++++++
 drivers/firmware/efi/efi.c            |   4 +
 include/linux/efi.h                   |   4 +
 6 files changed, 664 insertions(+)
 create mode 100644 drivers/firmware/efi/capsule-pstore.c
--

Change Log (v1->v2):
  - Use memremap() instead of ioremap() for firmware tables 
  - Remove "default n" in Kconfig file
  - Move check_capsule_support() up a bit
  - Update SoB chain
-- 
2.9.0.GIT
