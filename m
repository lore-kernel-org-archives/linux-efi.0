Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827758;
	b=aFG1G/Xq20hqNT40JSzlWMm4p2vYxDyHFjOuT+Ve8QHTspSdJljHyAkWyjY/ip0GZS/3
	 xjeRntMBd4COOWngW5jkDMvjmLN2VZRLwLdd6xk5aqFmBw2Ct5nCMyaKYT427CH9iYgKE
	 KfILYXGORyd0V1M5rTlTyhMrF5FOald4Xe5PSB2Qv/9fgWCSmFBSzYRUOVAuIkPU1x1eB
	 GWR72wxUyRWe+X5l2Z3PygT43kknjSKZM+cKVIHaTEotgl6S0/ComfJ/5hnWbbJVh99aq
	 cPbVyzWOQ4BnoJoB7Z4RKwivPy73hlh8OdyUtkMrGXAiAwsDJkI4IdYTtUDO0Ftmdzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827758;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:In-Reply-To:References:Date:Message-ID:MIME-Version:
	 Content-Type;
	bh=pMF2p6YcO2QVMQMOY4bKoxrfiTZxHw+eFJxoGmwi4ZQ=;
	b=nZBUW0ZotiMxckhlLPa0U5wfjaI28VOrNx45Apt4Crgbuz1V65P9Dq/oJOtBXDQ+IGbK
	 jcD4jgf8weG2JjIMMhBBI9o3usbLTjKlnxWhzvkvE/RLU6WD3DfKFpQmsmEU5kVCZ625+
	 x6ukDui2tbAbGb/Vo8I8RokPP6tmobhmYg7mpc/Uxmwrsw6O8xTdvRG7x42P+eTqa+OaG
	 PauNff6HS3ALqVh89ABEOFyDBF7qCKQFD0ULjCKUeTnP4NFbVsr1CaBtgOJXM0wEolkY8
	 WbYTV/bjJhR/+xFP+CyK+/xqV2tqAAs49qqn/m90dJeuZCN+cVbFfjHMZvCDAj61hiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="jC5SUq/5";
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=N3hx1Pt1;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D38B606A8B1
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 11:15:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D38B606A8B1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=jC5SUq/5;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=N3hx1Pt1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794827756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pMF2p6YcO2QVMQMOY4bKoxrfiTZxHw+eFJxoGmwi4ZQ=;
	b=jC5SUq/5vuITv/HRjyu1h/sxmjzoM6c2YNxeFbS45cXk1gUqFfKZh0lb4C0+Rhe2ihi+E4
	1fh8bg/8lk+vTqnBfLYW0WMXYedWWGYdHiJDfB0KqAL0xlY1b0KKEOFo5mV0AZgjLeKUqF
	HwluBuO8cA5FCO4cQ7FNmXVGftC8FTc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-3xI05k4lPze6xneG3CvxbA-1; Mon, 16 Nov 2026 06:15:55 -0500
X-MC-Unique: 3xI05k4lPze6xneG3CvxbA-1
X-Mimecast-MFC-AGG-ID: 3xI05k4lPze6xneG3CvxbA_1794827754
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4bb67b2c00cso6251455e9.1
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 03:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794827754; x=1795432554; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pMF2p6YcO2QVMQMOY4bKoxrfiTZxHw+eFJxoGmwi4ZQ=;
        b=N3hx1Pt1jv9mX2bZ2jHtSWbPafhktII65uYXOMT6jdQIVQlhmlRhN8pqFCK0ME1rOk
         aut+QIr6rzPOMZ8CAXwReqY3ccZ61IsgeTnfIJFcPBBhiyOYjtV6DfeEWMScFSIY1hfQ
         GCd1HhRC2ylJVryiG1oe4WqI8dle3QmUg3lKtTpqGXlKGIIEdxIFhKRXyzUgKxqRpPPs
         XNjb17jSImKs9//le26w5/mrxuGiNsDqv1duBXBDqui7eisMUqWPSr7VCF395nT0OvjO
         UVYKGySQAFJPh5y6lsME20sVVhWxhyUdFyaKeCg+COUU+ju86ndcAARrM/AoRg4s6etd
         NMsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827754; x=1795432554;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pMF2p6YcO2QVMQMOY4bKoxrfiTZxHw+eFJxoGmwi4ZQ=;
        b=2AOJsVu2fBGkKJWv/NaBEBsMWON5+Geecb/BYR42OTES7DUfPevMzQpjjw1IPgr89L
         jVS826u/ZRoARVv41EEswrmNIRwWdcVrmb5Xpw1EV0fAdrERCmIMEKCVP5EoBgBZMLa2
         Z/tUu2tBRHq5OY3gvMWMivkwK78ePqmj3f1ArINQcrl4em/xhiXJkEr0iZsRNSG9L9Kh
         xhd1bNYUSTwNjU823MF0x//fsTVbUTT8yFkAIIuRhWXWTYbTpKdJmfPUL8cTxWhukNOs
         YqNIEi9cdATnMkH8G1BUU8Kbsg8rbOMsBAHU/mr2dEdkRBD8OSvLEfI6XUcgiNktqoCF
         PtkA==
X-Gm-Message-State: APuU4Z+NBkDzREF8zdIEJrfaKKdda9HrqNcGs7Ib3U8aPtKCY64PSG9K
	Oaqz1bxPBgcbQyFot8ZDK2XQ4+CATLFxxn9Ch3asn9HZpxXxrLbsywG7lbJP97CEpQ28DMPEX+6
	s6dUTluwBEKISTNe9WiQ9krmbudUvIVb9WbGUSu3pEl7CafM9aTlhDeZbZcAGnQ==
X-Gm-Gg: AYBFou1dRBUs2+EkVmmwiTI4voEYJZsoX9pE0aDMfiWkuvZvvbqjGCgIP2SQZk2uwC4
	5ZbI9u+ugFSZ5w2CTiVdClXyZYoVsp/izmoLUsmV8j8VVUIItJolm121q2HkTXA/47D3gtAATMh
	hAOnGyoJXYLlv/UOIrshaZhrAzbOB64y5XmzCL7lyCLrBLZBKumpvS7UHgrEGyqu8Z0OyJTZGyZ
	VUIY9GSaY8Gq9awMraZ7TU6Z/4rbaZvkZcCE9uzoX8I5V/8E+9Idq5emARENpSHVyqMTSSF1Yeb
	gWEw4FXqSq82jCr61so68K5z8CEwX0548u0ehJEOe7Ur+40DCMLjobVePDUNwUrATj2dLeeglg5
	s3+OO4arjrH/Q88sBasjpWYM7NyFXU0ZUvzbdPEqlhd6oxgUnLVUq6LcsW5bZslNw26rEq09Zb/
	59Y4MP+01xHRmueq8hpR3rqQPFXcJHlyaqCvyPQFE=
X-Received: by 2002:a05:600c:4f86:b0:4bb:5fd1:92aa with SMTP id 5b1f17b1804b1-4bb5fd19428mr163024045e9.15.1794827753814;
        Mon, 16 Nov 2026 03:15:53 -0800 (PST)
X-Received: by 2002:a05:600c:4f86:b0:4bb:5fd1:92aa with SMTP id 5b1f17b1804b1-4bb5fd19428mr163023445e9.15.1794827753292;
        Mon, 16 Nov 2026 03:15:53 -0800 (PST)
Received: from localhost (62-151-111-63.jazzfree.ya.com. [62.151.111.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb666a3ca1sm202154675e9.9.2026.11.16.03.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:15:52 -0800 (PST)
From: Javier Martinez Canillas <javierm@redhat.com>
To: Thorsten Blum <blum@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Vincent Mailhol
 <mailhol@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Thorsten
 Blum <blum@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efistub/x86: Use struct_size() in preserve_pci_rom_image()
In-Reply-To: <20261108152835.20294-2-blum@kernel.org>
References: <20261108152835.20294-2-blum@kernel.org>
Date: Mon, 16 Nov 2026 12:15:51 +0100
Message-ID: <xlv1a4n9rpqw.fsf@fmartine-thinkpadx1carbongen12.rmtes.csb>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Thorsten Blum <blum@kernel.org> writes:

Hello Thorsten,

> Use struct_size(), which provides additional compile-time checks for
> structures with flexible array members (e.g., __must_be_array()), to
> determine the ROM allocation size.
>
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---

Acked-by: Javier Martinez Canillas <javierm@redhat.com>

-- 
Best regards,

Javier Martinez Canillas
Core Platforms
Red Hat

