Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69AA3B6C15;
	Mon, 15 Jun 2026 20:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781556235; cv=none; b=NVYzndRpDTaoz9vcooCKe2/hkseNP4lBg6+NYml9JZ16hQacJJubnmeX8DkChVuZXJQsR79bbDbKDO4QKt2gwV5Vqgd0UPG4fvklYE2HYyS9N2Fe7YIql3Q4DuVcab9WD4LJ3tepy4/UAZ8oe1J7jX2etk0Bbj1sW8zCxDQb+XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781556235; c=relaxed/simple;
	bh=faFwjoN0gn80v9QqMuh2mJ76DSKcg+KCmO8Za4zFEdQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iKakvP9p2OqT+bg94Kp5TeZfslm9ijLi9heIgQf7ThynyjkZv6MXWzKLSojUbYKFM8Ilev6eKNh12J8jESpr3iqwZHOxZCWJM4U9YbpVQuH8FauWtGifhU9Rc6kAl7tS1NWD8A5e6E32s0rfgvbJ8QtmTCvVqixaC3iCFMr8ZsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S9nA0vhD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9nA0vhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492711F000E9;
	Mon, 15 Jun 2026 20:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781556234;
	bh=pAr0CezAnYbjsc5uzKsTNhtjW8ESmPALnRPgKDluIbA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S9nA0vhDxdupgcHbwB2JLHzDQ2Foz/U+lEYay6SGXpc21k+gF9cSVbZFiGnLkDmyH
	 seRBOTTaN92A9/6ZDT6eDYu1wKhuDVok+mjhODT/ijI2tCNs38MRiJKw7xsVwWvLh5
	 6pW1z7ECVQBZKSADO9xjN/WqSSNb5gFeEgj1jj1xm742D+xJCkFc3sjeShnHg6dwDo
	 4sDxJLMnlENN71pyGTYkOTR9LiCcPUOuOPo9U3E3F9xR2xTRHNZuqosI0KepEKYVH5
	 B40niaAFhxysltgzI9N0LDzy489Y4Kdnle4jwCcK00OFBYSPnF1ysU/0lcq0j9OfQD
	 Rft/70AOqbmmw==
Message-ID: <1996618c-a6ab-497f-9c4e-33468e7802d4@kernel.org>
Date: Mon, 15 Jun 2026 22:43:51 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/19] parisc: define DPS root partition type UUID
To: Helge Deller <deller@gmx.de>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-parisc@vger.kernel.org
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
 <20260615-discoverable-root_partitions-v1-8-39c78fac42e2@kernel.org>
 <0158c89cffd76c621607f66d1889ccc084754729.camel@HansenPartnership.com>
 <0290e66b-1da2-4706-ab28-2d47f164df08@gmx.de>
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
In-Reply-To: <0290e66b-1da2-4706-ab28-2d47f164df08@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 15/06/2026 at 22:27, Helge Deller wrote:
> On 6/15/26 22:02, James Bottomley wrote:
>> On Mon, 2026-06-15 at 18:09 +0200, Vincent Mailhol wrote:
>>> DPS [1] assigns GPT partition type UUIDs to operating system
>>> partitions. Root partitions use architecture-specific type UUIDs so
>>> the OS can discover the intended root filesystem without relying on a
>>> root=  cmdline option.
>>>
>>> Define DPS_ROOT_PARTITION_TYPE_UUID in asm/dps_root.h for parisc and
>>> select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID.
> 
> Vincent, first of all thank you for at least trying to including parisc
> (and other
> niche Linux ports) in the specification! (whatever the outcome is!)

You are welcome. My personal interest is only x86_64 at the moment, but
at least I tried to make it useful to the broader community!

>>> [1] The Discoverable Partitions Specification (DPS)
>>> Link:
>>> https://uapi-group.org/specifications/specs/
>>> discoverable_partitions_specification/
>>
>> How are you planning to make this work for parisc?  Some systems have a
>> PALO boot partition (fdisk type 0xf0) but the more modern way is to
>> place palo inside a hidden ext4 inode in /boot.  The way parisc IODC
>> works is very similar to the way MSDOS boots with the palo location
>> table in the first block so I theorize that would probably work for gpt
>> partitions as well ... I'm just not sure anyone has tested it.
>>
>> However, to get this to work with PALO for auto discovery, you'd need
>> palo patches to recognize the DPS UUID and no-one seems to have
>> submitted anything to palo for this.
> 
> Maybe it's not necessary that palo does this job?
> palo could stay as is and load kernel and the initrd.
> Then the kernel (or the scripts in initrd) could try to find the root
> partition on it's own (and handle GPT discs).
> 
> I even once started porting grub to parisc (which is currently on hold
> because I'm busy with other stuff). If I ever finish it, having such a
> mechanism/constant already in place is IMHO beneficial.

You can see my answer to Alexander on the cover letter. This was an
oversight. parisc does not have CONFIG_EFI to begin with, so the feature
is just dead code there.

I will remove parisc (and all other architectures which do not have a
CONFIG_EFI) in v2. If someone wants to implement EFI support those
architectures, only then, we can revisit this DPS topic for these
architectures.


Yours sincerely,
Vincent Mailhol

