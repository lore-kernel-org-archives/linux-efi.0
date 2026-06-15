Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603AA3CDBAB;
	Mon, 15 Jun 2026 16:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781542001; cv=none; b=q751C3sEmy/drgd6IRbkeuZAZrnbvb9LbtqjuMP169KUXR11aLfeHojzjlOyFIkBm2rtFGWH3x05zosYuNDrNOwSz1ik1tiZI1UFUvXcRKqLvPpw5QRP3uyyx9nBUdBloWV/nvmVPjh2J/7xr7+a8/zmY6Risy+ANrYKhPInPxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781542001; c=relaxed/simple;
	bh=Nv6PpL3Wmk91/Ljl3hTLaA87T0DrWiL+ju/yIdbueJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vnz7Hls/4fA8lHReTDAoQs1w+bwAmDey4QczPXhrvbUF4dvP2V9b6pNtDJiIRFfhhR5ISvi6z5R4C96HD9WyziYrm9Qiy/eK90mCApiJvtRdQYSBRS4+hh9wqG0lk7g5MnpOTx8HDt6q63QVaFCs6vA0qMWdfqEw3jOYdykzQgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mxeR8YGL; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mxeR8YGL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781542000; x=1813078000;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Nv6PpL3Wmk91/Ljl3hTLaA87T0DrWiL+ju/yIdbueJc=;
  b=mxeR8YGLniuQyXXOGp4oHqGuMPNRvta+YBP0i41M2t5fx+mCkTP9aYj0
   7+d/4zuiWBk+0OmPIYwxU1uLiF7aBDue6E2zeNozN/pzkzH34w1NnCLah
   jEqHLV7C0viEiOsX1L4FmMCnIxfsP5bEYfI3u+f/64tfnTIMXWPlEIBwn
   lHXrNlVz19/yH7t9LxMIH1d5EF+EFb8wgDspCtUXFHtixeG39fkr7lqU+
   87wy4ujdRXA5NLtbq66Ml+pQyX6U3SdI22tb2rf/by1fMEglVICeREqyh
   wToowRB1/yC6vAzhfSxUF0N7ZFqVzaLQDra91RHXWqbC3BVQqGrXTkrIc
   A==;
X-CSE-ConnectionGUID: Q4IWf3tbQbSR5vCnCj+0JQ==
X-CSE-MsgGUID: 2mHqQ/UqRtqMoYclSMeeXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="81303518"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="81303518"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 09:46:40 -0700
X-CSE-ConnectionGUID: KrhAIdYYSd29psL411RRxg==
X-CSE-MsgGUID: 5tK2djymRoyAPEr8zqR6PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="243354445"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.24]) ([10.125.111.24])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 09:46:39 -0700
Message-ID: <03be57ae-0e41-4b8a-adc5-bdd85ccce951@intel.com>
Date: Mon, 15 Jun 2026 09:46:41 -0700
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
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260615-discoverable-root_partitions-v1-12-39c78fac42e2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/15/26 09:09, Vincent Mailhol wrote:
> +#ifdef CONFIG_X86_64
> +#define DPS_ROOT_PARTITION_TYPE_UUID "4f68bce3-e8cd-4db1-96e7-fbcaf984b709"
> +#else
> +#define DPS_ROOT_PARTITION_TYPE_UUID "44479540-f297-41b2-9af7-d131d5f0458a"
> +#endif

This doesn't make a whole lot of sense to me. 64-bit kernels can run
32-bit userspace just fine.

But this #ifdef as proposed means that only a 32-bit *OR* 64-bit kernel
can auto-discover a given partition.

I kinda think you should just have an array of strings for these things,
maybe glued together with some preprocessor magic. Logically something
like this:

const char* const uuids[] = {
#ifdef CONFIG_ARM64
	"b921b045-1df0-41c3-af44-4c6f280d3fae"
#endif
#ifdef CONFIG_X86_64
	"4f68bce3-e8cd-4db1-96e7-fbcaf984b709",
#endif
#if defined(CONFIG_X86) && defined(CONFIG_COMPAT32)
	"44479540-f297-41b2-9af7-d131d5f0458a",
#endif
...
};

... and then search the array. I honestly don't think you need to
sprinkle UUIDs all over the architectures.

It could probably also be done almost entirely in Kconfig. This could be
in, say block/partitions/Kconfig, or arch/*/Kconfig:

config DPS_ROOT_PARTITION_TYPE_UUID_1
	string
        default "4f68bce3-e8cd-4db1-96e7-fbcaf984b709" if X86_64
	default "b921b045-1df0-41c3-af44-4c6f280d3fae" if ARM64
	...

config DPS_ROOT_PARTITION_TYPE_UUID_2
	string
        default "44479540-f297-41b2-9af7-..." if X86 && COMPAT_32

const char* const uuids[] = {
#ifdef CONFIG_DPS_ROOT_PARTITION_TYPE_UUID_1
	CONFIG_DPS_ROOT_PARTITION_TYPE_UUID_1
#endif
#ifdef CONFIG_DPS_ROOT_PARTITION_TYPE_UUID_2
	CONFIG_DPS_ROOT_PARTITION_TYPE_UUID_2
#endif
...
};

There are a lot of ways to do this. I'm just not a super big fan of the
current proposal.

So, boiling it down:

1. Should more than one UUID be supported per kernel build?
2. Should the UUIDs be defined in arch code or generic code?
3. Kconfig or #ifdefs?

