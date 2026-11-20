Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795135156;
	b=SB8YRzOKLN4G66n0KO/5qLdSxoZ8Fym0GTzjiiY5UHGPOemK7cnPGpRF5FR5zaPrL6yK
	 KPzMYTsLOB1Bcuy9Tv7mL8xh1/MVgKSqi7jZrVwK6G9TOiMwGQTxbFhM83zBBo1r+hpcG
	 A1A95+HkgqWw4u7y37OPrwsiI1UhP/EbBZYLORq6EirXml0T83t0ZnNTa0AKi8VJjPuMF
	 +bOWOi7uzoJxdNraynEmqFkYOvFQ5/70wi1rszCmZR6NFppyC3IHThU9vjmoG6pA7lv96
	 S/LlyjaKEp3+zOxCU08V8KWx0M2JjoQkzLBMfPGudbwOOFDMn3crivqOjqzH+MwxT+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795135156;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Message-ID:Subject:To:Cc:In-Reply-To:References:MIME-Version:
	 Date:Content-Type:Content-Transfer-Encoding;
	bh=5gxwyGctvojwIiXOCGBcUPizSCDvTG4IBxX7KHgzhdg=;
	b=xHDP/KcvJdwuCcJV8Ucd/+yBgleYv43qLy/OgPjKc1QnU4j2TXZqMmoFp62KpS7zs8CK
	 Z4wU+ikHgaOb1zjtUNOo4jY+L84batoD1HHg/7W5I9/DtD1/5pPAVm4F/8B6nH+dp/Up9
	 cAhgYTKlIWUjo+8oCRIqdDL4ebo0ARafWeLUJh4ug6qqzVrbuhYDUeH2z31h/NZWDzZte
	 KKhQlo45XGeyRWJg3yKaTE5tqm1fngzVEK2ezBg410wcPvYZOPHCGPkyDbAIeoUyh/8L3
	 Y9NaFQFjNkL9DcQdCL7t3q6KqsymmURwu7tAMSBKvWgm6Uk+Z1GnsHP2gbPU7hSapBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AXIrbsRs;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3E1606A32A
	for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 00:39:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC3E1606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AXIrbsRs
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1b3acec6677so532125c88.1
        for <linux-efi@vger.kernel.org>; Thu, 19 Nov 2026 16:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795135155; x=1795739955; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:date:mime-version:references
         :in-reply-to:cc:to:subject:message-id:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5gxwyGctvojwIiXOCGBcUPizSCDvTG4IBxX7KHgzhdg=;
        b=AXIrbsRssxXaO3w8GrpTDhyAHBoe8gHl6vr1AgWK/cwk9Q07YyUHncFHncJa46UUL3
         TgmkdDVvNftjYQdNRFgZsqI49nDzWumOSnYxV8wcUZs5Gcnn3anIwpCjKujLDJwmC8iK
         6ZK6VAZw9CgJl7Df/Bzv063r+hBx0B4fidZsdWJ1jC9OEal3iZJMf2BxLf882Td28SIX
         Wz+DJjNddHav9pLJ2ujtZ60os7JcAtjRIXP90PgnT+QSy1hSyARUgJcqpbzkKFaDOm2z
         mIqhczej3xSQrEXsLvf0mbJQVNl2nG2Qp8a8zIM9aNMdpQWUM+0SIaeq3USPn5pQh7m9
         qPFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795135155; x=1795739955;
        h=content-transfer-encoding:content-type:date:mime-version:references
         :in-reply-to:cc:to:subject:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5gxwyGctvojwIiXOCGBcUPizSCDvTG4IBxX7KHgzhdg=;
        b=OFW1A4QcAA5FENW1+/I3bBPNwhaHpVc9PfztA1zqm/uSK+M2GsV5sv+OfkGZTu/b+z
         XdabN6V+gMv0ibcgS6hK8dbM9ELh8Tsq+P85DTaKM5bgB5sgjKYDQDOj6X53KARQFFaD
         qGfSXxGdXlEsB30ERuddhgTqAd6EUOyaurzdypsT2rJLg2fL3c19JUxSKE68fKFBYYeO
         QYL/P1irobPCoEVjw6ot/qx51JfVPaStV3gl7cD0KeGdwhrwEU4aOJ2+5yG1QVFIK/H8
         TchDnGYqE0Bq+2XHtvjDt72RQK4Z7jm8hBO9FmNj1gMRolzdyvzrfyZEqxplR5tE8PdF
         Zx/w==
X-Forwarded-Encrypted: i=1; AL+hErEOn7UX7r6HBsdCV+0SDt+1D/Z4vuDEY3YvMfzlZTocfW/ugHCoFEJKRBek2WN/rpqyunpuoOyfv40=@vger.kernel.org
X-Gm-Message-State: APuU4Z8KOBh5+LsC00XYcsX3CCa1VC8V2HtbTw7Zt3BVT77jLHelnFXc
	SXFW94CdURhaHCPVIs7hM51dx0qUDg7pEatvqYRLYY2JfzzP9oh+x7yT0cst7qSrOPQ=
X-Gm-Gg: AYBFou18Y/YG3DsHwxBT1z4wTHGi5mzx4d0RuNrMRcEdRNrCHOq3OAe9KX7lpBjvTZs
	wP85IuFY2iDaqBx3jb9LwOd4fEIvMGOoWf3JnHdHsJpktPhM/lqo4ES5ideyfCAhlHJgksBNs0v
	p7PHggFWjxZltZtoQ5Oy7VJreQSIL+C34hSq2xfpcciEv1tPHe/REflsXT5XOaWmLcf7k+l5yOw
	ZQ0u4D/tKFwUhniFwL4Vutcq0Iu2ZnqiXad5vF6CDL/LGOvDmW/tny5SnKNWUtD/rG9aWq+8DUx
	1M2wDK/AIdUfMGUFM4Z1PXAdN21gdWy8hER8LorhC4XmcnG9ir1I+LScaxO/Wz85yqe4mJ9/PYb
	KTSSMG8Nk59FY+h9lNEMB3QTUwIZvtn2RjyIrbohvJ7NmAoBGjRbXZ/ZWF37ViSzma0obiSxBcB
	FnVk+BP+tZ7hM5FEOZhWXpRQMUhaFnXes8EPaCySxjfpgLKu9X7iC/hDDktm8WRTH+F0p0wAjje
	R5GhtiQ5JcXYk5fa7vAgNz8u+C+XaQJcvpLoal75/v14Uob/mUbWBCRe3C64yirFBYUUCONLcDN
	hVQVIUbX5yDtdf2Ix4SHpIe3vSWm1cmDOAYfdBDBL19BtOImsAcxO40lMxiVIBlzaHdy6QZnisE
	dej5JJ0cYMSwMrtTkLE8Oajk6FwSjoGBHnJSI3VUbPoCpf+18SZ4=
X-Received: by 2002:a05:701b:4555:20b0:1b5:2988:eba7 with SMTP id a92af1059eb24-1b556947286mr1278313c88.41.1795135154985;
        Thu, 19 Nov 2026 16:39:14 -0800 (PST)
Received: from [127.0.0.1] (ip68-107-67-45.sd.sd.cox.net. [68.107.67.45])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b55682d301sm2184747c88.10.2026.11.19.16.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 16:39:14 -0800 (PST)
From: jasmeet.bhatia.us@gmail.com
Message-ID: <32909f9cc196a161bf380b6f64603b75@gmail.com>
Subject: Re: [PATCH v1 0/2] efi/tpm: Preserve event log without changing x86
 E820
To: ilias.apalodimas@linaro.org
Cc: ardb@kernel.org, rafael@kernel.org, pavel@ucw.cz, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAC_iWjJ1L5MYWy2vHG3AHYcfqx7urJmaTYP7vuyvZm8GSnWCDw@mail.gmail.com>
References: <cover.1788259938.git.jasmeet.bhatia.us@gmail.com>
 <a9e23066-aa75-44be-ac3b-9a15f4cf6047@app.fastmail.com>
 <DL6NCV1KQ9F9.6K6XZQCS4AF3@gmail.com>
 <c3ca811b-a6eb-4f4d-bbb2-4feef02e3db2@app.fastmail.com>
 <CAC_iWjL9jDsRaU7kEemYfwk292Nxa49cK0Rq=81pC=FWNRDhvg@mail.gmail.com>
 <b66f68b5220ddcadddb41340d3ea3388@gmail.com>
 <CAC_iWjJ1L5MYWy2vHG3AHYcfqx7urJmaTYP7vuyvZm8GSnWCDw@mail.gmail.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Fri, 20 Nov 2026 00:39:13 +0000
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi Ilias,

On Wed Nov 18, 2026 at 10:11 PM -08:00, Ilias Apalodimas wrote:
> Hi Jasmeet,
> 
> On Wed, 18 Nov 2026 at 04:57, <jasmeet.bhatia.us@gmail.com> wrote:
> >
> > Hi Ard and Ilias,
> >
> > I wanted to follow up on this discussion after a couple of months.
> > My bad at being slow, at keep this discussion moving.
> >
> > Has there been any more considerations with the preferred approach,
> > regarding the EFI TPM event log reference and kexec?
> >
> > This issue is still relevant to Framework 16 owners and the temporary
> > fix has been confirmed to work for other users despite not being a
> > proper fix to this issue.
> >
> > I'm always happy to prepare and test any patches once we decide what
> > direction we want to move forward towards!
> 
> Ard suggested we discard the EventLog on kexecs and I agree that in
> its current state it doesn't offer much to security. Is there any
> specific reason you want it to survive?
> 

No, I don't have a specific reason to preseve the TPM event log across
kexec. My original patch only preserved it to avoid adding any
regressions, but I do agree that not preserving the event log would
simplify things greatly, and I can't think of it providing much value.

I'm hoping that will allow us to return back to the EFI_LOADER_DATA and
the E820 instability issue that was causing hibernation failures on
Framework laptops, and possibly other devices.

If you and Ard are comfortable with that approach, I'd be happy to prep
that patch and test it!

Thanks again for the guidance!

Jazz

