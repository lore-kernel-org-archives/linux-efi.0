From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH] rtc: Disable EFI rtc for x86
Date: Fri,  3 Oct 2014 13:32:56 +0100
Message-ID: <1412339576-17972-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit da167ad7638759 ("rtc: ia64: allow other architectures to use EFI
RTC") inadvertently introduced a regression for x86. We've been careful
not to enable the EFI rtc driver for x86 due to the generally buggy
implementations of the time-related EFI runtime services.

Previous attempts have been made to us the time EFI services, but all
have eventually been reverted due to crashes inside the firmware code.

In fact, since the above commit was merged we've seen reports of crashes
on 32-bit tablets,

  https://bugzilla.kernel.org/show_bug.cgi?id=84241#c21

Disable it explicitly for x86 so that we don't give users false hope
that this driver will work - it won't, and your machine is likely to
crash.

Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

Unless anyone objects, I'm happy to take this through the EFI tree.

 drivers/rtc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index a168e96142b9..54ef393b0def 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -806,7 +806,7 @@ config RTC_DRV_DA9063
 
 config RTC_DRV_EFI
 	tristate "EFI RTC"
-	depends on EFI
+	depends on EFI && !X86
 	help
 	  If you say yes here you will get support for the EFI
 	  Real Time Clock.
-- 
1.9.3
