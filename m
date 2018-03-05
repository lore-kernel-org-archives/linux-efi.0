From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V2 2/3] efi: Introduce efi_rts_workqueue and some infrastructure to invoke all efi_runtime_services()
Date: Mon,  5 Mar 2018 15:23:09 -0800
Message-ID: <1520292190-5027-3-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1520292190-5027-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520292190-5027-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee@vger.kernel.org, Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, Dave Hansen <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Zijlstra <peter.zijlstra@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dan Williams <dan.j.williams@intel.com>
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
	a. populates efi_runtime_work
	b. queues work onto efi_rts_wq and
	c. waits until worker thread returns

The caller thread has to wait until the worker thread returns, because
it's dependent on the return status of efi_runtime_service() and, in
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
Cc: Lee, Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Zijlstra <peter.zijlstra@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 drivers/firmware/efi/efi.c              | 15 ++++++++
 drivers/firmware/efi/runtime-wrappers.c | 61 +++++++++++++++++++++++++++++++++
 include/linux/efi.h                     | 20 +++++++++++
 3 files changed, 96 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 838b8efe639c..04b46c62f3ce 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -75,6 +75,8 @@ static unsigned long *efi_tables[] = {
 	&efi.mem_attr_table,
 };
 
+struct workqueue_struct *efi_rts_wq;
+
 static bool disable_runtime;
 static int __init setup_noefi(char *arg)
 {
@@ -329,6 +331,19 @@ static int __init efisubsys_init(void)
 		return 0;
 
 	/*
+	 * Since we process only one efi_runtime_service() at a time, an
+	 * ordered workqueue (which creates only one execution context)
+	 * should suffice all our needs.
+	 */
+	efi_rts_wq = alloc_ordered_workqueue("efi_rts_workqueue", 0);
+	if (!efi_rts_wq) {
+		pr_err("Failed to create efi_rts_workqueue, EFI runtime services "
+		       "disabled.\n");
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+		return 0;
+	}
+
+	/*
 	 * Clean DUMMY object calls EFI Runtime Service, set_variable(), so
 	 * it should be invoked only after efi_rts_workqueue is ready.
 	 */
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index ae54870b2788..649763171439 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -1,6 +1,14 @@
 /*
  * runtime-wrappers.c - Runtime Services function call wrappers
  *
+ * Implementation summary:
+ * -----------------------
+ * 1. When user/kernel thread requests to execute efi_runtime_service(),
+ * enqueue work to efi_rts_workqueue.
+ * 2. Caller thread waits until the work is finished because it's
+ * dependent on the return status and execution of efi_runtime_service().
+ * For instance, get_variable() and get_next_variable().
+ *
  * Copyright (C) 2014 Linaro Ltd. <ard.biesheuvel@linaro.org>
  *
  * Split off from arch/x86/platform/efi/efi.c
@@ -22,6 +30,8 @@
 #include <linux/mutex.h>
 #include <linux/semaphore.h>
 #include <linux/stringify.h>
+#include <linux/workqueue.h>
+
 #include <asm/efi.h>
 
 /*
@@ -33,6 +43,57 @@
 #define __efi_call_virt(f, args...) \
 	__efi_call_virt_pointer(efi.systab->runtime, f, args)
 
+/* efi_runtime_service() function identifiers */
+enum {
+	GET_TIME,
+	SET_TIME,
+	GET_WAKEUP_TIME,
+	SET_WAKEUP_TIME,
+	GET_VARIABLE,
+	GET_NEXT_VARIABLE,
+	SET_VARIABLE,
+	SET_VARIABLE_NONBLOCKING,
+	QUERY_VARIABLE_INFO,
+	QUERY_VARIABLE_INFO_NONBLOCKING,
+	GET_NEXT_HIGH_MONO_COUNT,
+	RESET_SYSTEM,
+	UPDATE_CAPSULE,
+	QUERY_CAPSULE_CAPS,
+};
+
+/*
+ * efi_queue_work:	Queue efi_runtime_service() and wait until it's done
+ * @rts:		efi_runtime_service() function identifier
+ * @rts_arg<1-5>:	efi_runtime_service() function arguments
+ *
+ * Accesses to efi_runtime_services() are serialized by a binary
+ * semaphore (efi_runtime_lock) and caller waits until the work is
+ * finished, hence _only_ one work is queued at a time and the queued
+ * work gets flushed.
+ */
+#define efi_queue_work(_rts, _arg1, _arg2, _arg3, _arg4, _arg5)		\
+({									\
+	struct efi_runtime_work efi_rts_work;				\
+									\
+	INIT_WORK_ONSTACK(&efi_rts_work.work, efi_call_rts);		\
+	efi_rts_work.func = _rts;					\
+	efi_rts_work.arg1 = _arg1;					\
+	efi_rts_work.arg2 = _arg2;					\
+	efi_rts_work.arg3 = _arg3;					\
+	efi_rts_work.arg4 = _arg4;					\
+	efi_rts_work.arg5 = _arg5;					\
+	/*								\
+	 * queue_work() returns 0 if work was already on queue,		\
+	 * _ideally_ this should never happen.				\
+	 */								\
+	if (queue_work(efi_rts_wq, &efi_rts_work.work))			\
+		flush_work(&efi_rts_work.work);				\
+	else								\
+		BUG();							\
+									\
+	efi_rts_work.status;						\
+})
+
 void efi_call_virt_check_flags(unsigned long flags, const char *call)
 {
 	unsigned long cur_flags, mismatch;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index c4efb3ef0dfa..bb06b71af55c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1652,4 +1652,24 @@ struct linux_efi_tpm_eventlog {
 
 extern int efi_tpm_eventlog_init(void);
 
+/*
+ * efi_runtime_work:	Details of EFI Runtime Service work
+ * @func:		EFI Runtime Service function identifier
+ * @arg<1-5>:		EFI Runtime Service function arguments
+ * @status:		Status of executing EFI Runtime Service
+ */
+struct efi_runtime_work {
+	u8 func;
+	void *arg1;
+	void *arg2;
+	void *arg3;
+	void *arg4;
+	void *arg5;
+	efi_status_t status;
+	struct work_struct work;
+};
+
+/* Workqueue to queue EFI Runtime Services */
+extern struct workqueue_struct *efi_rts_wq;
+
 #endif /* _LINUX_EFI_H */
-- 
2.7.4
