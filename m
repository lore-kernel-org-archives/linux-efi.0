From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 4/4] init: efi: arm: enable (U)EFI runtime services on arm
Date: Tue, 25 Jun 2013 19:11:03 +0100
Message-ID: <1372183863-11333-5-git-send-email-leif.lindholm@linaro.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, hpa@linux.intel.com, tglx@linutronix.de, matt.fleming@intel.com, Leif Lindholm <leif.lindholm@linaro.org>
List-Id: linux-efi@vger.kernel.org

Since the efi_set_virtual_address_map call has strict init ordering
requirements, add an explicit hook in the required place.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 init/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/init/main.c b/init/main.c
index 9484f4b..c61706e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -872,6 +872,12 @@ static noinline void __init kernel_init_freeable(void)
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
+
+#ifdef CONFIG_ARM
+	if (efi_enabled(EFI_RUNTIME_SERVICES))
+		efi_enter_virtual_mode();
+#endif
+
 	lockup_detector_init();
 
 	smp_init();
-- 
1.7.10.4

