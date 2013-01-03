From: Matt Fleming <matt@console-pimps.org>
Subject: [RFC PATCH 2/2] samsung-laptop: Disable on EFI hardware
Date: Thu,  3 Jan 2013 13:18:05 +0000
Message-ID: <1357219085-4312-3-git-send-email-matt@console-pimps.org>
References: <1357219085-4312-1-git-send-email-matt@console-pimps.org>
Return-path: <platform-driver-x86-owner@vger.kernel.org>
In-Reply-To: <1357219085-4312-1-git-send-email-matt@console-pimps.org>
Sender: platform-driver-x86-owner@vger.kernel.org
To: Steve Langasek <steve.langasek@canonical.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Olof Johansson <olof@lixom.net>, Tony Luck <tony.luck@intel.com>, Matt Fleming <matt.fleming@intel.com>, Corentin Chary <corentincj@iksaif.net>, platform-driver-x86@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

There have been reports of this driver causing Machine Check
Exceptions on recent EFI-enabled Samsung laptops,

	https://bugzilla.kernel.org/show_bug.cgi?id=47121

So disable it if booting from EFI since this driver relies on
grovelling around in the BIOS memory map which isn't going to work.

Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Steve Langasek <steve.langasek@canonical.com>
Cc: platform-driver-x86@vger.kernel.org
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/platform/x86/samsung-laptop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index dd90d15..a94c0ee 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -1534,6 +1534,9 @@ static int __init samsung_init(void)
 	struct samsung_laptop *samsung;
 	int ret;
 
+	if (efi_enabled(EFI_BOOT))
+		return -ENODEV;
+
 	quirks = &samsung_unknown;
 	if (!force && !dmi_check_system(samsung_dmi_table))
 		return -ENODEV;
-- 
1.7.11.7
