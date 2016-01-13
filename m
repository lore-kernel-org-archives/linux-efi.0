From: Sylvain Chouleur <sylvain.chouleur@gmail.com>
Subject: [PATCH v3 0/3] efi interruptible runtime services
Date: Wed, 13 Jan 2016 17:32:39 +0100
Message-ID: <1452702762-27216-1-git-send-email-sylvain.chouleur@gmail.com>
References: <1452119637-10958-1-git-send-email-sylvain.chouleur@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452119637-10958-1-git-send-email-sylvain.chouleur@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: sylvain.chouleur@gmail.com
Cc: Sylvain Chouleur <sylvain.chouleur@intel.com>, linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org

From: Sylvain Chouleur <sylvain.chouleur@intel.com>

Changes in v3:
 - efivars_(un)register: use down_interruptible()
 - efivar_create_sysfs_entry: unregister new_var in case of failure
 - efi_interruptible: in case of panic call directly legacy handlers

Sylvain Chouleur (3):
 efi: implement interruptible runtime services
 efi: don't use spinlocks for efi vars
 efi: use a file local lock for efivars

 arch/x86/Kconfig                          |   17 +++
 arch/x86/include/asm/efi.h                |    1 
 arch/x86/platform/efi/Makefile            |    1 
 arch/x86/platform/efi/efi_32.c            |    5 +
 arch/x86/platform/efi/efi_64.c            |    5 +
 arch/x86/platform/efi/efi_interruptible.c |  189 ++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/efi-pstore.c         |   36 +++++--
 drivers/firmware/efi/efivars.c            |   22 +++-
 drivers/firmware/efi/vars.c               |  315 ++++++++++++++++++++++++++++++++++++++++----------------------------
 fs/efivarfs/inode.c                       |    5 -
 fs/efivarfs/super.c                       |    9 +
 include/linux/efi.h                       |   18 ---
 12 files changed, 463 insertions(+), 160 deletions(-)
