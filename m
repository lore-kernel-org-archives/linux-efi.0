From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V4 1/3] efi: Make efi_rts_work accessible to efi page fault handler
Date: Thu,  6 Sep 2018 16:27:46 -0700
Message-ID: <1536276468-28499-2-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: ricardo.neri@intel.com, matt@codeblueprint.co.uk, Sai Praneeth <sai.praneeth.prakhya@intel.com>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

After the kernel has booted, if any accesses by firmware causes a page
fault, the efi page fault handler would freeze efi_rts_wq and schedules
a new process. To do this, the efi page fault handler needs
efi_rts_work. Hence, make it accessible.

There will be no race conditions in accessing this structure, because,
all the calls to efi runtime services are already serialized.

Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Based-on-code-from: Ricardo Neri <ricardo.neri@intel.com>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Al Stone <astone@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 53 ++++++---------------------------
 include/linux/efi.h                     | 36 ++++++++++++++++++++++
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
index 401e4b254e30..855992b15269 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1659,7 +1659,43 @@ struct linux_efi_tpm_eventlog {
 
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
 /* Workqueue to queue EFI Runtime Services */
 extern struct workqueue_struct *efi_rts_wq;
 
+extern struct efi_runtime_work efi_rts_work;
+
 #endif /* _LINUX_EFI_H */
-- 
2.7.4
