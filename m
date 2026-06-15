Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A8A1C84D0;
	Mon, 15 Jun 2026 20:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781555602; cv=none; b=n443sX1xPIpoZVt6SPAh37PyCCuFL/0F12zCj/eit4wkE2YvpjsSxPpFCuB/cNGxcL/QEuAlChpaTgHfwSHfK40HlIfz5QQAZ0+PUjW7FdNhiIoJ7vlQTnicnFYNCDmQrENJjIHdAVi/olelZtjS4FhKPoKtSM/F88Oy4jleP9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781555602; c=relaxed/simple;
	bh=9Z4Q+BvDBzDR3RYOg8ewj62G0BIToP4WyuMbIhRXeBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CjWc7Y5Kb9piihbqZB8q2IAmM9lNEbMw3NW/0uLTMKmRjYLda/Vd701CRA7QkcJ4qNJsnMhI+0QKtgN7WM1c60T0wVsN+KkGWqEd1yrGM97wyCdc+ay5SncCL7EYlTWhcX5ICatTza1SCg/pdSTrZ+2wdj1QTIEXDiBzxhdCoNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E86R2Mc0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E86R2Mc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89131F000E9;
	Mon, 15 Jun 2026 20:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781555601;
	bh=as7Ogfoc/AyskAy2+J9eXyhxUhgDui71XAx+CHT5Mew=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E86R2Mc0QLlmn6hDEj5MnafzRYyOh8VthGPhggOCVEqZ9xx+sywlJb7QXeIaMbEFA
	 rvREbsI3Zv0iMBuDfYoDef4TgGcmk0gnzth2mBKPpYT5zfQfxZKaETEbxVznMvRfoH
	 piXE10ylpTWfk/t+pECRYcy/iMGYN/iwRMhVbs6e5bPwfcEmSrgpliHOIWdD3C35KZ
	 3dd4XZnD7RANNMAcrkEHv2ZJgOVbQ7VfGmUoC1gB6jeJzKn1pSM0YTSpCEnNMVRUEO
	 3IE0flzeBTi4viwUUEYjyjwYKI+KhiEhnh6PLe1a+NU0sfU6WVODjevHGI2ZZiYcfX
	 AyBnvEPDADOhQ==
Message-ID: <131a450f-f9c6-464c-8e4e-a4c7a29fb5de@kernel.org>
Date: Mon, 15 Jun 2026 22:33:11 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/19] init: discoverable root partitions, a.k.a. an
 omittable "root=" cmdline option
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 linux-alpha@vger.kernel.org, Vineet Gupta <vgupta@kernel.org>,
 linux-snps-arc@lists.infradead.org, Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 loongarch@lists.linux.dev, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 linux-mips@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
 <20260615170432.GW2636677@ZenIV>
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
In-Reply-To: <20260615170432.GW2636677@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 15/06/2026 at 19:04, Al Viro wrote:
> On Mon, Jun 15, 2026 at 06:08:56PM +0200, Vincent Mailhol wrote:
> 
>> Tested with GRUB, which implements the LoaderDevicePartUUID EFI variable
>> in its bli module [3]. With this, I was able to boot a kernel with a
>> completely empty cmdline and no initrd.
>>
>> [1] The Discoverable Partitions Specification (DPS)
>> Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/
>>
>> [2] systemd-gpt-auto-generator
>> Link: https://www.freedesktop.org/software/systemd/man/latest/systemd-gpt-auto-generator.html
>>
>> [3] GRUB -- §16.2 bli
>> Link: https://www.gnu.org/software/grub/manual/grub/html_node/bli_005fmodule.html
> 
> So what does that thing, tied to EFI as it is, have to do with architectures where
> 	* firmware is rather unlike EFI

I made CONFIG_DPS_ROOT_AUTO_DISCOVERY depend on CONFIG_EFI for this reason.

> 	* firmware wouldn't know what to do with GPT
> 	* GRUB is *not* ported to, let alone used
> such as, say it, the very first one mentioned at your [1]?

Fair point. I just did:

  $ git grep "^config EFI$"
  arch/arm/Kconfig:config EFI
  arch/arm64/Kconfig:config EFI
  arch/loongarch/Kconfig:config EFI
  arch/riscv/Kconfig:config EFI
  arch/x86/Kconfig:config EFI

Anything not in this list is dead code at the moment.

> Or is that conditional upon "if anyone wants to design replacement firmware
> for those, and if they agree to follow our wishlist"?

No, it was just an oversight from my side. I will just keep arm, arm64,
loongarch, riscv and x86 in my v2.


Yours sincerely,
Vincent Mailhol

