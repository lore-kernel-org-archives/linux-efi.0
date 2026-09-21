Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166B93E00A6;
	Mon, 21 Sep 2026 19:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020748; cv=none; b=eV/ZM04cwZIVFhFW22woStrSuCD6jyg0Gcs1Iw8V/CyOVvJ60hkuvgOk41boJXMfi3IMTaTxpFMtvpgU8MZaMKVigytnRaIdEqxAC/OJZXA2dQr8S+CsF/5oSzCdNxnNEDaElDXxvYDC3d4WlyBdWubvU2JhCowN3aTFmGM1DiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020748; c=relaxed/simple;
	bh=dSl4ScKPF1XOp7cJfc/jXsaDcSkxjhT0Ieqx8OIFsoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ji4O6bjQgcjzUfwYW5l8LYH6YkQHjIZOWezd/l/RAHERYtyF54OCKtclmSl8yQw3aerWlGtTQiFhYb5+j4B9UZ1U/kd1owpHFA4Apbl6LyiTznMBjnHQMHA35lNiKVGVePHBFfx6zD8/95NbRDpO7KAeyVp/8ZOBB/H4jE2BTyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ICHHt2C0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ICHHt2C0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371B41F00898;
	Mon, 21 Sep 2026 19:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020746;
	bh=peND3u9iKMtv2zvMcDVYUpzbofbKohHRcq1jnaDFbnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICHHt2C0VmIDG9URopw9qksrwfUtfgRpDtLr+UrdDLrG0zqSgNRcj9CdJDNVRufIC
	 F3w8czv3WxRzXSCWLJ90f6yDOqd6OQiYhbq+EGOmgn03UX9fqv0buL2lF8CMp38Eyd
	 HsNH25u/jeQ+Q40aTaQxvkI8rrLrmdUfNy5JemcL/jgGHv7MxNDyWzvr9SXR4dbvKN
	 k8txKnaCLwKXHtCmXFSWZac9ur+5LIn4uVKC52SRzMv9JBWS0CCCuHcdk36xUZaTlh
	 of22+Al90cbHGAdRI5Gga3ob1lfLdNdmrMT4k2g3smLeHs8dc5Eirhfj+Bn9IB8i55
	 IBho6QPK9NEKQ==
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
 [PATCH v1 06/17] platform/x86: serdev_helpers: Switch to use
 acpi_bus_get_primary_device()
Date: Mon, 21 Sep 2026 21:49:07 +0200
Message-ID: <2720286.Lt9SDvczpP@rafael.j.wysocki>
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
 drivers/platform/x86/serdev_helpers.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/platform/x86/serdev_helpers.h b/drivers/platform/x86/serdev_helpers.h
index 57eac75805e2..20267e1941f1 100644
--- a/drivers/platform/x86/serdev_helpers.h
+++ b/drivers/platform/x86/serdev_helpers.h
@@ -74,8 +74,7 @@ get_serdev_controller(const char *serial_ctrl_hid,
 		return ERR_PTR(-ENODEV);
 	}
 
-	/* get_first_physical_node() returns a weak ref */
-	parent = get_device(acpi_get_first_physical_node(adev));
+	parent = acpi_bus_get_primary_device(adev);
 	acpi_dev_put(adev);
 	if (!parent) {
 		pr_err("error could not get %s/%s serial-ctrl physical node\n",
-- 
2.51.0




