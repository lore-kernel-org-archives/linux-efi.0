From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 08/11] efi/x86: drop task_lock() from efi_switch_mm()
Date: Thu, 27 Sep 2018 10:50:35 +0200
Message-ID: <20180927085039.8391-9-ard.biesheuvel@linaro.org>
References: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>, Alistair Strachan <astrachan@google.com>, Ben Hutchings <ben@decadent.org.uk>, Bhupesh Sharma <bhsharma@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Ivan Hu <ivan.hu@canonical.com>, Jeremy Linton <jeremy.linton@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Robinson <pbrobinson@redhat.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Stefan Agner <stefan@agner.ch>
List-Id: linux-efi@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

efi_switch_mm() is a wrapper around switch_mm() which saves current's
->active_mm, sets the requests mm as ->active_mm and invokes
switch_mm().
I don't think that task_lock() is required during that procedure. It
protects ->mm which isn't changed here.

It needs to be mentioned that during the whole procedure (switch to
EFI's mm and back) the preemption needs to be disabled. A context switch
at this point would reset the cr3 value based on current->mm. Also, this
function may not be invoked at the same time on a different CPU because
it would overwrite the efi_scratch.prev_mm information.

Remove task_lock() and also update the comment to reflect it.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/platform/efi/efi_64.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index ee5d08f25ce4..e8da7f492970 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -619,18 +619,16 @@ void __init efi_dump_pagetable(void)
 
 /*
  * Makes the calling thread switch to/from efi_mm context. Can be used
- * for SetVirtualAddressMap() i.e. current->active_mm == init_mm as well
- * as during efi runtime calls i.e current->active_mm == current_mm.
- * We are not mm_dropping()/mm_grabbing() any mm, because we are not
- * losing/creating any references.
+ * in a kernel thread and user context. Preemption needs to remain disabled
+ * while the EFI-mm is borrowed. mmgrab()/mmdrop() is not used because the mm
+ * can not change under us.
+ * It should be ensured that there are no concurent calls to this function.
  */
 void efi_switch_mm(struct mm_struct *mm)
 {
-	task_lock(current);
 	efi_scratch.prev_mm = current->active_mm;
 	current->active_mm = mm;
 	switch_mm(efi_scratch.prev_mm, mm, NULL);
-	task_unlock(current);
 }
 
 #ifdef CONFIG_EFI_MIXED
-- 
2.18.0
