Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792943118;
	b=5UJVxHl7hYtKOWPCjTJIXr1XCPNP9kOYZ6jMIoXpwF1awVff7n33ZdnDio9AgEMDLofC
	 NyYLVYHaexivj09FZphH3z9M6h78dQhNuYWxY72jg/rNGqc0ajUv7Wy5OO/jKJteCaE7N
	 AHPv3fHo0XdV0JYazp6CKn4fPMPF9py3o4tnGZjWdfNyzyz0a7FIoYO8eOMWrQmuBf10I
	 J/+nXBApLlioWoi5alRaziP9UtsTgh4yNzFsVQInrRpu3VU6vfXmM+wx2VT14QE/H6Wq5
	 q2JXIVUPpltkOtn8QYlH3W/+X/TWfOF40NM6QghsmDMAloM6zF1rysRbYzdUJ/nEpzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792943118;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=sdpC63S8PW/vEWglTEPzIB9ynEUF8IZDAW2ZXW0eCxE=;
	b=1KVwIfl1qSfg66rVIdwJeulAU176MNB4lhN824id3FE8XqqsuA92829NZ0qGzLaozuiE
	 nYZHBlejxwGBPaG6SjblirU5FtjFFJSRo5tWrhcKvGDn4i5UIFbYgthPtbYJPA9AS/uTy
	 1173zQ+nNQg2A4QkGe/zUSXU3VWlMY4h8LCde4f00cncEgyWW+tOZEsHNq/1z1O+SGcZ5
	 K3NYJ2XoeOok/GsGi5/0VUWdRSxmJGuWlXxsXBEeRJuVUU4HuOw51HLSuvp1BbRCi9q3T
	 YPwB/QSQqD0AoC4J95ZcT+EU/94OWKx7iI5/bcAdMi9rDHhp3mcAP49BXPRXClfY35Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YgcnthxO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39678606A31A;
	Sun, 25 Oct 2026 15:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YgcnthxO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09EB1F01825;
	Sun, 25 Oct 2026 15:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792943116;
	bh=sdpC63S8PW/vEWglTEPzIB9ynEUF8IZDAW2ZXW0eCxE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YgcnthxO13YbsH1YdsB6vqM+B6cCn/xPjNgNRgNtW3i4Hv8iIu1tS1ognqDj/OV7M
	 opo4I4cvbPGG4+Bszwv8FOVBLcO1OWbdaYGhl2tFgWXX0QASQoCmLG249VuFDuuvCQ
	 2K0y4vz6uA6azMYj9M6LmXw0Ye/ZKYZlhrPmiXF3A7TP4R7/t9lXhk2YLvOw+O4nWP
	 W25KZ54fV0b1HUS4D/VjBhraGcyBQyZCKEEpNj/2HnnTCxWW9PHZBsz5nx2i9f1D7p
	 wnNz+VqZ2si4VgQ7PEWN6dQDh4bZBvdBVTDQUQhTMUV7fc+1GCFf3yEbOMpSsT/W2O
	 /7E3DcQKle1+A==
Message-ID: <a0306e3e-0f1d-4e11-8ca9-b2b6d5ad8854@kernel.org>
Date: Sun, 25 Oct 2026 16:45:12 +0100
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] init: add DPS root partition type UUID definitions
To: sashiko-reviews@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
 Davidlohr Bueso <dave@stgolabs.net>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>
Cc: linux-efi@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Matthew Wilcox <willy@infradead.org>
References: <20261025-discoverable-root_partitions-v2-0-fb77d0821fab@kernel.org>
 <20261025-discoverable-root_partitions-v2-2-fb77d0821fab@kernel.org>
 <sashiko-outbox-184220@kernel.org>
From: Vincent Mailhol <mailhol@kernel.org>
Content-Language: en-US
Autocrypt: addr=mailhol@kernel.org; keydata=
 xjMEZluomRYJKwYBBAHaRw8BAQdAf+/PnQvy9LCWNSJLbhc+AOUsR2cNVonvxhDk/KcW7FvN
 JFZpbmNlbnQgTWFpbGhvbCA8bWFpbGhvbEBrZXJuZWwub3JnPsKZBBMWCgBBAhsDBQsJCAcC
 AiICBhUKCQgLAgQWAgMBAh4HAheAFiEE7Y9wBXTmfyDldOjiq1/riG27mcIFAmrTM8wFCR1O
 HxcACgkQq1/riG27mcJ2KAEAhG19xBSkjiA9dtatvq2WJnGaes4SUmY+LSn7dh1Lf7YBAIwB
 lsMMmigMTk3Qgwymg1nT+Z8z1Owc/TGtRlo4ZcwMzjgEZx4y8xIKKwYBBAGXVQEFAQEHQJrb
 YZzu0JG5w8gxE6EtQe6LmxKMqP6EyR33sA+BR9pLAwEIB8J+BBgWCgAmAhsMFiEE7Y9wBXTm
 fyDldOjiq1/riG27mcIFAmrTNKcFCRUFdT0ACgkQq1/riG27mcLEVwD/VmnQtTf6yhowaIFj
 AjUtwiyQz9ja4NRu9GOvz/pb2L8A/3QcADR0dcxADGsmOiBpN2M9KI7nqdNIq3VPM/3/5fcB
In-Reply-To: <sashiko-outbox-184220@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 25/10/2026 at 14:13, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] init: DPS_ROOT_PARTITION_TYPE_UUID sets 64-bit UUID on 32-bit LOONGARCH
> --
> 
> commit 109ce0d2c6fc812a6bc94f72e97807013dc5fc56
> Author: Vincent Mailhol <mailhol@kernel.org>
> 
> init: add DPS root partition type UUID definitions
> 
> This commit adds the hidden DPS_ROOT_PARTITION_TYPE_UUID string Kconfig
> symbol populated with the Discoverable Partitions Specification root
> partition type UUIDs for EFI-supported architectures, along with the
> derived DPS_ROOT_AUTO_DISCOVERY boolean symbol.
> 
> Link: https://uapi-group.org/specifications/specs/discoverable_partitions_specification/
> 
>> diff --git a/init/Kconfig b/init/Kconfig
>> index b31aa298c4fe5..133854355697b 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -2166,6 +2166,20 @@ config ARCH_HAS_PREPARE_SYNC_CORE_CMD
>>  config ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
>>  	bool
>>  
>> +config DPS_ROOT_PARTITION_TYPE_UUID
>> +	depends on EFI && EFI_PARTITION
>> +	string
>> +	default "69dad710-2ce4-4e3c-b16c-21a1d49abed3" if ARM
>> +	default "b921b045-1df0-41c3-af44-4c6f280d3fae" if ARM64
>> +	default "77055800-792c-4f94-b39a-98c91b762bb6" if LOONGARCH
> 
> [Severity: Medium]
> Should the LOONGARCH default also depend on 64BIT, matching the RISCV &&
> 64BIT check on the next line?
> 
> The UUID 77055800-792c-4f94-b39a-98c91b762bb6 is defined by the
> Discoverable Partitions Specification specifically for 64-bit LoongArch
> (SD_GPT_ROOT_LOONGARCH64), and the specification does not define a root
> partition type UUID for 32-bit LoongArch.

I see. I overlooked the 32-bit LoongArch case because DPS only defines
partition type UUIDs for LoongArch64. I will add a 64BIT guard in v3:

	default "77055800-792c-4f94-b39a-98c91b762bb6" if LOONGARCH && 64BIT

I will wait for further review comments before posting v3.

> In arch/loongarch/Kconfig, config LOONGARCH unconditionally selects EFI and
> supports both 32-bit and 64-bit kernel builds (such as
> arch/loongarch/configs/loongson32_defconfig):
> 
> arch/loongarch/Kconfig:
> config LOONGARCH
>     ...
> 	select EFI
> 	select GENERIC_ATOMIC64 if 32BIT
>     ...
> config 32BIT
> 	bool "32-bit kernel"
> 
> config 64BIT
> 	bool "64-bit kernel"
> 
> When building a 32-bit LoongArch kernel (CONFIG_LOONGARCH=y, CONFIG_32BIT=y,
> CONFIG_EFI=y, and CONFIG_EFI_PARTITION=y), DPS_ROOT_PARTITION_TYPE_UUID gets
> populated with the 64-bit LoongArch UUID and DPS_ROOT_AUTO_DISCOVERY is
> enabled. Because a 32-bit LoongArch kernel sets elf_check_arch to
> elf32_check_arch in arch/loongarch/include/asm/elf.h and only loads
> ELFCLASS32 binaries, wouldn't early_lookup_dps_root() auto-discover and
> mount a 64-bit LoongArch root partition when root= is omitted, and then fail
> to execute its 64-bit userspace?


Yours sincerely,
Vincent Mailhol
