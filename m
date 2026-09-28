Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB46948A8C2;
	Mon, 28 Sep 2026 10:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790591254; cv=none; b=BSZBv6Hm2LTrRaw/DelcFMRq72DFTpM01swUTuIXJjAcobSxdFGJHqHCG+0br4/VFWXNw59GQNg9zO5RwxrMX59ljZx0XLIMF4+A37FRLEOip1PYm5V7CXZGDrpK2uAXqbL37PCQPCICxFEGXW+XLzjJD61JPJVA+pyEY75uAIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790591254; c=relaxed/simple;
	bh=QVR1P0y6tBOU7MA30g/VzPqDJvUjUfNZb/v6wwESHA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eiNDK5+AUCFeRreA3AOMyJWuaBMoiWQcxQMYc9McyA3a2q8zRFTyV7Nzssbp00Bv0rC4xjsCIBzNkG2YSw0vOBT8KuawCPgTWGsM3u5I498ij5ZyxfKRqG2HI8YsU1vNQCSGNvjUwjM3iVfDr7H8guW5IerHypyB16n4UGJpToY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OzqgRwAW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OzqgRwAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A661F000FF;
	Mon, 28 Sep 2026 10:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790591253;
	bh=TltTu2GayBcfZmAW/CasQEAr+MrcpVQ2RS6PHdIKOjE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OzqgRwAW2du0wry5dUBxZL9MehZUleJZMRlmpYlVPOoiM+XZovcKfb+l9d0ULqXhN
	 /evsjS2W/ZmZ5zewM9GSw2V76GYCu3GdsS3jJY/YTygNOaSdZgWuOs4jLYAR12fv74
	 hCPsFZxAp6CWzOlyfPJ/ct9VfBH9SiiODcj2abhbIhH3FWFT6tuj3OqeOQw4MwisZG
	 vTLnG/wwwIJ8B9owNvNarYH/mlAbg+Ki85wkyqMoirQn0Y5y8wJZGXFysM/x3GPn0g
	 zFXr3xk4S977/s1ZHRhet7memdb3QCRLN0k7otSVIhiwun/+mPw7WuF7EI2NO0++Dc
	 n/+ddCJkwxBtg==
Message-ID: <564b7a1a-7273-48a8-9015-92f0166eac79@kernel.org>
Date: Mon, 28 Sep 2026 12:27:29 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/10] x86/boot: Drop pointless re-implementation of
 panic()
To: Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
 Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-13-ardb+git@google.com>
 <20260909191410.GAaqGwAsCewrdVZZ0s@fat_crate.local>
 <cee2e02b-3817-44cf-857f-62a148290367@app.fastmail.com>
 <aqKrhNQ3mZMs5-Dy@thinkstation>
 <b24b9785-b790-476d-985d-e8c5405d192b@app.fastmail.com>
 <20260912061005.GDaqTsveevVkzxRJoI@fat_crate.local>
 <b259aff1-1fb1-4819-88ca-9b47dac036cd@app.fastmail.com>
 <20260912175410.GAaqWRwnz7bHUtXYSs@fat_crate.local>
 <862d50e1-2072-407b-882d-5e3074a3c225@app.fastmail.com>
 <20260913181105.GAaqbnOUDX2YNFW8iQ@fat_crate.local>
 <CAMZ6RqJCMt3zoDQ2iWXWJvxSifB0cV20FayX=yxoG30QdJ8aQA@mail.gmail.com>
 <08f0833e-12fb-4d74-9d0b-beda435f7e65@app.fastmail.com>
From: Vincent Mailhol <mailhol@kernel.org>
Content-Language: en-US
Autocrypt: addr=mailhol@kernel.org; keydata=
 xjMEZluomRYJKwYBBAHaRw8BAQdAf+/PnQvy9LCWNSJLbhc+AOUsR2cNVonvxhDk/KcW7FvN
 JFZpbmNlbnQgTWFpbGhvbCA8bWFpbGhvbEBrZXJuZWwub3JnPsKZBBMWCgBBFiEE7Y9wBXTm
 fyDldOjiq1/riG27mcIFAmdfB/kCGwMFCQp/CJcFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcC
 F4AACgkQq1/riG27mcKBHgEAygbvORJOfMHGlq5lQhZkDnaUXbpZhxirxkAHwTypHr4A/joI
 2wLjgTCm5I2Z3zB8hqJu+OeFPXZFWGTuk0e2wT4JzjgEZx4y8xIKKwYBBAGXVQEFAQEHQJrb
 YZzu0JG5w8gxE6EtQe6LmxKMqP6EyR33sA+BR9pLAwEIB8J+BBgWCgAmFiEE7Y9wBXTmfyDl
 dOjiq1/riG27mcIFAmceMvMCGwwFCQPCZwAACgkQq1/riG27mcJU7QEA+LmpFhfQ1aij/L8V
 zsZwr/S44HCzcz5+jkxnVVQ5LZ4BANOCpYEY+CYrld5XZvM8h2EntNnzxHHuhjfDOQ3MAkEK
In-Reply-To: <08f0833e-12fb-4d74-9d0b-beda435f7e65@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/09/2026 at 12:09, Ard Biesheuvel wrote:
> On Mon, 28 Sep 2026, at 11:44, Vincent Mailhol wrote:
>> Hi Borislav,
>>
>> On Sun. 13 Sept. 2026 at 20:11, Borislav Petkov <bp@alien8.de> wrote:
>>> On Sun, Sep 13, 2026 at 06:35:33PM +0200, Ard Biesheuvel wrote:
>>>> The reason I want to get rid of panic() is because snprintf() is going
>>>> to be removed from the EFI stub.
>>>
>>> Ok, I'll queue it into x86/boot and give you an immutable tag it doesn't look
>>> like something urgent to me.
>>
>> I had a look at tip/x86/boot but could not find this patch yet, nor an
>> immutable tag containing it.
>>
>> Just checking whether it is still queued on your side, thanks!
>>
>>
>> And, by the way:
>>
>> Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
>>
> 
> Thanks.
> 
> Latest is here:
> https://lore.kernel.org/linux-efi/20260925075137.44298-5-ardb@kernel.org/

Ha! I missed that new version. Thanks for the link. I will test it.


Yours sincerely,
Vincent Mailhol

