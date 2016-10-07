From: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V3 09/10] trace, ras: add ARM processor error trace event
Date: Fri,  7 Oct 2016 15:31:21 -0600
Message-ID: <1475875882-2604-10-git-send-email-tbaicar@codeaurora.org>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475875882-2604-1-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tomasz.nowicki-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Dkvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org
Cc: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Currently there are trace events for the various RAS
errors with the exception of ARM processor type errors.
Add a new trace event for such errors so that the user
will know when they occur. These trace events are
consistent with the ARM processor error section type
defined in UEFI 2.6 spec section N.2.4.4.

Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 drivers/firmware/efi/cper.c |  9 ++++++
 drivers/ras/ras.c           |  1 +
 include/ras/ras_event.h     | 67 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index f9ffba6..21b8a6f 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -34,6 +34,7 @@
 #include <linux/aer.h>
 #include <linux/printk.h>
 #include <linux/bcd.h>
+#include <ras/ras_event.h>
 
 #define INDENT_SP	" "
 
@@ -256,6 +257,14 @@ static void cper_print_proc_armv8(const char *pfx,
 		    CPER_ARMV8_INFO_VALID_PHYSICAL_ADDR)
 			printk("%sphysical fault address: 0x%016llx\n",
 				newpfx, err_info->physical_fault_addr);
+		trace_arm_event(proc->affinity_level, proc->mpidr, proc->midr,
+				proc->running_state, proc->psci_state,
+				err_info->version, err_info->type,
+				err_info->multiple_error,
+				err_info->validation_bits,
+				err_info->error_info,
+				err_info->virt_fault_addr,
+				err_info->physical_fault_addr);
 		err_info += 1;
 	}
 
diff --git a/drivers/ras/ras.c b/drivers/ras/ras.c
index fb2500b..8ba5a94 100644
--- a/drivers/ras/ras.c
+++ b/drivers/ras/ras.c
@@ -28,3 +28,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(extlog_mem_event);
 #endif
 EXPORT_TRACEPOINT_SYMBOL_GPL(mc_event);
 EXPORT_TRACEPOINT_SYMBOL_GPL(unknown_sec_event);
+EXPORT_TRACEPOINT_SYMBOL_GPL(arm_event);
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 5861b6f..eb2719a 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -162,6 +162,73 @@ TRACE_EVENT(mc_event,
 );
 
 /*
+ * ARM Processor Events Report
+ *
+ * This event is generated when hardware detects an ARM processor error
+ * has occurred. UEFI 2.6 spec section N.2.4.4.
+ */
+TRACE_EVENT(arm_event,
+
+	TP_PROTO(const u8 affinity,
+		 const u64 mpidr,
+		 const u64 midr,
+		 const u32 running_state,
+		 const u32 psci_state,
+		 const u8 version,
+		 const u8 type,
+		 const u16 err_count,
+		 const u8 flags,
+		 const u64 info,
+		 const u64 virt_fault_addr,
+		 const u64 phys_fault_addr),
+
+	TP_ARGS(affinity, mpidr, midr, running_state, psci_state,
+		version, type, err_count, flags, info, virt_fault_addr,
+		phys_fault_addr),
+
+	TP_STRUCT__entry(
+		__field(u8, affinity)
+		__field(u64, mpidr)
+		__field(u64, midr)
+		__field(u32, running_state)
+		__field(u32, psci_state)
+		__field(u8, version)
+		__field(u8, type)
+		__field(u16, err_count)
+		__field(u8, flags)
+		__field(u64, info)
+		__field(u64, virt_fault_addr)
+		__field(u64, phys_fault_addr)
+	),
+
+	TP_fast_assign(
+		__entry->affinity = affinity;
+		__entry->mpidr = mpidr;
+		__entry->midr = midr;
+		__entry->running_state = running_state;
+		__entry->psci_state = psci_state;
+		__entry->version = version;
+		__entry->type = type;
+		__entry->err_count = err_count;
+		__entry->flags = flags;
+		__entry->info = info;
+		__entry->virt_fault_addr = virt_fault_addr;
+		__entry->phys_fault_addr = phys_fault_addr;
+	),
+
+	TP_printk("affinity level: %d; MPIDR: %016llx; MIDR: %016llx; "
+		  "running state: %d; PSCI state: %d; version: %d; type: %d; "
+		  "error count: 0x%04x; flags: 0x%02x; info: %016llx; "
+		  "virtual fault address: %016llx; "
+		  "physical fault address: %016llx",
+		  __entry->affinity, __entry->mpidr, __entry->midr,
+		  __entry->running_state, __entry->psci_state, __entry->version,
+		  __entry->type, __entry->err_count, __entry->flags,
+		  __entry->info, __entry->virt_fault_addr,
+		  __entry->phys_fault_addr)
+);
+
+/*
  * Unknown Section Report
  *
  * This event is generated when hardware detected a hardware
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
