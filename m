From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC] fs: make efivarfs a pseudo filesystem, built by default with EFI
Date: Thu, 18 Dec 2014 17:50:49 +0000
Message-ID: <1418925049-3659-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

efivars is currently enabled under MISC_FILESYSTEMS, which is decribed
as "such as filesystems that came from other operating systems".
In reality, it is a pseudo filesystem, providing access to the kernel
UEFI variable interface.

Since this is the preferred interface for accessing UEFI variables, over
the legacy efivars interface, also build it by default as a module if
CONFIG_EFI.

Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 fs/Kconfig          | 2 +-
 fs/efivarfs/Kconfig | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 664991a..a6bb530 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -165,6 +165,7 @@ config HUGETLB_PAGE
 	def_bool HUGETLBFS
 
 source "fs/configfs/Kconfig"
+source "fs/efivarfs/Kconfig"
 
 endmenu
 
@@ -209,7 +210,6 @@ source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
 source "fs/f2fs/Kconfig"
-source "fs/efivarfs/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
diff --git a/fs/efivarfs/Kconfig b/fs/efivarfs/Kconfig
index 367bbb1..c2499ef 100644
--- a/fs/efivarfs/Kconfig
+++ b/fs/efivarfs/Kconfig
@@ -1,6 +1,7 @@
 config EFIVAR_FS
 	tristate "EFI Variable filesystem"
 	depends on EFI
+	default m
 	help
 	  efivarfs is a replacement filesystem for the old EFI
 	  variable support via sysfs, as it doesn't suffer from the
-- 
2.1.3
