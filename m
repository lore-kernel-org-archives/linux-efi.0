Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3A03C73C0
	for <linux-efi@vger.kernel.org>; Fri, 20 Mar 2026 14:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774018392; cv=none; b=hTMt3sYiKWNZBbPEevjOmoVtu6Eb3vThbo9QDKxSSLmVimaMY1voZCnvE5YcUuW5Eq82lijIzdizwHSrac9RCAtrbU3LodawrJW6ky2NiIEN2s0m0v8v/cQRyDnJ6nOb0Ro5WHmGcttmO52dHhAe6I/rGBqtGmDpdfu7IQd4VZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774018392; c=relaxed/simple;
	bh=Jfmttwx8FBEnXpEGQIu0ujjRU8fBebfRwySfXrGmTaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aDXjUgajAL0QKueCGbp9n71mseJnEDZWK82YQp3HLP5Vx5sk1c4aRm+a+XBHQg8doNp9q1hMYEZDGwAD1CH0Oeg+uwmzvHNZ7ajH3LydsXmyU9/wxxQNbKuBrUXruo9dQiHwdoxyj8RYqn7243HjJ+jjpoucjyU+tYlc7CW31qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IQltsbGi; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQltsbGi"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82c20f1e890so308777b3a.3
        for <linux-efi@vger.kernel.org>; Fri, 20 Mar 2026 07:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774018390; x=1774623190; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=rTHKXCWTdDkx4cn++Ba0jyyHVgHk9d/lYR5yOZKUNRA=;
        b=IQltsbGiz6ehLog+mWJ2KaQqA55FebXU+UpXz7b//FMAY7KE1Wl02lRyC7603Bb1QX
         0gLe5IfAYano0fqjTeNvhHzGEcvaRUYvBQIk6Fbct1BIXV81xOeHAfPmPeX9h8l6P7fT
         QxWp1mile5sH3hAxjAUnhAarGFbMFf5gUBkaW5cWpCZf4CaXjcuI1j8vBHsG7TyffcVg
         n+WtggHZMmIYSX6s6bhlVi3i/ugWjdAeL7KGG9p11iZovBKC/QvHB2YUhbm1cpotpsTL
         LZYR+PCLtzW6xSWSatCD2FOTdHJuk8y/Jam+l3W/NB55QiEMJ0Vq/RK6mfZ7jesnEgiZ
         /0pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774018390; x=1774623190;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rTHKXCWTdDkx4cn++Ba0jyyHVgHk9d/lYR5yOZKUNRA=;
        b=AHhVMZigrYPt50SnCvR0Zdy8x/bBUbgQiVJkANSOzAAxkn1KhjlqX8UH9FEwMM+V/o
         lGDGWeVtAjsybOrr7Qb+QIyyd/8Cu1fSTvA+W4LUB41TgA4209TWSl8no/OJb8/jleCa
         GK3OP5I8gbTULjTku3qYMwtSc63GV38xOmn0tspwOd41bEU7VPKeiDJO/TNsIqeFYuSu
         OkNy9/mfkWkSyeiLcOa+4IIKoIU3m3QBt9NMCK2LQ7C9XxHilqb2vTgmQvBk5W3Nehgy
         A6ult7G5BGfbufAzNAqJwwa9f0CVQvAV29PMZ+W4Hz0NMZ2s4fvapvkdLBcQn6FpD1cZ
         1n6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUtdX4aLBsS+y59CDHiV2JR+YGVOvTMHhllMf3950CMEwR9q9PX0tvUeKFAmFAK70XV0Tt2YzyyzYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTcu5BCHFjhtqLKSuYquVezQvLQ+AQAZ+qAgnH4ydR+rifjjah
	n6JZJySon6M0qbLKssTV/awZuX9lPxhvWbjpbWdOQc3KLU3dnmulDQcE
X-Gm-Gg: ATEYQzyfS8X8xlFku2/iBp72nN2RSDvSr1ReXXHVMcZoKZgX6MLCsky+/CknzJrN3NZ
	OPwicYHvJ2yTXI+duyNpetTgCpxxxTTGP59qi8Yr44Sz8CYan2oGKv8BhLTKTJWbD9gBs2Zj0vl
	XvQuCGii76uUZQj4eD39esUcecVfTVzFb/7+7H9SnJp3GQHMB1sYvn16TkmNBTb3yLJEPl/lC4T
	gFZma91Vpzkxrh46kQtcjryWvYKCZXfmCM35gnO62OfJwI7p0hwz9vqKU2LyfaUfcf9xKMdb76h
	4a3V1w9tKOAUtJB4B8YDyvmr/egtwVA9npldv1Nr/G72Gc0xi6re0WXrT9z4DrX7FWiU5MDbfWh
	xTVQgF/cPGkFUJ+2PDa3KF6gjVn5ysQep0O9evxrN2P4stwlj6tSbSeHjW6of0yZqWX0z5YIXyH
	0+muliyW8SgQv0mtGS/sfVaec+qajhYgTmARWipoMSC3SIipJ3EjmTLJOs3IQ6aceYbheKVoPh
X-Received: by 2002:a05:6a00:3491:b0:82a:955:50d3 with SMTP id d2e1a72fcca58-82a8c395ad2mr2483562b3a.45.1774018390304;
        Fri, 20 Mar 2026 07:53:10 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03bbf0c2sm2799129b3a.15.2026.03.20.07.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2026 07:53:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <b58a981a-6264-42d9-b158-650dd194ca9c@roeck-us.net>
Date: Fri, 20 Mar 2026 07:53:08 -0700
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/efi: defer freeing of boot services memory
To: Mike Rapoport <rppt@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Thomas Gleixner <tglx@kernel.org>, linux-efi@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260225065555.2471844-1-rppt@kernel.org>
 <100b9ae1-74cc-48b3-ba63-1a72cfa2ebbd@roeck-us.net>
 <ab1U59ye2eBOz6x3@kernel.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <ab1U59ye2eBOz6x3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/26 07:08, Mike Rapoport wrote:
> On Thu, Mar 19, 2026 at 09:06:52PM -0700, Guenter Roeck wrote:
>> Hi,
>>
>>> +void __init efi_unmap_boot_services(void)
>>>   {
>>>   	struct efi_memory_map_data data = { 0 };
>>>   	efi_memory_desc_t *md;
>>>   	int num_entries = 0;
>>> +	int idx = 0;
>>> +	size_t sz;
>>>   	void *new, *new_md;
>>>   
>>>   	/* Keep all regions for /sys/kernel/debug/efi */
>>>   	if (efi_enabled(EFI_DBG))
>>>   		return;
>>>   
>>> +	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
>>
>> Was this possibly supposed to be
>> 	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
>> 				       ^		     ^
>> ?
> 
> Yes, thanks for catching this.
>   

Thanks for confirming.

Just for the record, it wasn't really me, it was an instance of Sashiko
running on the LTS backport of the patch.

Guenter

> @Ard, can you please pick the fix:
> 
>  From 8fc5c5e828e7d127e6210bc9952451300591cdce Mon Sep 17 00:00:00 2001
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> Date: Fri, 20 Mar 2026 15:59:48 +0200
> Subject: [PATCH] x86/efi: efi_unmap_boot_services: fix calculation of
>   ranges_to_free size
> 
> ranges_to_free array should have enough room to store the entire EFI
> memmap plus an extra element for NULL entry.
> The calculation of this array size wrongly adds 1 to the overall size
> instead of adding 1 to the number of elements.
> 
> Add parentheses to properly size the array.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Fixes: a4b0bf6a40f3 ("x86/efi: defer freeing of boot services memory")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   arch/x86/platform/efi/quirks.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 35caa5746115..79f0818131e8 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -424,7 +424,7 @@ void __init efi_unmap_boot_services(void)
>   	if (efi_enabled(EFI_DBG))
>   		return;
>   
> -	sz = sizeof(*ranges_to_free) * efi.memmap.nr_map + 1;
> +	sz = sizeof(*ranges_to_free) * (efi.memmap.nr_map + 1);
>   	ranges_to_free = kzalloc(sz, GFP_KERNEL);
>   	if (!ranges_to_free) {
>   		pr_err("Failed to allocate storage for freeable EFI regions\n");

