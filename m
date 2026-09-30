Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2482F353A65;
	Wed, 30 Sep 2026 18:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793928; cv=none; b=UP+ljyLP5s8KfV9PNEvGV94JKSU8G7Tt7o08TSfhjaeP+WAsi3dXV1Ry6L82g1J3fx03HTDSBijel/GNEL87ZavWOPLn+jcjk7r5kD03/e1nZ144UfRltDxUnqBn14rJWeqtRHIjIESsWv61oDYFCNbk+IT67puT1LQwXlW6Cv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793928; c=relaxed/simple;
	bh=D2Q4ndQ5kq6cv7G5VBHOSS9RO2v8HcOkQIbLvf8sGx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sj9xl+V9mqkKnP0olua2SBJvlAY//5gMLhBpiOfN/N3Bza30DhEKk3AXaix0LVJkfPZ2id6VnbyeoyFRiLXjwzJ6FVBCKAMccd1n/yBTu8aoN445LMVPcf7OMUGYrMfjrxbsXu9dnPOIK2PKGd0jIAh4M6+EOrspFHHacJ52+9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AmEbGLAU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AmEbGLAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375A31F0089B;
	Wed, 30 Sep 2026 18:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790793926;
	bh=fIo75/ZA2hb+/w3b7P/tnJ5SIXlHwF5f78Uc4xRp+f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmEbGLAUyUsgx7rwtTy2/gQiIBpEUL0KnmdkdTDXgNbaQEPv1IFdcd3vHYzvSBbPv
	 TCI50eYEQSO4uTA4b4w0EJaSZ8uM3f38Owwbj9quB2NvbGPnpEiUk9tR96DTcCa+Ka
	 qeI6qqAUjxUu0JR6nVkXkuHo3QG2pwzRLAXFDyKSaoO4R/yHl4982hC2hVhp851ReI
	 xH1mk20PuZXfQMtlMIorGwok616c7c993aAIiNp4fZWpJg/5pL/0VGJthdg9ptvCrD
	 9UGcImRb2H6Xqjqc0uid32emjNsvLZ3Rr1JmDfh0GAU2UatLWLd4xb+fAQ6+Pg7bu/
	 U6kUKNJt4dImw==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>, linux-sound@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Sudeep Holla <sudeep.holla@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Will Deacon <will@kernel.org>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
 David Rhodes <david.rhodes@cirrus.com>,
 Richard Fitzgerald <rf@opensource.cirrus.com>, patches@opensource.cirrus.com,
 Shenghao Ding <shenghao-ding@ti.com>, Kevin Lu <kevin-lu@ti.com>,
 Baojun Xu <baojun.xu@ti.com>, Sen Wang <sen@ti.com>
Subject:
 [PATCH v2 4/5] ALSA: hda: tas2781: Switch to use
 acpi_bus_get_primary_device()
Date: Wed, 30 Sep 2026 20:42:36 +0200
Message-ID: <8782185.NyiUUSuA9g@rafael.j.wysocki>
Organization: Linux Kernel Development - Intel
In-Reply-To: <4766532.LvFx2qVVIh@rafael.j.wysocki>
References: <4766532.LvFx2qVVIh@rafael.j.wysocki>
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

This patch depends on new material in linux-next.

If you maintain the code updated by it, please consider ACKing it, so I can
pick it up and remove the problematic API replaced by it during the 7.4
merge window.

In the absence of feedback, it will be resent again when 7.4-rc1 is out.

Thanks!

v1 -> v2: No changes

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




