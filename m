Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185164248DC;
	Tue, 22 Sep 2026 12:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081240; cv=none; b=ZBuSV2r3gsEFOzs2epPGt+93qpIpWzij+Gfyd872kPhyMPGOOcwuWbcT+BFiaAz/8OjQzMwY/zVwVuDG7CimwBV4MJBwQcv1nf072DN6U6OoPn6B/3cUMCtE4DJfg+OgsV+a0ixDGfQ5dhcSRT9L6hERAHpq1Fn0OzqiqcHOYc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081240; c=relaxed/simple;
	bh=8ZKyqOu0mEmRU4MJJjqfKU5OT/hrxhKmNGxrkJ1omVE=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jTHODBDjbrTfN+qVeWhfHPHtTPKmSeObFYVu+C3PwUiBbR+S75bR+0I6qpzaWwTfkB1077Op+OzGZWejsbTM9cPH1kQAn+phVrAwBOfrxafuZfBFjRASlhAQRxh0eaM82YiVbQeE5s1r73G+qefImF7OdWBEA0CTuljSZ9kLa/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W8tUvca5; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W8tUvca5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790081238; x=1821617238;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=8ZKyqOu0mEmRU4MJJjqfKU5OT/hrxhKmNGxrkJ1omVE=;
  b=W8tUvca5PHakNVU8W3KdzzvE0tupjrBHcBYq7mWmCNvvzo2dZlTE+5ZE
   GE6IsywKUUP9K+YwIRfUU7qVELFGEHd/bkVvcWUzoqN1qmxTzafPTcbtu
   OZkUu5zYfywIp+Sp8IgFF+E4cF42/yeqQP+4FwMzeDseUF0y6VY9EXsUP
   /EfAQaJvRkp8IQ+/BudyKZObao6Yv+hte28+9qKD+zWydQVsEMzRI1eND
   p8pU5bO6BxsFhkzUCVg0fkxyuZ7a9hpPLz+/bAYXGi8BigZXPq5ad6Klm
   W4FBDVXx0TDjs6eHegtpalGJWsxZV3jQVfQodlSa7RD8WmGvNlllO+liG
   A==;
X-CSE-ConnectionGUID: CtV3F+JGRmOcwzbDpOboog==
X-CSE-MsgGUID: pc0tHu51RJqcmwNb4FXOXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="94509130"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="94509130"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 05:47:15 -0700
X-CSE-ConnectionGUID: ZNKd8pjLSDqm/Bu8+RVLxA==
X-CSE-MsgGUID: Y5imD72iRmm/cXg8yK2ddw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="272318929"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.80])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 05:47:02 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 22 Sep 2026 15:46:56 +0300 (EEST)
To: "Rafael J. Wysocki" <rafael@kernel.org>
cc: Linux ACPI <linux-acpi@vger.kernel.org>, 
    LKML <linux-kernel@vger.kernel.org>, 
    Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
    Mika Westerberg <mika.westerberg@linux.intel.com>, 
    Lorenzo Pieralisi <lpieralisi@kernel.org>, 
    Hanjun Guo <guohanjun@huawei.com>, Sudeep Holla <sudeep.holla@kernel.org>, 
    linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
    Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
    Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
    "Joerg Roedel (AMD)" <joro@8bytes.org>, 
    Mark Pearson <mpearson-lenovo@squebb.ca>, 
    "Derek J. Clark" <derekjohn.clark@gmail.com>, 
    Hans de Goede <hansg@kernel.org>, platform-driver-x86@vger.kernel.org, 
    David Rhodes <david.rhodes@cirrus.com>, 
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
    Mika Westerberg <westeri@kernel.org>, 
    Yehezkel Bernat <YehezkelShB@gmail.com>
Subject: Re: [PATCH v1 08/17] platform/x86: x86-android-tablets: Use
 acpi_bus_get_primary_device()
In-Reply-To: <3912360.MHq7AAxBmi@rafael.j.wysocki>
Message-ID: <b5e7637d-e189-6ac7-6e47-9f4a21aab2ca@linux.intel.com>
References: <7995179.EvYhyI6sBW@rafael.j.wysocki> <3912360.MHq7AAxBmi@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1698044991-1790081216=:1233"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1698044991-1790081216=:1233
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 21 Sep 2026, Rafael J. Wysocki wrote:

> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>=20
> Replace acpi_get_first_physical_node() that is slated for removal
> with acpi_bus_get_primary_device() that takes a reference to the
> device it is about to return.
>=20
> This addresses a potential use-after-free that may occur if the
> device returned by acpi_get_first_physical_node() is removed right
> after dropping its ACPI companion's physical_node_lock in that
> function.
>=20
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/platform/x86/x86-android-tablets/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/platform/x86/x86-android-tablets/core.c b/drivers/pl=
atform/x86/x86-android-tablets/core.c
> index cfff7f5eac5d..2c262f117235 100644
> --- a/drivers/platform/x86/x86-android-tablets/core.c
> +++ b/drivers/platform/x86/x86-android-tablets/core.c
> @@ -390,7 +390,6 @@ static int gpio_secondary_fwnode_init(struct device *=
parent,
>  {
>  =09const struct software_node *const *swnode;
>  =09struct fwnode_handle *fwnode;
> -=09struct device *phys_dev;
>  =09int ret;
> =20
>  =09if (!node_group)
> @@ -418,7 +417,8 @@ static int gpio_secondary_fwnode_init(struct device *=
parent,
>  =09=09if (WARN_ON(!fwnode))
>  =09=09=09return -ENOENT;
> =20
> -=09=09phys_dev =3D acpi_get_first_physical_node(to_acpi_device(dev));
> +=09=09struct device *phys_dev __free(put_device) =3D
> +=09=09=09=09acpi_bus_get_primary_device(to_acpi_device(dev));
>  =09=09if (!phys_dev)
>  =09=09=09return dev_err_probe(parent, -ENODEV,
>  =09=09=09=09=09     "No physical device for ACPI GPIO dev: %pfwP\n",
>=20

Seems to be based on the latest code,

Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>

--=20
 i.

--8323328-1698044991-1790081216=:1233--
