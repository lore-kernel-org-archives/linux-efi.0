Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13564078E0;
	Tue, 15 Sep 2026 17:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789491673; cv=none; b=pShcjIHAGOFdbthWhIh59Gn/9jognYyeB/jQQ2NSkPyGdatndtU4V3TNGevz6pBIGbn3aUVM98kwAiZgItGmGal6+MwEZjWu42zv2Pi0PYK53cWhj7IT/+80NckYQS2hDaJ8SK/Xh1y0kgKluCODCAcfGn0PgHKbkhwEGq1JaJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789491673; c=relaxed/simple;
	bh=1INvFVGtwVc+KjLGC2f6uzcw6Eo7XyKN3FD5O/gnxj8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=qi7DdEuxEDBFSTopdApWX8pSqTemW5L/UIxaFydcJ4+ODadresf8FYGNm+ItTL8ZA2mJMBgVMHenKUoj7etbjb9XqijgvVGxRh204L23yzmWmg+jhgk65K6EVVt2eSm4rNwM8Akf1tcaQIkVYkhZ+NiTrVYEYsUJr88FY6Qjkwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gztKKsCF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gztKKsCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756EF1F00893;
	Tue, 15 Sep 2026 17:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789491671;
	bh=IxUZ5FsbZXa9xx+yT6cPwJROURd1Q9oeUXRrQ7S4cqM=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=gztKKsCFIseOzCGP6aM2Gm+Aqsmd7o3zkG0x3y6cgFNfOJpH95of8GeVlA6NSDb8F
	 dm8ddP9RCKWmtPj+pMcw50PQ2MUvtOB1lZu6WqjFb84YsmsNG2IzQI+vvgziqkN05I
	 iBY/GK8s7Hm5qNv3p9ctH4ordCQgckzRN9OnJoTCk0+MYdrCthh9rhMeWsFg8ahSVI
	 HLcRbZ2Bwe6bPWZbjdg0yQ8mdQU/mrPhW3N+BdGpJDR0oHEQnLmCmsQBTb6YvWPosS
	 q7FQAlwl8oITA4AIcE/IHorzh2Y2d0zdrgEmz7Im3Zs0W4WmKoAJXQudvZ5QlLocv3
	 VspxW+eN4a4bw==
Message-ID: <7394c719-5e5c-4e38-8b83-c22868fb2425@kernel.org>
Date: Tue, 15 Sep 2026 19:01:09 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vincent Mailhol <mailhol@kernel.org>
Subject: Re: [PATCH v2 06/10] efi/libstub: Avoid efi_puts() for compile time
 constant strings
To: Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 x86@kernel.org
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-18-ardb+git@google.com>
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
In-Reply-To: <20260909115530.1924665-18-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/9/26 13:55, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> efi_puts() performs a UTF-8 to UTF-16 conversion on its input, as the
> EFI console's native character set is UTF-16.
> 
> This is pointless for compile time constant strings, since we can
> simply define those as UTF-16 to begin with.

I would nuance this a bit. This is a trade-off between space and time.
ASCII text takes half of the space but needs a runtime conversion.

Note this is not an objection to the patch itself, but I think the
commit message could be slightly more nuanced.

> Note that efi_puts() also performs LF to CR-LF conversion, so this needs
> to be taken into account as well.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

(...)

Yours sincerely,
Vincent Mailhol
