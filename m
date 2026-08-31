Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49956439008
	for <linux-efi@vger.kernel.org>; Mon, 31 Aug 2026 13:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183375; cv=none; b=mQihb1etEEfiZFUVMfOZKK1K1aBCKS2Kj3TcI68k7YK8L69B3y7ricQ0H+knQj5LtdyJoMNcDJImkyjn+LffDzf2uBUKBdlPlC8WQO7XiUjtLn+o2110rDQuCNpQrUPargMSui6UhowSDpdQxMX9LFq1wHzzN5GhslrrxGIoeD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183375; c=relaxed/simple;
	bh=zZM95wC5xa3y/ynEioVC9ujjbxihojs8MB7oUzWpMJg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=q36MkM6d1RoTQlavNMrC+UKbvESSISljYnveyAXkP4zzfl96TfZQvKyH0bv7uXIPmhtEja9yJYAu83NfSPoN+ThkTwaoFiVhNh+/Vvt0y7Eacjjt0bg/+1QO7n3jsjkhUtWobwQn6vZ7SVvXZxIl3vs/mjLJ5pMAXrr5H4/2b5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mPyfRjG0; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mPyfRjG0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788183374; x=1819719374;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=zZM95wC5xa3y/ynEioVC9ujjbxihojs8MB7oUzWpMJg=;
  b=mPyfRjG0GOimpadRaSGN3RQRUdaN7t2atBejul3jQI+0qJ9Sv/4UpiaS
   9utAMiJYxNSCP7MdKFgvHDrbMGcaZ8N2PzcJ2ddiYkrD0b1g8eh4bTTns
   dO2h0lEEQeQGJcYT6OO9tB+dC3uEHZrjp7nnviFMpoTMpZIEIwZKjaznK
   A8rOaKGxzo7ubOeOzPA1RS5EAuZMir9QqbK22iij9zN0aLuC2BO7Q/tGy
   A0eZIatzwy/jtZx915SzQvBzNjq+1Ov3ECoHMWKe7L8yaBYs0fuOb+Wff
   34zpnYaaG+JKniK5javKaGp5zMHbQ9XaWn3vTTaevhixh3WDEX462G0na
   g==;
X-CSE-ConnectionGUID: DtCwrVrwSPWBKuOL2q6Xhg==
X-CSE-MsgGUID: GirNIQHsQY+klJKKHXWx8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="88601936"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="88601936"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 06:36:13 -0700
X-CSE-ConnectionGUID: zKscVdwFREaMaNs/TX5SHg==
X-CSE-MsgGUID: PjGE/sbmRtS8CF8mVpGbvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="268839312"
Received: from abityuts-desk1.ger.corp.intel.com (HELO localhost) ([10.245.244.22])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 06:36:10 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, javierm@redhat.com,
 ardb@kernel.org, ilias.apalodimas@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH v2 2/3] drm/edid: Add drm_edid_get_preferred_size()
In-Reply-To: <4645113d-3b31-4d92-b392-5d5284225211@suse.de>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260831093020.494701-1-tzimmermann@suse.de>
 <20260831093020.494701-3-tzimmermann@suse.de>
 <f5f1ab9e6fab9499e49f116369858ee4da626025@intel.com>
 <4645113d-3b31-4d92-b392-5d5284225211@suse.de>
Date: Mon, 31 Aug 2026 16:36:07 +0300
Message-ID: <5126b708b6e77b6bb15a355f858fcd54b732f653@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Aug 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
> Absolutely.=C2=A0 The only reason I added this helper is that the driver=
=20
> needs the size for setting up the display pipeline before the connector=20
> exists. I looked into using the existing code without the connector, but=
=20
> that refactoring seemed to do more harm than good. Hence the new helper.

Heh, I looked into that too while reviewing, and agreed.

> Should the new function be named drm_edid_detect_panel_size() to signal=20
> the use case?

Surprisingly, no strong feelings either way, both work for me.


BR,
Jani.


--=20
Jani Nikula, Intel
