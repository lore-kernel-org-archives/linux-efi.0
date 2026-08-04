Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C264BCAA2;
	Tue,  4 Aug 2026 20:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785873920; cv=none; b=FriowJemA4anchzrG4jqQkrxAD+4dQQNHhcsPyLiutj1qFGQTXwdYonm/6jxNqOoaJ/CVDO5w6KSyjRZuQDBTMQ4Lbg6jN+6Rbi9PkaEcQH/egAodOv4Cyyr5JYekJep00EF9XOQlGTluNLUKkrEy76CSC9vbogSiosyY7N3rhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785873920; c=relaxed/simple;
	bh=rbBk7ax4ArpPoz48bpwPnsFLDFL4n8dlYquR9wY+sXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AcR4AqRrNlVcQ5BNXUkPE7/hhqQ77ctvk28/9yHcKMmE8nM8EJJRxyJzVZEnER5MKLV+5/PyEYSIoB8NLWMcED3uWrcqobPQJgBH2x6Q0LNGyuBQQpXaD7y7aME+EAmh6oyT8vEYqBTRe1lCdoJAVjqi2MHnTS8ohrzOT1Z3J/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lmBC0h24; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lmBC0h24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A3E1F000E9;
	Tue,  4 Aug 2026 20:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785873918;
	bh=PxfkStZE2LTjNr1PwVAWLYYSwCtVtLYKfRYDpA3yXOE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lmBC0h24rolfH+r0Dl1RDnp1oBN8r63IKKQe6STBxoHo3MGyyzMZ23NOCrqhFMPgC
	 Q9nacMvoe5AmvOnuyDsI8u8iDpQUHaiR7gp6SL/88ff/UCR0Wvr23911S/nvZ584po
	 Tykh20hUiEMYDsE/bzhsNfqwAB1eka9IEC6KI+UT0vtgE+jpKHjP9Oik2Sx4lNuopE
	 1wIyz7vF/Nqw/5FJ3QjPPLwLR1ckph+TdO1l7dYWdwBKNBgd2ns4s/ZL62Wo6Tfsdp
	 jkwG1C37dDDG0FPRoAdqTC5HUStitcJP9bpRYhoS6tyMM8rOJ2aDc93/twVEc7T/R7
	 86SQRjoWS8HmA==
Message-ID: <be3fba3c-4f31-4407-aa78-3408aa043f46@kernel.org>
Date: Tue, 4 Aug 2026 22:05:13 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] efi/libstub: populate LoaderDevicePartUUID
To: Ard Biesheuvel <ardb@kernel.org>,
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

Hi Ard,

This is a resend of:

  https://lore.kernel.org/all/96dac58a-9f10-4bd5-ad7d-c238743b60e7@kernel.org/

My SMTP server detected your message as spam and prefixed the message
subject with:

  *** SPAM ***

And this stayed in the subject of my reply. Now, I am worried that you
may not have gotten it because of that, thus this resend.

Aside from the fixed email subject, this is the same message.

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
