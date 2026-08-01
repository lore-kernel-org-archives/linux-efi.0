Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E5E2BE05A;
	Sat,  1 Aug 2026 22:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785623009; cv=none; b=kBYmcAvYw5cRMPLbQh42BuVscV186DDo3/4nsOMLoKS6NQqZHoCo+VcdY6vOU6r+0l8qgzSI87NScfy1x6Dg1GnUx2++e4CbgFKctG/CGEw2lxeIX6wEJh1FzXJ06Dt1hubrBiaB2NdBDeKBFGROyr5ya1MnOhRjEkOsmerViPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785623009; c=relaxed/simple;
	bh=+b6ml37KHikMRBjn++jnwL+l5aXLxO2ITUAlQ6Jg+Hc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y7qumyLetx7QGxr8xv0oR5I8VgBOa90qQiDA5tAadgtK6AOYN4rYQOiU71P4MqAi+dRX/iXaEeobTiijm1Ok0/zEfl+6aM4xDtRYbPv7/DyC9uHVT5zqHW7tJsVDK6j9bGq3qZWCRYgR8P+g8iqIDdU0ZAhpJU1h70aCD2GXsF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aAHQnJ2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aAHQnJ2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1661F00AC4;
	Sat,  1 Aug 2026 22:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785623008;
	bh=4tGj03GAiv20y4kHdsiJOTseAiPDSpGYtxJwFTrA8iU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aAHQnJ2SBcHNSf5HZnE1qntBANlwNzw4OmGdwLoqzjTikoJtbTOfwmFMoXudz/Tp0
	 sech7kX57lZgliYvs7Ezr2fNPuSP9mJmdc0m1bS0H5S7RilnlB8U7GZQZ2BJiFRIe3
	 cQ5HPbo2xdMpoi2B4+qPiLIRv3nJFMqAJ+ZC+MqydDvkXuiJHHImfYdAptme125JzJ
	 nCyjtUTSkq8TK4tUDUDLI5G2bEETn/LPaAyqDyLtGpd/rHQMAvwokr28tAMp/okRjn
	 iGJtknq4+zdY3DnVxhCilqR0OWikbUQ50wI+7UYsJcaI20Brt9fPjr0u8jC2IgTmT1
	 FU+WV6gq/VyVQ==
Message-ID: <96dac58a-9f10-4bd5-ad7d-c238743b60e7@kernel.org>
Date: Sun, 2 Aug 2026 00:23:25 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: *** SPAM *** Re: [PATCH] efi/libstub: populate
 LoaderDevicePartUUID
To: Ard Biesheuvel <ardb@kernel.org>, Vincent Mailhol <mailhol@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
References: <20260725-efi_stub_bli-v1-1-966e4748077f@kernel.org>
 <0aad56b5-a650-49c6-a193-db65c4c4395e@app.fastmail.com>
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
In-Reply-To: <0aad56b5-a650-49c6-a193-db65c4c4395e@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 01/08/2026 at 15:47, Ard Biesheuvel wrote:
> Hi Vincent,
> 
> On Sat, 25 Jul 2026, at 01:11, Vincent Mailhol wrote:
>> The Boot Loader Interface [1] defines LoaderDevicePartUUID. That
>> variable contains the GPT partition UUID of the device path from which
>> the boot loader was loaded.
>>
>> This is used for example by systemd-gpt-auto-generator [2] to identify
>> the disk the boot loader was launched from and automatically detect and
>> mount partitions on it.
>>
>> GRUB populates it [3], but most EFI firmware implementations do not.
>> Because of that, the variable is missing when booting the kernel from
>> the EFI stub.
>>
>> Read the loaded image device path, extract the GUID signature from its
>> GPT HD() device path node and publish it as LoaderDevicePartUUID under
>> the Linux loader entry vendor GUID. Do not overwrite an existing
>> variable, so a boot loader supplied value keeps precedence.
>>
>> Use a volatile variable with boot-service and runtime access so the
>> value remains available to user space services such as systemd, without
>> persisting stale boot state across resets.
>>
>> Install the efi_bli_set_variables() hook in both the generic efi-stub.c
>> path and the x86-specific x86-stub.c path.
>>
>> [1] The Boot Loader Interface
>> Link: https://systemd.io/BOOT_LOADER_INTERFACE/
>>
>> [2] systemd-gpt-auto-generator
>> Link: 
>> https://www.freedesktop.org/software/systemd/man/latest/systemd-gpt-auto-generator.html
>>
>> [3] GRUB -- §16.2 bli
>> Link: 
>> https://www.gnu.org/software/grub/manual/grub/html_node/bli_005fmodule.html
>>
>> Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
>> ---
>> Here is a bit of extra context around this patch. I recently installed
>> coreboot on my machine with edk2 as the payload. After booting the
>> kernel directly from the EFI stub instead of booting it from GRUB, I
>> noticed that some partitions which were previously mounted automatically
>> were not mounted anymore.
>>
>> Upon investigation, I found that those partitions were mounted
>> automatically using DPS [4]. DPS needs the LoaderDevicePartUUID EFI
>> variable, which was set by GRUB but not by edk2.
>>
>> I first proposed a series to add that variable in edk2 [5]. The change
>> was not well received because BLI is perceived as too specific to Linux
>> systems. Upon reflection, I concluded that the kernel EFI stub is the
>> best location to implement it because it resolves the problem for EFI
>> firmware implementations in one place.
>>
> 
> So it is the bootloader that sets this variable, and you want to boot
> without a bootloader, right?

Kind of.

In my view, when booting through the EFI stub, the EFI stub becomes the
boot loader. I can also quote Documentation/admin-guide/efi-stub.rst:

  Since the EFI boot stub performs the jobs of a boot loader, in a
  certain sense it IS the boot loader.

which supports that idea.

> What about systemd-boot, does it set this variable?

Yes, it sets it in its efi_main().

Link: https://github.com/ivandavidov/systemd-boot/blob/master/project/src/sd-boot/boot.c#L1760-L1762

But IMHO, using systemd-boot kind of defeats the purpose of directly
booting the kernel from its EFI stub.

 
Yours sincerely,
Vincent Mailhol
