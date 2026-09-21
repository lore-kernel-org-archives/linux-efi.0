Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6053E1681;
	Mon, 21 Sep 2026 19:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020683; cv=none; b=AnvzIJZP68pYz+mjXjc7ZMj9YJcq8VjIsLSa7GXD78vVy1cL1V9fWBbja0nDPBMLmUlbqWuxXDpQPEtXEhgBcbw+Q5OCSdXmslmrTWk7L2G5UDLSkcGhZiLnD+RHpdMGL0jjBkqhuItv8cboeii1WaKIVarPIZ5gQcWpWswe0jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020683; c=relaxed/simple;
	bh=PuDgcUnfUxSDQ/MUOSppfK36EcGqO6QwNGeAN9i6xwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NWnW8etazWn9Si3fyOXyKHstOx9d1At+PX+E54rZxSLlb99sS28IQImHb7B1qbs/CNTT0fflwiRY6YNe7GlkhjciXD8iks7ZzWZunrc01t2oXdT3VsiMi83y0QJweIcPbjs9MdNz2wjxIcD5jjLv5PhEgwsxESid3J0sj5LGZxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ci0EfexE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ci0EfexE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763B91F000FF;
	Mon, 21 Sep 2026 19:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020681;
	bh=n4tfQQNoh1s0SuFBn8g/TxJGhMe3ZOSgNRY3dXc6AJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ci0EfexEzpXudF6A1c0TRtaS3ijsUSJzv01W1MLD2bmATKrk4YDSRg9uokuQTkYan
	 urzbYyusNB+l570E5twrDA1odMxPLzuEshNs6shFYh7z7YT1HLPBhUZTBB8UUz/NDp
	 DrCb4KDhJ8OUEOs7U+IbTOs/3KI0DnpxKsWjXdModl6jPM22pi7RlmvW7WL6q+E+Tu
	 iS657fJiAxB7i8oRzIHoC0Vm/Or2EPgEm/yHGYZBleqSlxQybJDLd7bVQSOJfd0nUt
	 Zw4WOcr1rc00S7qHzQL747+8FZYX4Y5yDELZISU2iLc8BNhPOIj3b1lrJDbfR0Vyyo
	 W7Q5xsASeT4Ew==
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
 [PATCH v1 12/17] ALSA: hda: tas2781: Switch to use
 acpi_bus_get_primary_device()
Date: Mon, 21 Sep 2026 21:53:12 +0200
Message-ID: <895014215.0ifERbkFSE@rafael.j.wysocki>
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
 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c | 3 +--
 sound/hda/codecs/side-codecs/tas2781_hda_spi.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
index 5e5f46c9fb6b..161ca965c63e 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_i2c.c
@@ -100,8 +100,7 @@ static int tas2781_read_acpi(struct tasdevice_priv *p, const char *hid)
 		return -ENODEV;
 	}
 
-	struct device *physdev __free(put_device) =
-		get_device(acpi_get_first_physical_node(adev));
+	struct device *physdev __free(put_device) = acpi_bus_get_primary_device(adev);
 	ret = acpi_dev_get_resources(adev, &resources, tas2781_get_i2c_res, p);
 	if (ret < 0) {
 		dev_err(p->dev, "Failed to get ACPI resource.\n");
diff --git a/sound/hda/codecs/side-codecs/tas2781_hda_spi.c b/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
index da71b57a26ee..f3ba7132d2b8 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
@@ -341,8 +341,7 @@ static int tas2781_read_acpi(struct tas2781_hda *tas_hda,
 
 	strscpy(p->dev_name, hid, sizeof(p->dev_name));
 
-	struct device *physdev __free(put_device) =
-		get_device(acpi_get_first_physical_node(adev));
+	struct device *physdev __free(put_device) = acpi_bus_get_primary_device(adev);
 	acpi_dev_put(adev);
 	if (!physdev)
 		return -ENODEV;
-- 
2.51.0




