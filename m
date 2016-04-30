From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH] efi/capsule: Make efi_capsule_pending() lockless
Date: Sat, 30 Apr 2016 23:13:27 +0100
Message-ID: <1462054407-9735-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Taking a mutex in the reboot path is bogus because we cannot sleep
with interrupts disabled, such as when rebooting due to panic(),

 [   18.069005] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:97
 [   18.071639] in_atomic(): 0, irqs_disabled(): 1, pid: 7, name: rcu_sched
 [   18.085940] Call Trace:
 [   18.086911]  [<ffffffff8142e53a>] dump_stack+0x63/0x89
 [   18.088260]  [<ffffffff810a1048>] ___might_sleep+0xd8/0x120
 [   18.089860]  [<ffffffff810a10d9>] __might_sleep+0x49/0x80
 [   18.091272]  [<ffffffff818f5110>] mutex_lock+0x20/0x50
 [   18.092636]  [<ffffffff81771edd>] efi_capsule_pending+0x1d/0x60
 [   18.094272]  [<ffffffff8104e749>] native_machine_emergency_restart+0x59/0x280
 [   18.095975]  [<ffffffff8104e5d9>] machine_emergency_restart+0x19/0x20
 [   18.097685]  [<ffffffff8109d4b8>] emergency_restart+0x18/0x20
 [   18.099303]  [<ffffffff81172d6d>] panic+0x1ba/0x217

In this case all other CPUs will have been stopped by the time we
execute the platform reboot code, so 'capsule_pending' cannot change
under our feet. We wouldn't care even if it could since we cannot wait
for it complete.

Also, instead of relying on the external 'system_state' variable just
use a reboot notifier, so we can set 'stop_capsules' while holding
'capsule_mutex', thereby avoiding a race where system_state is updated
while we're in the middle of efi_capsule_update_locked() (since CPUs
won't have been stopped at that point).

Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/capsule.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index 0de55944ac0b..4703dc9b8fbd 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -22,11 +22,12 @@ typedef struct {
 } efi_capsule_block_desc_t;
 
 static bool capsule_pending;
+static bool stop_capsules;
 static int efi_reset_type = -1;
 
 /*
  * capsule_mutex serialises access to both capsule_pending and
- * efi_reset_type.
+ * efi_reset_type and stop_capsules.
  */
 static DEFINE_MUTEX(capsule_mutex);
 
@@ -50,18 +51,13 @@ static DEFINE_MUTEX(capsule_mutex);
  */
 bool efi_capsule_pending(int *reset_type)
 {
-	bool rv = false;
-
-	mutex_lock(&capsule_mutex);
 	if (!capsule_pending)
-		goto out;
+		return false;
 
 	if (reset_type)
 		*reset_type = efi_reset_type;
-	rv = true;
-out:
-	mutex_unlock(&capsule_mutex);
-	return rv;
+
+	return true;
 }
 
 /*
@@ -176,7 +172,7 @@ efi_capsule_update_locked(efi_capsule_header_t *capsule,
 	 * whether to force an EFI reboot), and we're racing against
 	 * that call. Abort in that case.
 	 */
-	if (unlikely(system_state == SYSTEM_RESTART)) {
+	if (unlikely(stop_capsules)) {
 		pr_warn("Capsule update raced with reboot, aborting.\n");
 		return -EINVAL;
 	}
@@ -298,3 +294,23 @@ out:
 	return rv;
 }
 EXPORT_SYMBOL_GPL(efi_capsule_update);
+
+static int capsule_reboot_notify(struct notifier_block *nb,
+				 unsigned long event, void *cmd)
+{
+	mutex_lock(&capsule_mutex);
+	stop_capsules = true;
+	mutex_unlock(&capsule_mutex);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block capsule_reboot_nb = {
+	.notifier_call = capsule_reboot_notify,
+};
+
+static int __init capsule_reboot_register(void)
+{
+	return register_reboot_notifier(&capsule_reboot_nb);
+}
+core_initcall(capsule_reboot_register);
-- 
2.7.3
