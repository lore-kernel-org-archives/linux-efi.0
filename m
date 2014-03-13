From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v2 03/15] efi: create memory map iteration helper
Date: Thu, 13 Mar 2014 22:46:56 +0000
Message-ID: <1394750828-16351-4-git-send-email-leif.lindholm@linaro.org>
References: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, catalin.marinas@arm.com, matt.fleming@intel.com
Cc: roy.franz@linaro.org, Leif Lindholm <leif.lindholm@linaro.org>, msalter@redhat.com
List-Id: linux-efi@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

There are a lot of places in the kernel which iterate through an
EFI memory map. Most of these places use essentially the same
for-loop code. This patch adds a for_each_efi_memory_desc()
helper to clean up all of the existing duplicate code and avoid
more in the future.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 include/linux/efi.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 64d532c..a3276da 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -622,6 +622,12 @@ extern int efi_set_rtc_mmss(const struct timespec *now);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 
+/* Iterate through an efi_memory_map */
+#define for_each_efi_memory_desc(m, md)					   \
+	for ((md) = (m)->map;						   \
+	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
+	     (md) = (void *)(md) + (m)->desc_size)
+
 /**
  * efi_range_is_wc - check the WC bit on an address range
  * @start: starting kvirt address
-- 
1.7.10.4
