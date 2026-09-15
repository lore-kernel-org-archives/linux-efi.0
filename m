Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1583B3BF2;
	Tue, 15 Sep 2026 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789491637; cv=none; b=j7THrcVCIVUZ9D4xw2/27w+S7T6v4nAJs1HGykCvlHguEOpsFRU2EZ24qp0hh2zqB+hTUeVzbxyJt5ZLXdAA2aDAHYz2GktaYO9g85fEvQiSEO5mQddzlexWCW58esamusZRJgcZQ4JxfRETInzjCAXsmDjtVMNk8l3xk6JnVhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789491637; c=relaxed/simple;
	bh=nLDxzz2dWNFm6NSyCBrB8Ip3P2HQVLOec4u7zzHbcyw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=oKsrqdVUunz4IFufIe3ybviaj2vUzZqoEiB6SoHcLf0g/mYttZNBChCiANTwQHE6hxedLF4ExoZfucqjsXnYI0fysYUfcR6YgVFl+T8oT2m8QOZ0/GSFW+W0IN2uoS6VfJs8IjsFntkOGRnGuAZUmPxOGa3axDQ7vay+qGMkvfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m2mfeFYp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m2mfeFYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75891F000FF;
	Tue, 15 Sep 2026 17:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789491634;
	bh=xB955G0Tjms5eQFLlFqi9qYOjaC5fRUpUYe/3Knqckw=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=m2mfeFYpxbbg3x33uKKkhYcttRDtnnALXZekDCpdJxZpficOMNaGTMnBrr5EKYCQz
	 TgS9FqjdH1/yWbAcs+CNWpZbISypBTtKDcKpJ2V2fm9RayuoTNwcMFq8c4BZNTr1D5
	 IjyBacmxYmpxB6qnR8yK5QgNjZMbU6BeMNqPasHgQ6xiZcfrgXYf09mh68VKAvqtAN
	 bz9nR0W0BnCh95SPKlfiYXtEJ8xcQjRZTE90TdjlRGepOpevDM3c+5ym9eMdHETvFf
	 r6oitta0COzCUPUZhK/Xi2u418bGK93xXXxEn1vrJcVLFXxREeIA5s1BCdp3kROzuj
	 upj1PXK2pDBnQ==
Message-ID: <2bcd2325-5ec4-4260-8f31-4526ba5a4aea@kernel.org>
Date: Tue, 15 Sep 2026 19:00:30 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vincent Mailhol <mailhol@kernel.org>
Subject: Re: [PATCH v2 05/10] efi/libstub: Use ucs2_string library for UTF-16
 to UTF-8 conversion
To: Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 x86@kernel.org
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-17-ardb+git@google.com>
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
In-Reply-To: <20260909115530.1924665-17-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/9/26 13:55, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Don't rely on sprintf() with a wide string conversion modifier to
> convert the command line from UTF-16 to UTF-8. Instead, use the
> existing ucs2 string library routine that does the same. Note that while
> UEFI claims support for UTF-16, in practice it ignores surrogate pairs
> entirely, and so the simplified UCS-2 character set (where each
> character takes up exactly 2 bytes) is sufficient here.
> 
> This removes the only user of sprintf() in the EFI stub, so drop that
> function as well.
> 
> Since boot memory is plentiful on UEFI systems, just establish a worst
> case upper bound for the size of the buffer (which can never exceed
> COMMAND_LINE_SIZE), and allocate that first. Then, perform the
> conversion, and only fall back to processing the command line character
> by character if that resulted in truncation. This makes the common
> execution path much simpler.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  drivers/firmware/efi/libstub/Makefile          |   3 +-
>  drivers/firmware/efi/libstub/efi-stub-helper.c | 100 ++++++++------------
>  drivers/firmware/efi/libstub/vsprintf.c        |  11 ---
>  3 files changed, 41 insertions(+), 73 deletions(-)
> 
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index 77a2b2d74f3f..12c0c7deb5cb 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -66,7 +66,8 @@ KBUILD_AFLAGS			:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
>  lib-y				:= efi-stub-helper.o gop.o secureboot.o tpm.o \
>  				   file.o mem.o random.o randomalloc.o pci.o \
>  				   skip_spaces.o lib-cmdline.o lib-ctype.o \
> -				   alignedmem.o printk.o vsprintf.o
> +				   alignedmem.o printk.o vsprintf.o \
> +				   lib-ucs2_string.o
>  
>  # include the stub's libfdt dependencies from lib/ when needed
>  libfdt-deps			:= fdt_rw.c fdt_ro.c fdt_wip.c fdt.c \
> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> index f27f2e1f0019..4b51a0bf0e66 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -12,6 +12,7 @@
>  #include <linux/efi.h>
>  #include <linux/kernel.h>
>  #include <linux/overflow.h>
> +#include <linux/ucs2_string.h>
>  #include <asm/efi.h>
>  #include <asm/setup.h>
>  
> @@ -334,81 +335,58 @@ char *efi_convert_cmdline(efi_loaded_image_t *image)
>  {
>  	const efi_char16_t *options = efi_table_attr(image, load_options);
>  	u32 options_size = efi_table_attr(image, load_options_size);
> -	int options_bytes = 0, safe_options_bytes = 0;  /* UTF-8 bytes */
> -	unsigned long cmdline_addr = 0;
> -	const efi_char16_t *s2;
> -	bool in_quote = false;
> +	unsigned long options_chars = 0;
> +	unsigned long cmdline_bytes;
>  	efi_status_t status;
> -	u32 options_chars;
> +	char *cmdline_addr;
>  
>  	if (options_size > 0)
>  		efi_measure_tagged_event((unsigned long)options, options_size,
>  					 EFISTUB_EVT_LOAD_OPTIONS);
>  
>  	efi_apply_loadoptions_quirk((const void **)&options, &options_size);
> -	options_chars = options_size / sizeof(efi_char16_t);
> -
> -	if (options) {
> -		s2 = options;
> -		while (options_bytes < COMMAND_LINE_SIZE && options_chars--) {
> -			efi_char16_t c = *s2++;
> -
> -			if (c < 0x80) {
> -				if (c == L'\0' || c == L'\n')
                                                  ^^^^^^^^^^
This newline check is not present in the new version. The new code only
checks for NUL termination through ucs2_strnlen(). The patch description
says nothing about this, so maybe this is an omission?

> -					break;
> -				if (c == L'"')
> -					in_quote = !in_quote;
> -				else if (!in_quote && isspace((char)c))
> -					safe_options_bytes = options_bytes;
> -
> -				options_bytes++;
> -				continue;
> -			}
> -
> -			/*
> -			 * Get the number of UTF-8 bytes corresponding to a
> -			 * UTF-16 character.
> -			 * The first part handles everything in the BMP.
> -			 */
> -			options_bytes += 2 + (c >= 0x800);
> -			/*
> -			 * Add one more byte for valid surrogate pairs. Invalid
> -			 * surrogates will be replaced with 0xfffd and take up
> -			 * only 3 bytes.
> -			 */
> -			if ((c & 0xfc00) == 0xd800) {
> -				/*
> -				 * If the very last word is a high surrogate,
> -				 * we must ignore it since we can't access the
> -				 * low surrogate.
> -				 */
> -				if (!options_chars) {
> -					options_bytes -= 3;
> -				} else if ((*s2 & 0xfc00) == 0xdc00) {
> -					options_bytes++;
> -					options_chars--;
> -					s2++;
> -				}
> -			}
> -		}
> -		if (options_bytes >= COMMAND_LINE_SIZE) {
> -			options_bytes = safe_options_bytes;
> -			efi_err("Command line is too long: truncated to %d bytes\n",
> -				options_bytes);
> -		}
> -	}
> +	if (options)
> +		options_chars = ucs2_strnlen(options,
> +					     options_size / sizeof(efi_char16_t));
>  
> -	options_bytes++;	/* NUL termination */
> +	/* Each UCS-2 char takes up at most 3 UTF-8 bytes */
> +	cmdline_bytes = min(3 * options_chars, COMMAND_LINE_SIZE - 1) + 1;
>  
> -	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, options_bytes,
> +	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, cmdline_bytes,
>  			     (void **)&cmdline_addr);
>  	if (status != EFI_SUCCESS)
>  		return NULL;
>  
> -	snprintf((char *)cmdline_addr, options_bytes, "%.*ls",
> -		 options_bytes - 1, options);
> +	if (ucs2_as_utf8_l(cmdline_addr, options, options_chars,
> +			   cmdline_bytes) >= COMMAND_LINE_SIZE) {
> +		/*
> +		 * The output fills up the entire buffer, and may have been
> +		 * truncated. This can only happen when options_bytes equals
> +		 * COMMAND_LINE_SIZE.

If truncation occurs because there is not enough space left for a
multi-byte character, ucs2_as_utf8_l() returns a value below
COMMAND_LINE_SIZE.

Should the test instead check whether all the options_chars were consumed?

> +		 * Work backwards through the buffer to find a safe truncation
> +		 * point (i.e., a blank character not inside a quoted string).
> +		 */
> +		int safe_pos[2] = {};
> +		int in_quote = 0;
> +
> +		for (int i = COMMAND_LINE_SIZE - 1; i >= 0; i--) {
> +			char c = cmdline_addr[i];
> +
> +			if (!c)
> +				return cmdline_addr;
> +			else if (c == '"')
> +				in_quote ^= 1;
> +			else if (!safe_pos[in_quote] && isspace(c))
> +				safe_pos[in_quote] = i;
> +		}
> +
> +		efi_err("Command line is too long: truncated to %d bytes\n",
> +			safe_pos[in_quote]);
> +		cmdline_addr[safe_pos[in_quote]] = '\0';
> +	}
>  
> -	return (char *)cmdline_addr;
> +	return cmdline_addr;
>  }
>  
>  /**
> diff --git a/drivers/firmware/efi/libstub/vsprintf.c b/drivers/firmware/efi/libstub/vsprintf.c
> index 71c71c222346..dba136679172 100644
> --- a/drivers/firmware/efi/libstub/vsprintf.c
> +++ b/drivers/firmware/efi/libstub/vsprintf.c
> @@ -551,14 +551,3 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list ap)
>  
>  	return pos;
>  }
> -
> -int snprintf(char *buf, size_t size, const char *fmt, ...)
> -{
> -	va_list args;
> -	int i;
> -
> -	va_start(args, fmt);
> -	i = vsnprintf(buf, size, fmt, args);
> -	va_end(args);
> -	return i;> -}


Yours sincerely,
Vincent Mailhol
