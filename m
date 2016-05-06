From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 1/5] efi/capsule: Make efi_capsule_pending() lockless
Date: Fri,  6 May 2016 22:39:27 +0100
Message-ID: <1462570771-13324-2-git-send-email-matt@codeblueprint.co.uk>
References: <1462570771-13324-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462570771-13324-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Bryan O'Donoghue <pure.logic@nexus-software.ie>, joeyli <jlee@suse.com>, Kweh Hock Leong <hock.leong.kweh@intel.com>
List-Id: linux-efi@vger.kernel.org

Taking a mutex in the reboot path is bogus because we cannot sleep
with interrupts disabled, such as when rebooting due to panic(),

  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:97
  in_atomic(): 0, irqs_disabled(): 1, pid: 7, name: rcu_sched
  Call Trace:
    dump_stack+0x63/0x89
    ___might_sleep+0xd8/0x120
    __might_sleep+0x49/0x80
    mutex_lock+0x20/0x50
    efi_capsule_pending+0x1d/0x60
    native_machine_emergency_restart+0x59/0x280
    machine_emergency_restart+0x19/0x20
    emergency_restart+0x18/0x20
    panic+0x1ba/0x217

In this case all other CPUs will have been stopped by the time we
execute the platform reboot code, so 'capsule_pending' cannot change
under our feet. We wouldn't care even if it could since we cannot wait
for it complete.

Also, instead of relying on the external 'system_state' variable just
use a reboot notifier, so we can set 'stop_capsules' while holding
'capsule_mutex', thereby avoiding a race where system_state is updated
while we're in the middle of efi_capsule_update_locked() (since CPUs
won't have been stopped at that point).

Cc: Borislav Petkov <bp@alien8.de>
Cc: Kweh Hock Leong <hock.leong.kweh@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: joeyli <jlee@suse.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
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
