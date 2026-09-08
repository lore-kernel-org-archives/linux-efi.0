Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE5B598C01;
	Tue,  8 Sep 2026 18:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788893301; cv=none; b=RWQUvbSO4AO/L6M0kQPUnSBmFbeWm3m5eRbyjcR9PQoujkrFtiN+kCjwuP6dXlxZtF0FQs/TgANudKkcwZMgtn6r2xQjPUstKYXjpBeFVzabhrxf6xUqs/ahxwkz94OSScnmK++3K6nwHP+1M/5eVDvqJsvWO9blqmI2ArYQ0jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788893301; c=relaxed/simple;
	bh=xoul/AmjbT7mtSArYZ0HfSSRRed34jgm7ikODlj29Aw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rJgTTbw2oPlac7q9ve05qlTWn6tjHu81QnbBUvpmiWHH/523XzcpwEVl2RdAoe7qDM9r1xX9zFYrfxNH/wBVqvkH37/2kurGiaUZH+yupfCr42F27n7E7l6So50K+gHV1OTvnkNTALj0S5bp+4X6lsQvP7RbxQnJ1NqG0lEqXCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/hlL+/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/hlL+/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824001F00A3D;
	Tue,  8 Sep 2026 18:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788893297;
	bh=KOJV19sSyfmHE3xyj5OINm0nC7ZyBG+yaMvc0SoKxcI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m/hlL+/jY1WVC7HznaqXUyCUM53nHVCDIG3rVC8UROlL12KHWSX7Xlk2hPiZPSr7H
	 9NVr4pwCjNlK2zcXDE6wcrzkdqfsquivyxVYqwqnN1RaqcRpf666vr2jYFDLYcCMEi
	 KHUvIDtJ/bMMCQaM7XENCF5NiAzeTKlQy187S7oN/58seS02jcPRycWLmuMCaxCXZO
	 NUTr4gtRZuSdW7Nr2hRdfoqmFATF8Mqo07yHJzCBCDVDmUYaxSK1pPxasOr9DAOuKb
	 tOUvHm1eYvKIfYQAx9CLLiZu3RlXTd6wng41YeCdcRB5nXrU3aJ/49/02eXWRxPFXw
	 Klt5/aCWGaUrQ==
Message-ID: <2c7c1cfe-3ed7-468d-9056-8d7e77d15a5a@kernel.org>
Date: Tue, 8 Sep 2026 20:48:12 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] efi/libstub: add initial Boot Loader Interface support
To: Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
References: <20260906-efi_stub_bli-v3-1-e7dc0d6b8fcd@kernel.org>
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
In-Reply-To: <20260906-efi_stub_bli-v3-1-e7dc0d6b8fcd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 06/09/2026 at 23:52, Vincent Mailhol wrote:
> The Boot Loader Interface (BLI) [1] defines EFI variables that expose
> boot loader state to the running OS. LoaderInfo identifies the boot
> loader, while LoaderDevicePartUUID records the GPT partition UUID of
> the partition containing it.
> 
> LoaderDevicePartUUID is used, for example, by systemd-gpt-auto-generator
> [2] to identify the disk the boot loader was launched from and
> automatically detect and mount partitions on it.
> 
> GRUB [3] and systemd-boot [4] populate these variables, but when the
> kernel is started directly by EFI firmware, there is no conventional
> external boot loader to provide them. In that case, because the EFI stub
> performs the boot loader role, it should provide the variables itself.
> 
> Use LoaderInfo as a sentinel: if it is already set by an earlier boot
> stage or cannot be set, bail out. Otherwise, populate the other BLI
> variables.
> 
> Parse the loaded image device path, extract the GUID signature from its
> GPT HD() node and publish it under the Linux loader entry vendor GUID as
> the volatile LoaderDevicePartUUID EFI variable.
> 
> Install the efi_bli_set_variables() hook in both the generic efi-stub.c
> path and the x86-specific x86-stub.c path.
> 
> [1] The Boot Loader Interface
> Link: https://systemd.io/BOOT_LOADER_INTERFACE/
> 
> [2] systemd-gpt-auto-generator
> Link: https://www.freedesktop.org/software/systemd/man/latest/systemd-gpt-auto-generator.html
> 
> [3] GRUB -- §16.2 bli
> Link: https://www.gnu.org/software/grub/manual/grub/html_node/bli_005fmodule.html
> 
> [4] systemd -- systemd-boot UEFI Boot Manager
> Link: https://github.com/systemd/systemd/blob/main/docs/BOOT.md?plain=1#L102
> 
> Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
> ---

(...)

> +static void efi_bli_populate_loader_part_uuid(efi_loaded_image_t *image)
> +{
> +	static efi_guid_t device_path_guid = EFI_DEVICE_PATH_PROTOCOL_GUID;
> +	efi_char16_t partuuid[UUID_STRING_LEN + 1];
> +	const struct efi_hd_dev_path *hd_node;
> +	const struct efi_dev_path *path;
> +
> +	if (efi_bs_call(handle_protocol, efi_table_attr(image, device_handle),
> +			&device_path_guid, (void **)&path) != EFI_SUCCESS)
> +		return;
> +
> +	hd_node = efi_bli_find_hd_node(path);
> +	if (!hd_node)
> +		return;
> +
> +	if (efi_snprintf(partuuid, ARRAY_SIZE(partuuid), "%pUl",
> +			 hd_node->signature.b) != UUID_STRING_LEN)
                         ^^^^^^^^^^^^^^^^^^^^
I just realize that there is a small mistake here. Conceptually
speaking, %pUl expects a pointer to a efi_guid_t. Of course, because of
the function being variadic, no type enforcement is done and the
compiler is happy with hd_node->signature.b which is an u8 array.

But the clean approach is definitely:

	if (efi_snprintf(partuuid, ARRAY_SIZE(partuuid), "%pUl",
			 &hd_node->signature) != UUID_STRING_LEN)

@Ard, do you want me to send a v4, or can you just fix while applying?

> +		return;
> +
> +	set_efi_var(L"LoaderDevicePartUUID", &loader_entry_guid,
> +		    EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
> +		    sizeof(partuuid), partuuid);
> +}

(...)


Yours sincerely,
Vincent Mailhol

