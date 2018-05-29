From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V5 2/3] efi: Create efi_rts_wq and efi_queue_work() to invoke all efi_runtime_services()
Date: Mon, 28 May 2018 19:21:03 -0700
Message-ID: <1527560464-19466-3-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1527560464-19466-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527560464-19466-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, Dave Hansen <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Naresh Bhat <naresh.bhat@linaro.org>, Ricardo Neri <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dan Williams <dan.j.williams@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

When a process requests the kernel to execute any efi_runtime_service(),
the requested efi_runtime_service (represented as an identifier) and its
arguments are packed into a struct named efi_runtime_work and queued
onto work queue named efi_rts_wq. The caller then waits until the work
is completed.

Introduce some infrastructure:
1. Creating workqueue named efi_rts_wq
2. A macro (efi_queue_work()) that
	a. Populates efi_runtime_work
	b. Queues work onto efi_rts_wq and
	c. Waits until worker thread completes

The caller thread has to wait until the worker thread completes, because
it depends on the return status of efi_runtime_service() and, in
specific cases, the arguments populated by efi_runtime_service(). Some
efi_runtime_services() takes a pointer to buffer as an argument and
fills up the buffer with requested data. For instance,
efi_get_variable() and efi_get_next_variable(). Hence, caller process
cannot just post the work and get going.

Some facts about efi_runtime_services():
1. A quick look at all the efi_runtime_services() shows that any
efi_runtime_service() has five or less arguments.
2. An argument of efi_runtime_service() can be a value (of any type)
or a pointer (of any type).
Hence, efi_runtime_work has five void pointers to store these arguments.

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
 drivers/firmware/efi/efi.c              | 14 ++++++
 drivers/firmware/efi/runtime-wrappers.c | 83 +++++++++++++++++++++++++++++++++
 include/linux/efi.h                     |  3 ++
 3 files changed, 100 insertions(+)

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
index ae54870b2788..cf3bae42a752 100644
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
@@ -33,6 +45,77 @@
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
+	RESET_SYSTEM,
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
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 3016d8c456bc..116689c56441 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1651,4 +1651,7 @@ struct linux_efi_tpm_eventlog {
 
 extern int efi_tpm_eventlog_init(void);
 
+/* Workqueue to queue EFI Runtime Services */
+extern struct workqueue_struct *efi_rts_wq;
+
 #endif /* _LINUX_EFI_H */
-- 
2.7.4
