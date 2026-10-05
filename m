Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB7D34EF1F;
	Mon,  5 Oct 2026 23:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791241438; cv=none; b=TzOg6zM8LWRzVxCZzSwAawns9DM7DtpZw2OXNGFqT3Z2MFtUVXR6rbLywbTOtB4G+GdZUjo28pFaGO/epjJd28v2SSI1ji0oayOlCHXf0xCO0d0VVDnAxuhJpghn2GSvwxZ3qYYV3/Xevm6fjip+0uSXh7tyySYP6G7dWWEGirw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791241438; c=relaxed/simple;
	bh=P6JQPlHoeafJGRYinVjy9w8WTTzF6bJg18Bvk4Fd1vQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MUQtcWKg4VV/+xiL0mPgX6WW3VamTn2N9qRJD5D/dFCMbPNa49tG5H0k5eMEDMdlTkkTYPbpXFYvewdGY4lLmpBfW2UL7j+DJu+YsfBvAA9oII7Xeqku5vz968V/d8lHe9ahj02tZg4gAD9BMAcmEY8zFlCIbLYJ9fkG+Uq6kJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=qOJnVq0f; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="qOJnVq0f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:Cc:To:From:Subject:
	MIME-Version:Date:Message-ID:From:Reply-To;
	bh=zUJ5Wg4hDTNRhIDxP93tWlP4XCV4f22ojxdYcCOKUDI=; b=qOJnVq0fAk9690E4Y+J8xQDk4C
	wHTkhnooMFjCLB2rcjuYLl6wPWvgQPmVhEV20SPd9G7xkz5ddTFnKASJ2IQ42wfjCdNbokhlC1FaN
	3JgPAa1njzOD7NwMIaG+LsasgaoV/I4rEQEG4u0lCru2lOVaTLCtvv9mc1v9JGXIowhHKQxBSRpA1
	12j6pZ7gAPDVjVUlQKF2XuoZQkTtkrkdCnasJjROAiRoN8SXjtgg284hpDeJtbx5JcGURPYMgEGYy
	Ut9cxcRikDPoxeKQA37plB1z7WBo/mIHeyh0E5qWL3ZQYatpAw/Mk3knmW/EyIy1rgbJW2BfoPUP1
	m0O7IGOg==;
Received: from [187.90.178.110] (helo=[192.168.15.93])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1xDrih-00C5aM-42; Tue, 06 Oct 2026 01:03:43 +0200
Message-ID: <9b44943a-fd07-ba56-b5b4-77777f64685f@igalia.com>
Date: Mon, 5 Oct 2026 20:03:37 -0300
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
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-hardening@vger.kernel.org,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Tony Luck <tony.luck@intel.com>, stable@vger.kernel.org,
 kernel-dev@igalia.com, kernel@gpiccoli.net
References: <20260906235838.2928815-1-gpiccoli@igalia.com>
 <273c9217-4630-4585-8cb5-3c5c8f0b77d3@app.fastmail.com>
 <cdd454e2-a311-71b5-2449-25cdfba893fd@igalia.com>
Content-Language: en-US
In-Reply-To: <cdd454e2-a311-71b5-2449-25cdfba893fd@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/09/2026 14:12, Guilherme G. Piccoli wrote:
> Hi Ard, thanks for your prompt response!
> 
> 
>>> [...]
>>>  	if (pstore_disable)
>>>  		return 0;
>>>
>>> +	if (efi_pstore_info.bufsize)
>>> +		return 0;
>>> +
>>
>> Can we please address the root cause rather than paper over it here?
>>
>> What is the point of having a) a pstore_disable= param on a module
>> (which can be blacklisted or simply not loaded) and b) having it
>> runtime writable so pstore-efi can be toggled on/off at will?
>>
> 
> Well ... despite we agree on that, I think removing pstore_disable is
> kinda breaking "the contract" we're following since long time ago.
> 
> The thing is: unlike ramoops, or even maybe pstore/blk and other
> potential backends, efi_pstore is a bit of a different beast IIUC.
> 
> It doesn't require any config, by having it loaded, it'll just go ahead
> and ...get enabled as pstore backend (unless pstore.backend sets otherwise).
> 
> And not only that: efi_pstore is **usually built-in** - I guess in all
> distros I've checked and by default config, it's built-in.
> 
> So, probably to avoid having to use {initcall,module}_blacklist
> (depending on the build type), I guess it was decided to have this
> parameter. The commit [0] that added that, >13y ago, mentions that since
> it was enabled by default and some EFI implementations had issues when
> filling its memory with oops logs, the option was to add such
> parameter+Kconfig to force disabling efi_pstore. Good decision or not,
> we should now live with that IMO.
> 
> 
>> Also, the practice of controlling the functionality of a builtin
>> diagnostic feature by poking something under /sys/module/foo/params
>> is in rather poor taste IMNSHO.
>>
> 
> Not only poor taste, I would say super counter-intuitive. But allowing
> the sysfs playing was added by myself, to enable users to change it
> without requiring a reboot, for a very cheap cost (well...not so cheap,
> since I added a bug and here am I now, trying to fix it heh).
> 
> If we require a reboot, we are in the same situation of kdump -
> crashkernel must be set on command-line and requires a reboot to
> properly reserve the memory. There is no technical reason for that in
> case of efi_pstore, at least, none I can see.
> 
> 
> So, with all that said, what is the path you suggest we follow?
> 
> a) This simple fix (or something similar)?
> 
> b) Drop entirely pstore_disable, risking a lot of users to just face
> breakages in their setups?
> 
> c) Other ideas?
> 


Hey Ard / Kees, gentle ping - how should / could we proceed here?

Apologies for the ping during LPC week, no hurries - just didn't want to
leave this bug without fixing waaay too much time heh


Cheers!
