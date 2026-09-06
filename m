Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B22A346ACD;
	Sun,  6 Sep 2026 22:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788732897; cv=none; b=DekyTckho515cLxfxLj0NW7K+yDGGrJYPcCCKEknR2cLqofZ7trfyb/PMxobqkJ39ibcNn8SxLZsFez9ygVdchlL5v27cEmO7JA+7Mpd8GePNZkXAEip3tMKAmQerzLTqIIk3633N7G/cV7hx4byc+QZfhKnigVzWMm4C9k9a8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788732897; c=relaxed/simple;
	bh=fBVwzq5Z3SjyD32hMJAWnebPaKxxyeOWcoEU9xKIJZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N/1CWWGacXm46usorVBCH5eu3TiCYT9A9C9Eiy9B4vVCDZtWYAU1MWc4577dW6Sjrjv1awttdT0J3VX1uecJCP2cpRMQc9CqZYaprbk51bUIoFESH0ROS46WBtHZjWIUjSUMJtoiWTBuNtRShxQLcDx9upHovbzxZn9r5N9nyMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eUo/UBsU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUo/UBsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DBA1F00A3A;
	Sun,  6 Sep 2026 22:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788732895;
	bh=LHY8RTGigSXmdkzD+9KmHauLCPoLo9awnCgicKZbZ2k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eUo/UBsUNXVC8mmeFntFFOcwrxaapKsLZZ6ptJ+wdVMp/htvtcifBATIPr4YtHwxQ
	 9K7Jxi3k/GvsQ/sA5RFxyHaRwLT+/vzm2+/+Wbpi6NK63njNDC9TIK+bdX3HRBpNRs
	 yHyW1UZupE4ncNRENGs/LxwWvolgfWkJogW0UVxqmRKTXuTMYqVcD7teZaUbrJhAq+
	 I+oXtUYELcH0+JcFeBLBXUVshFvPhqcta/RepU6qR9mMfLnhtjr037YY7U42nL+Qma
	 KZIwtCwYjIRfvrAINGxwupCMHgXpbhIhQBknN7lQQ8H8vdLbF/672ucv64xOKBEGrj
	 c+vlLdmRrNedw==
Message-ID: <1d0291a5-885f-4996-814f-10ce2cf52ec4@kernel.org>
Date: Mon, 7 Sep 2026 00:14:52 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] efi/libstub: Avoid UTF-16 conversion busywork
To: Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
References: <20260906130817.1151961-9-ardb@kernel.org>
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
In-Reply-To: <20260906130817.1151961-9-ardb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/09/2026 at 15:08, Ard Biesheuvel wrote:
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
> Cc: Vincent Mailhol <mailhol@kernel.org>
> Cc: x86@kernel.org

With the panic() dependency now resolved, this compiles and run well.
I rebased my BLI series on top of it and could confirm the good
behaviour of efi_snprintf(). I just sent a v3 of my BLI patch.

Link: https://lore.kernel.org/linux-efi/20260906-efi_stub_bli-v3-1-e7dc0d6b8fcd@kernel.org/


That said, sashiko has a few findings which looks relevant to me:

Link: https://sashiko.dev/#/patchset/20260906130817.1151961-9-ardb%40kernel.org

with the two most concerning findings being the correct handling of
ucs2_as_utf8()'s options argument when it is NULL and the correct
NUL-termination of the kernel cmdline.

I didn't try to reproduce those issues, but the report looked legit to
me.


Yours sincerely,
Vincent Mailhol
