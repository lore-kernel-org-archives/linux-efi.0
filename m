Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B654052D1;
	Mon, 21 Sep 2026 19:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020759; cv=none; b=Z8eaBT41N1GQndpujSO3CRYQdLO/5ixT5jSr4PJbaHKUL86Q5Wb8pEcqRwADPZl1tEspU45SwOpt7n+EUWaAAC+jn5dqbzsEiVmtz4UCNdiTjf/oEn1GjR63uBMwry7LV+HOq/8qvLLvBLyICwS51d4DR9MB4VH2q2/KXGoc5vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020759; c=relaxed/simple;
	bh=xjv9gw19jajbPTwOCvMFsEvootNb3/SGqtxLJD462n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fE2gnOJdJ3ea3PzUbV4zeRl/pIYR7xwRuueOWpEqa+5zZhLGhTvfc/gJVnp0CnjOnTEbLOPUmemtfoaCe1C9RV1bMqjc8qGF4lLoEbLBU4rdA6v8noRZUVNhyq93NpDDMerewAjZJdo3fDdmwe6t/flXK6U3nLbFDgKjYrbQ5Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJMUchJq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJMUchJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1FE1F00893;
	Mon, 21 Sep 2026 19:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020758;
	bh=OJ0j+leg3y+Dpt5s4ny9DBNrD2A1KCj7Cpe/XpV27PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJMUchJq4XPhBwwniY+m7JZkvTDeHbUY5uyTkX0G05IqLNA6EH3+lQHO0F3undOJe
	 Em9rOFh9y54stRVtWOT9ltk7rw4wzV5ISTEuKXzmn1+B53EUPrGDanCqq+wc3EY7C4
	 JSiBlogkHgPTiFOFSqFOUxrtQIxXt9Hop5CyFNS8/BJgDIlp5TUHIKYQY2BuOiA6hc
	 XwpOSpzVpr2LaJjGR7MSoMH4SpOYbaoCPdtbSvIv69G5xETyO/2hJaVv8rul5kt74O
	 v/UKkHf0XTi+FrYAvK9+UHlUO6QImrQmOaU0XspiAZGlafld7GrXFInYxK88sSND0H
	 d8kukbBC/zKGg==
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
 [PATCH v1 05/17] platform/x86: yogabook: Switch to use
 acpi_bus_get_primary_device()
Date: Mon, 21 Sep 2026 21:48:30 +0200
Message-ID: <1973238.CQOukoFCf9@rafael.j.wysocki>
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
 drivers/platform/x86/lenovo/yogabook.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/lenovo/yogabook.c b/drivers/platform/x86/lenovo/yogabook.c
index 1a4b2ab1f35d..8a91d440724b 100644
--- a/drivers/platform/x86/lenovo/yogabook.c
+++ b/drivers/platform/x86/lenovo/yogabook.c
@@ -353,13 +353,13 @@ static int yogabook_wmi_probe(struct wmi_device *wdev, const void *context)
 		goto error_put_devs;
 	}
 
-	data->kbd_dev = get_device(acpi_get_first_physical_node(data->kbd_adev));
+	data->kbd_dev = acpi_bus_get_primary_device(data->kbd_adev);
 	if (!data->kbd_dev || !data->kbd_dev->driver) {
 		r = -EPROBE_DEFER;
 		goto error_put_devs;
 	}
 
-	data->dig_dev = get_device(acpi_get_first_physical_node(data->dig_adev));
+	data->dig_dev = acpi_bus_get_primary_device(data->dig_adev);
 	if (!data->dig_dev || !data->dig_dev->driver) {
 		r = -EPROBE_DEFER;
 		goto error_put_devs;
-- 
2.51.0




