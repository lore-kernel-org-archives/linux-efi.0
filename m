Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AC7332EA0;
	Wed,  9 Sep 2026 17:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788973943; cv=none; b=qcg8H2qiWJ1Z89t/2qf2QQfP+FezzRi0BD+Z3FVjgWc9p2vI0J6p8lE23miWJ6IoHQZMvXfHi3GAFme9oshsg6pl7OuZ0VJ1XtditcnuyATJ75uMnMM/dpUDXy902VTIJpuXK0Ga/E42UtzSgpsgcImsNkbr+CP7ckz7jxlI6YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788973943; c=relaxed/simple;
	bh=tkFm8ArrEWzeaieZuP5vpupn9vkxk9K5f19tdLq0x6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oTxbAnUOF84sHWvycMgOQ5ItnjKLa2l9LQqsbVPgyNlZf21Bcon4/klTm+nGjYskfvq/I00srQmnCdJmVMlKLeenABnV8kdvAUHqHmtAddQcAMbTLQkN5DxUQPQ+Ko0F2qu6dpGODbg9PcIg6QpDSBrtH3NdvLY/6e1rrhMJoZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=mRoldLWC; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="mRoldLWC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:From:Cc:To:Subject:
	MIME-Version:Date:Message-ID:From:Reply-To;
	bh=8XgErxDLDWlJhlMbKCkXJshZlMHhtU9PCEfmJxraKvk=; b=mRoldLWCiE+Lczs6o22SpBAC7s
	zbihh4qj+xqvm+CI70oQnXGdh7imAFsYLddNd0QC+I6JsS7aJrX7LG9UP5afYSyoh82fh6IU3B0sw
	/qOOsJOQPNxtPckLL3ccmi86TY1A8OAZ6iuDazFksryg/k7IEI03ipJHXNLT4uhivScVqRt5cWbys
	4UqiExJPOPOggxCUy/mZgJv19a0NO3I1fOuD9/1SGvvGK5bXZAC+eO1eELPJ4xCtxhEWeXwaBGOyE
	AKoGcmzwAr0GE7BrO00J01FAl9kdnt4TTqKZ1DjA8qPAwjv99szF2Xe0OLub5rGw0m5rwlStdnpeH
	5H1t+8Tg==;
Received: from [191.32.244.59] (helo=[192.168.1.56])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1x4LqF-00H9d9-Jm; Wed, 09 Sep 2026 19:12:11 +0200
Message-ID: <cdd454e2-a311-71b5-2449-25cdfba893fd@igalia.com>
Date: Wed, 9 Sep 2026 14:12:05 -0300
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] efi: pstore: Fix pstore_disable parameter setting (if
 built as module)
Content-Language: en-US
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-hardening@vger.kernel.org,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, Kees Cook <kees@kernel.org>,
 Tony Luck <tony.luck@intel.com>, stable@vger.kernel.org,
 kernel-dev@igalia.com, kernel@gpiccoli.net
References: <20260906235838.2928815-1-gpiccoli@igalia.com>
 <273c9217-4630-4585-8cb5-3c5c8f0b77d3@app.fastmail.com>
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <273c9217-4630-4585-8cb5-3c5c8f0b77d3@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ard, thanks for your prompt response!


>> [...]
>>  	if (pstore_disable)
>>  		return 0;
>>
>> +	if (efi_pstore_info.bufsize)
>> +		return 0;
>> +
> 
> Can we please address the root cause rather than paper over it here?
> 
> What is the point of having a) a pstore_disable= param on a module
> (which can be blacklisted or simply not loaded) and b) having it
> runtime writable so pstore-efi can be toggled on/off at will?
> 

Well ... despite we agree on that, I think removing pstore_disable is
kinda breaking "the contract" we're following since long time ago.

The thing is: unlike ramoops, or even maybe pstore/blk and other
potential backends, efi_pstore is a bit of a different beast IIUC.

It doesn't require any config, by having it loaded, it'll just go ahead
and ...get enabled as pstore backend (unless pstore.backend sets otherwise).

And not only that: efi_pstore is **usually built-in** - I guess in all
distros I've checked and by default config, it's built-in.

So, probably to avoid having to use {initcall,module}_blacklist
(depending on the build type), I guess it was decided to have this
parameter. The commit [0] that added that, >13y ago, mentions that since
it was enabled by default and some EFI implementations had issues when
filling its memory with oops logs, the option was to add such
parameter+Kconfig to force disabling efi_pstore. Good decision or not,
we should now live with that IMO.


> Also, the practice of controlling the functionality of a builtin
> diagnostic feature by poking something under /sys/module/foo/params
> is in rather poor taste IMNSHO.
> 

Not only poor taste, I would say super counter-intuitive. But allowing
the sysfs playing was added by myself, to enable users to change it
without requiring a reboot, for a very cheap cost (well...not so cheap,
since I added a bug and here am I now, trying to fix it heh).

If we require a reboot, we are in the same situation of kdump -
crashkernel must be set on command-line and requires a reboot to
properly reserve the memory. There is no technical reason for that in
case of efi_pstore, at least, none I can see.


So, with all that said, what is the path you suggest we follow?

a) This simple fix (or something similar)?

b) Drop entirely pstore_disable, risking a lot of users to just face
breakages in their setups?

c) Other ideas?


Appreciate your/others feedback, thanks in advance!
Cheers,

Guilherme


[0] ec0971ba5372 ("efivars: Add module parameter to disable use as a
pstore backend")
