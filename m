Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C170313527;
	Sat,  5 Sep 2026 12:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788609946; cv=none; b=jrN8VZI9d3OyTxi+h0segTZ8EY3kY7CUE1tO1RoMTed+nJvhbx4KK6zhQqfn3QKAf+iqJe+nWfmDBXvyzVHbI7xlexU3lQDPFj4PryEhPN/6NuKmLKK/R78YJBNhQKvnBE0QETY1I9kP6lIvTqd167MmTfqX2J487SiI/U9cCNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788609946; c=relaxed/simple;
	bh=Ib8tZNKo1V2rLQH5Uu0f1JmvjoWo8NE9HsiSFNTRUlI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MQoKd69znNVzpyc75iBecdIW78bHiVd2NdXQEXJKApiHw1VQs/6Ono74Cvx0E6YgCGlT1qp2HxwNgtRbM8SOZCgIbU6WSMrggyQxbbP7UbzBWy71qFw04CkgeWFaRmw9SNXcNGMS3e3X8SzJlvolaNa0tfFNexCbEIyMM0RfB1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SDmBi7k1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SDmBi7k1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68E81F00A3D;
	Sat,  5 Sep 2026 12:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788609944;
	bh=H+P3r3pU8scUhbCgwtS4r/2uCahe7yBWVuu+dcLoT/E=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=SDmBi7k1+FPPLuDItGOYXKbVeYlmFbvMUCf5d7zbORc9o0nlQqi2AyS8+VD8NFw2R
	 XMYwOhUmRyRkY0XqvFG/3DqiIHrD6ly0Qur6I+E8uHhZQPBoX3n8GKYdHXcj5UtNF/
	 btiZWRfmxHZa64FD2jGq44w+p4jHt2q7S9h2+ZlnU09LXbvjirAycdluHVRoYrNNJJ
	 Lx2G+HxckGC6r/6uR/UyqNwHmk9DquDukqSuKUOOtHCogt+OYouIDjB+QkR3Hia0Jw
	 UttGOFkU4jRTSEGed2CSlCg3soh/05HwuQjgPuAq158cpd5xvnhHTWxhXwBE8Go4IR
	 ZxS2PAEMGaI9g==
Message-ID: <d0a41184-e65f-4b3c-9c65-eef123ffa5e0@kernel.org>
Date: Sat, 5 Sep 2026 14:05:41 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] efi/libstub: populate LoaderDevicePartUUID
From: Vincent Mailhol <mailhol@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
References: <20260903-efi_stub_bli-v2-1-dbf7ba915117@kernel.org>
 <b3982808-5ae5-48b8-a677-9f284a764685@app.fastmail.com>
 <d6b7cdae-8b99-49a2-9d9d-03eb77deb1dd@kernel.org>
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
In-Reply-To: <d6b7cdae-8b99-49a2-9d9d-03eb77deb1dd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/09/2026 at 00:06, Vincent Mailhol wrote:
> On 04/09/2026 at 18:12, Ard Biesheuvel wrote:
>> Hello Vincent,
>>
>> On Thu, 3 Sep 2026, at 23:19, Vincent Mailhol wrote:
>>> The Boot Loader Interface [1] defines LoaderDevicePartUUID. That EFI
>>> variable records the GPT partition UUID of the partition containing the
>>> boot loader.
>>>
>>> This is used, for example, by systemd-gpt-auto-generator [2] to identify
>>> the disk the boot loader was launched from and automatically detect and
>>> mount partitions on it.
>>>
>>> GRUB [3] and systemd-boot [4] populate it, but when the kernel is
>>> started directly by EFI firmware, there is no conventional external boot
>>> loader to provide the variable. In that case, because the EFI stub
>>> performs the boot loader role, it should provide the variable itself.
>>>
>>
>> Fair enough.
>>
>> But shouldn't it set LoaderInfo as well then?
> 
> Sure. This is quite easy to do.
> 
> Any preference of what to put in that variable? I am thinking of
> adding the release number like this:
> 
> 	#define EFI_BLI_LOADER_INFO L"Linux EFI stub " UTS_RELEASE
> 
> This looks consistent with what the other boot loaders are doing:
> 
> 	$ cat /sys/firmware/efi/efivars/LoaderInfo-4a67b082-0a4c-41cfb6c7-440b29bb8c4f 
> 	GRUB 2.12
> 
> Also, this gave me an idea. Maybe we can use the LoaderInfo variable
> as a sentinel for all other variables:
> 
> 	void efi_bli_set_variables(efi_loaded_image_t *image)
> 	{
> 		unsigned long size = 0;
> 
> 		if (get_efi_var(L"LoaderInfo", &loader_entry_guid,
> 				NULL, &size, NULL) != EFI_NOT_FOUND)
> 			return;
> 
> 		efi_bli_populate_loader_info();
> 		efi_bli_populate_loader_part_uuid(image);
> 	}
> 
> If it is set, we bail out, otherwise, we assume that the earlier boot
> stage did not implement BLI and we blindly populate everything. No
> more additional check on whether LoaderDevicePartUUID or other
> variables are set!

FYI, this is my latest WIP:

	void efi_bli_set_variables(efi_loaded_image_t *image)
	{
		static efi_char16_t loader_info[] = L"Linux EFI stub " UTS_RELEASE;
		unsigned long size = 0;
	
		if (get_efi_var(L"LoaderInfo", &loader_entry_guid,
				NULL, &size, NULL) != EFI_NOT_FOUND)
			return;
	
		if (set_efi_var(L"LoaderInfo", &loader_entry_guid,
				EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
				sizeof(loader_info), loader_info) != EFI_SUCCESS)
			return;
	
		efi_bli_populate_loader_part_uuid(image);
	}

The idea is that the sentinel check will not only be the presence of
LoaderInfo but also the fact that we could successfully set it. The
other variables (LoaderDevicePartUUID and whatever might comme in the
future) are set without further check and failure to set them is
silencely ignored.

> Does this approach make sense?

(...)

>> I'm reluctant to add this kind of code as a special one-off, so I got a
>> bit carried away and took this code and put it in the stub's printf
>> layer.
> 
> Thanks for the extra work!
> 
>> Could you please check whether the first two patches at [0] are
>> sufficient for efi_bli_guid_to_str() to be replaced by a simple
>> efi_snprintf("%pUl", ...) call here?
> 
> Ack. I already rebased and did a compile test, OK so far. The runtime
> test will come later. If I find an issue, I will send you a fix. If
> not, I will just send the v3 rebased on top of your
> efi-libstub-native-utf16 branch.

I spoke a bit too quick. Compiling

  drivers/firmware/efi/libstub/lib.a

worked well, but in a full build,

  arch/x86/boot/compressed/error.c

failed to link because it expects libstub to provide vsnprintf()
(c.f. comment above panic()) which you removed in commit edbd49dfea2a
("efi/libstub: Add widestring support to vsnprintf()").

You need to squash this in that commit:

---8<---
diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
index 521bdace031df..337326ce00488 100644
--- a/drivers/firmware/efi/libstub/vsprintf.c
+++ b/drivers/firmware/efi/libstub/vsprintf.c
@@ -663,6 +663,11 @@ int snprintf(char *buf, size_t size, const char *fmt, ...)
 	return i;
 }
 
+int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
+{
+	return efi_vsnprintf(buf, size, fmt, args, false, false);
+}
+
 int efi_snprintf(efi_char16_t *buf, size_t size, const char *fmt, ...)
 {
 	va_list args;
---8<---

or modify arch/x86/boot/compressed/error.c to take another vsnprintf()
variant.


Yours sincerely,
Vincent Mailhol
