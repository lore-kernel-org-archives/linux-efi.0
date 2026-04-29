Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E5B32AAD6
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 06:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777444665; cv=none; b=ocxf8a8vR1DbtGkPWAmiiRtQuZJTB8s+8/QpiqaRsRBmkA5i6TlON3t9A6/WnjEzcGUdg1OOJCHkhA4m2xCGlnYf+qKO9R1L3zJ1cF0oK1VvuQ3xDHIwUvcMh6cPSBjqS87zsDgL+M9NA0gv3nCw/yrrKZJ85k2dPMlGXiYEFR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777444665; c=relaxed/simple;
	bh=iOXaQ514kBcEDtFcOaV3iugutGARy7Dpow49t/f/tNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DFVHPfOr7rcw/ETwBlWgjJRQsaK+wK1UxBAp5k/v2pB9vveemlxTrUnoATayHlzT09Y8g0ytAqANxZ2hRFSKh+OXgv1nsyctqyYHoWm12CNgVOxsmPncmpQfhBxm7ei/bC5tPCl3KhasDgJBR6eT/YqPDuohXzQunSXvfH/tsNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U9omDo/V; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sYh3G7Kp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U9omDo/V";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sYh3G7Kp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777444663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AeZYr2fCdGK0VNHoyjQr2Nb6AVscYu5idnpYFGj9I6I=;
	b=U9omDo/VcxqhPZB0GRN+Q/aYgAVIFYIC3aKUZbMa4az6jbIE1gROk/o7HG+imoBT/K03h+
	IvBKHfVaN7V0Y8uH7rs38uPyWDWucJ0+U1iIezf3pg+bexMQKuPM6PVWRs1quErH5GC76i
	u4b05b4uRGJerpt9HEHEgaJMJWZkGvs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-JshkDJJqNr6ra0TcJkqOlA-1; Wed, 29 Apr 2026 02:37:42 -0400
X-MC-Unique: JshkDJJqNr6ra0TcJkqOlA-1
X-Mimecast-MFC-AGG-ID: JshkDJJqNr6ra0TcJkqOlA_1777444662
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8f30b09dfe0so1239880685a.1
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 23:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777444662; x=1778049462; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AeZYr2fCdGK0VNHoyjQr2Nb6AVscYu5idnpYFGj9I6I=;
        b=sYh3G7Kp6UvRqhgtGgUmWEqnhCk3HVuzbRBMA47VhhUvzFljja79IlE/FJjKtlEAmv
         aJ2/47/qbNaNxwEHM1JP2xJQN6+0IuogTRE5X9O2ZkvJux48umxjjWLtlicMzMPWFYLV
         aV9CaNCJNfl6cuuh+yFDwW6HLe/CRHN4diMbPAHuE4H0eq6GS+LPZNv+KWqdsqmmOpsk
         t96BeZ05ztC4gfQSgsGBJ/HCPQhKd4NIuRtpeycplqy/4J7FddN74fDqyNqWbXtXyk/a
         bfbMoN38hnbQERhi+n6pdt1bpMgWk1gpqfoUZMIkJD6idi9Tek/daFhuZSO0Llg2aKm2
         7TTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777444662; x=1778049462;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AeZYr2fCdGK0VNHoyjQr2Nb6AVscYu5idnpYFGj9I6I=;
        b=m46+BvokfoJ6LrQ7FU6EWqnIWHPTMN1HP8EqUR02s5Jew+ayBFUP7CzAwrtLw2qdaG
         DGoDRaxkc4kzbVMSMStuVqTM0U4LKz3w5e4mqAf77Gm1m+L3168EGqT9122wltKX+VmG
         5y6sRnCJsEIR3Nn3hq7VJdCB/owJV4on09gOM2C2Q3YrP8vtTUlaS1EcOPr4Yy4HohHJ
         uMJK2zQqTVwLVzM0BH+34u+l5gcJWoFnkdtAP3vWMdAsei6rM09hc+godJuF4OTtSgXn
         adWX2BPEGYTT9d/GECckWcJSJkreO892uvXInCgtA1AirN9do4RX5uUcSG3gGrE+K56w
         6SZA==
X-Forwarded-Encrypted: i=1; AFNElJ/TL/mGLriW5LxxIXvWGXUwmXnUQcouXQEf1aNqFQWS6b+9SkBfTRUjyarWbkgOmpsAMGFsNEW/ARI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJjc0BE5WYi4SEMv6NHMXenQC0rG2107Oq0a3DNm/7AG2gngOQ
	FYrXer7F/b6XMlAdWGKzu/JoBQE3ihhdS2U42sxSWGUA7oLA70yaCvV2eJ8YAj6DatcdNEQGqns
	vhfK6Pl0ahxGK3AG84cr9XqzvvVpC+6MVmCyLbrFCsUOmLE75636e43CrCdn5wg==
X-Gm-Gg: AeBDievAFFscEHL2tW3ltK5HO5mUBcBtiMknMp5pu+lQWjtC7/+56knYofBFWDA3dcq
	xaIYHHvvwH5wTg7OYyvPbyGcfutpfTOXyT3MfXE9sw1ZR2I/DCt6pzw5pADoJEv0E0Lg6QEP1OL
	8uJAcf+myd+uwmSUac2Xtzn7wQFg68BAd1aYVG9xTwHAwMVHseWxWrEdKfGkZrjp1hmzEdRKTaj
	ZzCR1yHBs36mrGf08Muq9MvmEJ+suHxaDKmZkWFvk8iTO3h2ilEZ+zOdJkyYBWZMfa/n5MyDAJ2
	DudFDKUFHgZMHzApuqLPApdMAPF2N8cPqLKo2MXiT/OLlLEGi0aXTw4hMmZr6Yl7PksNuynCs3g
	1oEiS+Ao2RJkEccfcaQZMF4j/v1kgLlixkwy8b18uXZ/WuVEv4sjsXMZZCQ==
X-Received: by 2002:a05:620a:4688:b0:8cf:dfc9:c09c with SMTP id af79cd13be357-8f7d6e43f9cmr916884385a.10.1777444661605;
        Tue, 28 Apr 2026 23:37:41 -0700 (PDT)
X-Received: by 2002:a05:620a:4688:b0:8cf:dfc9:c09c with SMTP id af79cd13be357-8f7d6e43f9cmr916882185a.10.1777444661171;
        Tue, 28 Apr 2026 23:37:41 -0700 (PDT)
Received: from [10.33.192.176] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8f93c80adadsm107110285a.5.2026.04.28.23.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 23:37:40 -0700 (PDT)
Message-ID: <2b28b579-846a-4da5-8e67-f4a633c81714@redhat.com>
Date: Wed, 29 Apr 2026 08:37:39 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] efi/libstub: Move efi_relocate_kernel() into its only
 remaining user
To: Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, WANG Rui <r@hev.cc>,
 Huacai Chen <chenhuacai@loongson.cn>
References: <20260428170608.3561937-2-ardb+git@google.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260428170608.3561937-2-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28/04/2026 19.06, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> LoongArch is the only arch that still uses efi_relocate_kernel(), so
> before making changes to it that LoongArch needs, turn it into a private
> function. Move efi_low_alloc_above() into mem.c while at it, and drop
> the relocate.c source file altogether.
> 
> Cc: WANG Rui <r@hev.cc>
> Cc: Huacai Chen <chenhuacai@loongson.cn>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> Unless there are any objections, I will queue this up and rebase the
> LoongArch changes adding efi_cache_sync_image() on top of it.
> 
>   drivers/firmware/efi/libstub/Makefile         |   2 +-
>   drivers/firmware/efi/libstub/efistub.h        |   7 -
>   drivers/firmware/efi/libstub/loongarch-stub.c |  79 ++++++++++
>   drivers/firmware/efi/libstub/mem.c            |  82 ++++++++++
>   drivers/firmware/efi/libstub/relocate.c       | 166 --------------------
>   5 files changed, 162 insertions(+), 174 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

