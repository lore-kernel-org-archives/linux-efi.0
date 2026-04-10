Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B523339F172
	for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 11:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775821003; cv=none; b=rBLrR6g1OkMtq55GSXiZClRk5wl4/62zP3zmevNrVxBfHNjUIc3AfyNVJcq1voPn1nXRqkWN4bgg2MGDa6K81TRgmn6KgUlS7JXYy6c9+cEVYZkgYmWx/j1cqSEzT35gPFn9f9tq6po8S5Gov1XY9HsR0+uoeGGRt0xhdMdZk4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775821003; c=relaxed/simple;
	bh=v60A9nmrd17F3sLLIDwXCi5cXBPWYFtdBJFk+o2VYFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RsB1/ZPTXDJ7vzHIRcSk1aqQ2zEYe1eo2D8lUlv02YRtkEnNb7t25kbw0wNOX7dqxSLoM8r0Zn8/b5eie9xL2+843hDb60IKIDf23mq3UD6l8jo8/5neNU6FyfySkznG3NPbQm6B5MVq8Xjouiacv6zR7+fCfJPa3ZOWUVevyZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CgeXqVFy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sTPOAjgu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CgeXqVFy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sTPOAjgu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775821000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5HZeha/D/5ppXDBmJvEjjwoJZpkNnriOytUM2YyarTs=;
	b=CgeXqVFy5o4pegKYEaJ64HA6wY407GEunBUs0EjAF6xtqa9Z+tOTXPEKWAtI8SM4fEVZHD
	B7vQY2HqPAZP3l4IeWoVF5qHor1P499GAptTUIHtMlCJKuBmFnqkGkgRr2QI9iKGI5+9Vf
	Ij3I8iSBfuU6Wkvm0EMHYiMx9l3W7Uk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-tIOKneiMPSqU9uNGXoy9Ig-1; Fri, 10 Apr 2026 07:36:37 -0400
X-MC-Unique: tIOKneiMPSqU9uNGXoy9Ig-1
X-Mimecast-MFC-AGG-ID: tIOKneiMPSqU9uNGXoy9Ig_1775820996
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48378df3469so13878425e9.1
        for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 04:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775820996; x=1776425796; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5HZeha/D/5ppXDBmJvEjjwoJZpkNnriOytUM2YyarTs=;
        b=sTPOAjguiFERV2MpOkAOuDCz4NALxhEz0t7CsZvqUBcg4d4FTtitSrUUoCeKq2LakZ
         WOLJS0/3q5Xchg4XpjhqPoamx3tKxEXZ3qlxhwxEI/GWD71QfnE8jaU8E0YuSak+mWR1
         pxNd8S7c/69UaY5dEyToyeWMsOCSo1eNn/QmZInD96YMW/LlTJIwcaiw4cL/HgOsIeEW
         oaP5VumK/KN41kpdfdQIlvrlShMXXJBq0qtLSgYAu5CbJSPIl/EIPqS2QqPjUztcAjOe
         VeJoEfwpP5n0Xtx2QuQxYxe9mcpRmFWx6YvrKdGS37lLtn5rF/Eja1F8cnSD9l1cBMTy
         +A4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775820996; x=1776425796;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5HZeha/D/5ppXDBmJvEjjwoJZpkNnriOytUM2YyarTs=;
        b=HQyyEv+3anor27RJGksTInmreIyAYyt1JkgfJm6tzGvwRaCs3H1DPeFiP81bdKlZQn
         cJsYXift4xIg2H9NbzuNoCAG26H6PRGbPB6ALB/HfOff7di8u1orLvpyND4Csr7QK9/h
         3qEGCiLaQjpspKx1mQX5i38OSPvp+huhz5vgNkpHwdyyihqK+RGq4opN/VkSZXi7htNB
         ZHU1kzchetALweiMPiqj+833ggD2h0FObymEc+ArZQT0av5y09WyA7UHEN71/UFWEYd9
         mnFIxI3zKW1fIvO5vYD/HMVDnOlqY03yFAzz30dSZBxZDfTe4BNKGxGHUT2I7iNH1+xq
         RzOw==
X-Forwarded-Encrypted: i=1; AJvYcCUftMHHOu53m07gcWjWYl/RT8cENcFsk0yT4wnzVSugZOduncoBAuGW1FarUSGhGi+g7OPXJ4ZzdUI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKnh5Uh74m2bquZvfmToqYuaZcKmMrALR95okx/hDrC2Kg7xYR
	CZaZJuCEyx4rdVthFFBwfLtAOkpxvSahGZW8Hd4drDrGgArPmLU7rPhP/JhiODuFBidwl8XwAV4
	9T/FLmfkVXhOhAudu3oOpf0YVsV2njDLSMOJxkY+C1kNRMQIo78mR4uqsOiVYpA==
X-Gm-Gg: AeBDieuNRY9TgG/mw9yx228LPkQLaCdpyaFYeT6tqs51oxcv5PEUNv16lM3J34Ft9T9
	kR2v9IreOYIQ0fa7duWrXtbvp1OiWhv5B9gJcK0JtgipBkDewZw4KmkI5BmOwfApCaPjhCbK9Wg
	tgfY0PHPz3vMU1UMQ1jasGnjSERga3xfZqCLfhMLR+CK2AGxnMWFo9Xdt6JhYGT1YJ06NlAI6hJ
	9cgv+Nbf4lhTphJ+/UgZWUhvo1hPkNmw5DSWQm8KlEHWsXp4WBk5hudO2OfB17cQsiIw02esZKB
	L/qH4JwKQ5M3MCy+2GqAsq5/fV9EnBVpHG1GgXiPmW/LiyGIknhPJOpUMMajpnyViuIp5L7fK0d
	gKN91tQxvPGacevbTeg==
X-Received: by 2002:a05:600d:8496:10b0:486:f893:56c6 with SMTP id 5b1f17b1804b1-488db8d16aamr1686055e9.10.1775820996016;
        Fri, 10 Apr 2026 04:36:36 -0700 (PDT)
X-Received: by 2002:a05:600d:8496:10b0:486:f893:56c6 with SMTP id 5b1f17b1804b1-488db8d16aamr1685785e9.10.1775820995592;
        Fri, 10 Apr 2026 04:36:35 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.114.56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d58bf10fsm64482265e9.8.2026.04.10.04.36.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2026 04:36:35 -0700 (PDT)
Message-ID: <665b4369-b322-477e-9ca1-2d83490a7c4b@redhat.com>
Date: Fri, 10 Apr 2026 13:36:33 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] x86/efi: Drop redundant EFI_PARAVIRT check
To: Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 Ard Biesheuvel <ardb@kernel.org>
References: <20260410075950.1687350-9-ardb+git@google.com>
 <20260410075950.1687350-11-ardb+git@google.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260410075950.1687350-11-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/04/2026 09.59, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> efi_memblock_x86_reserve_range() exits early if EFI_PARAVIRT is set, so
> there is no point in checking it a second time further down.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>   arch/x86/platform/efi/efi.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index d84c6020dda1..b60f8454a1ec 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -211,11 +211,9 @@ int __init efi_memblock_x86_reserve_range(void)
>   	data.desc_size		= e->efi_memdesc_size;
>   	data.desc_version	= e->efi_memdesc_version;
>   
> -	if (!efi_enabled(EFI_PARAVIRT)) {
> -		rv = efi_memmap_init_early(&data);
> -		if (rv)
> -			return rv;
> -	}
> +	rv = efi_memmap_init_early(&data);
> +	if (rv)
> +		return rv;

Maybe add:

  Fixes: d85e3e3494078 ("efi: xen: Set EFI_PARAVIRT for Xen dom0 boot on all 
architectures")

?

Anyway,
Reviewed-by: Thomas Huth <thuth@redhat.com>

