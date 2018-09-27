From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 06/11] efi: Make efi_rts_work accessible to efi page fault handler
Date: Thu, 27 Sep 2018 10:50:33 +0200
Message-ID: <20180927085039.8391-7-ard.biesheuvel@linaro.org>
References: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>, Alistair Strachan <astrachan@google.com>, Ben Hutchings <ben@decadent.org.uk>, Bhupesh Sharma <bhsharma@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Ivan Hu <ivan.hu@canonical.com>, Jeremy Linton <jeremy.linton@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Robinson <pbrobinson@redhat.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Stefan Agner <stefan@agner.ch>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

After the kernel has booted, if any accesses by firmware causes a page
fault, the efi page fault handler would freeze efi_rts_wq and schedules
a new process. To do this, the efi page fault handler needs
efi_rts_work. Hence, make it accessible.

There will be no race conditions in accessing this structure, because
all the calls to efi runtime services are already serialized.

Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 53 +++++--------------------
 include/linux/efi.h                     | 36 +++++++++++++++++
 2 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index aa66cbf23512..b18b2d864c2c 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -45,39 +45,7 @@
 #define __efi_call_virt(f, args...) \
 	__efi_call_virt_pointer(efi.systab->runtime, f, args)
 
-/* efi_runtime_service() function identifiers */
-enum efi_rts_ids {
-	GET_TIME,
-	SET_TIME,
-	GET_WAKEUP_TIME,
-	SET_WAKEUP_TIME,
-	GET_VARIABLE,
-	GET_NEXT_VARIABLE,
-	SET_VARIABLE,
-	QUERY_VARIABLE_INFO,
-	GET_NEXT_HIGH_MONO_COUNT,
-	UPDATE_CAPSULE,
-	QUERY_CAPSULE_CAPS,
-};
-
-/*
- * efi_runtime_work:	Details of EFI Runtime Service work
- * @arg<1-5>:		EFI Runtime Service function arguments
- * @status:		Status of executing EFI Runtime Service
- * @efi_rts_id:		EFI Runtime Service function identifier
- * @efi_rts_comp:	Struct used for handling completions
- */
-struct efi_runtime_work {
-	void *arg1;
-	void *arg2;
-	void *arg3;
-	void *arg4;
-	void *arg5;
-	efi_status_t status;
-	struct work_struct work;
-	enum efi_rts_ids efi_rts_id;
-	struct completion efi_rts_comp;
-};
+struct efi_runtime_work efi_rts_work;
 
 /*
  * efi_queue_work:	Queue efi_runtime_service() and wait until it's done
@@ -91,7 +59,6 @@ struct efi_runtime_work {
  */
 #define efi_queue_work(_rts, _arg1, _arg2, _arg3, _arg4, _arg5)		\
 ({									\
-	struct efi_runtime_work efi_rts_work;				\
 	efi_rts_work.status = EFI_ABORTED;				\
 									\
 	init_completion(&efi_rts_work.efi_rts_comp);			\
@@ -184,18 +151,16 @@ static DEFINE_SEMAPHORE(efi_runtime_lock);
  */
 static void efi_call_rts(struct work_struct *work)
 {
-	struct efi_runtime_work *efi_rts_work;
 	void *arg1, *arg2, *arg3, *arg4, *arg5;
 	efi_status_t status = EFI_NOT_FOUND;
 
-	efi_rts_work = container_of(work, struct efi_runtime_work, work);
-	arg1 = efi_rts_work->arg1;
-	arg2 = efi_rts_work->arg2;
-	arg3 = efi_rts_work->arg3;
-	arg4 = efi_rts_work->arg4;
-	arg5 = efi_rts_work->arg5;
+	arg1 = efi_rts_work.arg1;
+	arg2 = efi_rts_work.arg2;
+	arg3 = efi_rts_work.arg3;
+	arg4 = efi_rts_work.arg4;
+	arg5 = efi_rts_work.arg5;
 
-	switch (efi_rts_work->efi_rts_id) {
+	switch (efi_rts_work.efi_rts_id) {
 	case GET_TIME:
 		status = efi_call_virt(get_time, (efi_time_t *)arg1,
 				       (efi_time_cap_t *)arg2);
@@ -253,8 +218,8 @@ static void efi_call_rts(struct work_struct *work)
 		 */
 		pr_err("Requested executing invalid EFI Runtime Service.\n");
 	}
-	efi_rts_work->status = status;
-	complete(&efi_rts_work->efi_rts_comp);
+	efi_rts_work.status = status;
+	complete(&efi_rts_work.efi_rts_comp);
 }
 
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 22e4de9d3700..a929d2bf41fa 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1662,6 +1662,42 @@ struct linux_efi_tpm_eventlog {
 
 extern int efi_tpm_eventlog_init(void);
 
+/* efi_runtime_service() function identifiers */
+enum efi_rts_ids {
+	GET_TIME,
+	SET_TIME,
+	GET_WAKEUP_TIME,
+	SET_WAKEUP_TIME,
+	GET_VARIABLE,
+	GET_NEXT_VARIABLE,
+	SET_VARIABLE,
+	QUERY_VARIABLE_INFO,
+	GET_NEXT_HIGH_MONO_COUNT,
+	UPDATE_CAPSULE,
+	QUERY_CAPSULE_CAPS,
+};
+
+/*
+ * efi_runtime_work:	Details of EFI Runtime Service work
+ * @arg<1-5>:		EFI Runtime Service function arguments
+ * @status:		Status of executing EFI Runtime Service
+ * @efi_rts_id:		EFI Runtime Service function identifier
+ * @efi_rts_comp:	Struct used for handling completions
+ */
+struct efi_runtime_work {
+	void *arg1;
+	void *arg2;
+	void *arg3;
+	void *arg4;
+	void *arg5;
+	efi_status_t status;
+	struct work_struct work;
+	enum efi_rts_ids efi_rts_id;
+	struct completion efi_rts_comp;
+};
+
+extern struct efi_runtime_work efi_rts_work;
+
 /* Workqueue to queue EFI Runtime Services */
 extern struct workqueue_struct *efi_rts_wq;
 
-- 
2.18.0
