From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V5 3/3] efi: Use efi_rts_wq to invoke EFI Runtime Services
Date: Mon, 28 May 2018 19:21:04 -0700
Message-ID: <1527560464-19466-4-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1527560464-19466-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527560464-19466-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, Dave Hansen <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Naresh Bhat <naresh.bhat@linaro.org>, Ricardo Neri <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dan Williams <dan.j.williams@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Presently, when a user process requests the kernel to execute any
efi_runtime_service(), kernel switches the page directory (%cr3) from
swapper_pgd to efi_pgd. Other subsystems in the kernel aren't aware of
this switch and they might think, user space is still valid (i.e. the
user space mappings are still pointing to the process that requested to
run efi_runtime_service()) but in reality it is not so.

A solution for this issue is to use kthread to run
efi_runtime_service(). When a user process requests the kernel to
execute any efi_runtime_service(), kernel queues the work to efi_rts_wq,
a kthread comes along, switches to efi_pgd and executes
efi_runtime_service() in kthread context. Anything that tries to touch
user space addresses while in kthread is terminally broken.

Implementation summary:
-----------------------
1. When user/kernel thread requests to execute efi_runtime_service(),
enqueue work to efi_rts_wq.
2. Caller thread waits for completion until the work is finished because
it's dependent on the return status of efi_runtime_service().

Semantics to pack arguments in efi_runtime_work (has void pointers):
1. If argument is a pointer (of any type), pass it as is.
2. If argument is a value (of any type), address of the value is passed.

Introduce a handler function (called efi_call_rts()) that
1. Understands efi_runtime_work and
2. Invokes the appropriate efi_runtime_service() with the appropriate
arguments

Semantics followed by efi_call_rts() to understand efi_runtime_work:
1. If argument was a pointer, recast it from void pointer to original
pointer type.
2. If argument was a value, recast it from void pointer to original
pointer type and dereference it.

The non-blocking variants of set_variable() and query_variable_info()
should be used while in atomic context. Use of blocking variants like
set_variable() and query_variable_info() while in atomic will issue a
warning ("scheduling wile in atomic") and prints stack trace. Presently,
pstore uses non-blocking variants and hence works fine.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Naresh Bhat <naresh.bhat@linaro.org>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 drivers/firmware/efi/runtime-wrappers.c | 135 ++++++++++++++++++++++++++++----
 1 file changed, 119 insertions(+), 16 deletions(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index cf3bae42a752..127d4de00403 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -173,13 +173,104 @@ void efi_call_virt_check_flags(unsigned long flags, const char *call)
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
+	case RESET_SYSTEM:
+		__efi_call_virt(reset_system, *(int *)arg1,
+				*(efi_status_t *)arg2,
+				*(unsigned long *)arg3,
+				(efi_char16_t *)arg4);
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
@@ -190,7 +281,7 @@ static efi_status_t virt_efi_set_time(efi_time_t *tm)
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(set_time, tm);
+	status = efi_queue_work(SET_TIME, tm, NULL, NULL, NULL, NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -203,7 +294,8 @@ static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(get_wakeup_time, enabled, pending, tm);
+	status = efi_queue_work(GET_WAKEUP_TIME, enabled, pending, tm, NULL,
+				NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -214,7 +306,8 @@ static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(set_wakeup_time, enabled, tm);
+	status = efi_queue_work(SET_WAKEUP_TIME, &enabled, tm, NULL, NULL,
+				NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -229,8 +322,8 @@ static efi_status_t virt_efi_get_variable(efi_char16_t *name,
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(get_variable, name, vendor, attr, data_size,
-			       data);
+	status = efi_queue_work(GET_VARIABLE, name, vendor, attr, data_size,
+				data);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -243,7 +336,8 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(get_next_variable, name_size, name, vendor);
+	status = efi_queue_work(GET_NEXT_VARIABLE, name_size, name, vendor,
+				NULL, NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -258,8 +352,10 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(set_variable, name, vendor, attr, data_size,
-			       data);
+
+	status = efi_queue_work(SET_VARIABLE, name, vendor, &attr, &data_size,
+				data);
+
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -276,6 +372,7 @@ virt_efi_set_variable_nonblocking(efi_char16_t *name, efi_guid_t *vendor,
 
 	status = efi_call_virt(set_variable, name, vendor, attr, data_size,
 			       data);
+
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -293,8 +390,10 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(query_variable_info, attr, storage_space,
-			       remaining_space, max_variable_size);
+
+	status = efi_queue_work(QUERY_VARIABLE_INFO, &attr, storage_space,
+				remaining_space, max_variable_size, NULL);
+
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -315,6 +414,7 @@ virt_efi_query_variable_info_nonblocking(u32 attr,
 
 	status = efi_call_virt(query_variable_info, attr, storage_space,
 			       remaining_space, max_variable_size);
+
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -325,7 +425,8 @@ static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(get_next_high_mono_count, count);
+	status = efi_queue_work(GET_NEXT_HIGH_MONO_COUNT, count, NULL, NULL,
+				NULL, NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -340,7 +441,8 @@ static void virt_efi_reset_system(int reset_type,
 			"could not get exclusive access to the firmware\n");
 		return;
 	}
-	__efi_call_virt(reset_system, reset_type, status, data_size, data);
+	efi_queue_work(RESET_SYSTEM, &reset_type, &status, &data_size, data,
+		       NULL);
 	up(&efi_runtime_lock);
 }
 
@@ -355,7 +457,8 @@ static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(update_capsule, capsules, count, sg_list);
+	status = efi_queue_work(UPDATE_CAPSULE, capsules, &count, &sg_list,
+				NULL, NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
@@ -372,8 +475,8 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 
 	if (down_interruptible(&efi_runtime_lock))
 		return EFI_ABORTED;
-	status = efi_call_virt(query_capsule_caps, capsules, count, max_size,
-			       reset_type);
+	status = efi_queue_work(QUERY_CAPSULE_CAPS, capsules, &count,
+				max_size, reset_type, NULL);
 	up(&efi_runtime_lock);
 	return status;
 }
-- 
2.7.4
