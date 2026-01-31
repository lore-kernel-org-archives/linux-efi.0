Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2321CAA65
	for <linux-efi@vger.kernel.org>; Sat, 31 Jan 2026 01:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769822379; cv=none; b=lGkrfIKdsUGXEATVpdVGmtOVS4JFcPjAHzM2ezFrSTQkmX/a0w799XyI+qaBTG7+jjvKV03ERql6P3qKXGzcZ0XnYp0R2XihkI4Y6pA66/PcXEvVZeqMsJr85d2fAOHFEE0hcvlON7C1V3wfoeismfuf+WcJL2eNHoi9Wfq/xWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769822379; c=relaxed/simple;
	bh=P/AkJ7VMQl7xg3h+SCs73opP330uFlSO7pps2YFNAtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NTd84TQJirPNiVaotquGL83OgY13Ta+G6l4lteLWt5s3jNsTzjNKMKXtnAxSGjnpYRDgHHHcv8nVbIprnv0BetUzhdm+dRJrkYaPwq4Lx5KaGoghhszwLxUD6gk2mSwot4S22NuIsbnlQilFZGtWKrESJ1Y5SKDNfBGG7NjI+FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Czvb2QDl; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Czvb2QDl"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59dd7bfeb8aso3102482e87.0
        for <linux-efi@vger.kernel.org>; Fri, 30 Jan 2026 17:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1769822376; x=1770427176; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EPpl6A64UKlYlKR2j1fRkib4LdNnz2WqgktVIjm2uzU=;
        b=Czvb2QDltq7M8634vLJNNzvHWgcuzDWoIB5XftT0RVRrzd7zhbYN8wja4EbJO8LyVj
         yeWebQBvwgVpceS6B9qJwNCiOnzQp0HPvd3iPEI4a/gI3/dF9Laaekgqbw9m4A34ektt
         2JQ7YNFN4ubt1rrsf9Js8ArRt4ft/9r2BZsqE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769822376; x=1770427176;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EPpl6A64UKlYlKR2j1fRkib4LdNnz2WqgktVIjm2uzU=;
        b=fhc1COhvUWYs8QyMHUjc7GBRac6zFoQbC0IfVAVoY26SquGyWMp2Nfn5DapBTsauYZ
         b61OnBhj/blqLknvJMd5KDocomtVjjn9OD1N6oh9wMnfZiMrvOMDPDA35LQbPGX/Ooah
         d78fZ5M14OLqLVFq9XWKEEmdI+CXEImzryUxh7zV7C2+/2id9Q8Tt0ak81WDvkyQlOxm
         eRWxl8jFLKdHe5M6CQmjhdK7Vd4xGGr4y5raFgZpMEtvYOU6NXX6zuB99+uLZLn8C/q+
         t01weri7pHWIrG3zCcUe3s8KeSBYBNeljRQcetnA2fsSn3xjRJKZFeQhFbSZDVvHZUK1
         jtmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLAvWGCLiL+0vpsvi/QKDJhZauNMBZF6fDsJB8TBqftTc041JTTdlmV3N5PzeuN0J2wTwbOf+DGkg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/7qv0RY2bZqZmQZN1amqQGJXoWyRi+V0mHOJeQiELvuY5P383
	TSFw2YgM3CBr1VblDrPIeExIgPoCQRrnfWy3wqISCYoaUjli3TWh8EjVwb7fEAshorsl4kbNhTj
	0iyT0ACdryQ==
X-Gm-Gg: AZuq6aJ3/lpG2GvKaccwdswcs8VJniHGQEehH5XDv1WHhZJlMhIo8MGxtP8Ed7+UjQe
	gL41ypGrq9ioFedI3f/rR9VewzHpOMhlVVZSeIcdKMU4FbRQc2B5kZoAVm4+6YbANr+uoAnDY3z
	icJWhTUvPMaeNSq3qy6BRhfz9HdlcJCD3LPuxZj9CulxFrq0XWxHF1U9ZGzt7qxNukdrRwzxjmM
	V1EFwKcCeVH+zz/H6+T1ED0hGw86hrh2SfdDTMAo444Jhvig27gAm0vrU3348z5VxfRx3MfgLzf
	I6v4sw9QM8nP2eusmGwUry2TrSc8jfsaq4s2Qm+OiOGjIt67pRvHp3GgtkD6AQeN8lS9AQug6fz
	M0u8IZMIyNFThYYqkiMiHwqbdphj4SuoUbIGa+AVZLsOWlskQBtTB5fHaq0Yg88qTUTQwA1ALvR
	lwYoahrpGZRGEMiyAv81FPOEWE3T+e0k2sMn+zwAxBMhR9RBFx5bCkjThZIW0o
X-Received: by 2002:ac2:4c52:0:b0:59d:db01:e0e6 with SMTP id 2adb3069b0e04-59e16401a65mr1710911e87.20.1769822376206;
        Fri, 30 Jan 2026 17:19:36 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e0748eb3csm2081611e87.45.2026.01.30.17.19.36
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jan 2026 17:19:36 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-59b76844f89so2498326e87.1
        for <linux-efi@vger.kernel.org>; Fri, 30 Jan 2026 17:19:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVhq8lKAbYHSC2WW2B6FzRuytmS1qhbNRzFDH1fQ69DUiBq2V1b3co/pYKYQUatfMfSyz9Ehp9wH7Y=@vger.kernel.org
X-Received: by 2002:a05:6402:35c7:b0:658:ba49:96c2 with SMTP id
 4fb4d7f45d1cf-658de54e61dmr2863591a12.6.1769821915767; Fri, 30 Jan 2026
 17:11:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV> <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
 <20260130235743.GW3183987@ZenIV> <CAHk-=wgk7MRBj4iwQLHocVCa94Jf0cMEz2HzUAS9+6rGtnp4JA@mail.gmail.com>
 <20260131010821.GY3183987@ZenIV>
In-Reply-To: <20260131010821.GY3183987@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Jan 2026 17:11:39 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiXq-bPyKywNOw7z6ehrVReyS-hSPuQkJvuhJWfXGFm=A@mail.gmail.com>
X-Gm-Features: AZwV_QiG_nByRrd83VYAdhaCU5_carsYUlImGLyJR9w-28CTqo3phlyWLRwFL8I
Message-ID: <CAHk-=wiXq-bPyKywNOw7z6ehrVReyS-hSPuQkJvuhJWfXGFm=A@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Samuel Wu <wusamuel@google.com>, Greg KH <gregkh@linuxfoundation.org>, 
	linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 30 Jan 2026 at 17:06, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I'd rather go for a spinlock there, protecting these FFS_DEACTIVATED
> transitions;

Yes, that's the much better solution.  The locking in this thing is horrendous.

But judging by Samuel's recent email, there's something else than the
open locking thing going on.

          Linus
