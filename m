Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBDF2E7386;
	Wed, 30 Sep 2026 18:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793914; cv=none; b=dH3dqZK33iwZ6EpUn+lLgCWTIupomniC2EPxMjmQIT54pw6kQ2xbpYOgBl1hb7G/G2fDdTt1VG/wN8qdu0ZbeoQ1LD5cFB4HvDW55UtKpIjxIddROcZRxg+IJLW2OEy8O+gIt0G0pHGEIhrPiPr1kKGkgSb7ZqQHFG/9dO68MR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793914; c=relaxed/simple;
	bh=bxB1scayv8b4zz5zP1qNakxI8SCbU+g1DMqQRKDjTmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O6VC6e/54ImxCwVQpz2i6QfHqJBIhJ8ryyxSocKa0fQzxE90qRteSwmUsYh8bXaMUzhJLec7uSRub6ktvyDW9bRvPVvqhUiIs6CysyAnLCbSAlbwt0rrHRFN5Wswb4Vd8GWXXatYdu9VUXHJ220bZF/dVRAM9Nnt7g3PPu9MI4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W1oPMbDZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W1oPMbDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B73E1F00898;
	Wed, 30 Sep 2026 18:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790793913;
	bh=az8uo1MSqUUzA+uFMs11FJL351K6zE7Q4oadgfzKqQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1oPMbDZDb9X3TZvQnW9wpA+7P3OTh5oyRYCj0nYgsvRzds8UZIOUN7twv+Mp6LN7
	 oTNJM+Kk/F8odvVkjaF3gA8jkdxhQUxjpJRli8QHEXNK+fqUNy8MU2ih2fMaIe86+6
	 Rr4g3q64Vm4QU1NIT1M39hSbR7Wy/HCsGrs1YxSPP3kHZ26trjQ8pUvReERPEkThcI
	 vIIaNzZRCL0J/7jY0NqE7eN7Njxpf1S/qmB71J5AjVKEouBf+mtKGP53iSnQRJPZ3b
	 WdwEHlhFfzY+GWieOF6xABzlTsycghPfsrbOc3hql+K1XifVYK0zy63HkFmL+0q02q
	 l5oWVukBQOM+g==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Sudeep Holla <sudeep.holla@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Will Deacon <will@kernel.org>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
 David Rhodes <david.rhodes@cirrus.com>,
 Richard Fitzgerald <rf@opensource.cirrus.com>, linux-sound@vger.kernel.org,
 patches@opensource.cirrus.com, Shenghao Ding <shenghao-ding@ti.com>,
 Kevin Lu <kevin-lu@ti.com>, Baojun Xu <baojun.xu@ti.com>,
 Sen Wang <sen@ti.com>
Subject: [PATCH v2 5/5] ACPI: bus: Drop acpi_get_first_physical_node()
Date: Wed, 30 Sep 2026 20:45:01 +0200
Message-ID: <4537440.ejJDZkT8p0@rafael.j.wysocki>
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

Fold acpi_get_first_physical_node() into acpi_primary_dev_companion()
that is its only remaining caller and drop its signature from the
header file.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
---

v1 -> v2:
   * Add R-by from Sudeep

---
 drivers/acpi/bus.c   | 20 +++++---------------
 include/linux/acpi.h |  7 -------
 2 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 808c6746be14..cc6989d88645 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -809,24 +809,14 @@ struct device *acpi_bus_get_primary_device(struct acpi_device *adev)
 }
 EXPORT_SYMBOL_GPL(acpi_bus_get_primary_device);
 
-/**
- * acpi_get_first_physical_node - Find first physical node of an ACPI device
- * @adev:	ACPI device in question
- *
- * Return: First physical node of ACPI device @adev
- */
-struct device *acpi_get_first_physical_node(struct acpi_device *adev)
-{
-	guard(mutex)(&adev->physical_node_lock);
-
-	return primary_physical_device(adev);
-}
-EXPORT_SYMBOL_GPL(acpi_get_first_physical_node);
-
 static struct acpi_device *acpi_primary_dev_companion(struct acpi_device *adev,
 						      const struct device *dev)
 {
-	const struct device *phys_dev = acpi_get_first_physical_node(adev);
+	const struct device *phys_dev;
+
+	guard(mutex)(&adev->physical_node_lock);
+
+	phys_dev = primary_physical_device(adev);
 
 	return phys_dev && phys_dev == dev ? adev : NULL;
 }
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index ba5234bd93a2..6f69819f9c9a 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -105,8 +105,6 @@ static inline const char *acpi_dev_name(struct acpi_device *adev)
 	return dev_name(&adev->dev);
 }
 
-struct device *acpi_get_first_physical_node(struct acpi_device *adev);
-
 enum acpi_irq_model_id {
 	ACPI_IRQ_MODEL_PIC = 0,
 	ACPI_IRQ_MODEL_IOAPIC,
@@ -938,11 +936,6 @@ static inline const char *acpi_dev_name(struct acpi_device *adev)
 	return NULL;
 }
 
-static inline struct device *acpi_get_first_physical_node(struct acpi_device *adev)
-{
-	return NULL;
-}
-
 static inline void acpi_early_init(void) { }
 static inline void acpi_subsystem_init(void) { }
 
-- 
2.51.0




