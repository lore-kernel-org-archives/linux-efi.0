Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98323D3CEF;
	Wed, 30 Sep 2026 18:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793943; cv=none; b=BgFSyPIivW96io8Fa2cE1WLnLj42FVWG10IPp3xJepQCYTYUvQBY3AJ73vTlG3PRR+DspBA2udIIXORK2COi6a7laNfQkC9D0OOem3hF9gSFxnYi6wrOIaCyIroTt0N7eTuED2a+PXm+wZdNC3vaqFN5BoqgpaMslENhKPseH/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793943; c=relaxed/simple;
	bh=oBb+17du6NRtxN3osGyM9CWUvAswLCoR9Oit+aa25a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V5fQ7PDFsye46Zr0Sr6eGJqfnT/J2gc3iDm6YprgxUAmuS2/cgwYnBC9uDinvhCvSAk/H5tTzQ1PGLhBOJ5Bgpvcw54ktLOyN4IuhsJENn2GGf9qMrOqJUXrqFnT0+P8YVuTilFxW9vOx1anRpdNAm2gbDbnJjwnb2tr138z1Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nvAgqC7+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nvAgqC7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C88A1F00898;
	Wed, 30 Sep 2026 18:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790793941;
	bh=sPUa1UDCepLgjEsxDYzNytI1H2lpA7WtjDbyVIjlxxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nvAgqC7+qL/txwB6g/TswQeMlYhqV9aY8pC6/L455ocIF2QraBN9yB7ixoNUQzQIr
	 AZAPONZ6gWyHGW+LUosU4Ts3onnbq40wLFrUX8c7cCSHYH4zzVUbRZJEqxjRAcrjPA
	 9AQV4IbWrLJihN0wZ00K4jZ/nIhS0I8wz/cZoqbpKlcoz3D06Azuxd+oZUA2Hr39lY
	 oLvpXENea7TXznnfd+XhNSaCzUrunYcm36OlagR3IJ1dNarLnGsIGsoq/7FG/FCetw
	 j+HOMAH5/1q4RgX1yyjE2C9vH76CtofXW4PAT2wIWT8AjJrCHMudpX8MaWGWGGGKPa
	 A01KTsF5lw4eg==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Sudeep Holla <sudeep.holla@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Will Deacon <will@kernel.org>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
 David Rhodes <david.rhodes@cirrus.com>,
 Richard Fitzgerald <rf@opensource.cirrus.com>, linux-sound@vger.kernel.org,
 patches@opensource.cirrus.com, Shenghao Ding <shenghao-ding@ti.com>,
 Kevin Lu <kevin-lu@ti.com>, Baojun Xu <baojun.xu@ti.com>,
 Sen Wang <sen@ti.com>
Subject:
 [PATCH v2 1/5] efi/dev-path-parser: Switch to use
 acpi_bus_get_primary_device()
Date: Wed, 30 Sep 2026 20:41:40 +0200
Message-ID: <3974502.kQq0lBPeGt@rafael.j.wysocki>
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




