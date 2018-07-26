From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH RT] rtc: Disable RTC_DRV_EFI on RT
Date: Thu, 26 Jul 2018 11:04:49 +0200
Message-ID: <20180726090449.hfvtey3ruzzhzdaz@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, rostedt@goodmis.org, linux-rt-users@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Anna-Maria Gleixner <anna-maria@linutronix.de>
List-Id: linux-efi@vger.kernel.org

Based on measurements the EFI functions get_variable /
get_next_variable take up to 2us. The functions get_time, set_time take
around 10ms. Those 10ms are too much. Even one ms would be too much.
The funny part is that EFI is invoked with enabled interrupts.
According to my tracing I see the interrupt almost 10ms later which
indicates that EFI is disabling interrupts while doing its thing.

This was observed on "EFI v2.60 by SoftIron Overdrive 1000". I don't say
that every EFI implementation does this but given that it has to access a
slow bus like I2C/SPI it is expected.

Disable EFI's RTC driver on RT.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/rtc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index a2ba5db36145..248d72711650 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1087,7 +1087,7 @@ config RTC_DRV_DA9063
 
 config RTC_DRV_EFI
 	tristate "EFI RTC"
-	depends on EFI && !X86
+	depends on EFI && !X86 && !PREEMPT_RT_BASE
 	help
 	  If you say yes here you will get support for the EFI
 	  Real Time Clock.
-- 
2.18.0
