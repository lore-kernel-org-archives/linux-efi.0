Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825524734EB;
	Fri,  2 Oct 2026 09:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790933838; cv=none; b=uQ/Ftyc+6VeGoxEkE/lTOQbwXN7ywY205xTyIJg9QKnXGG3/FN1rFltAk+aJxmszerSQKz/b5gFjbuWQUB0sI3p9UZ5b7RO7sOYzrE4yLt3lbQtnpgRxZnYYrcVO2DAIhECa/urJ7n4zbgCBIcrzFKps81ZmH6uY1sY/1c2V9/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790933838; c=relaxed/simple;
	bh=vkAnse3lUenZrbluf+TC/dwnO7fgQNXovdcKA+wUiQk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fQljbHsKZyjgaIhBj/E+mGih7Psk6qEsNZbSxv1+tzivNGJeRlbuLxH9D3cTS9UWgVO0egyXURT/70EsD05TXDlte8chnR250d8VNz/ncFwA/FH1pf4UTD+jIgOK4+yLks9owfzqh2TF5eebniw6riWDXBvG4JA6PpM2Zpfy/mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K6rk7NZV; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K6rk7NZV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790933836; x=1822469836;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=vkAnse3lUenZrbluf+TC/dwnO7fgQNXovdcKA+wUiQk=;
  b=K6rk7NZVPWVc3ivjD6cOB9IeKWKLSNDpPHSLmSNGGIJ769xjHRlKHGYE
   Jg2AsXx6dpLh4PRss/SLcS2f2d0TMdD6JvDp40P8pY9qCaXnOLZJFpyN0
   bBPnaRNw+LEeiWwXgvJR1Ig2SYv3WctYYFX0z0pth14l/ECXKXkTmcJZf
   jeag3UkdcylPpYmTD6zRHdEYk+IeKGn6jHSgsOlxKhIQ5q7cE1WCsqdUm
   wxappFRBgSvrjVzb/RSlR2JIjyDGCw4L+nGQTUq2VgnSgcAnYwpSgAvjw
   fYyTOZwbla6lTKEzC8R0Oa2h2AKyqknnLIYM3T/5v95INXMuQy0zXkrLR
   w==;
X-CSE-ConnectionGUID: 381VHtr9TFKYUed5YyXyyw==
X-CSE-MsgGUID: 6U0HTMkxTOejXNQ6ZCGF1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90729748"
X-IronPort-AV: E=Sophos;i="6.27,136,1787036400"; 
   d="scan'208";a="90729748"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2026 02:37:16 -0700
X-CSE-ConnectionGUID: g685PMKrQRORckEJrD+6Vg==
X-CSE-MsgGUID: petXPvW8S/y8A57wLp05cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,136,1787036400"; 
   d="scan'208";a="276267967"
Received: from slindbla-desk.ger.corp.intel.com (HELO localhost) ([10.245.244.196])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2026 02:37:10 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: =?utf-8?Q?M=C3=A0xim?= Pedraza Padilla <maximpedraza@gmail.com>, Maarten
 Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Rob Herring <robh@kernel.org>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Ard
 Biesheuvel <ardb@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: Francesco Valla <francesco@valla.it>, Mario Limonciello
 <mario.limonciello@amd.com>, Javier Martinez Canillas
 <javierm@redhat.com>, Jocelyn Falempe <jfalempe@redhat.com>, Sam Ravnborg
 <sam@ravnborg.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, Shuah
 Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v4 02/13] efi: bgrt: export the BGRT table and image
 size
In-Reply-To: <20261001195847.141192-3-maximpedraza@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20261001195847.141192-1-maximpedraza@gmail.com>
 <20261001195847.141192-3-maximpedraza@gmail.com>
Date: Fri, 02 Oct 2026 12:37:07 +0300
Message-ID: <5c92c6f27b0778124d2365603374f70bd9b69b8d@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 01 Oct 2026, M=C3=A0xim Pedraza Padilla <maximpedraza@gmail.com> wr=
ote:
> The DRM splash client reads the boot graphics the firmware left behind
> through bgrt_tab and bgrt_image_size. Built as part of drm_client_lib,
> which can be a module, it then fails to link:
>
>   ERROR: modpost: drivers/gpu/drm/clients/drm_client_lib.ko: symbol 'bgrt=
_tab' undefined!
>   ERROR: modpost: drivers/gpu/drm/clients/drm_client_lib.ko: symbol 'bgrt=
_image_size' undefined!
>
> Export both. They are filled in once, early in boot, and only read
> after that.
>
> Reported-by: Mario Limonciello <mario.limonciello@amd.com>
> Closes: https://lore.kernel.org/dri-devel/5d7067de-97b7-4232-9cf6-e4b9786=
96482@amd.com/
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: M=C3=A0xim Pedraza Padilla <maximpedraza@gmail.com>
> ---
>  drivers/firmware/efi/efi-bgrt.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-b=
grt.c
> index 1da451582812..746a8fb3a337 100644
> --- a/drivers/firmware/efi/efi-bgrt.c
> +++ b/drivers/firmware/efi/efi-bgrt.c
> @@ -17,7 +17,10 @@
>  #include <linux/efi-bgrt.h>
>=20=20
>  struct acpi_table_bgrt bgrt_tab;
> +EXPORT_SYMBOL_GPL(bgrt_tab);
> +
>  size_t bgrt_image_size;
> +EXPORT_SYMBOL_GPL(bgrt_image_size);

Data is not an interface.

If these will be used more, perhaps it would be better to wrap access to
them in functions? I think most of the time it will help with
maintenance.

And you can add stubs for CONFIG_ACPI_BGRT=3Dn where they belong,
i.e. include/linux/efi-bgrt.h instead of drm_splash.c like in patch 11
of this series.


BR,
Jani.


>=20=20
>  struct bmp_header {
>  	u16 id;

--=20
Jani Nikula, Intel
