Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793981924;
	b=WseFQynqctrV01jXrKWV/lQlmQsMquC5RiLrAJq0grXTiQMSr45dH+28dSGjDZ3kDsET
	 c+1uStuKLNMmO++bZOm05Yo5z7A523NRT5DuShiHY64fhU8xK5f8Bsuc4S1M3rrRXH12K
	 r/mG+jvadIf/tPCYEXHz483s9a/u5ubHNYs928n6Wv2tHDMNhkggW8k8y9V8EOqX7my80
	 cY8PwSKiOLOeL/i5aQuIvBIjwcHdvJMuaPGmzEMoyGTuM2I+wsjZ0cSsVXrjW7MEPmcmx
	 BLYbXn2oL/fBS1t+oCb6LpaLh/IMb9r1ptSZ16rciO6Xwy2J4EsZ0Bovbv0e3+y7kwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793981924;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:Content-Language:From:To:Cc:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=1/bSPx/dVDOqHfCRwF1YnWcS2LPjAxurHZJkqp6cuVk=;
	b=oPl6UKNbAa4ykWALOp21vZxnQX/XtG7pZXRkvveIwMRsJVoW9mN4KAWo/ODtvgeDHVid
	 oahpSXJZFxk+vN6uH8ffVKyIiKGEdb1Bp1jhti+/+BvjJW1kuax5+jOagL4pBRJg4IWnU
	 5xcuaFSPb7ZMSXDJw8GAZk5+g87i35R2hXgDiOz4sqF/6txTJPUd4JDSmOimVuMQDArAq
	 jk4fMr3rmHDRNRy4z/mIbkdDPQfkna5k5g4TlGpuBsCa+JgEmmVZpsgk0I8ZNA5eB6TO4
	 cxfpOYydT8zncJi4ZUhQSpKBL5REKP+cC7aa1IiCOCYNKYU2Ci+3olUysHKez7K79Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=XL6Kggvm;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2204C606A329;
	Fri,  6 Nov 2026 16:18:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2204C606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=XL6Kggvm
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:Cc:To:From:Subject:
	MIME-Version:Date:Message-ID:From:Reply-To;
	bh=1/bSPx/dVDOqHfCRwF1YnWcS2LPjAxurHZJkqp6cuVk=; t=1793981923; x=2109341923; 
	b=XL6KggvmlerWN6TFKXqqheHifHS3/iX804Njfa3/9Dulh+2cqzKhLxBDig0Fz4e7GyUndxO0mMq
	1CbBDwt2h6yPxRwFpA1tsyguGrDix0+P/wWC83uR1W8ggKfbZfC9ZiHXsiRxgWbdRtCTbezJmcdTa
	oOCLfE13fVXIHVnvhuepm0UveuQCULPQMuaozGfrM5YmAkYsWMqwf7hhtTvbjva+etoZ61htmlM9i
	EoA7XHaWCn649L+iOx4CvM+eB1oJPvsLpdi4J6h3YRCcLBIkdfizKQ1VHLhvH6bvGHjEfM8CA+ryX
	izR1urJGauYmcTZc0FICrZ7CsCkd35NnbU7g==;
Received: from [189.110.51.50] (helo=[192.168.15.3])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1xPMeD-004Zvm-S0; Fri, 06 Nov 2026 17:18:38 +0100
Message-ID: <2f3734de-1f6c-6820-1508-baa35dbc46db@igalia.com>
Date: Fri, 6 Nov 2026 13:18:34 -0300
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] efi: pstore: Fix pstore_disable parameter setting (if
 built as module)
Content-Language: en-US
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Tony Luck <tony.luck@intel.com>
Cc: linux-efi@vger.kernel.org, linux-hardening@vger.kernel.org,
 stable@vger.kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net
References: <20260906235838.2928815-1-gpiccoli@igalia.com>
 <273c9217-4630-4585-8cb5-3c5c8f0b77d3@app.fastmail.com>
 <cdd454e2-a311-71b5-2449-25cdfba893fd@igalia.com>
 <9b44943a-fd07-ba56-b5b4-77777f64685f@igalia.com>
In-Reply-To: <9b44943a-fd07-ba56-b5b4-77777f64685f@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/10/2026 20:03, Guilherme G. Piccoli wrote:
> [...]
>>> What is the point of having a) a pstore_disable= param on a module
>>> (which can be blacklisted or simply not loaded) and b) having it
>>> runtime writable so pstore-efi can be toggled on/off at will?
>>>
>>
>> Well ... despite we agree on that, I think removing pstore_disable is
>> kinda breaking "the contract" we're following since long time ago.
>>
>> The thing is: unlike ramoops, or even maybe pstore/blk and other
>> potential backends, efi_pstore is a bit of a different beast IIUC.
>>
>> It doesn't require any config, by having it loaded, it'll just go ahead
>> and ...get enabled as pstore backend (unless pstore.backend sets otherwise).
>>
>> And not only that: efi_pstore is **usually built-in** - I guess in all
>> distros I've checked and by default config, it's built-in.
>>
>> So, probably to avoid having to use {initcall,module}_blacklist
>> (depending on the build type), I guess it was decided to have this
>> parameter. The commit [0] that added that, >13y ago, mentions that since
>> it was enabled by default and some EFI implementations had issues when
>> filling its memory with oops logs, the option was to add such
>> parameter+Kconfig to force disabling efi_pstore. Good decision or not,
>> we should now live with that IMO.
>>
>>
>>> Also, the practice of controlling the functionality of a builtin
>>> diagnostic feature by poking something under /sys/module/foo/params
>>> is in rather poor taste IMNSHO.
>>>
>>
>> Not only poor taste, I would say super counter-intuitive. But allowing
>> the sysfs playing was added by myself, to enable users to change it
>> without requiring a reboot, for a very cheap cost (well...not so cheap,
>> since I added a bug and here am I now, trying to fix it heh).
>>
>> If we require a reboot, we are in the same situation of kdump -
>> crashkernel must be set on command-line and requires a reboot to
>> properly reserve the memory. There is no technical reason for that in
>> case of efi_pstore, at least, none I can see.
>>
>>
>> So, with all that said, what is the path you suggest we follow?
>>
>> a) This simple fix (or something similar)?
>>
>> b) Drop entirely pstore_disable, risking a lot of users to just face
>> breakages in their setups?
>>
>> c) Other ideas?
>>
> 
> 
> Hey Ard / Kees, gentle ping - how should / could we proceed here?
> 
> Apologies for the ping during LPC week, no hurries - just didn't want to
> leave this bug without fixing waaay too much time heh
> 

Hi folks, gently ping - anything I can do to unblock this fix?
Thanks in advance,


Guilherme
