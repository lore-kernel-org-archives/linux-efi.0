From: Florent Revest <florent.revest@arm.com>
Subject: [RFC 01/11] arm64: Add an SMCCC function IDs header
Date: Fri, 25 Aug 2017 09:31:31 +0100
Message-ID: <1503649901-5834-2-git-send-email-florent.revest@arm.com>
References: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: mark.rutland@arm.com, linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, catalin.marinas@arm.com, ard.biesheuvel@linaro.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, leif.lindholm@arm.com, marc.zyngier@arm.com, revestflo@gmail.com, pbonzini@redhat.com, Florent Revest <florent.revest@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: linux-efi@vger.kernel.org

The ARM SMC Calling Convention (DEN 0028B) introduces function IDs for
hypercalls, given in the x0 register during an SMC or HVC from a guest.

The document defines ranges of function IDs targeting different kinds of
hypervisors or supervisors.

Two ID ranges are of particular interest for the kernel:
    - Standard hypervisor service calls
    - Vendor specific hypervisor service calls

This patch introduces a couple of useful macros when working with SMCCC.
They provide defines of those ID ranges to be used by HVC handling (KVM)
or calling. (e.g: to leverage paravirtualized services)

The document also defines standard return values to be written into x0
after a hypercall handling. Once again, those macros can potentially be
used from both the hypervisor or the guest.

Signed-off-by: Florent Revest <florent.revest@arm.com>
---
 include/linux/smccc_fn.h | 50 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 include/linux/smccc_fn.h

diff --git a/include/linux/smccc_fn.h b/include/linux/smccc_fn.h
new file mode 100644
index 0000000..f08145d
--- /dev/null
+++ b/include/linux/smccc_fn.h
@@ -0,0 +1,50 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Copyright (C) 2017 ARM Limited
+ */
+
+#ifndef __LINUX_SMCCC_FN_H
+#define __LINUX_SMCCC_FN_H
+
+/*
+ * Standard return values
+ */
+
+#define SMCCC_STD_RET_SUCCESS          0
+#define SMCCC_STD_RET_UNKNOWN_ID       -1
+
+
+/*
+ * SMC32
+ */
+
+/* Standard hypervisor services interface */
+#define SMCCC32_STD_HYP_FN_BASE                0x85000000
+#define SMCCC32_STD_HYP_FN(n)          (SMCCC32_STD_HYP_FN_BASE + (n))
+
+/* Vendor specific hypervisor services interface */
+#define SMCCC32_VDR_HYP_FN_BASE                0x86000000
+#define SMCCC32_VDR_HYP_FN(n)          (SMCCC32_VDR_HYP_FN_BASE + (n))
+
+
+/*
+ * SMC64
+ */
+
+/* Standard hypervisor services interface */
+#define SMCCC64_STD_HYP_FN_BASE                0xc5000000
+#define SMCCC64_STD_HYP_FN(n)          (SMCCC64_STD_HYP_FN_BASE + (n))
+
+/* Vendor specific hypervisor services interface */
+#define SMCCC64_VDR_HYP_FN_BASE                0xc6000000
+#define SMCCC64_VDR_HYP_FN(n)          (SMCCC64_VDR_HYP_FN_BASE + (n))
+
+#endif /* __LINUX_SMCCC_FN_H */
--
1.9.1

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
