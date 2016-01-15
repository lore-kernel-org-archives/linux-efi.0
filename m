From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v2 08/16] xen/hvm/params: Add a new delivery
	type for event-channel in HVM_PARAM_CALLBACK_IRQ
Date: Fri, 15 Jan 2016 14:55:21 +0800
Message-ID: <1452840929-19612-9-git-send-email-zhaoshenglong@huawei.com>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org, stefano.stabellini@citrix.com, david.vrabel@citrix.com
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, xen-devel@lists.xen.org, julien.grall@citrix.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

Add a new delivery type:
val[63:56] == 3: val[15:8] is flag: val[7:0] is a PPI.
To the flag, bit 0 stands the interrupt mode is edge(1) or level(0) and
bit 1 stands the interrupt polarity is active low(1) or high(0).

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 include/xen/interface/hvm/params.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/xen/interface/hvm/params.h b/include/xen/interface/hvm/params.h
index a6c7991..550688a 100644
--- a/include/xen/interface/hvm/params.h
+++ b/include/xen/interface/hvm/params.h
@@ -34,6 +34,11 @@
  *                  Domain = val[47:32], Bus  = val[31:16],
  *                  DevFn  = val[15: 8], IntX = val[ 1: 0]
  * val[63:56] == 2: val[7:0] is a vector number.
+ * val[63:56] == 3: val[15:8] is flag of event-channel interrupt:
+ *                      bit 0: interrupt is edge(1) or level(0) triggered
+ *                      bit 1: interrupt is active low(1) or high(0)
+ *                  val[7:0] is PPI number used by event-channel.
+ *                  This is only used by ARM/ARM64.
  * If val == 0 then CPU0 event-channel notifications are not delivered.
  */
 #define HVM_PARAM_CALLBACK_IRQ 0
-- 
2.0.4
