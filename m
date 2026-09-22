Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8E83C3F64;
	Tue, 22 Sep 2026 12:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081317; cv=none; b=gpKOK79vd/acaoxuBzBJuMc0YvFhudxGs8Z85eZpdcGISpmXLcHp/9qTOSOfp+NjICOtWzq3JKBEEWBf3OopYD1jnb11ZuvKvuQ3Ih+whKXceLnquyqtxACfkuI1JzRQd1Ppbqr/W5AciEzVs2pahWQkjF8HzGcjN/RJbjcCPf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081317; c=relaxed/simple;
	bh=qpF5www/qPUXSNZo2UHhbjLD5x+pblk2MWF/eef8p7I=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=azoQk3oGWinAO0AB7OKRFful7+ftCUZPqaOfZuhnY8piNkn0rnF8zNg9u6dWJCpXFqvaYwjvdPL3LuTmNc80j2WfNpbzeKvCo47786D+RRGE8RfXjicoc85xIUakNgF+rnhpoqdaGcpCOCG59Omi6xnYlb4DsPPhEyiYIz3DCUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ggRV/+t6; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ggRV/+t6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790081315; x=1821617315;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=qpF5www/qPUXSNZo2UHhbjLD5x+pblk2MWF/eef8p7I=;
  b=ggRV/+t6rkMcSi5yHn4cGG0U2Fon7SDCUFWO0eLQjBmP3h4j17DENuqq
   2IfALFjN2ZHnHpItjBh7hSpb1WuZI/kXFNbFMb0p5wcXDLlaGKGj5wDu1
   D2kTCcdsUOtxoUaYM/w1Tkfz0nls7kC+4ssUOj8XGPjInjwfM837nFPOL
   /1EYotmCXPC9lhfFxOe4QTorb5/kAlZt0sTAX4q3pMuJvGjJzu0rqGD4h
   6KLnyKHtOA2IBuXfv9RV/jcNIryeAaqHyW7TSkybxwrgK7Fd4q9FxCrkE
   T2mqR3Y0vcwnfxE0LbOb3WfYF2r0+DlzlP7dCHPSJJQWgmX+E0LHIeLBS
   A==;
X-CSE-ConnectionGUID: rRJf5XnETuSTdOb9egAF5A==
X-CSE-MsgGUID: AXvh3yyRSwiJkczHEbOSgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90796977"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="90796977"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 05:48:34 -0700
X-CSE-ConnectionGUID: I61J/lMPR6yWm2SobW9uzQ==
X-CSE-MsgGUID: Y5GxCWZmT3qY5hE+HY8CAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="301039531"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.80])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 05:48:21 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 22 Sep 2026 15:48:19 +0300 (EEST)
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
Subject: Re: [PATCH v1 06/17] platform/x86: serdev_helpers: Switch to use
 acpi_bus_get_primary_device()
In-Reply-To: <2720286.Lt9SDvczpP@rafael.j.wysocki>
Message-ID: <5fa97997-ae1f-0ff3-918c-e3195164c2ef@linux.intel.com>
References: <7995179.EvYhyI6sBW@rafael.j.wysocki> <2720286.Lt9SDvczpP@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1862122475-1790081299=:1233"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1862122475-1790081299=:1233
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
>  drivers/platform/x86/serdev_helpers.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/platform/x86/serdev_helpers.h b/drivers/platform/x86=
/serdev_helpers.h
> index 57eac75805e2..20267e1941f1 100644
> --- a/drivers/platform/x86/serdev_helpers.h
> +++ b/drivers/platform/x86/serdev_helpers.h
> @@ -74,8 +74,7 @@ get_serdev_controller(const char *serial_ctrl_hid,
>  =09=09return ERR_PTR(-ENODEV);
>  =09}
> =20
> -=09/* get_first_physical_node() returns a weak ref */
> -=09parent =3D get_device(acpi_get_first_physical_node(adev));
> +=09parent =3D acpi_bus_get_primary_device(adev);
>  =09acpi_dev_put(adev);
>  =09if (!parent) {
>  =09=09pr_err("error could not get %s/%s serial-ctrl physical node\n",
>=20

Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>

--=20
 i.

--8323328-1862122475-1790081299=:1233--
