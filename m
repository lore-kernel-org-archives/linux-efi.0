Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D16A3AE6E5;
	Mon, 21 Sep 2026 19:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020638; cv=none; b=SRBmzPl5umdX2+aBhxdZhK7ebb6v1ygdEMUwftsg1OMgTp2h/3UGssA/n1wMxvDmbVOsza7FExn9pRKcgSuVNGcFzTuz6ZuYKRV74QtVirvYH038hbUe0816caao4SWYrkYH34rSXJLDbXm96ojb1i7/WQTlt0IhSgamULh4aSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020638; c=relaxed/simple;
	bh=iPsHQbbpQwUFp6xKd/dCzNUBdpGDy/+EYaeTWLuWMnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UDWGtChOfpe8Cr5j+R0TK9WcCYBXnLtaHY5aldb1/F0ArC7+oU6eJLTRrI1TsCYC0RQbnDaSFDpV1C5y4eb2DH0RbQXsnrxB6ITLKGIE/vZN1fSrPzIPcD+ozNyqNT7w8yH7j7BPAYmQm1bnH2uu2WCOdEX7z0p7OY/a/O2sVWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IdwgEx+Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IdwgEx+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A3F1F000FF;
	Mon, 21 Sep 2026 19:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020637;
	bh=TAVGV/5Thua1TFZOVKbuRwl/jAXk2aReC7bLxrqFtsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdwgEx+YGAuylT795p2nuD/OUN0WwNll7UPKO7jtrFpUGbfB2ob36smndpAzNfWsm
	 5ppEiNvfzHg0fKrFzZIb+itRMzh6qndqxQr8pFoZUbHgUPHz0VxFNgDSvfymhuRNYU
	 4mS76GiBu07fKd+7HqmbT9eMiPL/Sq2FkdG2ODfs+YPG8sONNNaJ4VZY+7T14Keboq
	 pyId8WU52CtwkRDtulypkfELySzUMCu1ynPmTUL2MNBTRPooxu4shT3wo+JwvMKNq0
	 dZkVETyhg0G4jtY6AdWpwAZNxlY9y0DxnPh4Bg3IbGwQYr1v/pYAgOR+3rKYLwDsZI
	 PFqJcTS8OUDfA==
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
 [PATCH v1 16/17] ASoC: loongson: Switch to use acpi_bus_get_primary_device()
Date: Mon, 21 Sep 2026 21:55:56 +0200
Message-ID: <2796562.BddDVKsqQX@rafael.j.wysocki>
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
 sound/soc/loongson/loongson_card.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/loongson/loongson_card.c b/sound/soc/loongson/loongson_card.c
index 6422cc1703b6..9f3907278462 100644
--- a/sound/soc/loongson/loongson_card.c
+++ b/sound/soc/loongson/loongson_card.c
@@ -196,7 +196,6 @@ static int loongson_card_parse_acpi(struct loongson_card_data *data)
 	struct snd_soc_card *card = &data->snd_card;
 	const char *codec_dai_name;
 	struct acpi_device *adev;
-	struct device *phy_dev;
 	int i, ret;
 
 	/* fixup platform name based on reference node */
@@ -204,7 +203,7 @@ static int loongson_card_parse_acpi(struct loongson_card_data *data)
 	if (!adev)
 		return -ENOENT;
 
-	phy_dev = acpi_get_first_physical_node(adev);
+	struct device *phy_dev __free(put_device) = acpi_bus_get_primary_device(adev);
 	if (!phy_dev)
 		return -EPROBE_DEFER;
 
-- 
2.51.0




