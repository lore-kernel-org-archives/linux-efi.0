From: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] efi: Distinguish between "remaining space" and actually used space
Date: Mon,  1 Apr 2013 11:14:00 -0400
Message-ID: <1364829240-26475-2-git-send-email-matthew.garrett@nebula.com>
References: <515150EC.7040203@redhat.com>
 <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364829240-26475-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

EFI implementations distinguish between space that is actively used by a
variable and space that merely hasn't been garbage collected yet. Space
that hasn't yet been garbage collected isn't available for use and so isn't
counted in the remaining_space field returned by QueryVariableInfo().

Combined with commit 68d9298 this can cause problems. Some implementations
don't garbage collect until the remaining space is smaller than the maximum
variable size, and as a result check_var_size() will always fail once more
than 50% of the variable store has been used even if most of that space is
marked as available for garbage collection. The user is unable to create
new variables, and deleting variables doesn't increase the remaining space.

The problem that 68d9298 was attempting to avoid was one where certain
platforms fail if the actively used space is greater than 50% of the
available storage space. We should be able to calculate that by simply
summing the size of each available variable and subtracting that from
the total storage space. With luck this will fix the problem described in
https://bugzilla.kernel.org/show_bug.cgi?id=55471 without permitting
damage to occur to the machines 68d9298 was attempting to fix.

Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efivars.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 60e7d8f..a6d8a58 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -439,9 +439,19 @@ static efi_status_t
 check_var_size_locked(struct efivars *efivars, u32 attributes,
 			unsigned long size)
 {
-	u64 storage_size, remaining_size, max_size;
+	u64 storage_size, remaining_size, max_size, active_available;
+	struct efivar_entry *entry;
+	struct efi_variable *var;
 	efi_status_t status;
 	const struct efivar_operations *fops = efivars->ops;
+	unsigned long active_size = 0;
+
+	/*
+	 * Any writes other than EFI_VARIABLE_NON_VOLATILE will only hit
+	 * RAM, not flash, so ignore them.
+	 */
+	if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
+		return EFI_SUCCESS;
 
 	if (!efivars->ops->query_variable_info)
 		return EFI_UNSUPPORTED;
@@ -452,8 +462,33 @@ check_var_size_locked(struct efivars *efivars, u32 attributes,
 	if (status != EFI_SUCCESS)
 		return status;
 
-	if (!storage_size || size > remaining_size || size > max_size ||
-	    (remaining_size - size) < (storage_size / 2))
+	list_for_each_entry(entry, &efivars->list, list) {
+		var = &entry->var;
+		status = get_var_data_locked(efivars, var);
+
+		if (status || !(var->Attributes & EFI_VARIABLE_NON_VOLATILE))
+			continue;
+
+		active_size += var->DataSize;
+		active_size += utf16_strsize(var->VariableName, 1024);
+		/*
+		 * There's some additional metadata associated with each
+		 * variable. Intel's reference implementation is 60 bytes -
+		 * bump that to 128 to account for vendor additions and
+		 * potential alignment constraints
+		 */
+		active_size += 128;
+	}
+
+	/*
+	 * Add on the size of any boot services-only variables
+	 */
+	active_size += boot_var_size;
+
+	active_available = storage_size - active_size;
+
+	if (!storage_size || size > remaining_size ||
+	    (active_available - size) < (storage_size / 2))
 		return EFI_OUT_OF_RESOURCES;
 
 	return status;
-- 
1.8.1.2
