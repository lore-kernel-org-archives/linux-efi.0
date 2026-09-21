Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA603E2ACA;
	Mon, 21 Sep 2026 20:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020810; cv=none; b=ZtRC8/rgHtRm6p+2b1DOh40o5WY/P9waT/mbgO6H0oeQF9ncz5kb0mOJO0gQE4K61I5oTTk1RgaGNEwkC4EBTIKGbXBJZtRpOBXKNId3Zfec1iLHLc9uIZ7S+9KjKuSnaxyMtDyqAV2VYnHtqowBULm6HYXjsbNt+gXaGQCAKO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020810; c=relaxed/simple;
	bh=p6v+cd79xmVsCqhGZBsut6uzEDQUrUWmD5mxe+kpuoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mtKkhrV7NFQJx+qop3pX4ovmm37mpwbmInDP+yjyRqmZDngRm5GLdAK7IYqidGa6Pyaa4JsvebppIpVj4hDQsvIY1ZvF+KmQjsxlopH5iBRhode/IWQsIpFnTpuz8/wCppnGz5GG09kT36oHNxEus3GQuk1MMXFfKc+WEePJSBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGd0c8fw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGd0c8fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE8C1F00898;
	Mon, 21 Sep 2026 19:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020803;
	bh=zNolz+v90tYRAgMmlaBqFoeM8H2neYyDYxiSR5AIgyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QGd0c8fw9lgBVCg7SNGJk8iDmbtATr49UqOL9y0REpuGdNsIwBm8z9dfmPXKfoRTy
	 8BCNA36oTOlq86KwdNjetlGO9UdpVztPqtaSwvaGxwpk6SyuS5gz+dNKFfIs+9QUA+
	 FdyjITQ/V5h2UPCPit5Y+qKTcuXTn6Re3KQ89OYV+Hr25XEmJlqapXug53+e3kxC4v
	 VVB6ui/m1Ht6wnvqI8aLOiuBzGRFA1lcBkTLy5bbGKCGgX0zHVIU9YV85NWAB+A5vF
	 ZStGu9O/UcATHCdN8Cdo+cjrSFav42TxWXEJONc06GyjCfUBOzFEpJb/BAQpZgPtl9
	 Y4HjCCFxBooRg==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Mika Westerberg <mika.westerberg@linux.intel.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
 Sudeep Holla <sudeep.holla@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Mark Pearson <mpearson-lenovo@squebb.ca>,
 "Derek J. Clark" <derekjohn.clark@gmail.com>,
 Hans de Goede <hansg@kernel.org>,
 Ilpo =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
 platform-driver-x86@vger.kernel.org, David Rhodes <david.rhodes@cirrus.com>,
 Richard Fitzgerald <rf@opensource.cirrus.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 linux-sound@vger.kernel.org, Shenghao Ding <shenghao-ding@ti.com>,
 Kevin Lu <kevin-lu@ti.com>, Baojun Xu <baojun.xu@ti.com>,
 Sen Wang <sen@ti.com>, Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
 Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
 Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
 Cezary Rojewski <cezary.rojewski@intel.com>,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
 Bard Liao <yung-chuan.liao@linux.intel.com>,
 Kai Vehmanen <kai.vehmanen@linux.intel.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
 Binbin Zhou <zhoubinbin@loongson.cn>,
 Andreas Noever <andreas.noever@gmail.com>,
 Mika Westerberg <westeri@kernel.org>, Yehezkel Bernat <YehezkelShB@gmail.com>
Subject: [PATCH v1 01/17] ACPI: bus: Use acpi/acpi_bus.h without CONFIG_ACPI
Date: Mon, 21 Sep 2026 21:45:59 +0200
Message-ID: <3717753.iIbC2pHGDl@rafael.j.wysocki>
Organization: Linux Kernel Development - Intel
In-Reply-To: <7995179.EvYhyI6sBW@rafael.j.wysocki>
References: <7995179.EvYhyI6sBW@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

Corrently acpi/acpi_bus.h is included in linux/acpi.h only if
CONFIG_ACPI is set, but it contains declarations that are useful
otherwise too.

For consistency, modify linux/acpi.h to always include acpi/acpi_bus.h
and update the latter to avoid exposing too much when CONFIG_ACPI is
not set.

Since acpi_has_method() is called from some code build when
CONFIG_ACPI is unset, add a stub for it to the !CONFIG_ACPI
block in acpi/acpi_bus.h.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/acpi/acpi_bus.h | 12 ++++++++----
 include/linux/acpi.h    |  2 +-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index a10a591c18b2..32837f507f40 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -9,6 +9,8 @@
 #ifndef __ACPI_BUS_H__
 #define __ACPI_BUS_H__
 
+#ifdef CONFIG_ACPI
+
 #include <linux/completion.h>
 #include <linux/container_of.h>
 #include <linux/device.h>
@@ -58,7 +60,6 @@ bool acpi_dock_match(acpi_handle handle);
 bool acpi_check_dsm(acpi_handle handle, const guid_t *guid, u64 rev, u64 funcs);
 union acpi_object *acpi_evaluate_dsm(acpi_handle handle, const guid_t *guid,
 			u64 rev, u64 func, union acpi_object *argv4);
-#ifdef CONFIG_ACPI
 bool
 acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld_info **pld);
 
@@ -77,7 +78,6 @@ acpi_evaluate_dsm_typed(acpi_handle handle, const guid_t *guid, u64 rev,
 
 	return obj;
 }
-#endif
 
 #define	ACPI_INIT_DSM_ARGV4(cnt, eles)			\
 	{						\
@@ -90,8 +90,6 @@ bool acpi_dev_found(const char *hid);
 bool acpi_dev_present(const char *hid, const char *uid, s64 hrv);
 bool acpi_reduced_hardware(void);
 
-#ifdef CONFIG_ACPI
-
 struct proc_dir_entry;
 
 #define ACPI_BUS_FILE_ROOT	"acpi"
@@ -942,8 +940,14 @@ int acpi_wait_for_acpi_ipmi(void);
 
 int acpi_scan_add_dep(acpi_handle handle, struct acpi_handle_list *dep_devices);
 u32 arch_acpi_add_auto_dep(acpi_handle handle);
+
 #else	/* CONFIG_ACPI */
 
+static inline bool acpi_has_method(acpi_handle handle, char *name)
+{
+	return false;
+}
+
 static inline struct device *acpi_bus_get_primary_device(struct acpi_device *adev)
 {
 	return NULL;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index ddacac812094..ba5234bd93a2 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -25,6 +25,7 @@ struct irq_domain_ops;
 #define _LINUX
 #endif
 #include <acpi/acpi.h>
+#include <acpi/acpi_bus.h>
 #include <acpi/acpi_numa.h>
 
 #ifdef	CONFIG_ACPI
@@ -35,7 +36,6 @@ struct irq_domain_ops;
 #include <linux/mutex.h>
 #include <linux/fw_table.h>
 
-#include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include <acpi/acpi_io.h>
 #include <asm/acpi.h>
-- 
2.51.0




