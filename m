Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792703595;
	b=2zkcowjoC2DErEVWDD/kayFRLCzMPmkT2Mim6VAsPpTF9wBc6xgspXFav7SK9Ql9gZZ9
	 X3pPGsOQPiacZyCZLTZINkJt+ns/6WQZ6yjZsLV2WJdKdF2u4+bxslqq9gvjQh0pml6kr
	 CEJLTe0lhdtXdZftzGSM6f3xjAZgfVNuIS2sG1THqXv8IRiAm3C5V5ToUYu2IQSxpahqP
	 +HvUPz5co6lSBTgBPmRJXnk0Pyn/bIOPkN3Xzp3JSmOMQ/Y34HyHc4ti6dHbtiF4ZWFJg
	 Kx/ufUqVKA0lfNGVPghxILJIaEkzsbQO6pv/qY+yDOKN+Rvpyqu+u9KC9GabACtFBUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792703595;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Ach3hL2Srzfu+a6M+3ZUllFO4YG7jNYVYfsD1QvzpSw=;
	b=FS7uyJ8OTBiJIqrkaiIm6K0tTHrZRLgGlbIomqBRysHTDWgkVc7as8P6GUiungMySO9+
	 /0vjWe/Hp7WiNhEY4LwPf71ydH9CPToRmDfUCmXyDUQnVzcuIRW7G8k6RmKcq7fmuxat9
	 mLDo0whq8qoUEKs5xoZTS51ESK18Gb7OrMdiIEVyXn6cUZMFjcecVo5T9AxDh+0IkZOp/
	 GVop0rGzE2Q3Ln5fKC3K34Fs11p75QwPKmf7sn3DN1DqKXIU76iLCWIdJF5kIU2D+E+pa
	 +hAjaJ5jRuM3V+nQq2BmikaBl5DkOtvEgSE7N2ZU4XTzCYExqtS/Qu62wVJp7tKCoLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=m19zDvon;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D4FF606A31B;
	Thu, 22 Oct 2026 21:13:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D4FF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=m19zDvon
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 9172820B7166; Thu, 22 Oct 2026 14:13:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9172820B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792703586;
	bh=Ach3hL2Srzfu+a6M+3ZUllFO4YG7jNYVYfsD1QvzpSw=;
	h=From:To:Cc:Subject:Date:From;
	b=m19zDvoniUbLgmQyGS/jD2Dk3YMVInWpfLB6326M8aCRpyKVLIC9bK1wjnp8CuLlW
	 atgUsnO31fdHcRz0lRfEZ7frLjI15x8j4iGOE6VT9lWTt9WJ0I3gUZ8yF8Y44muLej
	 TUbnHTPKWMFxtkLiJyZ3gQzr9XVMrcjDGogwAkwk=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: linux-acpi@vger.kernel.org,
	linux-efi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Pawel Chmielewski <pawel.chmielewski@intel.com>,
	acpica-devel@lists.linux.dev,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Subject: [PATCH 1/2] ACPI: TAD: introduce acpi_tad_rtc_available()
Date: Thu, 22 Oct 2026 17:13:03 -0400
Message-ID: <20261022211304.2285792-1-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Code outside of the TAD driver, such as the EFI subsystem, may need to
know whether or not the RTC can be driven via the ACPI TAD, for example
to avoid registering a redundant RTC.

For this purpose, add a new header, include/acpi/acpi_tad.h, containing
a define for the TAD's hardware ID, the TAD capability flags moved there
from the driver, and a helper, acpi_tad_rtc_available(), that returns
whether or not acpi-tad will register an RTC class device for a TAD.

acpi-tad does that for a TAD that implements the Get/Set Real Time
methods, as advertised by bit 2 of its _GCP return value, but only if
the TAD has been enumerated as a platform device, so make the helper
check both.

Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
---
 drivers/acpi/acpi_tad.c | 15 ++-------
 include/acpi/acpi_tad.h | 67 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 12 deletions(-)
 create mode 100644 include/acpi/acpi_tad.h

diff --git a/drivers/acpi/acpi_tad.c b/drivers/acpi/acpi_tad.c
index 45459a4ca..5fb978523 100644
--- a/drivers/acpi/acpi_tad.c
+++ b/drivers/acpi/acpi_tad.c
@@ -33,21 +33,12 @@
 #include <linux/rtc.h>
 #include <linux/suspend.h>
 
+#include <acpi/acpi_tad.h>
+
 MODULE_DESCRIPTION("ACPI Time and Alarm (TAD) Device Driver");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Rafael J. Wysocki");
 
-/* ACPI TAD capability flags (ACPI 6.6, Section 9.17.2) */
-#define ACPI_TAD_AC_WAKE	BIT(0)
-#define ACPI_TAD_DC_WAKE	BIT(1)
-#define ACPI_TAD_RT		BIT(2)
-#define ACPI_TAD_RT_IN_MS	BIT(3)
-#define ACPI_TAD_S4_S5__GWS	BIT(4)
-#define ACPI_TAD_AC_S4_WAKE	BIT(5)
-#define ACPI_TAD_AC_S5_WAKE	BIT(6)
-#define ACPI_TAD_DC_S4_WAKE	BIT(7)
-#define ACPI_TAD_DC_S5_WAKE	BIT(8)
-
 /* ACPI TAD alarm timer selection */
 #define ACPI_TAD_AC_TIMER	(u32)0
 #define ACPI_TAD_DC_TIMER	(u32)1
@@ -895,7 +886,7 @@ static int acpi_tad_probe(struct platform_device *pdev)
 }
 
 static const struct acpi_device_id acpi_tad_ids[] = {
-	{"ACPI000E", 0},
+	{ACPI_TAD_HID, 0},
 	{}
 };
 
diff --git a/include/acpi/acpi_tad.h b/include/acpi/acpi_tad.h
new file mode 100644
index 000000000..4825e10e9
--- /dev/null
+++ b/include/acpi/acpi_tad.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ACPI Time and Alarm Device (TAD) definitions (ACPI 6.6, Section 9.17)
+ */
+#ifndef __ACPI_TAD_H
+#define __ACPI_TAD_H
+
+#include <linux/acpi.h>
+#include <linux/bits.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+
+#define ACPI_TAD_HID		"ACPI000E"
+
+/* ACPI TAD capability flags (ACPI 6.6, Section 9.17.2) */
+#define ACPI_TAD_AC_WAKE	BIT(0)
+#define ACPI_TAD_DC_WAKE	BIT(1)
+#define ACPI_TAD_RT		BIT(2)
+#define ACPI_TAD_RT_IN_MS	BIT(3)
+#define ACPI_TAD_S4_S5__GWS	BIT(4)
+#define ACPI_TAD_AC_S4_WAKE	BIT(5)
+#define ACPI_TAD_AC_S5_WAKE	BIT(6)
+#define ACPI_TAD_DC_S4_WAKE	BIT(7)
+#define ACPI_TAD_DC_S5_WAKE	BIT(8)
+
+#if IS_ENABLED(CONFIG_ACPI_TAD) && IS_ENABLED(CONFIG_RTC_CLASS)
+/**
+ * acpi_tad_rtc_available - Check if the RTC can be driven via the ACPI TAD
+ *
+ * Check if there is a TAD that the acpi-tad driver will register an RTC class
+ * device for.
+ *
+ * Context: Process context, after the ACPI namespace has been scanned.
+ *
+ * Return: %true if acpi-tad will provide an RTC, %false otherwise.
+ */
+static inline bool acpi_tad_rtc_available(void)
+{
+	struct acpi_device *adev;
+	unsigned long long caps;
+	struct device *dev;
+	acpi_status status;
+
+	adev = acpi_dev_get_first_match_dev(ACPI_TAD_HID, NULL, -1);
+	if (!adev)
+		return false;
+
+	dev = bus_find_device_by_acpi_dev(&platform_bus_type, adev);
+	if (!dev) {
+		acpi_dev_put(adev);
+		return false;
+	}
+	put_device(dev);
+
+	status = acpi_evaluate_integer(adev->handle, "_GCP", NULL, &caps);
+	acpi_dev_put(adev);
+
+	return ACPI_SUCCESS(status) && (caps & ACPI_TAD_RT);
+}
+#else
+static inline bool acpi_tad_rtc_available(void)
+{
+	return false;
+}
+#endif /* CONFIG_ACPI_TAD && CONFIG_RTC_CLASS */
+
+#endif /* __ACPI_TAD_H */
-- 
2.56.0

