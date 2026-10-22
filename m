Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792703595;
	b=YRcx2C2Lvv5MTaQdZ5svvOtxzsqNmGWy4OdegKYKbPKw6WvbIFNn4B5uuGO8T5KJcheT
	 INIs5WYQcwJSxyXqGmN4V8q24G75E0ki7k+rGTQOPWmEd5bXOxQgLMU+rh2xwIEgHzIKe
	 j/cswEc57WvZ6buXze/1OnGvOtFOio5QKLi4tUrBfTTiaTWiaYW3qhfxq5MO98+9M3Wq9
	 dY/cT8nf9LypdXwGVl2jaIbLauXi+//MQXcc9xIS+e2O9aGI7Wo4ssAlRyGgojO+Prb2b
	 dxu7liZh4XOb4K7mCPCpKD3CmcmFn4HoFKoYobekNCp5VWZjUXMavhyaCjncSjZd3xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792703595;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HVfBLk4HTc3Q1JSz/tfe3BVw+fdZ6OMFICyRLMEHTb0=;
	b=TPEPQ/Sx8cz4oKY3fXixlAThD3fMTj9BGgi2+ZFdUKFvMC7pluMyvXs/tW48rMP6iUVi
	 0jIhHw/SGDBII1XmO/BDbi7f1FflXa0qxe8xJknNr8pPgZBSdYH9y8YvrmSDyqhqV4hmX
	 vXGU2yvPz1tqkYlRClu7yi6ItlOhTZGBusECTFUsZrs+AgPdT+X4W83uRFmD4EthMFkvX
	 WHQm+XSJDr8izkJixYmMRqDoxw140EW1ADLqr88OIFMZaA69sOjbdQ3of0PzSLC/StHXF
	 FbKHLsy5+IBZ9115JayqldHp8g1cAEDD5jYnHTl9sWixw0sthXnRKJH89Rgfgxlwc9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b="EpkiT5/P";
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D440606A31A;
	Thu, 22 Oct 2026 21:13:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D440606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=EpkiT5/P
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 9FC2820B7167; Thu, 22 Oct 2026 14:13:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9FC2820B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792703586;
	bh=HVfBLk4HTc3Q1JSz/tfe3BVw+fdZ6OMFICyRLMEHTb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpkiT5/PFjdo40SKtLABbtNcnlTX13uBQMIZSpTOpqmmD3/h6dlfmo7uI+jS3pNuo
	 dA3PMomECm134w2pkCHYbFTSBhvDDgnM2lgVTTBKI0sRtyx4U3Z+Pe9T1GxdFNSuO5
	 KrHbK2p+4tz1kKlZyP4DDuuYpb6w3wxxUZGUzlDY=
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
Subject: [PATCH 2/2] efi: don't register rtc-efi if the ACPI TAD can drive the RTC
Date: Thu, 22 Oct 2026 17:13:04 -0400
Message-ID: <20261022211304.2285792-2-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261022211304.2285792-1-hamzamahfooz@linux.microsoft.com>
References: <20261022211304.2285792-1-hamzamahfooz@linux.microsoft.com>
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

EFI runtime services are best avoided where possible, and ACPI defines a
standard interface to the real time clock in the form of the Time and
Alarm Device (TAD), which the acpi-tad driver has been exposing as an
RTC class device since commit 8a1e7f4b1764 ("ACPI: TAD: Add RTC class
device interface").

So, don't register the rtc-efi platform device if acpi-tad is going to
register an RTC class device for the TAD, according to
acpi_tad_rtc_available().

Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
---
 drivers/firmware/efi/efi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9bc22de0d..706064479 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -34,6 +34,8 @@
 #include <linux/security.h>
 #include <linux/notifier.h>
 
+#include <acpi/acpi_tad.h>
+
 #include <asm/early_ioremap.h>
 
 struct efi __read_mostly efi = {
@@ -459,7 +461,8 @@ static int __init efisubsys_init(void)
 	if (!efi_enabled(EFI_BOOT))
 		return 0;
 
-	if (efi_rt_services_supported(EFI_RT_SUPPORTED_TIME_SERVICES))
+	if (efi_rt_services_supported(EFI_RT_SUPPORTED_TIME_SERVICES) &&
+	    !acpi_tad_rtc_available())
 		platform_device_register_simple("rtc-efi", 0, NULL, 0);
 
 	/* We register the efi directory at /sys/firmware/efi */
-- 
2.56.0

