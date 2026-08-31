Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14C83A6B65
	for <linux-efi@vger.kernel.org>; Mon, 31 Aug 2026 12:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788180599; cv=none; b=nR6ZsnZ3TvqNXf+2L//LGNL8/UaACdAg/M9nJcO8vA4t0EDyXVWMrWfrfvsJ8aiVuw2R5MEXULpjb6UWuY9/Ge8UXLFu8x5S+KBwHHspvuSU0n4wAxTG41SBTNV8mFvdLrhE+YXBOmt2sFcPcN0YivHfSF+z7jpb75zBB+e+ciE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788180599; c=relaxed/simple;
	bh=ZocEU62Tp7CW5EHPQf17jxETiiTSZAvc7mJXXDvDRW8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SLzB3sTq8DkiUbVEZHFtb7np80MnYY1q2nDN3f9+oIdWTZcFZyrTRPGzMyLSADlDHNOMvYligP+op8prfhKbXvyVtfRD1/K0Jzbs9HIGQMS8k77cFZJQFDaQd/SG39h2+ue4XTRjXcLg5qdErLLLV1MCw+Y+pxpassoAPfa0F6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C5/N5U0B; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C5/N5U0B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788180593; x=1819716593;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=ZocEU62Tp7CW5EHPQf17jxETiiTSZAvc7mJXXDvDRW8=;
  b=C5/N5U0BbbSltiA4f+JNL4bWZzzj+Gcq0AOUglOgy2VUhvjqp/f+hoB3
   raRP4zk48RTMJBOO6oxzBpEaQIXOWRZ5+wZd3K6FOxZ+XzaGt4K4eomXe
   q9DbtUWc9paUrtfs1tdV4RrHjL4NVjfWq3WbS+AzWvvaW+hkXiuoQ4M0Z
   Foim1BNBSxXDWA2trSSOTgdiELD8Uy1tMk46do6e+CqMUcDbKbMGnrTEx
   3kujM80a44HdWUK73nXsV7Vik05c7TxRWmVRQLMhKmsDRRKbVOWzz8rte
   e5wDcgZTGC+m7NBuZn+DqpiaMfmnEddY0P8SU58AWZssBPLHu9FY6/odu
   g==;
X-CSE-ConnectionGUID: 6gSc9p96RTewhmBXBkhmIA==
X-CSE-MsgGUID: OlgC+BJ9SJ6FlnAOEDeJqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="92396725"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="92396725"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 05:49:50 -0700
X-CSE-ConnectionGUID: c0HA87LeQU+ClPH7jZ54MA==
X-CSE-MsgGUID: x1fqedx1ROevCmq0ZjLOIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="266203450"
Received: from abityuts-desk1.ger.corp.intel.com (HELO localhost) ([10.245.244.22])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 05:49:47 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, javierm@redhat.com,
 ardb@kernel.org, ilias.apalodimas@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH v2 1/3] firmware/sysfb: Remove rotation quirk for Lenovo
 D330
In-Reply-To: <20260831093020.494701-2-tzimmermann@suse.de>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260831093020.494701-1-tzimmermann@suse.de>
 <20260831093020.494701-2-tzimmermann@suse.de>
Date: Mon, 31 Aug 2026 15:49:44 +0300
Message-ID: <5f8aceb5b36607877509995550d6dbbfad675ba7@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Aug 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
> The Lenovo D330 is a notebook with unmountable display. The display

Please elaborate on what you mean by "unmountable display".

No comments on the patch itself, I just haven't heard that before.

> is installed in landscape orientation, but the display mode is in
> portrait orientation. By default, the display output is rotated to
> the left by 90=C2=B0.
>
> The sysfb quirk breaks the display by swapping display width and
> height; and thus mixing up the display geometry. Fix this by keeping
> the display as-is. The sysfb DRM drivers, usually efidrm, will pick
> the correct panel orientation for the display.
>
> Tested on a Lenovo D330-10IGM IdeaPad.
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/firmware/efi/sysfb_efi.c | 9 ---------
>  1 file changed, 9 deletions(-)
>
> diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysf=
b_efi.c
> index 685283bb7327..2338de73c62c 100644
> --- a/drivers/firmware/efi/sysfb_efi.c
> +++ b/drivers/firmware/efi/sysfb_efi.c
> @@ -301,15 +301,6 @@ static const struct dmi_system_id efifb_dmi_swap_wid=
th_height[] __initconst =3D {
>  		},
>  		.callback =3D efifb_swap_width_height,
>  	},
> -	{
> -		/* Lenovo D330 with 800x1280 or 1200x1920 portrait screen */
> -		.matches =3D {
> -			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> -			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
> -					"Lenovo ideapad D330-10IGM"),
> -		},
> -		.callback =3D efifb_swap_width_height,
> -	},
>  	{
>  		/*
>  		 * Lenovo IdeaPad Duet 3 10IGL5 and 10IGL5-LTE with

--=20
Jani Nikula, Intel
