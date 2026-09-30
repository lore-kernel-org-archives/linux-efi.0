Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E3C2D594F;
	Wed, 30 Sep 2026 18:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793950; cv=none; b=EDXm575BbbyQnBBW0654ByuF2PaAHx1XHCq1o3dUfRHC14NzVY6yA7CpdiBN9Dh749qdCHd2urCKnttaJB//rOJioDzuGIzELTizMrn/+6jMoNxmkgPBWV7isYCSBYG44SO++ZMfSnCiT97F9Lt1y37p6/AdbhCY51qjbwIheAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793950; c=relaxed/simple;
	bh=A0JPBR0s881r6trtCWy205TLQhYlWPl2dvgjIl1rtYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=diHh7nP+VkMJqXzc2ujWJ6JHfxE4xcKDznG/Zm7T8SxsvbyYRCUIvPwKCeKuKEwovW6Hfs6HWpnOxT9nhcYo/Z2QQ3Nwytuc4mrpA2LJaCaIIuZtQcvXfwfvyMt7SYrTbHolY74oPat25U/lsZsjJ2mB0+siNeEZmvuTYgVsbuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PlULGXTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PlULGXTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226471F000FF;
	Wed, 30 Sep 2026 18:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790793949;
	bh=yQ2QwwI3avoP25dNRmxG7as4Pv+Y98K9wMxhJYOR9uI=;
	h=From:To:Cc:Subject:Date;
	b=PlULGXTZQ54c7Llau1cooqhd/TDJU5GWQRZHrW5/l1Xg+n1C0XNSmkHNDfqO2o6Pl
	 ajbRmBp/1O1YIY5aYMAO1gc7BV+rXg8Dn68ELvIu+//u+iLRWJeG7z39CxfqONRG6H
	 6P9gAL/Yy16eg1AEIcagBc0W8+XBzbKCvBYhCjCVChcbWlNMZ9vgScrvNY7U8m81rt
	 eDFKSfanqNq7EXY5BpxWGuA9IiFkQ5Ywc+Y4gioXO/wVmrbhi4vvwavVUwqoQ5DE+a
	 LB2lHmipNEju52t63YAemWJoZv9VBR9GyrV5O+Q5ln/0nApK2QoNit6BaiXFSBogE3
	 HGROvZZmBLRcw==
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
Subject:
 [PATCH v2 0/5] ACPI: Replace acpi_get_first_physical_node() with
 acpi_bus_get_primary_device()
Date: Wed, 30 Sep 2026 20:30:47 +0200
Message-ID: <4766532.LvFx2qVVIh@rafael.j.wysocki>
Organization: Linux Kernel Development - Intel
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Hi All,

This is a partial resend of

https://lore.kernel.org/linux-acpi/7995179.EvYhyI6sBW@rafael.j.wysocki/

that only includes patches that have not been ACKed and the last one that
depends on all of the others.  It is based on linux-next.

This series replaces acpi_get_first_physical_node(), which is inherently racy
and therefore generally unsafe to use, with acpi_bus_get_primary_device(), that
doesn't have this problem, everywhere in the code.

I will appreciate ACKs from maintainers of the code updated by the patches, so
I can pick them up and get rid of the problematic interface in one go.

Thanks!



