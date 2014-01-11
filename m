From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v4 5/5] init: efi: arm: enable (U)EFI runtime services on arm
Date: Sat, 11 Jan 2014 13:05:24 +0000
Message-ID: <1389445524-30623-6-git-send-email-leif.lindholm@linaro.org>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, matt.fleming@intel.com, roy.franz@linaro.org, msalter@redhat.com, linux@arm.linux.org.uk, grant.likely@secretlab.ca, patches@linaro.org, Leif Lindholm <leif.lindholm@linaro.org>
List-Id: linux-efi@vger.kernel.org

Since the efi_set_virtual_address_map call has strict init ordering
requirements, add an explicit hook in the required place.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Acked-by: Grant Likely <grant.likely@linaro.org>
---
 init/main.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/init/main.c b/init/main.c
index febc511..1331829 100644
--- a/init/main.c
+++ b/init/main.c
@@ -905,6 +905,10 @@ static noinline void __init kernel_init_freeable(void)
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
+
+	if (IS_ENABLED(CONFIG_ARM) && efi_enabled(EFI_BOOT))
+		efi_enter_virtual_mode();
+
 	lockup_detector_init();
 
 	smp_init();
-- 
1.7.10.4
