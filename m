Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA6E7081E
	for <linux-efi@vger.kernel.org>; Sun,  5 Apr 2026 00:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775350198; cv=none; b=Xibj9l5S2wLxOWQyC1j18qFfYHnufyCOp/Ks8OH0IqnYGutugkwpLzlQ9KPaYZbyfnSJNa6rBhFSz3s/RzaSopgmUFkFW/4TLTN9nUB0h01vQV0WeLp8IuKFWTYZ+DXy5TEuf0Nf03j7FRm6teiuZg8lkZKPIMS9wsdvLK26Q+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775350198; c=relaxed/simple;
	bh=u1oHYC5yROwISMhk5CBV5ZrM9e3kS91wlXnq2cd18/0=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:Subject:MIME-Version:
	 Content-Type; b=Q5CKz25+KIn2jAU0y0ygPPlUKJp1F1akibKtsZEvQSP9GEtYl0C3Cq4PIYtjgKjOANBm1ejYtb4LvQ+G5hrvW4iVe16n1vroQpG/HJjXbATMmEoaHmpkpTkRRyuOMwQDxMPyC8Bib1FwJuBq62iuuPO4MylAQYzMz5veQOV0bug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T7OHXoAC; arc=none smtp.client-ip=209.85.216.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T7OHXoAC"
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-3590042fa8eso2021231a91.1
        for <linux-efi@vger.kernel.org>; Sat, 04 Apr 2026 17:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775350197; x=1775954997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:in-reply-to
         :message-id:cc:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rv4VwX6IEXz5Pr+sT6c1/lwCCI3YuOIYRFVj57sG0Dk=;
        b=T7OHXoAClK8FuDqCOAUYYzspVlOJtREQGSfX3h0mdSVwSXoVZp8ghJ+q1PNNM+L5L0
         KNQlryEwOe8ijLKELkqlW9ih1mU1AygMZS+XtVmiO9r58OTQgi+HwigcY5KU+4z/q8EV
         M7mThntjTkYV9Kx6O/6EFaS/hNHMmpads8Ouj1XmbiTjHAKWKCIKSn/W8uJE3uoeskK3
         Jcov62LhZOtUxLSZmERFgcBoua/YXsVgUMUlQD9vXYnq0dRLo8MzHduS8zO/iF81zrBS
         05hDXtQdymtZAinwmW9jhoNPJPoU8oicT2ueNXZ6F+9Y3SDKZspgzc+rpZ3Zg3K2b13t
         eagQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775350197; x=1775954997;
        h=content-transfer-encoding:mime-version:subject:in-reply-to
         :message-id:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rv4VwX6IEXz5Pr+sT6c1/lwCCI3YuOIYRFVj57sG0Dk=;
        b=YT6YuyVITL5qf5XDpBXHpW4SIoewSxIizauoXjvxQWeYLWcXeaKwGXLdRKVBy8fWoW
         ycBP6uHKeTkfVvFMqvhsImb2/KnZdEj5/njiy6tFdNrfFZltk3LJcmGTXF/mHXVN7pZ4
         3wgIVKBeWrpN4AV6aFYFvU9ceKGkCDQC4Gl0WNaQO1dKbTtNvAatLRTTo3sbDAm50lm6
         Qs1hHyJ7PYWPaItJ343MiamZINbnX8yEBr0wrp5/iPzWy7/wV3xIYfQNxgt1fQ/F8rsO
         8OqzmgzI+toUW2VhlKWK9D7HgyskVPIyscePOygLO4j1noY8GgQoI5HtJ0g6fvDrui9g
         enOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSsMUK2A4MufYlzbEsrgwFFHeLzo7xrMqKCiImtbkR8xqCAjpbbYM/+PLZGzRdcdv72q8aBcmwYs8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5hm2I/Mxr3GoFlfFOlSXE1Kgbrdl3Elkxahm+tfyteVyZ00cq
	MVXnul+7FqIxP9rvksaF+gkhOtbc32W4kJeOWsyRttTS8THrzYjGYFxi
X-Gm-Gg: AeBDievbEWXBECblzP/IYOHKQVDfEVRPblJLv1bgV8nBn3/3aPGmQhO3DqRNaYdwOY0
	mIRxgn2lj7QuxKM+dOxNQXhpZh1Qp1ya3b4DeGhrUPqXyuSBTLQi822QeaKCHhx4FgSKaCPvT5S
	hCS08NKlROPoxYZ26y9lMFHMLcDklcznuW5w5MMAs1br3fgOqU1DX+Q3g+mHw3BI1NZdgMiFw9E
	Qakz4W2uT5pCjVRyc1FfEn7//orSQsJWL0Ndd3qdu1lRwdw2ivWw8KQlWLIRhrUVEmi20zF0SGv
	3/lLqe8nqXqkUaUAPe7jhhIuVcu94Ba4ezrJheqq9DzwAZBZR90r18moBV5qDDYK8OjUp8SQ9HE
	dF5LBfF77F503XmX451JCCgdKnNWqqZlApiMfTptrR888d0SXIHPjLS4yIxhe9yPoWioO9YoZJS
	GHYjUXfgqZXcrgARE9kqLSpHfmDWUV7hU36w==
X-Received: by 2002:a17:90b:3805:b0:35a:1b43:dff1 with SMTP id 98e67ed59e1d1-35de68757c2mr7161556a91.12.1775350196859;
        Sat, 04 Apr 2026 17:49:56 -0700 (PDT)
Received: from [127.0.0.1] ([142.91.102.47])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c6476301sm8736118a12.5.2026.04.04.17.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Apr 2026 17:49:56 -0700 (PDT)
Date: Sun, 5 Apr 2026 08:49:47 +0800
From: zhang <zhangweize9@gmail.com>
To: chlor@schou.dk
Cc: ardb@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <d5415782-362c-40d0-a7df-6533c0cb0a86@gmail.com>
In-Reply-To: <7648e713-ddb5-e42f-c715-73c097d196d8@schou.dk>
Subject: Re: EFI stub: WARNING: Failed to measure data for event 1:
 0x800000000000000b
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <d5415782-362c-40d0-a7df-6533c0cb0a86@gmail.com>

Hi Hans Schou.

I just searched online for your situation and found a post describing a
very similar problem.

Here is the link to this post:
https://forums.opensuse.org/t/efi-stub-warning-failed-to-measure-data-for-event-1-0x800000000000000b/187812/30

One comment in the original post reads as follows:

"i was having the same issue, the fix i found was going into the BIOS and
turning on secure boot then in the key managent setting of secure boot
clicking the reset to setup mode option then turning secure boot off and
then save and exit, if this does not work try restore to default key
option."

I think you can try this method; it might help you.

The original poster suggested enabling the Secure Boot option, which is the
operation described in your email (step 2).

If your kernel version is 6.16.4 or higher, that problem should disappear.

-- 
the-essence-of-life
