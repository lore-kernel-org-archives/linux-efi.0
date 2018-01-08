From: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] efi: Clarify that reset attack mitigation needs appropriate userspace
Date: Mon,  8 Jan 2018 14:50:00 -0800
Message-ID: <20180108225000.197906-1-mjg59@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Some distributions have turned on the reset attack mitigation feature,
which is designed to force the platform to clear the contents of RAM if
the machine is shut down uncleanly. However, in order for the platform
to be able to determine whether the shutdown was clean or not, userspace
has to be configured to clear the MemoryOverwriteRequest flag on
shutdown - otherwise the firmware will end up clearing RAM on every
reboot, which is unnecessarily time consuming. Add some additional
clarity to the kconfig text to reduce the risk of systems being
configured this way.

Signed-off-by: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/firmware/efi/Kconfig | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 2b4c39fdfa91..86210f75d233 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -159,7 +159,10 @@ config RESET_ATTACK_MITIGATION
 	  using the TCG Platform Reset Attack Mitigation specification. This
 	  protects against an attacker forcibly rebooting the system while it
 	  still contains secrets in RAM, booting another OS and extracting the
-	  secrets.
+	  secrets. This should only be enabled when userland is configured to
+	  clear the MemoryOverwriteRequest flag on clean shutdown after secrets
+	  have been evicted, since otherwise it will trigger even on clean
+	  reboots.
 
 endmenu
 
-- 
2.16.0.rc0.223.g4a4ac83678-goog
