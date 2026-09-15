Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BFC3B3BF2;
	Tue, 15 Sep 2026 17:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789491726; cv=none; b=n2rvXgLCHpEkihMB3lvOtswjZcidWjI9yqRYYpNJKvOInLW4rYwzbq4DtAo0Y7KcEHyY5KPV+bHqVutsN2BCLMxTcrylUm419D2H6bZEZgzz8KARUHQRuvcImU3d7IdKmWNX9yZJQE9ZQo+Znqa49T3FJup/N5eFJ500cH43u/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789491726; c=relaxed/simple;
	bh=EZ8QZY4WFtOWacS3IV8sfkIWxSIImghyBBlj+Jc7VJg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=nNatNmWi3V4PYPzWfCZYjYzUkC/aODy3ew5610Y76oyoVrcq79U/fBRKxGhPUwg74V2BfbUlYJLjO9nZy7gC3jyDAgdGEB+R54NbiHdTErcD2oGhJhPMo4L+m03iLhxcB7UO50Uh4t0pFxeXvB4T/B/v1kE5WWidi6wvukg9CPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kFDGvZeq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kFDGvZeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331221F000FF;
	Tue, 15 Sep 2026 17:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789491725;
	bh=9nRrmNKX6ng4xtc2loecHJuojea7l76z2B0Z5et/GKo=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=kFDGvZeq1yXZxRcOXEuPQh6O/TW8FY41vZYP231nsynYl6DtL2al3/J4uNk/yzc8s
	 iV06mS9gTw3Befz9uyPljGwMO3d8rwhCY33aDTFclKgC9j3fYc/mi4oC2QVgVMJb85
	 GE4NDcFt8gXE6ZRIL78TvvIaiIoEMxftto0sFdOJj+YoMp2Eigg73gO1rMPBr7Ekhr
	 og7kG5CvTRPTU1x0M/IUKjfyK4zFcxb2Cs14J0l060glAqYdWztNLLfsBARn/RjZyN
	 MJR16RsY3v7lU1ME8Uj7X8dXLFBf7/oV1ItqXUtPewSExN5TFIzhAt6IH1vCZuRghi
	 1dhX1lKSsBL7g==
Message-ID: <b1ad29b8-c0a4-43db-beff-63348eab99d5@kernel.org>
Date: Tue, 15 Sep 2026 19:02:02 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vincent Mailhol <mailhol@kernel.org>
Subject: Re: [PATCH v2 09/10] efi/libstub: Add efi_snprintf() to construct
 wide strings
To: Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 x86@kernel.org
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-21-ardb+git@google.com>
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
In-Reply-To: <20260909115530.1924665-21-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/9/26 13:55, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The native EFI character set is UTF-16 (or in practice, UCS-2).
> Implement efi_snprintf() to construct UTF-16 strings using printf style
> templates. This will be used in a subsequent patch to set the
> LoaderDevicePartUUID EFI variable.
> 
> Link: https://lore.kernel.org/all/20260903-efi_stub_bli-v2-1-dbf7ba915117@kernel.org/
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/firmware/efi/libstub/efistub.h  |  1 +
>  drivers/firmware/efi/libstub/vsprintf.c | 11 +++++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
> index 36056c624782..880c1d0c464b 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -1084,6 +1084,7 @@ int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
>  		  bool crlf);
>  
>  __printf(1, 2) int efi_printk(char const *fmt, ...);
> +__printf(3, 4) int efi_snprintf(efi_char16_t *buf, size_t size, const char *fmt, ...);
>  
>  void efi_free(unsigned long size, unsigned long addr);
>  DEFINE_FREE(efi_pool, void *, if (_T) efi_bs_call(free_pool, _T));
> diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
> index 7f6b891a338a..34a19495dace 100644
> --- a/drivers/firmware/efi/libstub/vsprintf.c
> +++ b/drivers/firmware/efi/libstub/vsprintf.c
> @@ -509,3 +509,14 @@ int efi_vsnprintf(efi_char16_t *buf, size_t size, const char *fmt, va_list ap,
>  
>  	return pos;
>  }
> +
> +int efi_snprintf(efi_char16_t *buf, size_t size, const char *fmt, ...)
> +{
> +       va_list args;
> +       int i;
> +
> +       va_start(args, fmt);
> +       i = efi_vsnprintf(buf, size, fmt, args, false);
> +       va_end(args);
> +       return i;


checkpatch.pl is complaining about the use of spaces instead of tabulations:

  WARNING: please, no spaces at the start of a line
  #41: FILE: drivers/firmware/efi/libstub/vsprintf.c:515:
  +       va_list args;$

  WARNING: please, no spaces at the start of a line
  #42: FILE: drivers/firmware/efi/libstub/vsprintf.c:516:
  +       int i;$

  WARNING: please, no spaces at the start of a line
  #44: FILE: drivers/firmware/efi/libstub/vsprintf.c:518:
  +       va_start(args, fmt);$

  WARNING: please, no spaces at the start of a line
  #45: FILE: drivers/firmware/efi/libstub/vsprintf.c:519:
  +       i = efi_vsnprintf(buf, size, fmt, args, false);$

  WARNING: please, no spaces at the start of a line
  #46: FILE: drivers/firmware/efi/libstub/vsprintf.c:520:
  +       va_end(args);$

  WARNING: please, no spaces at the start of a line
  #47: FILE: drivers/firmware/efi/libstub/vsprintf.c:521:
  +       return i;$


> +}


Yours sincerely,
Vincent Mailhol
