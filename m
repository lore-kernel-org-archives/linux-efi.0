Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094F73D0939;
	Mon, 21 Sep 2026 19:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020787; cv=none; b=f0Xoto9sUopuDyZ3ONtD2O2jXiyj5ea5pabQzQ14zZibNHzn3ODgYiIJMHisFVXxexJ74LPLAMCprtkrcm6YV6CIMz42vYkqI6WU30kqLvP8s72LtwnLN+BAyvl4fIujbQNuHC9P1BvM74AHjOeg+aZPU4pc4axXka3gkHV8q+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020787; c=relaxed/simple;
	bh=PgcWBQRWjxL799AC1v8Qwup6Bp05Fv8A5Dq7/5AV9Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SRqcsIPn5kicysunUqh+stj2MQihtvM4g5hTBCa2E+MlBt7JerIRdHZk1TNQd+ZsZJhLJjuVVr3igp/W54vyNfxu5BfYQqVsLgD4b8qoqpvEKObiQifMgfpH9E4tUHa9FVeHIwCupjP82S+Qv65LLJJkBhiOjTeoXJuCSYj1DSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GBNHRgIV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GBNHRgIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A611F00898;
	Mon, 21 Sep 2026 19:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020781;
	bh=4Gc84nshf57F/O9JNJXpRgG24Hn8rEipfBZo0XmFWJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBNHRgIVmDV+JRar2AXK7q9NmtoXmMqVqeOQ+Zmz9MRMTqdjM9OinEXErDLc9F07D
	 Cgo204193T83ZK7ugq6VrDNajh35492FawZ7ZxWHDspmr/t1VjVdxyradYr9+XtmLl
	 Xu+tS6qUixcP5R4eta4rFx4wD22P8BfZXjQ6Th3bNLHe37mgq174PB0Nuz0bosGkwH
	 qrIOsB6jCvijrcIF8pN7h+OqhoCPORhqjTHwk7TBKXbVwZgDljCqXZZV7x04Ni69Oe
	 hMu+sWlpcG703QK9FbdiYYTAHgGnYL0XvwabJTfEkKkZHbt+Martqgvfr7sEtN/boP
	 pLbb0Xy0CeBKg==
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
 [PATCH v1 03/17] efi/dev-path-parser: Switch to use
 acpi_bus_get_primary_device()
Date: Mon, 21 Sep 2026 21:47:15 +0200
Message-ID: <1870567.VLH7GnMWUR@rafael.j.wysocki>
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
 drivers/firmware/efi/dev-path-parser.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/dev-path-parser.c b/drivers/firmware/efi/dev-path-parser.c
index 13ea141c0def..e0f864cbaa8c 100644
--- a/drivers/firmware/efi/dev-path-parser.c
+++ b/drivers/firmware/efi/dev-path-parser.c
@@ -37,9 +37,9 @@ static long __init parse_acpi_path(const struct efi_dev_path *node,
 	if (!adev)
 		return -ENODEV;
 
-	phys_dev = acpi_get_first_physical_node(adev);
+	phys_dev = acpi_bus_get_primary_device(adev);
 	if (phys_dev) {
-		*child = get_device(phys_dev);
+		*child = phys_dev;
 		acpi_dev_put(adev);
 	} else
 		*child = &adev->dev;
-- 
2.51.0




