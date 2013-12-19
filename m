From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [RFC PATCH 08/14] rtc-efi: set uie_unsupported for indicate rtc-efi doesn't support UIE mode
Date: Thu, 19 Dec 2013 15:51:49 +0800
Message-ID: <1387439515-8926-9-git-send-email-jlee@suse.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1387439515-8926-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Alessandro Zummo <a.zummo@towertech.it>, "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt@console-pimps.org>, Matthew Garrett <matthew.garrett@nebula.com>
Cc: Elliott@hp.com, samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de, JBeulich@suse.com, linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com, x86@kernel.org, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

This patch set uie_unsupported flag when driver probed because current
rtc-efi driver doesn't support UIE mode. Otherwise RTC_UIE_ON ioctl doesn't
return EINVAL and it causes userspace think the RTC_UIE supported by rtc-efi.

Set uie_unsupported then We can enable CONFIG_RTC_INTF_DEV_UIE_EMUL to
emulate RTC_UIE on rtc-efi.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/rtc/rtc-efi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index e0e3c7e..693ea47 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -293,6 +293,8 @@ static int efi_rtc_probe(struct platform_device *dev)
 
 	rtc->caps = (RTC_TZ_CAP | RTC_DST_CAP);
 
+	rtc->uie_unsupported = 1;
+
 	platform_set_drvdata(dev, rtc);
 
 	return 0;
-- 
1.6.4.2
