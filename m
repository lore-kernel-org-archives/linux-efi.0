Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829313DBD43;
	Mon, 21 Sep 2026 19:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020672; cv=none; b=eNTjhh+o9L5JFspZrDh4jUtS9np8w2p5/zXS7F9lDokcVHHUkQ1hiRuX+pBXotqQ0MbjwqVyP8sjxJLRlz6KiChgS7u9dcD/nTRuKt/s3MCiGfNSxe6BD4X+kk/MwZyqEPwnfkUZxDGhFnkquQ6Zk4tBZOOLhSCp7RXCTS+qoEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020672; c=relaxed/simple;
	bh=bde9OhIEBF25ZgWU/cZ3tm9o0H+1fIB6TYCUFNFJGlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KAams2VvygT8ecczMbaTpR9DKldPulwELYSj4KZPsmjZa6GZ9XEK7621B4PeSf5aGvAObYTws8iyDiI73ZwOf91YWYRxu2CfHpTPvd3IgcOtCgm3GMlEkSIN4lQqdURyYqLe04o3zIJxgp6baPqA6gqefhJLkDZWbwgESYyNN2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MbARqiV7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MbARqiV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807C41F000FF;
	Mon, 21 Sep 2026 19:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020670;
	bh=9Mhs6eb7OkvMZOjYpBfupxS7w4Ah9cPyVbDMAhR1BJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbARqiV7B/zfuakxG+63SG5caSv4KSIkhdZNqBBLtdFvrpvbFYImUZ3HkRFCbqhrw
	 qjBWyHn2eArQLhi7ERNIpORwvbfItMm0+vn9Qia1T6y8R4KSNI3f8M+ZpfYK9YRl+g
	 Z2pp54eugw3h41rE/U9UhSYXwHMxOhBcyzmbbPydDabtRGpxv+QFLjDwN5yMzAA+Ki
	 sPQV8T7lVBbftVjwHFoL6vK1l7sz+uBY2z1m03CdVOHHKV9E73axcA2i4qF2+uqh1+
	 JX9Chi9bxAiot3vdNurFg4+je5ockMo707YpxprDWAN3Bvd2Co5CLiXTOcJkFeQ6cq
	 3KXm/C+wQUm2w==
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
 [PATCH v1 13/17] ASoC: amd: acp-es8336: Switch to use
 acpi_bus_get_primary_device()
Date: Mon, 21 Sep 2026 21:53:51 +0200
Message-ID: <2063881.yKVeVyVuyW@rafael.j.wysocki>
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

It also fixes a device reference counting issue that may lead to
a premature device release if gpiod_get_optional() fails in
st_es8336_late_probe().

Fixes: 02527c3f2300 ("ASoC: amd: add Machine driver for Jadeite platform")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 sound/soc/amd/acp-es8336.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp-es8336.c b/sound/soc/amd/acp-es8336.c
index 9f3f11256788..34e953d1a3a7 100644
--- a/sound/soc/amd/acp-es8336.c
+++ b/sound/soc/amd/acp-es8336.c
@@ -198,7 +198,7 @@ static int st_es8336_late_probe(struct snd_soc_card *card)
 	if (!adev)
 		return -ENODEV;
 
-	codec_dev = acpi_get_first_physical_node(adev);
+	codec_dev = acpi_bus_get_primary_device(adev);
 	acpi_dev_put(adev);
 	if (!codec_dev) {
 		dev_err(card->dev, "can not find codec dev\n");
-- 
2.51.0




