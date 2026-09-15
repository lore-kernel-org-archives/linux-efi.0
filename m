Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326F44BD7BF;
	Tue, 15 Sep 2026 18:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789496922; cv=none; b=S6V3CJdVmWJzIQslXYPCqbNORpI/IdVOscIOWDmTclgjJrbDUElSxNnsIww6v6+ALL5kWQ3BWpC2FBfSk3ab3wTRI6nRSONZsuVakPITGuo6AkjbbDON4fFtcZg/CrN0VMkypLQ7GXsnFEXDIlKs+KWTSvFCfvIMYse5UD0YPLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789496922; c=relaxed/simple;
	bh=K2v9iBFaTmblF7LLjs8V4fvJN8g8M/6pF/Is0FsH75c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aY+tdG+l4x/YgrRCHGwiqCNhd4kWMjV1IDsduOtoM+31wyUuFSL0PVsAjHIpUjBDBzL8vzSGjqaoicrsUIT5a/yc6ar+t7MnYQ9i6+MQFLWIx18zapZmvol9GfTvScCqeboWZsVZKFErpK6cWy3dwqqsCfcf/LHYVSHjB0kCjAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kneD8A0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kneD8A0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C1E1F000FF;
	Tue, 15 Sep 2026 18:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789496920;
	bh=JpN2DFnZLoqwI3jIrp8G2HAMxfqFA3eArz39p/f4vNw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kneD8A0BuhrBzx2bopOC4yG8tjBLARE0WxLIOQS86mc11s9U2Y9ZqIQuEjjzssqcF
	 HiMRpmdHbSmc3qGwJhjdU4mVPuRmz3R97cbIQ8V7qfS+HbST0iWOF+AywlaZ0pPJsJ
	 iBRL/Uyyv6BeH6oL9ncVpPjAnRK+esNjmBe8PmzNBrhVhASMuWV5vl58hP4BFVifB0
	 tgdrZeZYjhs/iGKNfsRSVZknKxztBvY6VRzEYzjujSW3ZIglqLIe4dL7HkKOcosV5Y
	 lKZWtYqaQ2ec63lVptMFh9pBT/Va3ESIAPawLDfSkCrdr/sIIG3I2tHRZF6/EMJ8UJ
	 JdDgADRsysFKQ==
Message-ID: <4744f837-538b-4b3c-b95c-1c5e0b8547b4@kernel.org>
Date: Tue, 15 Sep 2026 20:28:37 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/10] efi/libstub: Avoid UTF-16 conversion busywork
To: Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 x86@kernel.org
References: <20260909115530.1924665-12-ardb+git@google.com>
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
In-Reply-To: <20260909115530.1924665-12-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/09/2026 at 13:55, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The EFI libstub performs some redundant conversions between UTF-16 and
> UTF-8 and back again, which includes dealing with surrogate pairs, which
> UEFI implementations themselves simply ignore.
> 
> So drop all the homegrown code, and use the existing UCS-2 (== UTF-16
> without surrogate pairs) library code where conversion to UTF-8 is
> actually needed (the kernel command line).
> 
> The remaining handling involves the EFI console, which supports wide
> characters natively, so just use those directly.
> 
> Changes since v1 [0]:
> - drop size limit from ucs2_strscpy() instead of just the WARN()
> - suppress modinfo sections from ucs2_string when __DISABLE_EXPORTS is
>   defined
> - allow the input limit and max output size to be passed separately to
>   ucs2_to_utf8()
> - reimplement efi_convert_cmdline() to optimize the common case, and
>   only process the input character by character if its size exceeds
>   COMMAND_LINE_SIZE
> - use memcpy() to avoid strscpy() semantics in handling of %ls
> - incorporate Vincent's patch (which inspired this work) for
>   completeness
> 	
> Cc: Vincent Mailhol <mailhol@kernel.org>

Sorry for the late feedback. I just finished my review. Aside from the
few comments I left, the runtime tests were all OK. My BLI patch works
fine on top of your changes.

Thanks again for the time spent to accommodate for my patch!


Yours sincerely,
Vincent Mailhol

