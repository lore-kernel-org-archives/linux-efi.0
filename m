Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2230DF59;
	Tue, 16 Jun 2026 00:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781568599; cv=none; b=LwGdSdkjF5vXZcLjNM55x7xkPX0piUnp5e/2qkrvzmHVFUsHbMB9LPXHkc5ofsvQfVTtl9TC6C5eegK3cbkJUq8/p6RW/yO/hsx186J8hHfI5GjQzq3aaL1jofezdApds/aWY+63JJuFXWtjyaEI5DV26bX8ql/UOgO4+0YqLck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781568599; c=relaxed/simple;
	bh=t/kM7j8d0foldHsRhUKT2g6+r5v47tS8hckV+My2S7c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nwOle6mnTgWg7/EpW+5ihTsTCscLVzrGJ7hpNU7pFxUiWEbzKdHmlqgCftOGbXXOMJMM3EbyWKAHDre5jjDZZZTYBWza4Km2/Lt1JFswba05XiTkChcoQptWavH00zp7Fls/bAEKgIfJvbsHF59WBzvHqdHRzFIwRTT8O0o5j4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RNkAedHA; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RNkAedHA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781568598; x=1813104598;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t/kM7j8d0foldHsRhUKT2g6+r5v47tS8hckV+My2S7c=;
  b=RNkAedHAXpN2Sx0+8nFLXatYI3FZUwtXb5YkRCwvjq9/Td8a2QQFJRHP
   517P25fehRQNAqzxcWgxyH7pC/omoU3FZ0ra5fKC1gltq8a2OUc6MvNPx
   XJJAZXZna+292bx9Frxr9vobo9bjJPNpXS0Bb1T0+yNw0RZfsgAe3e0Aa
   alllcykGi0Va9kGJJyTTBNsv8qd/BXTRXQe58/+soFZ5p6iwKACxOT73l
   uKEY+XuRPvVBXBwJJ7WsWuzFSew6v/0wKQxCIsBYMlaL9ublVigKZ2lEZ
   S7bhgCk5U2LjXWaC5EV0BCUoyd1+psCp6yfoANWsjFBDcYWvVwU0VAx/d
   Q==;
X-CSE-ConnectionGUID: DxSgR9sjQFO9ugdA5i3tew==
X-CSE-MsgGUID: YhYtxBa7Ri+GXq8SHlJQqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="104992973"
X-IronPort-AV: E=Sophos;i="6.24,207,1774335600"; 
   d="scan'208";a="104992973"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 17:09:56 -0700
X-CSE-ConnectionGUID: uf8FQ6zNT++z6n9n/jceZw==
X-CSE-MsgGUID: 6aN6azQ4S8SjD3Yhv78Pgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,207,1774335600"; 
   d="scan'208";a="285727422"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.24]) ([10.125.111.24])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 17:09:55 -0700
Message-ID: <096515b9-26fd-4835-b713-0112025b9d27@intel.com>
Date: Mon, 15 Jun 2026 17:09:55 -0700
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/19] x86: define DPS root partition type UUIDs
To: Vincent Mailhol <mailhol@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Davidlohr Bueso <dave@stgolabs.net>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
 <20260615-discoverable-root_partitions-v1-12-39c78fac42e2@kernel.org>
 <03be57ae-0e41-4b8a-adc5-bdd85ccce951@intel.com>
 <ea71a433-fdcc-429d-adce-14e9fb726957@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <ea71a433-fdcc-429d-adce-14e9fb726957@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/15/26 13:19, Vincent Mailhol wrote:
...
> That said, your points make sense to me, and I would be supportive to
> allow a search for a secondary UUID as a kernel extension. If we do
> so, I think the only constraint should be to make sure that we check
> for the exact match first (e.g. check x86_64 type before x86_32 type).
> 
> Would that make sense?

Yep, that makes sense to me.

>> 2. Should the UUIDs be defined in arch code or generic code?
> 
> I think that you convinced me to put it in generic code.
> 
>> 3. Kconfig or #ifdefs?
> 
> I would say Kconfig. If we go for the exact match only, that would be:
> 
>   CONFIG_DPS_ROOT_PARTITION_TYPE_UUID
> 
> If we allow more as an extension, that would become:
> 
>   - CONFIG_DPS_ROOT_PARTITION_TYPE_UUID for the exact match
>   - CONFIG_DPS_ROOT_PARTITION_TYPE_UUID_SECONDARY for the compatible
>     one.
> 
> The drawback is that some entries will be in both:
> 
>   config DPS_ROOT_PARTITION_TYPE_UUID
>   	string
>   	  default "4f68bce3-e8cd-4db1-96e7-fbcaf984b709" if X86_64
>   	  default "44479540-f297-41b2-9af7-d131d5f0458a" if X86
> 
>   config DPS_ROOT_PARTITION_TYPE_UUID_SECONDARY
>   	string
>   	  default "44479540-f297-41b2-9af7-d131d5f0458a" if X86_64 && COMPAT_32
> 
> And I don't think we need more than two.

That's not ideal, but it's also a completely static thing that will get
written very, very rarely.

> A bonus question: should those Kconfig entries be hidden? I prefer the
> hidden option because it doesn't add that much code and I thought this
> was not worth bothering the user with one more menuconfig question.
> But I would be happy to change if people this this is worth an
> menuconfig entry.

Yeah, it should be hidden. Anybody that wants to change it for whatever
reason can edit the .config file or hack Kconfig.
