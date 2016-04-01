From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: [PATCH v10 09/17] xen/hvm/params: Add a new delivery type for event-channel in HVM_PARAM_CALLBACK_IRQ
Date: Fri,  1 Apr 2016 23:49:07 +0800
Message-ID: <1459525755-36968-10-git-send-email-shannon.zhao@linaro.org>
References: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, stefano.stabellini@citrix.com
Cc: david.vrabel@citrix.com, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@arm.com, peter.huangpeng@huawei.com, xen-devel@lists.xen.org, zhaoshenglong@huawei.com, shannon.zhao@linaro.org
List-Id: linux-efi@vger.kernel.org

This new delivery type which is for ARM shares the same value with
HVM_PARAM_CALLBACK_TYPE_VECTOR which is for x86.

val[15:8] is flag: val[7:0] is a PPI.
To the flag, bit 8 stands the interrupt mode is edge(1) or level(0) and
bit 9 stands the interrupt polarity is active low(1) or high(0).

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 include/xen/interface/hvm/params.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/xen/interface/hvm/params.h b/include/xen/interface/hvm/params.h
index 70ad208..4d61fc5 100644
--- a/include/xen/interface/hvm/params.h
+++ b/include/xen/interface/hvm/params.h
@@ -47,11 +47,24 @@
  * Domain = val[47:32], Bus = val[31:16] DevFn = val[15:8], IntX = val[1:0]
  */
 
+#if defined(__i386__) || defined(__x86_64__)
 #define HVM_PARAM_CALLBACK_TYPE_VECTOR   2
 /*
  * val[7:0] is a vector number.  Check for XENFEAT_hvm_callback_vector to know
  * if this delivery method is available.
  */
+#elif defined(__arm__) || defined(__aarch64__)
+#define HVM_PARAM_CALLBACK_TYPE_PPI      2
+/*
+ * val[55:16] needs to be zero.
+ * val[15:8] is interrupt flag of the PPI used by event-channel:
+ *  bit 8: the PPI is edge(1) or level(0) triggered
+ *  bit 9: the PPI is active low(1) or high(0)
+ * val[7:0] is a PPI number used by event-channel.
+ * This is only used by ARM/ARM64 and masking/eoi the interrupt associated to
+ * the notification is handled by the interrupt controller.
+ */
+#endif
 
 #define HVM_PARAM_STORE_PFN    1
 #define HVM_PARAM_STORE_EVTCHN 2
-- 
2.1.4
