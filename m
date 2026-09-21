Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CB23E025C;
	Mon, 21 Sep 2026 19:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020693; cv=none; b=i6AhcQo1oZZJL6vx9kHSTdBhAl/GzSihtvkPwG7ZtrlqhmuzuJhFNXj+xgNq9FXIr/aScJ38NrHb/YOuDRX3Q7fMN9iOEbERO4DGTafYovGFjoiIs8SNOeACH20OVEJSP6DdLE0x3WWGov9bcBJmSKLlnBRR0zkDqSNAB3/qXLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020693; c=relaxed/simple;
	bh=n2+8GPLKhhXB4YII9MNQWFiotVYFyPx3wznGcyhdjnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ksjmvFFu1JBffyEJbpp7251O5IuIcm/AU8BUbFg4DKLpHFofu7w/Nqc2WkAHaYGis1ukxj24OAB1CcAB4+FviB84R27KKrcC8XbhxpSvSOAD+pFUyNOwciHpgCiMgotgy3lP6Sasajx5rkYIHdGRpGtSw/70/jK7gkuNVbyuaPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kLy1SWp6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kLy1SWp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9451F00899;
	Mon, 21 Sep 2026 19:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020692;
	bh=1tN8EiEXErZri4xnT56eJvdv4f/XP1BJExpmWIMGBrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLy1SWp6TJB975WFGZpA6jNsFoxkFBjVtOK0Nt8M+P+OYJCkn0AAX26FJsOQeHw2p
	 D4hduh6noknXe01W+WMwG6F8c6irZMR0IzAnd8Xp8VXOGToWruuGotVdqEgc6+hAtW
	 f4PCSBcY1Zwz2gTMPpgxTFOfhOTJhnzc5/uSTzth948T5QM0CD+XSXiVENCx2uZRCX
	 gmj/4ZjesxNLKK8dGa/dE9CNYvlykdzPiLm/nmH+9YmxPlFnat1aNAD7e9apsznIXe
	 A83XjOeBNqqQt5BrNrC+zT+ibS0V3AqI/oMKM8uGo4x4hg/JWJRhcAbd6Q5/bVw1L3
	 UWH64iNo2u4JA==
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
 [PATCH v1 11/17] ALSA: hda: aw88399: Switch to use
 acpi_bus_get_primary_device()
Date: Mon, 21 Sep 2026 21:52:32 +0200
Message-ID: <2568518.jE0xQCEvom@rafael.j.wysocki>
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
 sound/hda/codecs/side-codecs/aw88399_hda.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/hda/codecs/side-codecs/aw88399_hda.c b/sound/hda/codecs/side-codecs/aw88399_hda.c
index 11cef4923024..439ad45557a4 100644
--- a/sound/hda/codecs/side-codecs/aw88399_hda.c
+++ b/sound/hda/codecs/side-codecs/aw88399_hda.c
@@ -209,8 +209,7 @@ static int aw88399_hda_acpi_probe(struct aw88399_hda *aw88399)
 		return -ENODEV;
 	}
 
-	struct device *physdev __free(put_device) =
-		get_device(acpi_get_first_physical_node(adev));
+	struct device *physdev __free(put_device) = acpi_bus_get_primary_device(adev);
 	acpi_dev_put(adev);
 	if (!physdev)
 		return -ENODEV;
-- 
2.51.0




