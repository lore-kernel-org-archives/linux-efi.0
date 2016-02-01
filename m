From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 06/14] efi: runtime-wrapper: Get rid of the rtc_lock spinlock
Date: Mon,  1 Feb 2016 22:07:00 +0000
Message-ID: <1454364428-494-7-git-send-email-matt@codeblueprint.co.uk>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454364428-494-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

The rtc_lock spinlock aims to serialize access to the CMOS RTC between
the UEFI firmware and the kernel drivers that use it directly. However,
x86 is the only arch that performs such direct accesses, and that never
uses the time related UEFI runtime services. Since no other UEFI enlightened
architectures have a legcay CMOS RTC anyway, we can remove the rtc_lock
spinlock entirely.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 311f415bff51..7b8b2f2702ca 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -61,24 +61,14 @@
  */
 static DEFINE_SPINLOCK(efi_runtime_lock);
 
-/*
- * As per commit ef68c8f87ed1 ("x86: Serialize EFI time accesses on rtc_lock"),
- * the EFI specification requires that callers of the time related runtime
- * functions serialize with other CMOS accesses in the kernel, as the EFI time
- * functions may choose to also use the legacy CMOS RTC.
- */
-__weak DEFINE_SPINLOCK(rtc_lock);
-
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
 	unsigned long flags;
 	efi_status_t status;
 
-	spin_lock_irqsave(&rtc_lock, flags);
-	spin_lock(&efi_runtime_lock);
+	spin_lock_irqsave(&efi_runtime_lock, flags);
 	status = efi_call_virt(get_time, tm, tc);
-	spin_unlock(&efi_runtime_lock);
-	spin_unlock_irqrestore(&rtc_lock, flags);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
 	return status;
 }
 
@@ -87,11 +77,9 @@ static efi_status_t virt_efi_set_time(efi_time_t *tm)
 	unsigned long flags;
 	efi_status_t status;
 
-	spin_lock_irqsave(&rtc_lock, flags);
-	spin_lock(&efi_runtime_lock);
+	spin_lock_irqsave(&efi_runtime_lock, flags);
 	status = efi_call_virt(set_time, tm);
-	spin_unlock(&efi_runtime_lock);
-	spin_unlock_irqrestore(&rtc_lock, flags);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
 	return status;
 }
 
@@ -102,11 +90,9 @@ static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
 	unsigned long flags;
 	efi_status_t status;
 
-	spin_lock_irqsave(&rtc_lock, flags);
-	spin_lock(&efi_runtime_lock);
+	spin_lock_irqsave(&efi_runtime_lock, flags);
 	status = efi_call_virt(get_wakeup_time, enabled, pending, tm);
-	spin_unlock(&efi_runtime_lock);
-	spin_unlock_irqrestore(&rtc_lock, flags);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
 	return status;
 }
 
@@ -115,11 +101,9 @@ static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 	unsigned long flags;
 	efi_status_t status;
 
-	spin_lock_irqsave(&rtc_lock, flags);
-	spin_lock(&efi_runtime_lock);
+	spin_lock_irqsave(&efi_runtime_lock, flags);
 	status = efi_call_virt(set_wakeup_time, enabled, tm);
-	spin_unlock(&efi_runtime_lock);
-	spin_unlock_irqrestore(&rtc_lock, flags);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
 	return status;
 }
 
-- 
2.6.2
