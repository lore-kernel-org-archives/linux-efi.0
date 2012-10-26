From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 04/20] efivarfs: Add documentation for the EFI variable filesystem
Date: Fri, 26 Oct 2012 08:51:47 +0100
Message-ID: <1351237923-10313-5-git-send-email-matt@console-pimps.org>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/filesystems/00-INDEX     |  2 ++
 Documentation/filesystems/efivarfs.txt | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)
 create mode 100644 Documentation/filesystems/efivarfs.txt

diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
index 8c624a1..7b52ba7 100644
--- a/Documentation/filesystems/00-INDEX
+++ b/Documentation/filesystems/00-INDEX
@@ -38,6 +38,8 @@ dnotify_test.c
 	- example program for dnotify
 ecryptfs.txt
 	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
+efivarfs.txt
+	- info for the efivarfs filesystem.
 exofs.txt
 	- info, usage, mount options, design about EXOFS.
 ext2.txt
diff --git a/Documentation/filesystems/efivarfs.txt b/Documentation/filesystems/efivarfs.txt
new file mode 100644
index 0000000..c477af0
--- /dev/null
+++ b/Documentation/filesystems/efivarfs.txt
@@ -0,0 +1,16 @@
+
+efivarfs - a (U)EFI variable filesystem
+
+The efivarfs filesystem was created to address the shortcomings of
+using entries in sysfs to maintain EFI variables. The old sysfs EFI
+variables code only supported variables of up to 1024 bytes. This
+limitation existed in version 0.99 of the EFI specification, but was
+removed before any full releases. Since variables can now be larger
+than a single page, sysfs isn't the best interface for this.
+
+Variables can be created, deleted and modified with the efivarfs
+filesystem.
+
+efivarfs is typically mounted like this,
+
+	mount -t efivarfs none /sys/firmware/efi/efivars
-- 
1.7.11.7
