From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 1/2] kconfig: use bool instead of boolean for type definition attributes, again
Date: Sat, 16 Dec 2017 00:38:01 +0900
Message-ID: <1513352282-4437-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kbuild@vger.kernel.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, "Luis R . Rodriguez" <mcgrof@suse.com>, Randy Dunlap <rdunlap@infradead.org>, Michal Marek <michal.lkml@markovi.net>, Sam Ravnborg <sam@ravnborg.org>, Ulf Magnusson <ulfalizer@gmail.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, devel@driverdev.osuosl.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Commit 6341e62b212a ("kconfig: use bool instead of boolean for type
definition attributes") did treewide replacement of 'boolean', and
also mentioned the keyword 'boolean' would be dropped later on.

Some years have passed, but it has not happened yet.  Meanwhile, some
new instances have come up.

I am really going to drop this keyword.  I need to do the replacement
once again.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/firmware/efi/Kconfig    | 2 +-
 drivers/staging/rtlwifi/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 2b4c39f..3abdda1 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -113,7 +113,7 @@ config EFI_CAPSULE_LOADER
 	  Most users should say N.
 
 config EFI_CAPSULE_QUIRK_QUARK_CSH
-	boolean "Add support for Quark capsules with non-standard headers"
+	bool "Add support for Quark capsules with non-standard headers"
 	depends on X86 && !64BIT
 	select EFI_CAPSULE_LOADER
 	default y
diff --git a/drivers/staging/rtlwifi/Kconfig b/drivers/staging/rtlwifi/Kconfig
index cb3a29a..12cf467 100644
--- a/drivers/staging/rtlwifi/Kconfig
+++ b/drivers/staging/rtlwifi/Kconfig
@@ -17,6 +17,6 @@ config RTLPHYDM_ST
 	default m
 
 config RTLWIFI_DEBUG_ST
-	boolean
+	bool
 	depends on R8822BE
 	default y
-- 
2.7.4
