From: Sylvain Chouleur <sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/3] efi interruptible runtime services
Date: Wed,  6 Jan 2016 23:33:54 +0100
Message-ID: <1452119637-10958-1-git-send-email-sylvain.chouleur@gmail.com>
References: <1450434591-31104-1-git-send-email-sylvain.chouleur@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450434591-31104-1-git-send-email-sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Changes in v2:
 - Split patch 1 in patches 1 and 2
 - Document (un)registration of __efivars protection
 - Return early from efivars_sysfs_exit() in case of failure
 - Improve readability
 - Update functions documentation
 - Fix typo
 - Fix checkpatch warnings
 - Warning in KConfig description

Sylvain Chouleur (3):
 efi: implement interruptible runtime services
 efi: don't use spinlocks for efi vars
 efi: use a file local lock for efivars

 arch/x86/Kconfig                          |   17 +++++
 arch/x86/include/asm/efi.h                |    1 
 arch/x86/platform/efi/Makefile            |    1 
 arch/x86/platform/efi/efi_32.c            |    5 +
 arch/x86/platform/efi/efi_64.c            |    5 +
 arch/x86/platform/efi/efi_interruptible.c |  191 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/efi-pstore.c         |   36 +++++++---
 drivers/firmware/efi/efivars.c            |   20 ++++-
 drivers/firmware/efi/vars.c               |  230 ++++++++++++++++++++++++++++++++++++++++----------------------------
 fs/efivarfs/inode.c                       |    5 +
 fs/efivarfs/super.c                       |    9 ++
 include/linux/efi.h                       |   12 ---
 12 files changed, 415 insertions(+), 117 deletions(-)
