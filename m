From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] arm64: document that pending SErrors are not allowed at kernel entry
Date: Fri,  1 Jul 2016 17:01:31 +0200
Message-ID: <1467385291-9880-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1467385291-9880-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467385291-9880-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Our current strategy to deal with pending SErrors at boot is to panic.
So let's mention in our boot protocol documentation that no SErrors
should be pending when handing over to the kernel.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 Documentation/arm64/booting.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
index 8d0df62c3fe0..75dcfead1a0c 100644
--- a/Documentation/arm64/booting.txt
+++ b/Documentation/arm64/booting.txt
@@ -154,8 +154,9 @@ Before jumping into the kernel, the following conditions must be met:
   x3 = 0 (reserved for future use)
 
 - CPU mode
-  All forms of interrupts must be masked in PSTATE.DAIF (Debug, SError,
-  IRQ and FIQ).
+  All forms of exceptions must be masked in PSTATE.DAIF (Debug, SError,
+  IRQ and FIQ), and any pending SError exceptions must be taken by the
+  boot loader or firmware before handing over to the kernel.
   The CPU must be in either EL2 (RECOMMENDED in order to have access to
   the virtualisation extensions) or non-secure EL1.
 
-- 
2.7.4
