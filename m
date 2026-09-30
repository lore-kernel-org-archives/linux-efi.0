Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AB22EA732;
	Wed, 30 Sep 2026 18:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793922; cv=none; b=m1QfBbRrfQq5RpRGnPNvFAQBev5ELbBs06T+WQF6FPn3Fx82gZpA7kqPC8Hk4XKZMhP+1j67NmbmBH7Rz+QpnTcFdfZVrb5JhwaGeQYQPWiO7KWgKibQ+b91Z757FRBf9PBNiH3DI9ccLjlgF+T8Pc1+ARCt1OLBawOdmtZA2Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793922; c=relaxed/simple;
	bh=tx9mQZnBRw8YetRzFdodW780rTrp63sKO+q7f6epAws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bqeTuJeiMeuQeAQh2H2Q05pvmNWIWzqqXbSSYUXdcs25gJZAyn5P2fK4aWnFnkVGxAAYoAKbpzA/mAGJX3UtTEAa09/zoR0RDm4puWNB2RDocnMmsIENaLTDDFq7JyiVGCmykoZtGe0+n0xRVqnH6h5Ohy7RUTXLld+y375IIyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSWKQUAU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSWKQUAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597EC1F00898;
	Wed, 30 Sep 2026 18:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790793920;
	bh=vA5hsqCvhvz/T3rPXSDNs/An5ZWBLUxtfQ5Oe7HS6yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hSWKQUAUMSVWY8REIbJ+wlwC5u8T4148msWaoNWgoJXh7xwPaFnhSYKH7JRmLBqyX
	 L+Apd5Y0CEHCGhWFZurBxVDtbOdZ7mRVGJfBrmENkww9WZN+EnYt5a6Yb+EHj/bTW5
	 Bcql1ZBb6HCDvzztw7mt0DTRzVW9o+OLh1OjbFcgpDcFOAPr0MMXeUCmoEWvCg7Jyu
	 FIr3MpKTblh9NuPJSfCrNy/TMXxrBH1knMccsawQ5HMi+0rHt4ocTepOR5CC/IhROD
	 uoXGPt0OdxtCj9AKFkxpAdhoqxOi8ZzhTtQbrYUe5N708o11e6kzedWOmIFqn3FJ0J
	 NO20Z3rDtLZtA==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>, iommu@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Sudeep Holla <sudeep.holla@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Will Deacon <will@kernel.org>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Robin Murphy <robin.murphy@arm.com>, David Rhodes <david.rhodes@cirrus.com>,
 Richard Fitzgerald <rf@opensource.cirrus.com>, linux-sound@vger.kernel.org,
 patches@opensource.cirrus.com, Shenghao Ding <shenghao-ding@ti.com>,
 Kevin Lu <kevin-lu@ti.com>, Baojun Xu <baojun.xu@ti.com>,
 Sen Wang <sen@ti.com>
Subject:
 [PATCH v2 2/5] iommu/arm-smmu-v3: Switch to use acpi_bus_get_primary_device()
Date: Wed, 30 Sep 2026 20:43:03 +0200
Message-ID: <3636226.QJadu78ljV@rafael.j.wysocki>
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




