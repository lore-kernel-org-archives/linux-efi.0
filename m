Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9003CC32E;
	Mon, 21 Sep 2026 19:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020726; cv=none; b=M9JQzqcnouUvEawUjTUGBLYiLWteggXJT65PLjnp3ccr1WtptbcG0podBACBLhzj81Rb7Osd4tbGVCzRlUveQav9f+EhCzTr3zQZJ9zSrNM7m/oPv6W6WPf86gqD7FHSl04e+3b+kTf3sZzNmlFJFYnWOZ1Xf7eOeimw7kl00Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020726; c=relaxed/simple;
	bh=9uZAGs3e8Cnvqz27ZBlqYoNAlHSPexEfJzEGqE6LPrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qFKeNcyR0jgL+z8xXQTFloRwdCRsB4hV3k0FRy/4wPXXJH45V+tagyC86lQJuzyj5pR+Aj+H6Ruf0pQsS/G+RihusVU+yIOa8pPIKeMldYkAZhpIcni52t96ewbH4GCpGfiDYG5JlLxjapfcpprwnwlyg6tSnMjrhpQ0TAb6ELA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LD6W2Wyz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LD6W2Wyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6F91F00893;
	Mon, 21 Sep 2026 19:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020725;
	bh=WJ8N+mrV6u3cfqGcoiPMbpRTWJEEOHp2lUrNnbxW06A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LD6W2WyzOksR0uOR2WulOxOo+3440yB3T3ZMsOTHOPwG4m1pEyPQOCOmNph0T4LIU
	 Nod+IxbhEmbhGxA5ARKKzMEa+6U+beez7PC0zbeMF7v1JKQ1cNeyPncwMnfZnqnLtt
	 xZ5BOp9K/5Pf/Ee55DqyWUNEekzivJ11F9niaNBC7trGJ6YqV3TipSMREUgAhk3jQm
	 roY8A7XHayg9rtMl7ADBJpfS1AuOSN1bHCjgttaIS1y3nbEW1WMa19VXzEUahCNLBJ
	 OLkpMSNuYCxAss9qlQX4y38Z8UVv48a18jH5UlbHiUhTI11KEXLou6o6HuzlAyDgF3
	 fUNb1sQPq2V4A==
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
Subject:
 [PATCH v1 08/17] platform/x86: x86-android-tablets: Use
 acpi_bus_get_primary_device()
Date: Mon, 21 Sep 2026 21:50:28 +0200
Message-ID: <3912360.MHq7AAxBmi@rafael.j.wysocki>
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

Replace acpi_get_first_physical_node() that is slated for removal
with acpi_bus_get_primary_device() that takes a reference to the
device it is about to return.

This addresses a potential use-after-free that may occur if the
device returned by acpi_get_first_physical_node() is removed right
after dropping its ACPI companion's physical_node_lock in that
function.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/platform/x86/x86-android-tablets/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/x86-android-tablets/core.c b/drivers/platform/x86/x86-android-tablets/core.c
index cfff7f5eac5d..2c262f117235 100644
--- a/drivers/platform/x86/x86-android-tablets/core.c
+++ b/drivers/platform/x86/x86-android-tablets/core.c
@@ -390,7 +390,6 @@ static int gpio_secondary_fwnode_init(struct device *parent,
 {
 	const struct software_node *const *swnode;
 	struct fwnode_handle *fwnode;
-	struct device *phys_dev;
 	int ret;
 
 	if (!node_group)
@@ -418,7 +417,8 @@ static int gpio_secondary_fwnode_init(struct device *parent,
 		if (WARN_ON(!fwnode))
 			return -ENOENT;
 
-		phys_dev = acpi_get_first_physical_node(to_acpi_device(dev));
+		struct device *phys_dev __free(put_device) =
+				acpi_bus_get_primary_device(to_acpi_device(dev));
 		if (!phys_dev)
 			return dev_err_probe(parent, -ENODEV,
 					     "No physical device for ACPI GPIO dev: %pfwP\n",
-- 
2.51.0




