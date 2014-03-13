From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v2 01/15] efi: delete stray ARM ifdef
Date: Thu, 13 Mar 2014 22:46:54 +0000
Message-ID: <1394750828-16351-2-git-send-email-leif.lindholm@linaro.org>
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

An #ifdef CONFIG_ARM clause in efi-stub-helper.c got included with some
of the generic stub rework by Roy Franz. Drop it here to make subsequent
patches less confusing.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index b6bffbf..6811af7 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -608,18 +608,8 @@ static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
 	}
 
 	options_size++;  /* NUL termination */
-#ifdef CONFIG_ARM
-	/*
-	 * For ARM, allocate at a high address to avoid reserved
-	 * regions at low addresses that we don't know the specfics of
-	 * at the time we are processing the command line.
-	 */
-	status = efi_high_alloc(sys_table_arg, options_size, 0,
-			    &cmdline_addr, 0xfffff000);
-#else
-	status = efi_low_alloc(sys_table_arg, options_size, 0,
-			    &cmdline_addr);
-#endif
+
+	status = efi_low_alloc(sys_table_arg, options_size, 0, &cmdline_addr);
 	if (status != EFI_SUCCESS)
 		return NULL;
 
-- 
1.7.10.4
