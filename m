From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/8] efi: Use a work queue to invoke EFI Runtime Services
Date: Wed, 11 Jul 2018 11:40:35 +0200
Message-ID: <20180711094040.12506-4-ard.biesheuvel@linaro.org>
References: <20180711094040.12506-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711094040.12506-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Presently, when a user process requests the kernel to execute any
UEFI runtime service, the kernel temporarily switches to a separate
set of page tables that describe the virtual mapping of the UEFI
runtime services regions in memory. Since UEFI runtime services are
typically invoked with interrupts enabled, any code that may be called
during this time, will have an incorrect view of the process's address
space. Although it is unusual for code running in interrupt context to
make assumptions about the process context it runs in, there are cases
(such as the perf subsystem taking samples) where this causes problems.

So let's set up a work queue for calling UEFI runtime services, so that
the actual calls are made when the work queue items are dispatched by a
work queue worker running in a separate kernel thread. Such threads are
not expected to have userland mappings in the first place, and so the
additional mappings created for the UEFI runtime services can never
clash with any.

The ResetSystem() runtime service is not covered by the work queue
handling, since it is not expected to return, and may be called at a
time when the kernel is torn down to the point where we cannot expect
work queues to still be operational.

The non-blocking variants of SetVariable() and QueryVariableInfo()
are also excluded: these are intended to be used from atomic context,
which obviously rules out waiting for a completion to be signalled by
another thread. Note that these variants are currently only used for
UEFI runtime services calls that occur very early in the boot, and
for ones that occur in critical conditions, e.g., to flush kernel logs
to UEFI variables via efi-pstore.

Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
[ardb: exclude ResetSystem() from the workqueue treatment
       merge from 2 separate patches and rewrite commit log]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/efi.c              |  14 ++
 drivers/firmware/efi/runtime-wrappers.c | 202 ++++++++++++++++++++++--
 include/linux/efi.h                     |   3 +
 3 files changed, 204 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 232f4915223b..1379a375dfa8 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -84,6 +84,8 @@ struct mm_struct efi_mm = {
 	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
 };
 
+struct workqueue_struct *efi_rts_wq;
+
 static bool disable_runtime;
 static int __init setup_noefi(char *arg)
 {
@@ -337,6 +339,18 @@ static int __init efisubsys_init(void)
 	if (!efi_enabled(EFI_BOOT))
 		return 0;
 
+	/*
+	 * Since we process only one efi_runtime_service() at a time, an
+	 * ordered workqueue (which creates only one execution context)
+	 * should suffice all our needs.
+	 */
+	efi_rts_wq = alloc_ordered_workqueue("efi_rts_wq", 0);
+	if (!efi_rts_wq) {
+		pr_err("Creating efi_rts_wq failed, EFI runtime services disabled.\n");
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+		return 0;
+	}
+
 	/* We register the efi directory at /sys/firmware/efi */
 	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
 	if (!efi_kobj) {
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index ae54870b2788..aa66cbf23512 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -1,6 +1,15 @@
 /*
  * runtime-wrappers.c - Runtime Services function call wrappers
  *
+ * Implementation summary:
+ * -----------------------
+ * 1. When user/kernel thread requests to execute efi_runtime_service(),
+ * enqueue work to efi_rts_wq.
+ * 2. Caller thread waits for completion until the work is finished
+ * because it's dependent on the return status and execution of
+ * efi_runtime_service().
+ * For instance, get_variable() and get_next_variable().
+ *
  * Copyright (C) 2014 Linaro Ltd. <ard.biesheuvel@linaro.org>
  *
  * Split off from arch/x86/platform/efi/efi.c
@@ -22,6 +31,9 @@
 #include <linux/mutex.h>
 #include <linux/semaphore.h>
 #include <linux/stringify.h>
+#include <linux/workqueue.h>
+#include <linux/completion.h>
+
 #include <asm/efi.h>
 
 /*
@@ -33,6 +45,76 @@
 #define __efi_call_virt(f, args...) \
 	__efi_call_virt_pointer(efi.systab->runtime, f, args)
 
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
+/*
+ * efi_queue_work:	Queue efi_runtime_service() and wait until it's done
+ * @rts:		efi_runtime_service() function identifier
+ * @rts_arg<1-5>:	efi_runtime_service() function arguments
+ *
+ * Accesses to efi_runtime_services() are serialized by a binary
+ * semaphore (efi_runtime_lock) and caller waits until the work is
+ * finished, hence _only_ one work is queued at a time and the caller
+ * thread waits for completion.
+ */
+#define efi_queue_work(_rts, _arg1, _arg2, _arg3, _arg4, _arg5)		\
+({									\
+	struct efi_runtime_work efi_rts_work;				\
+	efi_rts_work.status = EFI_ABORTED;				\
+									\
+	init_completion(&efi_rts_work.efi_rts_comp);			\
+	INIT_WORK_ONSTACK(&efi_rts_work.work, efi_call_rts);		\
+	efi_rts_work.arg1 = _arg1;					\
+	efi_rts_work.arg2 = _arg2;					\
+	efi_rts_work.arg3 = _arg3;					\
+	efi_rts_work.arg4 = _arg4;					\
+	efi_rts_work.arg5 = _arg5;					\
+	efi_rts_work.efi_rts_id = _rts;					\
+									\
+	/*								\
+	 * queue_work() returns 0 if work was already on queue,         \
+	 * _ideally_ this should never happen.                          \
+	 */								\
+	if (queue_work(efi_rts_wq, &efi_rts_work.work))			\
+		wait_for_completion(&efi_rts_work.efi_rts_comp);	\
+	else								\
+		pr_err("Failed to queue work to efi_rts_wq.\n");	\
+									\
+	efi_rts_work.status;						\
+})
+
 void efi_call_virt_check_flags(unsigned long flags, const char *call)
 {
 	unsigned long cur_flags, mismatch;
@@ -90,13 +172,98 @@ void efi_call_virt_check_flags(unsigned long flags, const char *call)
  */
 static DEFINE_SEMAPHORE(efi_runtime_lock);
 
+/*
+ * Calls the appropriate efi_runtime_service() with the appropriate
+ * arguments.
+ *
+ * Semantics followed by efi_call_rts() to understand efi_runtime_work:
+ * 1. If argument was a pointer, recast it from void pointer to original
+ * pointer type.
+ * 2. If argument was a value, recast it from void pointer to original
+ * pointer type and dereference it.
+ */
+static void efi_call_rts(struct work_struct *work)
+{
+	struct efi_runtime_work *efi_rts_work;
+	void *arg1, *arg2, *arg3, *arg4, *arg5;
+	efi_status_t status = EFI_NOT_FOUND;
+
+	efi_rts_work = container_of(work, struct efi_runtime_work, work);
+	arg1 = efi_rts_work->arg1;
+	arg2 = efi_rts_work->arg2;
+	arg3 = efi_rts_work->arg3;
+	arg4 = efi_rts_work->arg4;
+	arg5 = efi_rts_work->arg5;
+
+	switch (efi_rts_work->efi_rts_id) {
+	case GET_TIME:
+		status = efi_call_virt(get_time, (efi_time_t *)arg1,
+				       (efi_time_cap_t *)arg2);
+		break;
+	case SET_TIME:
+		status = efi_call_virt(set_time, (efi_time_t *)arg1);
+		break;
+	case GET_WAKEUP_TIME:
+		status = efi_call_virt(get_wakeup_time, (efi_bool_t *)arg1,
+				       (efi_bool_t *)arg2, (efi_time_t *)arg3);
+		break;
+	case SET_WAKEUP_TIME:
+		status = efi_call_virt(set_wakeup_time, *(efi_bool_t *)arg1,
+				       (efi_time_t *)arg2);
+		break;
+	case GET_VARIABLE:
+		status = efi_call_virt(get_variable, (efi_char16_t *)arg1,
+				       (efi_guid_t *)arg2, (u32 *)arg3,
+				       (unsigned long *)arg4, (void *)arg5);
+		break;
+	case GET_NEXT_VARIABLE:
+		status = efi_call_virt(get_next_variable, (unsigned long *)arg1,
+				       (efi_char16_t *)arg2,
+				       (efi_guid_t *)arg3);
+		break;
+	case SET_VARIABLE:
+		status = efi_call_virt(set_variable, (efi_char16_t *)arg1,
+				       (efi_guid_t *)arg2, *(u32 *)arg3,
+				       *(unsigned long *)arg4, (void *)arg5);
+		break;
+	case QUERY_VARIABLE_INFO:
+		status = efi_call_virt(query_variable_info, *(u32 *)arg1,
+				       (u64 *)arg2, (u64 *)arg3, (u64 *)arg4);
+		break;
+	case GET_NEXT_HIGH_MONO_COUNT:
+		status = efi_call_virt(get_next_high_mono_count, (u32 *)arg1);
+		break;
+	case UPDATE_CAPSULE:
+		status = efi_call_virt(update_capsule,
+				       (efi_capsule_header_t **)arg1,
+				       *(unsigned long *)arg2,
+				       *(unsigned long *)arg3);
+		break;
+	case QUERY_CAPSULE_CAPS:
+		status = efi_call_virt(query_capsule_caps,
+				       (efi_capsule_header_t **)arg1,
+				       *(unsigned long *)arg2, (u64 *)arg3,
+				       (int *)arg4);
+		break;
+	default:
+		/*
+		 * Ideally, we should never reach here because a caller of this
+		 * function should have put the right efi_runtime_service()
+		 * function identifier into efi_rts_work->efi_rts_id
+		 */
+		pr_err("Requested executing invalid EFI Runtime Service.\n");
+	}
+	efi_rts_work->status = status;
+	complete(&efi_rts_work->efi_rts_comp);
+}
+
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
 	efi_status_t status;
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(get_time, tm, tc);
+	status = efi_queue_work(GET_TIME, tm, tc, NULL, NULL, NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -107,7 +274,7 @@ static efi_status_t virt_efi_set_time(efi_time_t *tm)
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(set_time, tm);
+	status = efi_queue_work(SET_TIME, tm, NULL, NULL, NULL, NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -120,7 +287,8 @@ static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(get_wakeup_time, enabled, pending, tm);
+	status = efi_queue_work(GET_WAKEUP_TIME, enabled, pending, tm, NULL,
+				NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -131,7 +299,8 @@ static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(set_wakeup_time, enabled, tm);
+	status = efi_queue_work(SET_WAKEUP_TIME, &enabled, tm, NULL, NULL,
+				NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -146,8 +315,8 @@ static efi_status_t virt_efi_get_variable(efi_char16_t *name,
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(get_variable, name, vendor, attr, data_size,
-			       data);
+	status = efi_queue_work(GET_VARIABLE, name, vendor, attr, data_size,
+				data);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -160,7 +329,8 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(get_next_variable, name_size, name, vendor);
+	status = efi_queue_work(GET_NEXT_VARIABLE, name_size, name, vendor,
+				NULL, NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -175,8 +345,8 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(set_variable, name, vendor, attr, data_size,
-			       data);
+	status = efi_queue_work(SET_VARIABLE, name, vendor, &attr, &data_size,
+				data);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -210,8 +380,8 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(query_variable_info, attr, storage_space,
-			       remaining_space, max_variable_size);
+	status = efi_queue_work(QUERY_VARIABLE_INFO, &attr, storage_space,
+				remaining_space, max_variable_size, NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -242,7 +412,8 @@ static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(get_next_high_mono_count, count);
+	status = efi_queue_work(GET_NEXT_HIGH_MONO_COUNT, count, NULL, NULL,
+				NULL, NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -272,7 +443,8 @@ static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(update_capsule, capsules, count, sg_list);
+	status = efi_queue_work(UPDATE_CAPSULE, capsules, &count, &sg_list,
+				NULL, NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -289,8 +461,8 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(query_capsule_caps, capsules, count, max_size,
-			       reset_type);
+	status = efi_queue_work(QUERY_CAPSULE_CAPS, capsules, &count,
+				max_size, reset_type, NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 56add823f190..8ba0cdd244b2 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1651,4 +1651,7 @@ struct linux_efi_tpm_eventlog {
 
 extern int efi_tpm_eventlog_init(void);
 
+/* Workqueue to queue EFI Runtime Services */
+extern struct workqueue_struct *efi_rts_wq;
+
 #endif /* _LINUX_EFI_H */
-- 
2.17.1
