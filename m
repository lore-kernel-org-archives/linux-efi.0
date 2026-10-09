Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAC440961C
	for <linux-efi@vger.kernel.org>; Fri,  9 Oct 2026 08:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791535394; cv=pass; b=V1XD0asVaIopXyx5Gl82B7OofQmJEuY2aSHxWSoUr1jFwWKkUZM5c+E3hhXHu9/mUwez842S78V82HLwL17GeT7zhNvW1WklDPeRpJL2LdRM9zh7eApMiXnDfjzEvpxVTiRB+A6KsctvuEOQ5B5HnuOfD90Ugy9hG8gQe0rb+O4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791535394; c=relaxed/simple;
	bh=qAkai9AbESmrM4xIkF06nrF8EZpWdyV4GK1L9zcF+P0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=gg80esIcGT7RJg0639zZPWgqKP/IPTDeLxd/QpXy5WUwxtG1t02NI2GXOjeE3ED0ix94n3zJXE9kEl7+U4u3YamjB3NjDpC4X7S7djVr2DtQwyyrsBZeO+MnyvJ4Vi7flkKjnr4efUVJ92JDN2YnyUZgogywBvfASb6Yt6mzfDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Db3nxIrk; arc=pass smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Db3nxIrk"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-49e08af5fd4so2762514fac.1
        for <linux-efi@vger.kernel.org>; Fri, 09 Oct 2026 01:43:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791535387; cv=none;
        d=google.com; s=arc-20260327;
        b=K0uMPcs3lm8Jh8p1w59dHxI2bNHAtZwuvTg8q2OBbAQMIGqLmj7G5URRnEvhgApXUV
         92TGUZifkQrXpn03kRyrfVfh5n5n0pXD1635LxwxTbdhlZfulcyEbhY27F3MujzmDUDo
         6TYq6WpRQlmKB37PrPabeaoUY3VKqUDQwvNpG31MYtcfmiPwGOOkzUkWhOA14eENQ6bj
         hiV3ng3w5gZwrOCxfa6Xhb+mZp4gPoQex2e3cL4+xhGvPF4Z/QvX74cTnH9RXus1ojP2
         kIPTMJpLDb2/vgA9pzU+CwWEIZhamJd6OBfEFrv4GUwL5i9KG7FyP8uC5GPWNrCh/WAt
         9DyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=qAkai9AbESmrM4xIkF06nrF8EZpWdyV4GK1L9zcF+P0=;
        fh=95jYXLw2eUellArN83NN/2VrhkJOV5kFX1vaJOIodPw=;
        b=p9pOPfccBal3AxNLugOOpAFlHazVV8W7ThPGsSM05/xxx4fPPd/eJPvJ+Q74ignG1u
         ioTZy8B5gL60z/y8LbWgbcfYW2tcpduQ+PQuh48l7eBiB+q9h3+Y69niTmAdFMDmEaB2
         UhPjcRTEiL5K2sblx3lNowvASlBuK7J/hYZVyD34PjrENZkldvNn0GdFvYpcHmSUGEHE
         P+edUdegxtdZMeIczwLNJ4JPZ0gmI7pON2ipkhGhmirYI1qS7z9bGpEvANOokgcDK9Hl
         M4UcKhJOJEgJLjH/I9zz2m8LLLBiHZL315MxP4BS5bz5Q0hPcn6TZPFrnxB8fkDu621/
         ppJA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791535387; x=1792140187; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qAkai9AbESmrM4xIkF06nrF8EZpWdyV4GK1L9zcF+P0=;
        b=Db3nxIrkXy40IVlqOK7jq8F3qZ8l+ykcDsFu8SbfqLyZ+Ke7Zkv3iKHXPGo8D6eDhA
         yt5HYdeKkD0AXMdarK2lkO0r5rKkjNK2KUw5bFqi7BfqL3uJBmK15ztBVEjlwSEFqAee
         MxiTF+XXWaBD+kuqrJMwP3rSPofv2mMuZxfNY0G64wcobuNhbFl7bLaVF+YbnGzf0CJF
         rrahL9f9O1+l9KYIyQJEvCxRi56CoP4RfHDbz62tGWi7lzGItSfvExmnPjwfBEeLuBwn
         tgtG95kyTDuBRlYOUVVvNqYrXK7/z1a8pv8E0A1gDFBMQpdNsmaLqK6608sagl0pWBC6
         ih2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791535387; x=1792140187;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qAkai9AbESmrM4xIkF06nrF8EZpWdyV4GK1L9zcF+P0=;
        b=c4uxve8K8I9XScvyMQgunY12yM3zFiiuu38IyDFgMRpbqSnGIGqqxvm0AfrVjabx4o
         ZmNhadQ5y60kvgrr0ETssizlDKajZNUhN3IzZE/VJqr6FLHj7FulOxTXr1tIRLL9WYYm
         5etTjz+4L8mJudPnOvczPrqR6zAAfAEpYMUolOlpfAil0eiAsgWf/h15QhsqEVtTHt11
         gPk/aUhPgdOPJ526NXB1bEescn335SO9v8lMX3Yg1GI5RzOBCK1vhlYBbOtBb5fWQA87
         DurJbTV5RGXBAKStjchcd4K7RDTqWqm59IxOmMDurDBAPFIhUQZL47K84ZupQV9fyjG8
         w+kg==
X-Forwarded-Encrypted: i=1; AKwUvByDrGGPTs9HaVP61PfmgFvfVYpVhSfbDeERPXr8eIDcUBpz6D6zFKctHm1ooTOgdoNhqpkAnEE2ix8=@vger.kernel.org
X-Gm-Message-State: AFq9FYJE3FLRP9oQN+KNv8jMr24d126qYnCj59iXTu0PcwihGhFduoT1
	jAnFvSTS+ZdmT/xfMKTK92p3KSogzvEUNxhvp120FnkhqlYPrGh1Rk0tzz8p+JFXI06yLsRXlmI
	llvHEJJwokO1feRRcxfAYZV9n/n2qJ7o=
X-Gm-Gg: AYBFou0x+a4M4jfgYpCDkhosQNpwdTKyTKLT+Ui0byubVcBW4QbwWc2NtLX1+cl2w75
	+gH07wf2Fvd3ayeD4TIwYdsBAYrdCVnxGl8hc1SuMUGMhUJ7Rl2lY01V/1aTfM0IS1F57+7I14M
	NaQ1ngKoHVD0Yeli/dUa1VL124qM0R6gs2mW01oLxPeZs0NypR7Jg05b5qnWmdJcSYETlQpT0GQ
	A/VRuj8Hd/jYIVJHXPC6JGMgx5h6OhYsTKPqHRwp+2QAeybK/8KtjijvgJSKOLDaFl1DDTx0odc
	EKLuWzVNtBR0aMIC89sD4FTc+eKcvvJXMjizWjNbRyA8W8KCGa5htcQ8u+dRsj+YNyU=
X-Received: by 2002:a05:6871:580a:b0:499:f1a8:3ab9 with SMTP id
 586e51a60fabf-4a2a8ac1d29mr913849fac.48.1791535387330; Fri, 09 Oct 2026
 01:43:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: MaeeFilho FL <joaoanandalima@gmail.com>
Date: Fri, 9 Oct 2026 05:43:03 -0300
X-Gm-Features: AclHuK8D7bC1DTyUeb58TSqJecI2U3HsXQZM7EwBwNebsAbq75ZmHussbpT2z-M
Message-ID: <CAFA5sMc+CSN1J=r+fXkD_0=wacVVFwk6xkgv-rMRFoyYv+xWkg@mail.gmail.com>
Subject: Re: [PATCH v5] efivarfs: add nostatfs mount option to skip QueryVariableInfo()
To: Prashant Singh <singhpra@juniper.net>, Ard Biesheuvel <ardb@kernel.org>, Jeremy Kerr <jk@ozlabs.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, 
	Steve McIntyre <93sam@debian.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Prashant, Ard, Sebastian,

Thanks for addressing the feedback in v5. The cleanup of the commit log
and the implementation of the single data_race() wrapper for lockless
reconfigure path looks clean, robust, and production-ready.

This addresses the concurrency behavior gracefully without injecting
dead memory barriers, preserving deterministic boundaries for real-time
environments.

Reviewed-by: Jo=C3=A3o Guilherme da Silva Freitas Lima <joaoanandalima@gmai=
l.com>
