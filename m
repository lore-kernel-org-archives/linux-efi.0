Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46551391829
	for <linux-efi@vger.kernel.org>; Mon, 31 Aug 2026 16:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788195406; cv=none; b=qcYi6uw5js9N5Iw0siEpmtPvPjzrZ1tKGoaN72hf02ZmrIG/SsAz98XuMf+tQAArfKXfDe7a7xQkpU9R3UjNWrN5kyDZB7ExLNtGC0TPtZ19cZDGFByWpamLEYvBe7ZstJxNO0aqYMTcjhiJaYPp/wdi04aZWrImMcpwbyDL1Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788195406; c=relaxed/simple;
	bh=F+YjOfzFMf/cGJqzs1nRuvBR83gYIDUgBV6ieH5zoJQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KG5wEWacO1s4OcBPBBXTM9UlxJd8Am5MhgXIglpzlKuQxRd2ZfEM3xTwn1AAItvHH0jpZWlIgEBbzZxytdOWCcq4UzDk9WrL4juAnYfOaRv13lkZpNm5b3RLwRwX/yB9wR/3o0X4yDIKYBWrOzCmua+BQfdjjJTs5hpaV9RKbKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=im01zoch; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="im01zoch"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788195405; x=1819731405;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=F+YjOfzFMf/cGJqzs1nRuvBR83gYIDUgBV6ieH5zoJQ=;
  b=im01zochxGnKy0v40bVw0mPkD/z7hhp6F/OzxAlsH7PWTnSgx8Sn8wvV
   INiAyA+5vLGZilolcnKHzLP11lZWlLUEDkGdDHgY05+5P6d023d7Vjvqg
   txyln3RPEnbKtlYR1ImZWF+55s2KMaiwaXe8XI7DfGzDBA4s+SumQu3ez
   NMe55q4JafALqRHT/MmQs02lvEVke9HnKtiYjo3W4d61m7nVXzJIpRC6S
   htZIQMqERgC+XN1CG+rboTXNDVoJrZi/Qufz5wxKKIlXy1uFhcCZBCC9r
   JTDBWRqPTew6i0P7T69r9jVmlm222emBz8K0jNM3hgN1rGh6yjRE/dwDd
   g==;
X-CSE-ConnectionGUID: YX3EEpbLT5OYz5drRD0dow==
X-CSE-MsgGUID: zwpDLhmMRO6s2SAi+uUGOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="88631912"
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="88631912"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 09:56:44 -0700
X-CSE-ConnectionGUID: SSe1RcJ4TqeY9OtvJLfjPQ==
X-CSE-MsgGUID: 1DJb7QDxQHCB7ZRFExjuAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,254,1779174000"; 
   d="scan'208";a="292343217"
Received: from abityuts-desk1.ger.corp.intel.com (HELO localhost) ([10.245.244.22])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 09:56:40 -0700
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
Date: Mon, 31 Aug 2026 19:56:37 +0300
Message-ID: <ff8f369ace3f0cb322f2711b88b88b7b65063c6a@intel.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, 31 Aug 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
> Hi
>
> Am 31.08.26 um 15:13 schrieb Jani Nikula:
>> On Mon, 31 Aug 2026, Thomas Zimmermann <tzimmermann@suse.de> wrote:
>>> +
>>> +	/*
>>> +	 * Use display mode from the Preferred Timing Descriptor. For old
>>> +	 * and obscure displays, we might need better heuristics.
>>> +	 */
>>> +
>>> +	if (edid->revision < 4 && !(edid->features & DRM_EDID_FEATURE_PREFERRED_TIMING))
>> The preferred timing mode should always be there starting from EDID
>> 1.3. The bit doesn't indicate whether it's there or not. It should be
>> always set for EDID 1.3, and for EDID 1.4 it indicates whether the
>> preferred timing includes the native pixel format and the preferred
>> refresh rate.
>>
>> I think just if (edid->revision < 3) should be enough.
>
> Ok

I think I may have gotten this one wrong, and your original was correct.

I didn't double check what the EDID spec definition of pixel format is:
"Native Pixel Format is defined as the number of physical pixels along
the horizontal axis by the number of physical pixels along the vertical
axis of the display device."

i.e. exactly what you're looking for. Usually, I would not consider
"pixel format" to include resolution.

The preferred timing will still be there as I described, and I would
*guess* preferred most likely equals native, but your original is the
more cautious approach.

My bad, sorry for the noise.


BR,
Jani.


-- 
Jani Nikula, Intel
