Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AED33CEB9E;
	Wed, 30 Sep 2026 18:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793935; cv=none; b=usiY7nDLlB/w8mvtap8xgN9qfgn+nIguyttOF+R5P8p/DQZ/UXAPtiVTboIOCHE2+1Y1YmHQFNMhpQiG/l3Fnh/E7DeAJJg/eyqJ+2KeqMFR3msfsMG1mVs38tSyKpL+3aO6xG5m9u95pVVlZl7712EEIbRGibY6PrkCr9uw/x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793935; c=relaxed/simple;
	bh=YFgc6DGiz2RmNvUaXDR9d24S8CqeC+7+p1aF+2BYRYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dkrx24ny4cnXUBo5T0N06GNfC3a5Zbd03ac1HCYY01VLAw8AseAQcmQIMFakdEIVhNmxIb4vTDe/3+7sTDhG0UXnD5d5oRRxPO5qfg6o8LErAZDHoRTMDuX0J0thvmiSAp6f2jNmrPKmi9DWuj9cv7xFMnDLJprw2EN6Prnc2yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RG1fLF31; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RG1fLF31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1575F1F00898;
	Wed, 30 Sep 2026 18:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790793933;
	bh=4L9KB743dJyhVBRNiNV8YEwpftY1J+e9ffJPm3qRbXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RG1fLF31K6zig5yEi5YRjknLKdChfwUOp2jevRATPbks1co7p1huVxFGG6TvhDK+G
	 sbNzoLGi3xrD14lz9/X68Uqc4xc6dW1j+u0izKmyeNJsM5XlKaie9JYt8n9leWE2SO
	 97qzMCTfJp7GPxjzN7fw7lesKHTIX7YkgN+kAwztGNBUmZAeWVxm5vROXr0SawjKTT
	 6ob4egvQNlW6Bn0DGov74p826B/bqu5rTy12ySNIwDi9v5FgaA2saLDkJIsQ5q0+OI
	 KSSsWizGOySibRN+fB16hubKDwmpBEygTLzTUReovxGDST2C1yzPejNmJm1lGnYJzM
	 gB36thUB6B11Q==
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
 [PATCH v2 3/5] ALSA: hda: cs35l41: Switch to use
 acpi_bus_get_primary_device()
Date: Wed, 30 Sep 2026 20:42:15 +0200
Message-ID: <6200303.MhkbZ0Pkbq@rafael.j.wysocki>
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
 sound/hda/codecs/side-codecs/cs35l41_hda.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/hda/codecs/side-codecs/cs35l41_hda.c b/sound/hda/codecs/side-codecs/cs35l41_hda.c
index 62296be45c55..32abb71dd401 100644
--- a/sound/hda/codecs/side-codecs/cs35l41_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l41_hda.c
@@ -1926,8 +1926,7 @@ static int cs35l41_hda_read_acpi(struct cs35l41_hda *cs35l41, const char *hid, i
 	}
 
 	cs35l41->dacpi = adev;
-	struct device *physdev __free(put_device) =
-		get_device(acpi_get_first_physical_node(adev));
+	struct device *physdev __free(put_device) = acpi_bus_get_primary_device(adev);
 	if (!physdev) {
 		acpi_dev_put(adev);
 		return -ENODEV;
-- 
2.51.0




