Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C29B3DFC6A;
	Mon, 21 Sep 2026 19:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020649; cv=none; b=XII3BSNa24/cbTPD6UWsvETCOx5se0LF5ngfLpUkxhBYjogZDND5kHLmAvpjLTDSjTU+yLjM/lC+aOfVHTMWvHUwdzTAZeYWTRyYp5yZfm7w3BaxSTHf/tdhHoHi9Wqv5LYYA0Evmmsla1ULbitnQPK+6i6S/rgEqhZ4+TwUvQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020649; c=relaxed/simple;
	bh=Kmm40yDf8FH9kmztNlkvqESdLseM8T4eCzuBywjV3qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l3/vAH0z1GwdpVkIRtjOmLrsKiLG9XUlFqtXpltieUMZyf0e7K56tacWdoBRgilLp0lXNsE0qFHojAWicZBH2gr5GHBIBZWt4bx14gVCShUGqvMbuxk3TKyJmru4PMtAYXrOVuwNVWFh9116CAw4mcujhphiSfg1xEc35fvX1gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eBPbGqTS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eBPbGqTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A071F000FF;
	Mon, 21 Sep 2026 19:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020648;
	bh=go+HK5V8dXGRhi+GpzpcFcbkmCcxgz1J0eAaEUWZhfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eBPbGqTSwksrjwkr4sxg4GHe82m+5pK2JSUOLuofQeoEN7JhyzubEqijBqEtw46TS
	 bPoTnDlA57zedfb5Z7p+fWJn7DwaDW7OzQfH2apBiwD+eUYWNXxyHOnIY+jjirXYET
	 9bkk2F8LTszcnZO5VWDUCrXVO/ZPSJWnr0ZkRY6XhOH+eYGqFn5ztxBShSHxgARBMC
	 x0xsF26npySnRmgjxsapwtfTr+nXKuTV2jBcagbONYfI5YOO3x6q9ihurNpOIbyP7c
	 q7G0Yw1nH6sPJ8us29TpeYvn/O2n4pM9zlx/iG2wcGTkl/Bro+ideclJNV2DUEJkd/
	 kRm35X8DqBfDQ==
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
 [PATCH v1 15/17] ASoC: intel: boards: Switch to use
 acpi_bus_get_primary_device()
Date: Mon, 21 Sep 2026 21:55:15 +0200
Message-ID: <15844908.tv2OnDr8pf@rafael.j.wysocki>
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
 sound/soc/intel/boards/bytcht_es8316.c     | 4 ++--
 sound/soc/intel/boards/bytcr_rt5640.c      | 4 ++--
 sound/soc/intel/boards/bytcr_rt5651.c      | 4 ++--
 sound/soc/intel/boards/cht_bsw_rt5645.c    | 5 ++---
 sound/soc/intel/boards/sof_cirrus_common.c | 2 +-
 sound/soc/intel/boards/sof_es8336.c        | 4 ++--
 6 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index ea387dc74273..4d8d1d176a49 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -601,11 +601,11 @@ static int snd_byt_cht_es8316_mc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	codec_dev = acpi_get_first_physical_node(adev);
+	codec_dev = acpi_bus_get_primary_device(adev);
 	acpi_dev_put(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
-	priv->codec_dev = get_device(codec_dev);
+	priv->codec_dev = codec_dev;
 
 	/* override platform name, if required */
 	byt_cht_es8316_card.dev = dev;
diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 40da3eea5fa7..c84b9a0fe65a 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -1744,11 +1744,11 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	codec_dev = acpi_get_first_physical_node(adev);
+	codec_dev = acpi_bus_get_primary_device(adev);
 	acpi_dev_put(adev);
 
 	if (codec_dev) {
-		priv->codec_dev = get_device(codec_dev);
+		priv->codec_dev = codec_dev;
 	} else {
 		/*
 		 * Special case for Android tablets where the codec i2c_client
diff --git a/sound/soc/intel/boards/bytcr_rt5651.c b/sound/soc/intel/boards/bytcr_rt5651.c
index 62cb4856c797..a0ed56d285bc 100644
--- a/sound/soc/intel/boards/bytcr_rt5651.c
+++ b/sound/soc/intel/boards/bytcr_rt5651.c
@@ -943,11 +943,11 @@ static int snd_byt_rt5651_mc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	codec_dev = acpi_get_first_physical_node(adev);
+	codec_dev = acpi_bus_get_primary_device(adev);
 	acpi_dev_put(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
-	priv->codec_dev = get_device(codec_dev);
+	priv->codec_dev = codec_dev;
 
 	/*
 	 * swap SSP0 if bytcr is detected
diff --git a/sound/soc/intel/boards/cht_bsw_rt5645.c b/sound/soc/intel/boards/cht_bsw_rt5645.c
index 249be121be15..4f20928a3604 100644
--- a/sound/soc/intel/boards/cht_bsw_rt5645.c
+++ b/sound/soc/intel/boards/cht_bsw_rt5645.c
@@ -529,7 +529,6 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 	const char *platform_name;
 	struct cht_mc_private *drv;
 	struct acpi_device *adev;
-	struct device *codec_dev;
 	bool sof_parent;
 	bool found = false;
 	bool is_bytcr = false;
@@ -583,8 +582,8 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	/* acpi_get_first_physical_node() returns a borrowed ref, no need to deref */
-	codec_dev = acpi_get_first_physical_node(adev);
+	struct device *codec_dev __free(put_device) = acpi_bus_get_primary_device(adev);
+
 	acpi_dev_put(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
diff --git a/sound/soc/intel/boards/sof_cirrus_common.c b/sound/soc/intel/boards/sof_cirrus_common.c
index 88fc6cb2bfd4..a4ecb1f9a615 100644
--- a/sound/soc/intel/boards/sof_cirrus_common.c
+++ b/sound/soc/intel/boards/sof_cirrus_common.c
@@ -168,7 +168,7 @@ static int cs35l41_compute_codec_conf(void)
 				 cs35l41_name_prefixes[uid]);
 			continue;
 		}
-		physdev = get_device(acpi_get_first_physical_node(adev));
+		physdev = acpi_bus_get_primary_device(adev);
 		acpi_dev_put(adev);
 		if (!physdev) {
 			pr_devel("Cannot find physical node for HID %s UID %u (%s)\n", CS35L41_HID,
diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 9b016136c639..3c0d7155f059 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -693,11 +693,11 @@ static int sof_es8336_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	codec_dev = acpi_get_first_physical_node(adev);
+	codec_dev = acpi_bus_get_primary_device(adev);
 	acpi_dev_put(adev);
 	if (!codec_dev)
 		return -EPROBE_DEFER;
-	priv->codec_dev = get_device(codec_dev);
+	priv->codec_dev = codec_dev;
 
 	ret = snd_soc_fixup_dai_links_platform_name(&sof_es8336_card,
 						    mach->mach_params.platform);
-- 
2.51.0




