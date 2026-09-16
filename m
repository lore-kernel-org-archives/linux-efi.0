Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE5E4C67F3;
	Wed, 16 Sep 2026 10:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789554393; cv=none; b=ICa8M7iE3fZUIQlnASPQrKMEpUflVftOG6Ynt6qcSB4t48pYm8fJ++T5yKNIu7wJtqYMvfH9DhgF2Gl6neXOKOXV5GrYhHUT2vZ63g/S2mOuUuSWnZSMmh196ygTtJ80js4qiDO6lxU2KTGetz8fQMT6dUZ0AcTpspOnZ1rKkTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789554393; c=relaxed/simple;
	bh=RqPzWt+oHUBg+h1+63Lh5bVhj7REFL828WImcX4mdec=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ys1AeYBP4ajaLxruIZRP2ouWYLjWtnFNRMgWEiidtgbDeRkCi+KABebGT8KWyHrTcNU10Gg1dpeQVtido5HBQheLA0fGu9A01LjVfdy87qnQbct04LUmOrerLGWDfhO1gGesb0fSLKpypSlvZ35L2UVo0ywwTIPF9lTv4SM0x88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFCeuEsA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFCeuEsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D535B1F000FF;
	Wed, 16 Sep 2026 10:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789554386;
	bh=DTp1iA6KwxfztWvDrOMeMz5Phpuk6ej6XYTDd5JnmEM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NFCeuEsAfNPwnulZLAZl8koAwRmcS/GD9LoqYg6yFF6sd0+OgPkJBXjMyP3iJcxY4
	 nw80+05z82v7E0JgmCA089uLt+CyomXrEREXGy5JnAWK5zjTvHwoPuYrKAoRol2cqa
	 AidO0FR4enzxHHJRDMBJj8Weujftym8B4+Po47swavPmgQXlZHP4MWOcLqYPMdrWTB
	 M4btQ6ZjcMle919gKCDPGzAcgKHXGPS5ff8GBQmQw1azivW/ho/lVrmkUiQpIJNYVo
	 duH7v5eZpHpmFp1RmFKu4TkX8IgtpGiag6xGK71Iw3sEdOJJSxBEi6JnNu6b1N9OVC
	 x7Cqh18FasrLw==
Message-ID: <1d5c8df2-2517-4e01-a7b2-6a03e31b4b1a@kernel.org>
Date: Wed, 16 Sep 2026 12:26:22 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/10] lib/ucs2_string: Split out ucs2_as_utf8_l()
 taking a separate limit
To: Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 x86@kernel.org
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-16-ardb+git@google.com>
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
In-Reply-To: <20260909115530.1924665-16-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/09/2026 at 13:55, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> ucs2_as_utf() takes a maxlength argument, which specifies how many bytes
  ^^^^^^^^^^^^^
Typo: ucs2_as_utf8() (missing '8').

> the function is permitted to store into the destination buffer.
> 
> The same value is used as an upper bound for the ucs2_strnlen()
> invocation, which is reasonable in the general case, as each UCS-2
> character produces at least one byte of UTF-8 output, and so there is
> never a need to process more than 'maxlength' UCS-2 characters.
> 
> However, if the UCS-2 string is not NUL terminated, ucs2_strnlen() may
> read past the end of the buffer if 'maxlength' is set to a high value.
> 
> Current callers pass UCS-2 strings that are expected to be NUL
> terminated, but for processing the load options in the EFI stub, a
> version is needed that takes a separate limit argument. So split that
> off from the current implementation.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  include/linux/ucs2_string.h | 11 ++++++++++-
>  lib/ucs2_string.c           |  6 +++---
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/ucs2_string.h b/include/linux/ucs2_string.h
> index c499ae809c7d..74f23ca5a967 100644
> --- a/include/linux/ucs2_string.h
> +++ b/include/linux/ucs2_string.h
> @@ -14,7 +14,16 @@ ssize_t ucs2_strscpy(ucs2_char_t *dst, const ucs2_char_t *src, size_t count);
>  int ucs2_strncmp(const ucs2_char_t *a, const ucs2_char_t *b, size_t len);
>  
>  unsigned long ucs2_utf8size(const ucs2_char_t *src);
> +unsigned long
> +ucs2_as_utf8_l(u8 *dest, const ucs2_char_t *src, unsigned long limit,
> +	       unsigned long maxlength);
> +
> +static inline
>  unsigned long ucs2_as_utf8(u8 *dest, const ucs2_char_t *src,
> -			   unsigned long maxlength);
> +			   unsigned long maxlength)
> +{
> +	return ucs2_as_utf8_l(dest, src, ucs2_strnlen(src, maxlength),
> +			      maxlength);
> +}
>  
>  #endif /* _LINUX_UCS2_STRING_H_ */
> diff --git a/lib/ucs2_string.c b/lib/ucs2_string.c
> index f75fb4f7961a..2df9bef79eea 100644
> --- a/lib/ucs2_string.c
> +++ b/lib/ucs2_string.c
> @@ -132,11 +132,11 @@ EXPORT_SYMBOL(ucs2_utf8size);
>   * final NUL character.
>   */

ucs2_as_utf8_l() still uses the old documentation of ucs2_as_utf8().
It currently reads:

  /*
   * copy at most maxlength bytes of whole utf8 characters to dest from the
   * ucs2 string src.
   *
   * The return value is the number of characters copied, not including the
   * final NUL character.
   */

That documentation should probably be moved to linux/ucs2_string.h so
that ucs2_as_utf8() remains documented after being turned into a
static inline wrapper.

As for ucs2_as_utf8_l(), it would be worth adding a new comment block
to highlight its specific behaviour: the new limit argument, the fact
that the string is only NUL-terminated if there is enough space and
that the return value is not the number of wide characters copied but
the number of bytes copied.

>  unsigned long
> -ucs2_as_utf8(u8 *dest, const ucs2_char_t *src, unsigned long maxlength)
> +ucs2_as_utf8_l(u8 *dest, const ucs2_char_t *src, unsigned long limit,
> +	       unsigned long maxlength)
>  {
>  	unsigned int i;
>  	unsigned long j = 0;
> -	unsigned long limit = ucs2_strnlen(src, maxlength);
>  
>  	for (i = 0; maxlength && i < limit; i++) {
>  		u16 c = src[i];
> @@ -163,7 +163,7 @@ ucs2_as_utf8(u8 *dest, const ucs2_char_t *src, unsigned long maxlength)
>  		dest[j] = '\0';
>  	return j;
>  }
> -EXPORT_SYMBOL(ucs2_as_utf8);
> +EXPORT_SYMBOL(ucs2_as_utf8_l);
>  
>  #ifndef __DISABLE_EXPORTS
>  MODULE_DESCRIPTION("UCS2 string handling");


Yours sincerely,
Vincent Mailhol
