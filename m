Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3B03E49CC;
	Mon, 21 Sep 2026 19:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020797; cv=none; b=jHbtYKK3PuhgIZprPjt8RQn9tMr+zH9aoZ21rgld60JvgOqObpEARIy3vqzdZhvK+zlu6NczUGl/piYRpA4dvlrK520omZFUQWwrRfD0kn9g47Jnx5i8n0moay+YAHqbZwqsW3MxEp+tIDNs6/NmDoBRaZm+qxBXFeo+h6RJ4F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020797; c=relaxed/simple;
	bh=CGHA5rc5ODXuYZRY15loSeHcZbTvCn5CiOcGdHJ9kwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tgKrHgr98+EJ6Xj85eP7V6BfCwrTgL7zj566wV//LVjAC7kPmAuqA4MYAMROTdIPn1D1fq4HA6QNCikQFjsTl6JRe1NVOaOIEMNqKOshbdIVJ+QJ2mN5U058iM54iD+liQXc3zrskwYdjXVjlLAW7f0n4/vYT7Juy40rnRa5uao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/QZ44Qo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/QZ44Qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7921F00893;
	Mon, 21 Sep 2026 19:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020792;
	bh=6UjZ3rrjP9HMf//Eca0cD5Hxt1wv6E9n3d8DQuHis1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e/QZ44QoHkWQu3p7iBCIv9/7xn/8Du5V/nI1YenLVuShu29wR4TbMO/TFCpNmUIfQ
	 sA/NDjrZJJBqUNm+6p4NmRZwdQ3552p9YJguqEBwAcbguFjmUKFsUCuvLDsDjkrtBW
	 5aP3kEn7oAeirKrSev65TnRdlMpFzbJiDHemXNlnoc8HYUVxHa3TOGTYFzoCs37Cvd
	 FYn3/bLwkN4RcAmPSXWeCctarbfkKqlDcwehqs+0coUMpmTtd4BZAylrC+y0pehGXM
	 FGUaBREvbn3E5lZn3jfvOvrZpzH0LCVNWt4HhB6npAdLHRzoq1+c61E9/3215+MUFX
	 WAa9B+8VFsrVw==
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
 [PATCH v1 02/17] ACPI: amba: Switch to use acpi_bus_get_primary_device()
Date: Mon, 21 Sep 2026 21:46:37 +0200
Message-ID: <3362405.5fSG56mABF@rafael.j.wysocki>
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
 drivers/acpi/arm64/amba.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/arm64/amba.c b/drivers/acpi/arm64/amba.c
index 1350083bce5f..7ee431d9464a 100644
--- a/drivers/acpi/arm64/amba.c
+++ b/drivers/acpi/arm64/amba.c
@@ -87,11 +87,12 @@ static int amba_handler_attach(struct acpi_device *adev,
 	 * the amba device we are about to create.
 	 */
 	if (parent)
-		dev->dev.parent = acpi_get_first_physical_node(parent);
+		dev->dev.parent = acpi_bus_get_primary_device(parent);
 
 	device_set_node(&dev->dev, acpi_fwnode_handle(adev));
 
 	ret = amba_device_add(dev, &iomem_resource);
+	put_device(dev->dev.parent);
 	if (ret) {
 		dev_err(&adev->dev, "%s(): amba_device_add() failed (%d)\n",
 		       __func__, ret);
-- 
2.51.0




