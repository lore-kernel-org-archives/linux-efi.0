Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D563AE6F7;
	Mon, 15 Jun 2026 20:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781555952; cv=none; b=nyDmz4d7ag5PQROw4aGLu+XEPoYvPNvn+KqWiMsd+PUTq5yFoNbvQUKwGGt9rhe2j7Dx/HJfXn9g0XsC7uRcZuFxhXV6O7BtROCxLOw497jLdKe0u2vl4mlJ9btfKe4bwOj0qZ7RiQ9HNo6En3QRVirUTbLjlkRmMpPujrzz0c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781555952; c=relaxed/simple;
	bh=0JtCklaLGL7QD15IVn/Yl1ERNO17IxblN4L2EYLsAV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fnHo4sQ9Q5APpFmCSknI5yX+d/J72mYZMjQs+znUFZrcThcyN+zscunF0rSSSRahsa4r39N/JLsDIgQgmCH2EpmW/nJ2OEOQHUh5JmQfJ+bEmAbQr90ljkSiahbD2lPjh2vfOZ2G+sqpePH+KCY/ZhwBC072L+wgAVf8NYxXYfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lfkzhzUC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lfkzhzUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88DA1F000E9;
	Mon, 15 Jun 2026 20:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781555951;
	bh=8cBX8ViJcjjtQ+mUp4F9mfK8iMlxr9PtHmoBUj7imms=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lfkzhzUCPBDANxd7vlbZ4sfcZ6SPmg4OpSlbk42TpNeILIQylkfg080MOWSo4XPXO
	 bMpAEmFBAkVZOFDZRlo9JZdgsyNcWwvA/KDP4YYfS4nmWHPk/oc/Yh687LVBLvs8kd
	 CMUjpWZ0fIz1pvuQ4ZT7t+kttINmM62H8ovkBs0bXmbsiqLCx83LQr9atXa5J6CkRo
	 PVRRzwC5aut6DjhlRHjKyEhwJjBFfa1oAetG8F1GTeisQNLDy/K+ejrEjSsJnvdnp6
	 yR7CblkJ1gAN5uBrwPBnpupZPCJctnLs/jyDivFJ6TXo2kWJfMLYpI6viC3UKdpan/
	 eZ5hV+OiqosLA==
Message-ID: <cc9b7cd3-041c-461b-aa54-dba260433261@kernel.org>
Date: Mon, 15 Jun 2026 22:39:06 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/19] x86: define DPS root partition type UUIDs
To: Matthew Wilcox <willy@infradead.org>, Dave Hansen <dave.hansen@intel.com>
Cc: Vincent Mailhol <mailhol@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Davidlohr Bueso <dave@stgolabs.net>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
 <20260615-discoverable-root_partitions-v1-12-39c78fac42e2@kernel.org>
 <03be57ae-0e41-4b8a-adc5-bdd85ccce951@intel.com>
 <ajA-0YJW4gLr02c7@casper.infradead.org>
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
In-Reply-To: <ajA-0YJW4gLr02c7@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/06/2026 at 20:05, Matthew Wilcox wrote:
> On Mon, Jun 15, 2026 at 09:46:41AM -0700, Dave Hansen wrote:
>> There are a lot of ways to do this. I'm just not a super big fan of the
>> current proposal.
>>
>> So, boiling it down:
>>
>> 1. Should more than one UUID be supported per kernel build?
>> 2. Should the UUIDs be defined in arch code or generic code?
>> 3. Kconfig or #ifdefs?
> 
> Further questions ... why do this in the kernel?

Most of the plumbing was already there so that the feature is still
tiny. It seems like a reasonable trade-off to me.

> Seems perfectly suited to be in initramfs where we can throw away the
> code after boot.

The added code uses the __init attribute for this exact reason: so that
its memory can be reclaimed after.

-- 
Yours sincerely,
Vincent Mailhol

