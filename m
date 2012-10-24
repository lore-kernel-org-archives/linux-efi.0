From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Add syste-firmware-efi-efivars.mount for support automount EFI variable filesystem
Date: Wed, 24 Oct 2012 18:42:02 +0800
Message-ID: <1351075322-3824-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Add units/sys-firmware-efi-efivars.mount rule for support automount EFI variable filesystem

Cc: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
Cc: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 units/sys-firmware-efi-efivars.mount |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)
 create mode 100644 units/sys-firmware-efi-efivars.mount

diff --git a/units/sys-firmware-efi-efivars.mount b/units/sys-firmware-efi-efivars.mount
new file mode 100644
index 0000000..641d771
--- /dev/null
+++ b/units/sys-firmware-efi-efivars.mount
@@ -0,0 +1,17 @@
+#  This file is part of systemd.
+#
+#  systemd is free software; you can redistribute it and/or modify it
+#  under the terms of the GNU General Public License as published by
+#  the Free Software Foundation; either version 2 of the License, or
+#  (at your option) any later version.
+
+[Unit]
+Description=EFI Variables File System
+DefaultDependencies=no
+ConditionPathExists=/sys/firmware/efi/efivars
+Before=sysinit.target
+
+[Mount]
+What=efivarfs
+Where=/sys/firmware/efi/efivars
+Type=efivarfs
-- 
1.6.0.2
