Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C64E3FD12A;
	Mon, 21 Sep 2026 19:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020737; cv=none; b=qD0qysIEkmfBwPZ4lDjho3GjBUWhNgDYhvfC/zgDpBjuadPDwM6LVJuYrjK8QIx7IC3YEVYIQk9WFWIb2Q/xSlpdBLrA9g8ZB574zACTKZLsbtld7sWJdVOYkPbTkAFLaaVWm50vTKTnvCPU1Akm0LhiDOEbtb7QCKCi9LHh+es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020737; c=relaxed/simple;
	bh=CWlZKNbHDY1AceyD+PPDOHUBLiTFamO8GbWKGjDAayU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cc5Wabju0z81OLY+Ai5n59dhuyoEm+lhkqL1a8YCYpM/TfsdAn9C2EJGTubcZaH4U1TdXbSvhIlX6WGo5U4Mvl+WsnbnB1yl1yt/tkkrPkBD0xqeq39C6wRzlN62GrVIlugRzcUHRsrRVVzWtKIy2BZ1yusxtvYdCE50yBWduJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cr8/jTPO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cr8/jTPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7791F000FF;
	Mon, 21 Sep 2026 19:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020735;
	bh=pggRQk8Zulvr6Cr863p0bNlrJVErb5Ls06+ht2GM3Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cr8/jTPO4ju29h7a6Bana2wcdvyB81E04rvfgbs3js4wDOpP2pD0Pyb5vUGE6iyv1
	 7N7Mf+BHtmNQ/dQc+jNyHpxnUhnBGT2YrCP/ZkEXPf/vvUytwBUZf4JpaYlXM/L22C
	 4sI5NBdRiav6nUzbdg7itH/5iLuc1F4ZoRx6qT4F+973/OG0uIKOIF6c+aSq1+v6xY
	 P7ii9/OlqTKUrsZ0cWncNQT0+tGZDO/rKffEAumSnameaPiYDr92z08CDd6ixae3yb
	 PudyK8w+Y/3kdtYKXa+VHHAioQFDjHZ07r5b5sAdWFFPj1Svk3lDFMLaXgucCC9H97
	 EowGMpegtaKCw==
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
 [PATCH v1 07/17] platform/x86: apple-gmux: Switch to use
 acpi_bus_get_primary_device()
Date: Mon, 21 Sep 2026 21:49:49 +0200
Message-ID: <2287208.Mh6RI2rZIc@rafael.j.wysocki>
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
 include/linux/apple-gmux.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/apple-gmux.h b/include/linux/apple-gmux.h
index 206d97ffda79..d7939c3a08fd 100644
--- a/include/linux/apple-gmux.h
+++ b/include/linux/apple-gmux.h
@@ -109,7 +109,7 @@ static inline bool apple_gmux_detect(struct pnp_dev *pnp_dev, enum apple_gmux_ty
 		if (!adev)
 			return false;
 
-		dev = get_device(acpi_get_first_physical_node(adev));
+		dev = acpi_bus_get_primary_device(adev);
 		acpi_dev_put(adev);
 		if (!dev)
 			return false;
-- 
2.51.0




