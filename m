From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v7 05/17] xen: memory : Add new XENMAPSPACE type XENMAPSPACE_dev_mmio
Date: Thu, 24 Mar 2016 22:44:24 +0800
Message-ID: <1458830676-27075-6-git-send-email-shannon.zhao@linaro.org>
References: <1458830676-27075-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458830676-27075-1-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Add a new type of Xen map space for Dom0 to map device's MMIO region.

Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/xen/interface/memory.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index 2ecfe4f..9aa8988 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -160,6 +160,7 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_machphys_mapping_t);
 #define XENMAPSPACE_gmfn_foreign 4 /* GMFN from another dom,
 				    * XENMEM_add_to_physmap_range only.
 				    */
+#define XENMAPSPACE_dev_mmio     5 /* device mmio region */
 
 /*
  * Sets the GPFN at which a particular page appears in the specified guest's
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
