From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 09/17] xen/hvm/params: Add a new delivery type for event-channel in HVM_PARAM_CALLBACK_IRQ
Date: Sat, 23 Jan 2016 11:19:36 +0800
Message-ID: <1453519184-11908-10-git-send-email-zhaoshenglong@huawei.com>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453519184-11908-1-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Add a new delivery type:
val[63:56] == 3: val[15:8] is flag: val[7:0] is a PPI.
To the flag, bit 0 stands the interrupt mode is edge(1) or level(0) and
bit 1 stands the interrupt polarity is active low(1) or high(0).

Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/xen/interface/hvm/params.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/xen/interface/hvm/params.h b/include/xen/interface/hvm/params.h
index 70ad208..5dd629f 100644
--- a/include/xen/interface/hvm/params.h
+++ b/include/xen/interface/hvm/params.h
@@ -53,6 +53,15 @@
  * if this delivery method is available.
  */
 
+#define HVM_PARAM_CALLBACK_TYPE_EVENT    3
+/*
+ * val[15:8] is flag of event-channel interrupt:
+ *  bit 0: interrupt is edge(1) or level(0) triggered
+ *  bit 1: interrupt is active low(1) or high(0)
+ * val[7:0] is PPI number used by event-channel.
+ * This is only used by ARM/ARM64.
+ */
+
 #define HVM_PARAM_STORE_PFN    1
 #define HVM_PARAM_STORE_EVTCHN 2
 
-- 
2.0.4


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
