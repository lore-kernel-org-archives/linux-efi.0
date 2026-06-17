Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17243B71D1;
	Wed, 17 Jun 2026 20:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781729776; cv=none; b=TKEycs9WspM1qFGxQ8Dww2ckoKTtC9xcIME80Zw3UYefeMNqHdi0a3yyUul8vdVoF8zEx0kwLt4Ouejlj1MfslwLsJ7Ae5viB0ESkK+o/AoQMx71qUfBkHhCC725tpOYcEZ9Gt3+24g9hh7O+p3lThUYZxEVvjpPUGUjdWg+UsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781729776; c=relaxed/simple;
	bh=GUdIrNEWqIai7CCIg0CZjwnmvqMUo8fANAFyMnvTmo4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z7LXtRr6leDLz5XmsJ16ng7HWs9/lsxWNNfEmrSne0JF31TatkOT2qb+A+Fvyw0kvJHI47lmoMqIn2WMCy+uPVwbahhGs9zkdbkF+Smy7HMKwN7vp9f9ICQcSslViLYbFzjGzuU+TQoifr+a5UX7R1aOyIjJQ/1TAaBvN9QieuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+JgIxG8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+JgIxG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093671F000E9;
	Wed, 17 Jun 2026 20:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781729774;
	bh=A1dicipAfT1NcihzDB7nuXRVGuGocmFyEPV9zA3acUw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C+JgIxG8rwASDaFmpA6Zh29sHsXjVxomoiRH3OhPa889meEEW3u5FNT+dBtjSW/hw
	 D6sNaxoXruVEdJRs2TCBxuP28EcnIXSc5VAkaakRwBoxec3mO22QwXPEm1o8g68Ynd
	 8T8I2IgLVzXJB6nmke5oXdYS2A9totgcEQtmZtRlGO3HONE15zQQ/88bLpmm74eGQi
	 DWjnBfcuUlDaTgEjHaexYiGs3ETfD/34gnzgEP8hZqrBB2wyy4XzJUiGfxVPSxD1H2
	 c194yBAZig9SafF4ckJpaak40F8YXNFSE9LJCbVAb2fsNOLIPxGH8mSNw03gXnsF9u
	 w4PgjTaHOYmEg==
Message-ID: <01cc3ac9-c89e-491c-86ed-4c4c90809075@kernel.org>
Date: Wed, 17 Jun 2026 22:56:00 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/19] init: discoverable root partitions, a.k.a. an
 omittable "root=" cmdline option
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
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
 <20260617-irritation-rollen-wirst-7d636cbfec92@brauner>
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
In-Reply-To: <20260617-irritation-rollen-wirst-7d636cbfec92@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/06/2026 at 14:41, Christian Brauner wrote:
> On Mon, Jun 15, 2026 at 06:08:56PM +0200, Vincent Mailhol wrote:
>> DPS [1] defines GPT partition type UUIDs for OS partitions and
>> attributes that control whether such partitions should be
>> automatically discovered. The specification states that:
>>
>>   The OS can discover and mount the necessary file systems with a
>>   non-existent or incomplete /etc/fstab file and without the root=
>>   kernel command line option.
>>
>> DPS is already implemented in systemd-gpt-auto-generator [2], which,
>> when embedded in an initrd, indeed allows automatic detection of the
>> root filesystem through its partition type UUID.
>>
>> This series adds this discovery feature directly into the kernel so
>> that people who are not using systemd or not using an initrd can still
>> benefit from it. The implementation follows the same model as
>> systemd-gpt-auto-generator:
> 
> I happen to co-maintain the DPS. It is userspace policy and complex
> userspace policy at that and does not belong into the kernel.
> 
> This also implements a really tiny portion of the spec. It deals with a
> lot more complex concepts such as automatic partitioning during
> installation, verity, LUKS, containers. This is really not intended for
> the kernel at all. I mean, it's great that this spec is being used but I
> do not want this in the kernel just for the sake of auto-discovery.

The implementation of a tiny portion is voluntary. If I can draw a
parallel, it would be the same as saying that the root= cmdline option
is a tiny portion of what an fstab can do.

Yes it does not manage the LUKS, containers and so on, the same way it
is not possible to directly boot those things directly from the kernel.

So, I don't think this conflicts with the actual userland
implementations, the same way you can add root= to your command line and
still have an initrd next to it.

I did not intend to write this as a replacement but just as a complement
to fill the gap of kernel with no initrd.

> The DPS is completely generic and can be implemented by tooling other
> than systemd (util-linux implements it and so does refind iirc). I think
> not wanting to use or build alternative userspace tooling for this is a
> really weak argument for pushing this into the kernel.

Well, I might explain to you where I come from. Time to time, I mess up
my configuration. When this issue is in a userland config file (e.g. bad
fstab), the recovery is always easy.

But when I mess up the bootloader firmware configuration (e.g. grub,
u-boot, edk2), the fix is always painful. I have to fight with a shell
with which I am not familiar with to figure out what the correct
configuration is.

And an initrd would help but:

 - it is still one more file to look for pass as a parameter
 - on some machine I do not have one anyway

I think it would have been very neet to have a method to boot a kernel
with zero config (understand here: no cmdline, no initrd) and I find out
that DPS could achieve that if just a tiny part of it were implemented
in the kernel.

For example, in edk2, I would be able to just browse the disk from the
"Boot from file" menu and select a kernel. Currently it panics because
no configuration is attached. With DPS, we could have it boot linux from
that menu. All in a graphical interface, with just up/down arrows and
one enter keypress.

And this is my motivation. This non LUKS root read-only part of the DPS
is the only piece which makes sense for me in the kernel. Not that I
don't *want* to implement it in userland, but just that it doesn't
achieve what would be helpful to me (and I guess others).

I thought I wouldn't be the only one in the world to see value in that
this is why I posted it.


Yours sincerely,
Vincent Mailhol

