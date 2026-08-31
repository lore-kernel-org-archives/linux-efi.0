Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C02A3033F8
	for <linux-efi@vger.kernel.org>; Mon, 31 Aug 2026 13:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183168; cv=none; b=PY68zGs8AEHkTfShaT5StVZUTGLQJpdBXJlVOAS1j/K/4mh3YMtkTpIed0M7BTTWiMwR9Ddq2qSxDYvrYQ5UMunJdPkSoPOYfG3XWybr/SL7vVWz1XmrIFUUVQ7/1xzaY+MQIbyHBC+JGf1eUwpNWM5zdjY2JtYJzCXMM7EZF+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183168; c=relaxed/simple;
	bh=vxZm/tRDZyNZQcA5cU5ZQNQgkb9Y9quu5/0wsDyUHOg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WJNQMy8yxFGInwBSDpkIi6ih+wZUdma1Pl+w1/UvOmmCBjkr0Cl86ba74AzaVaVgLLjRVBbTLDwuki9SZ/3bZR9otXlZ50xciYVmIGvcD0paqMwj2BmZNYqCh/7yldhzzn23E10xNxpszXW0xXrOy/8f2QdQ0AIyvAWMsYOmnOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iKlXozt9; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iKlXozt9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788183167; x=1819719167;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=vxZm/tRDZyNZQcA5cU5ZQNQgkb9Y9quu5/0wsDyUHOg=;
  b=iKlXozt9l7MNeEUNW31Diw2sAXFStCC1LKKxbHL9eWd706NfXOYPGry5
   VGBNJKBYQT+RQ9Ta6IGGtqyAt+WIAFcmj+Cf3Qj0eQAEvbC/S0Et7hUk6
   CtOjCijI7xOUlSEEZU1ssPOzY2M+dHumF8wOu8BVlnDsyvxP9Z+wjOtu+
   eV8ITSLbWFhWUC+nWcCT0KblbYxwadJL8r+n7M26rRwxu73CXca6WL1Xu
   oha/N7RVr80jccHcEWoA0e9gFs2jVAninsAlarc/3KYuHyKTO9bTOUT+g
   gR459AYBG79xtvK/hTkntM33AsEi9X1B29Hh1mLk0F8JST8hhWOOzo/TP
   w==;
X-CSE-ConnectionGUID: IgsPstf0Qkep99mtgDhkdQ==
X-CSE-MsgGUID: jbMLZQSLQc6Xe9AtSSTyGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="99940758"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="99940758"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 06:32:47 -0700
X-CSE-ConnectionGUID: I9e9ZFCQS6K606NT3ndNZg==
X-CSE-MsgGUID: utGvlpgGTLaGxtI619LODQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="269389954"
Received: from abityuts-desk1.ger.corp.intel.com (HELO localhost) ([10.245.244.22])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 06:32:43 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Thomas Zimmermann <tzimmermann@suse.de>, javierm@redhat.com,
 ardb@kernel.org, ilias.apalodimas@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, simona@ffwll.ch,
 airlied@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH v2 1/3] firmware/sysfb: Remove rotation quirk for Lenovo
 D330
In-Reply-To: <88e53706-d237-46e3-afc3-deff5e372725@suse.de>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260831093020.494701-1-tzimmermann@suse.de>
 <20260831093020.494701-2-tzimmermann@suse.de>
 <5f8aceb5b36607877509995550d6dbbfad675ba7@intel.com>
 <88e53706-d237-46e3-afc3-deff5e372725@suse.de>
Date: Mon, 31 Aug 2026 16:32:39 +0300
Message-ID: <5211e49433f3483266bb10fce786fccd154f84b6@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Aug 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
> Am 31.08.26 um 14:49 schrieb Jani Nikula:
>> On Mon, 31 Aug 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
>>> The Lenovo D330 is a notebook with unmountable display. The display
>> Please elaborate on what you mean by "unmountable display".
>>
>> No comments on the patch itself, I just haven't heard that before.
>
> Sorry, that word doesn't exist; maybe "mountable".=C2=A0 I think "detacha=
ble"=20
> is the correct word.=C2=A0 The notebook's display can be removed from the=
=20
> keyboard to act like a tablet.

Ah, *lightbulb*. :)

Though arguably it's the keyboard that's detachable, as the display is
the main part that keeps working without the keyboard, not the other way
round.

BR,
Jani.


--=20
Jani Nikula, Intel
