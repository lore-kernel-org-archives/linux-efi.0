Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A909E4E50AF;
	Thu, 17 Sep 2026 06:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789626109; cv=none; b=g0ahNlZ+YpUkWpdsRy3tLFtG93EkvbB2/u+lLwVSwbp+J2f/4St7f2hF+sX5OmfK2i9XejWNA5e96AqubV/S4j98wpELsBE6lXB5f1DjCmMvalzYXQVqDJ9eWTJMbeXSiYd6o7RoWEVM3h2gSnuhE6TKiCrzr0w1M4DR2fQUowk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789626109; c=relaxed/simple;
	bh=4vFJCXm0H+3X9C2NcWa2a2u6p/MC1RWFawDV7OgZ44U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=izhrZTmqeuiWP36RJkAWf6sUfeaWktgR42LjS7yrXjxyTzKC9bhgjVFPHQIh/v9p2hA1d2AxkKV7hGX/WP62CNwTsbiroH9xWrngAjsVXa2UPmASjCvL3+UI5lLgPQVzRE/pt1Jpn5c5GUXbWEKQ6kUhMFq84KRBfGQGDie7RjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jNEbCrbM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jNEbCrbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408BA1F00893;
	Thu, 17 Sep 2026 06:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789626108;
	bh=uvz94Madl6XwgNZ98QYnERk2Nye9Am5+hUEu6jXWDR8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jNEbCrbM5tMYw3dQt3JRP63b1Ugj/rsR/xQcZhKv+tVleMXxebJLsD9eSIZht65oA
	 m7h2obEwK9HgaC9xZtIWVLQpPv2RfzwcTvLDDeXvNdtM0XeWcUFw76bbAQM4BMatTs
	 5X3V9aGu7potUF4nSlWWRMEd7NcvE/pL9Aw90UImJNOwIofoOhowO5ZlKlCW4kVhsY
	 kyVP24OQ1LgFpIl2tAseSKkfMzn4w8i18gokx0kncJbzGtvADJyTJ9s4kGU/2g20Jp
	 dZHlw6EJK1cI+7N9RxQjqisNCuPqLvJyqeockjaSTACLYjtqXWZPTkOeuytUfvpeut
	 sYe+uNO1DLEwA==
Message-ID: <c55f8ca6-3b67-45da-b309-b1793407fc04@kernel.org>
Date: Thu, 17 Sep 2026 08:21:45 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/9] efi/libstub: Avoid UTF-16 conversion busywork
To: Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
References: <20260916144647.2651379-11-ardb+git@google.com>
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
In-Reply-To: <20260916144647.2651379-11-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 16/09/2026 at 16:46, Ard Biesheuvel wrote:
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

This v3 looks good to me and runs fine.

Patch 8 still uses spaces instead of tabulation for indentations. But,
notwithstanding of that and for the full series:

Reviewed-by: Vincent Mailhol <mailhol@kernel.org>


Yours sincerely,
Vincent Mailhol

