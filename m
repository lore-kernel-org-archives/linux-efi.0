From: Jeff Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [RFC PATCH] efi/libstub: Retry ExitBootServices if map key is invalid
Date: Thu, 30 Jun 2016 09:35:33 -0600
Message-ID: <1467300933-3991-1-git-send-email-jhugo@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

There exists a race condition between when the efi stub grabs the memory
map, and when ExitBootServices is called at which point the EFI can process
an event which causes the memory map to be invalidated.  According to the
UEFI spec, ExitBootServices will return EFI_INVALID_PARAMETER if this
occurs, at which point the efi stub is expected to obtain the new memory
map, and retry the call to ExitBootServices.

Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---

I'm not particularly happy with the current state of this fix, but I feel like
this issue is somewhat unsolvable.  Currently I've based this solution upon
arch/x86/boot/compressed/eboot.c however it has two primary issues I'd like
feedback upon-

First issue-
efi_get_memory_map() performs an allocation as it attempts to create a
minimal sized buffer to hold the map.  Per my understanding of the UEFI spec,
allocations are not permitted after a call to ExitBootServices:

"A UEFI OS loader should not make calls to any boot service function other than
GetMemoryMap() after the first call to ExitBootServices()."

However the only alternative I can think of it to allocate a sufficently large
buffer so that it can be reused to hold the modified memory map.  There doesn't
seem to be any limit to the new map, so any buffer space value I would choose
would be arbitrary, and there would be some chance that it would be insufficent.
efi_get_memory_map() would need to be modified to "return" the origional size
of the allocated buffer as well, so I feel like this solution makes a mess of
the code, reduces the value of the efi_get_memory_map() helper function, and for
all that effort, we still can't fully address this race condition.

I guess the question is, where do we draw the line at "good enough" for
addressing this issue?  Do we use efi_get_memory_map() since it appears to be
cleaner and does not seem to cause a problem today, despite violating the spec?

Second issue-
When do we give up if we cannot get a good memory map to use with
ExitBootServices?  Currently there is an infinite loop in my patch.  I noticed
arch/x86/boot/compressed/eboot.c only retrys after the first failure.  I think
a single retry is insufficent, we could do better, but I'm aware that an
infinite loop is generally a bad idea.  Any strong opinions on when to quit?
100 attempts?  Either way, it seems the system will require a hard reboot if
the retry(s) ever end up failing.

 drivers/firmware/efi/libstub/fdt.c | 45 ++++++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index e58abfa..d3e70b0 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -250,16 +250,43 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 		}
 	}
 
-	/*
-	 * Update the memory map with virtual addresses. The function will also
-	 * populate @runtime_map with copies of just the EFI_MEMORY_RUNTIME
-	 * entries so that we can pass it straight into SetVirtualAddressMap()
-	 */
-	efi_get_virtmap(memory_map, map_size, desc_size, runtime_map,
-			&runtime_entry_count);
+	do {
+		/*
+		 * We should not free and/or allocate after calling
+		 * ExitBootServices, but this avoids the issue of guessing how
+		 * large of a buffer we need to store an updated memory map,
+		 * and its common for the implementation of ExitBootServices to
+		 * first check if the map key is current, and error out early
+		 * leaving all other services active.
+		 */
+		sys_table->boottime->free_pool(memory_map);
+		status = efi_get_memory_map(sys_table, &memory_map, &map_size,
+					    &desc_size, &desc_ver, &mmap_key);
+		if (status != EFI_SUCCESS) {
+			pr_efi_err(sys_table, "Unable to grab memory map for ExitBootServices.\n");
+			break;
+		}
+		/*
+		 * Update the memory map with virtual addresses. The function
+		 * will also populate @runtime_map with copies of just the
+		 * EFI_MEMORY_RUNTIME entries so that we can pass it straight
+		 * into SetVirtualAddressMap()
+		 */
+		efi_get_virtmap(memory_map, map_size, desc_size, runtime_map,
+				&runtime_entry_count);
+
+		/* Now we are ready to exit_boot_services.*/
+		status = sys_table->boottime->exit_boot_services(handle,
+								 mmap_key);
+		/*
+		 * EFI_INVALID_PARAMETER means our memory map key does not
+		 * match the current map, likely because some event such as an
+		 * interrupt caused an allocation ourside of our control.  Thus
+		 * we need to get the updated map, and try again.  Our FDT
+		 * allocation from above remains valid, so no need to redo that.
+		 */
+	} while (status == EFI_INVALID_PARAMETER);
 
-	/* Now we are ready to exit_boot_services.*/
-	status = sys_table->boottime->exit_boot_services(handle, mmap_key);
 
 	if (status == EFI_SUCCESS) {
 		efi_set_virtual_address_map_t *svam;
-- 
Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project.
