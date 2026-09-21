Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E963EDAB5;
	Mon, 21 Sep 2026 19:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020771; cv=none; b=E1zCWNpPaH0Vw4rElXhoYvrVa2ZQ09fSviVoUdYxbBRH2gSYdYs2eRCdxBQZSNr/+z2a6paq6zQI8Nf/sQqROxIyrWQoRtQxL7oEUAQ2L5O3ao6X5q0M42YTJ0Jdh7RIBxnp4gZPLUMWXbfvn665RWscDtkLuf+XHJt/sfVjBiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020771; c=relaxed/simple;
	bh=tDFDEt8IUs532azdvJKDW9TvNkB4b+8sjasg9lClwBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NZNCwb4vF2RHRt54l7qKOwhDhI2PWzIdVtqzP/3569f6VHAtAQxFpj3ad+KkpKlJ5tggD8oW2iHX71lpcQKFRCYikE1eVx+TGjnmbgewa1j/ogafCVCKixAeCL3ymPP2ovKTltVvIzKzmDqTvCc49FMcqPj58xljrPKxtLY3TKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=araOXMAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="araOXMAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542F91F000FF;
	Mon, 21 Sep 2026 19:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020770;
	bh=GX1kDtjAfCXSGF7xrHyk2v4uUNilnK+1K3CoVNBtw4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=araOXMAq3aGf5lhsHaF9EYdes13PfMxi/AKztAHU3Va9Nn/vDgBSHqo0RuqeabItb
	 oNtT8BI+9WhQK8aNHeB4p9DzopBjegRomly7sPn5r0P6tX7YLA7OEiadHOlHz1p3Po
	 0VRvp+5bka4Xj+WWdxNA/7dio0SkeoRI17P+Y0ba9o+uQWj0w05brmPZmTKxsTn9T5
	 eP2rj5gGHKTms7HdD42p0zHYEeGtpIJcstNChorLw7RXgTT55bYgqWnIG8AhDR8Yut
	 jAnt6ui6lqRaHEYMrQx5RSmAvq0KzO9sZYYAsJDB7eJ6B5lTlV3T9gsx0VW4f0eoni
	 3JhTcsw/W2k5g==
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
 [PATCH v1 04/17] iommu/arm-smmu-v3: Switch to use
 acpi_bus_get_primary_device()
Date: Mon, 21 Sep 2026 21:47:52 +0200
Message-ID: <2073406.usQuhbGJ8B@rafael.j.wysocki>
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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5732f3ba0122..98f105798b89 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -5307,7 +5307,7 @@ static void acpi_smmu_dsdt_probe_tegra241_cmdqv(struct acpi_iort_node *node,
 	adev = acpi_dev_get_first_match_dev("NVDA200C", uid, -1);
 	if (adev) {
 		/* Tegra241 CMDQV driver is responsible for put_device() */
-		smmu->impl_dev = get_device(acpi_get_first_physical_node(adev));
+		smmu->impl_dev = acpi_bus_get_primary_device(adev);
 		smmu->options |= ARM_SMMU_OPT_TEGRA241_CMDQV;
 		dev_info(smmu->dev, "found companion CMDQV device: %s\n",
 			 dev_name(smmu->impl_dev));
-- 
2.51.0




