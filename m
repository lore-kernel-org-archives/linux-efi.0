Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795147367;
	b=JFjDnpDn1tksGxdsVpR/KYWtX0h4b/6snJTDYf+j+rDqt9dzsV+3+SBZmnZ4pogM8TUI
	 WLe+Hs+TerUQQKZvABX4/5/AUw6/EcDRxuPVdnvjK3DQUhbi7tEqwIFkHFfX/tbBHU3zc
	 PXmASy0EivjFAQjasDsJ7Hs1vKGZKNyexh7dXX76exOhufTXDor5vPfo8SDvr5Aij2ZF1
	 eIOCTPSIOTq047xKQMSCQLMySLEysNWDkyVz4O3wFK2jiLlj3Dl/6YuP+U3DzAS52dw3H
	 gDprH7evqe5c8gBh3tKRzJwrhfvLsqOzcsDM7VpC2LWoa4hhxOquX+1tcJfW9EEXlVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795147367;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type;
	bh=TRNzUGKd2wKrR1v2ESH5QmUc5jp75PiKHVdd0VEreo0=;
	b=mobl+fuTy8qBckC/Wk1vUseQVKHIM5VFFV1yS1f5++vtyU5h1+zn+1v7HzdsnEdM56GI
	 2EKW2T3i1tk8cjfQ/9hALP60MB2yeiUf0dwya18f36kX4yOj6+xttcrM/eKHjMhA4puEH
	 9qls6NZatghy4SkOaqSvgjDNKlDZNz4W8rN4hsqSoXsG0FqmMASlrNGlz1ZIc5F9H7ftN
	 uMFnfMc57vdbrenwkwT0SNPULqwG2Iwc9KbBoaXjyXcydlAJNgtM2DrJPVag28JMR1Mfm
	 Ec5eLGdlhCecapAPfl7+CPaAg19q1M8FiHCtzRHDd1rfd2CghM8mZi1KyNRWGehzzKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SX+AD4Db;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508E4606A326
	for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 04:02:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 508E4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SX+AD4Db
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-372bdb942dbso580541eec.1
        for <linux-efi@vger.kernel.org>; Thu, 19 Nov 2026 20:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795147366; x=1795752166; darn=vger.kernel.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TRNzUGKd2wKrR1v2ESH5QmUc5jp75PiKHVdd0VEreo0=;
        b=SX+AD4Db4u/1rH6+ie25tXW4GxQhcJ+O567ogQJWIeCaFFcC/wn2bFB3i6t3NXc0dJ
         hZu+h1ypxP5/NGOyu+4Ww0lhN8bPxmwAcjj22EZtnZl7dwma5YRp1wT6ZeYSJAMkOnsn
         UoWaZp9jUk9ndt/Fcnll7b19qg4bI7Oz/dNAewKOdLWw98vZfCyG2FSI1izfT9xb5vYY
         M4a7cNk6VAQFIAtRUzsyMIkHENyeZ070KmFrn4V53ml6sdtriaxtgmSfsrt1fQIctx18
         JdgFT6i6v3GTuz5jgLdX+wC+/vO9J6hP6slNwKx4UGjzsDmrPwkF6jup7f6xUsbCy7/Q
         2JkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795147366; x=1795752166;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TRNzUGKd2wKrR1v2ESH5QmUc5jp75PiKHVdd0VEreo0=;
        b=EwKoIBLIBaH/kJVjf5sF5s4deHF4JTKzQPcfZLt/uxxmb0dHJY0A5UyIqSzwL0s6+M
         kezDu4G7eDOmzsLoJqoZgu47AVaObIAVv33JU1tpxoqA4RCpWK+Io677AFOXOdw+O+4q
         0ga6w6VoCIUvZYVALBZuyjGhrk8LGr5K78Yy2ny/j7kEV8+irYOKfkdQYOBqvWPlqD9r
         0qhY8CpsVS/2GP/YUc6upXHroUT/GWt7SXlXNPtFY1d8HTVNi5FysygmQ54Ttizo4KmP
         y1eKUKGdS71CFeL+m8Fy3J6zuc232yAdKtg7SmBbCaDInb7MRSIyzPyZCQZa2Fz9r1Uk
         kL7A==
X-Forwarded-Encrypted: i=1; AL+hErEuIsdIU87iZvSmicFRm1dwFcikNuZNRXdXzmvFNzqevlS+osETWj1yF+vW1OjD5ox4EkKMfe2TS28=@vger.kernel.org
X-Gm-Message-State: APuU4Z8ZFIQ3+0nwsJ2FtcLRJsY+8T2f9/tgASxkMIchtjQBuZJB7nsd
	dwWJSy4ZTL36Mv1V/jxOWqLLxC95VGAp8XVkBsgg2fHFmGaz+/8Cjv/c
X-Gm-Gg: AZFdTZcWE7PGieVhc1Vn25f5GQrhEbU3Ps3XXJBvZL+5p/DU8Zt7qy/83qvHnWe2tLl
	DRL+W15DqNV+nlqnVeu3AwOeMmnbvc1X/CXgZXfkrW883c/8I14guRVFudtsoTG+4cp0xErtzaY
	e4j1xqDCwLh9jeVDv2DJxzyzLtQ03kPIMhVl0uVQmIRKAuSGGH5CvpXcQaw1yodiHOlV177vJJr
	r85LOtIR8Whu+7mLBJ46Ap+kbpyjbWXJupkCi39tzFpbLww84MfXZEdNGSnIFuzTDgD3cEvqqu8
	/wXIDM+0AQPuS66OtBnfaM7jhedIJNFqC3pMw+ePIB5T8Frb80OlAG7hBakjs0hBMh78YeAMiAd
	CC7CPARD+rmp7bpaR7XouHchTJukh2mN/D42r2uS5GIpB6kg9xN8/PTIJMW2O3hkdHoY/3uxa+b
	MNgtrR+bBiSUbcluJBKqZMQUM7qhK4H1Sbl4XKGVOxAHLNq4HW33v55yYYfWjlBvhPowCIRsL7y
	fBUydF+jyIaG8R5wMkqo0pEYYB8RwcPtO1MgfT6BFiWqdaiKeIQ1Ld8Z3yGKfH5N2CfENRkK5Qu
	RjWNZs4twe4LGC8EUf14cCVe2/jdBLDLqTB3LQZTEnXw3/RmlG4Z0tH4HPAoEdNA7j7bqSmzfq1
	082ob867MqlY=
X-Received: by 2002:a05:7301:259a:b0:36e:800a:71fe with SMTP id 5a478bee46e88-3856c4b844cmr1448219eec.1.1795147366198;
        Thu, 19 Nov 2026 20:02:46 -0800 (PST)
Received: from DESKTOP-7QP7L26 ([45.190.211.142])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567cafec4sm3663071eec.26.2026.11.19.20.02.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Nov 2026 20:02:45 -0800 (PST)
Date: Fri, 20 Nov 2026 01:01:56 -0300 (Hora oficial do Brasil)
From: dev12124 <joaoanandalima@gmail.com>
To: jasmeet.bhatia.us@gmail.com
cc: ilias.apalodimas@linaro.org, ardb@kernel.org, rafael@kernel.org, 
    pavel@ucw.cz, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, 
    x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] efi/tpm: Preserve event log without changing x86
 E820
In-Reply-To: <32909f9cc196a161bf380b6f64603b75@gmail.com>
Message-ID: <be1f79a5-6685-7188-9e79-05ba7acb98a6@gmail.com>
References: <cover.1788259938.git.jasmeet.bhatia.us@gmail.com> <a9e23066-aa75-44be-ac3b-9a15f4cf6047@app.fastmail.com> <DL6NCV1KQ9F9.6K6XZQCS4AF3@gmail.com> <c3ca811b-a6eb-4f4d-bbb2-4feef02e3db2@app.fastmail.com> <CAC_iWjL9jDsRaU7kEemYfwk292Nxa49cK0Rq=81pC=FWNRDhvg@mail.gmail.com>
 <b66f68b5220ddcadddb41340d3ea3388@gmail.com> <CAC_iWjJ1L5MYWy2vHG3AHYcfqx7urJmaTYP7vuyvZm8GSnWCDw@mail.gmail.com> <32909f9cc196a161bf380b6f64603b75@gmail.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="317403-16462-1795147365=:13716"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--317403-16462-1795147365=:13716
Content-Type: text/plain; format=flowed; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Hi guys,

I reviewed the thread and I agree with solution: Discard the TPM Event Log 
in kexec and resolves the hibernation issue;

Is a good solution.

Thanks,
João Guilherme da Silva Freitas Lima <joaoanandalima@gmail.com>.
--317403-16462-1795147365=:13716--
