Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2326A3A5E9F
	for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 09:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777368779; cv=none; b=MW2glGMEtyG6VcFdXM5Xs98opLIOLtSaNrcOcMDxBj123woFVb7a/BXGLvdPlFu4lNRd57hmUDobCAHZnrEF2ydianJFhN59uVXwFv9LbWyaebAGPMcHw3UcoB2xwqiIIial/f/njZAd2418Cs5iTbtoVpiIfBJtbiaxVhxHpWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777368779; c=relaxed/simple;
	bh=WZ0dv++aH+AeLwkvbNXxLqu7wJ3mA6GpS63WG1N27Uc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pmSPCgB1wb29XRKTwF9IBPOlWQg1J0RBPYkOvCp/TVD4DiCBM8ZIdZlZwQ7RKyC0dHE1LGd7p+HXqfmGLxwBdz0s8OcJVnBi46F1OYRZsqaTtO9mw0h8SiUg5zfn6ptOXHnoVnnu3Wb43UBxvJKLJ/SaSbq4L0DuXK6M3bh+blM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-678a526f374so7380866a12.0
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 02:32:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777368776; x=1777973576;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Al22kA6RCf7FSEzj29cZLSkjdM9EgXxihmBX7/SeSVI=;
        b=h/ia6EMlzE4kpfST0Uax3f5kETeLzRVivKoyLyGqoIqPCdLUu6iFnFOKT5L8JvseXP
         fVOiZDdP6zK8jeLlgBf2ZkJFZ0Vsgy/tcgj0aMTO/uOeBpDRSYo1WmHxlPXtQA0y4OOM
         xHcBCyElakIovzueUd9SUVomOaYUD/aJiWkPip+CcEQvK2AqJSCcWYfrwLIOO2ULP8kA
         YqZ3o0sgxmGFZKPxg/NjU7O8XePU74JVQP8QrzzD1nTSsmGdiBtP5sxWkeTwQpXhWBXO
         9tmFbPoG4uHW0R68+++Tz4PTmWsyoSSW/FhNZagVwdwG9BKKOUoo2xEId8wZAiC9fXxU
         Qkng==
X-Forwarded-Encrypted: i=1; AFNElJ/Gq9nfiR0xg2AcrYiA1ZlLBki26dEif+gPF0WkWfip3k+DeKPGy/Kn8B44Lamb5OWdG9n2kGUxzZE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3ViVRfnVp9x3ZihTw6cxG7UrUReE5lL0gI5UqQ54ex+g2taPZ
	4vzVMluaExp+J6kQs6zK7GdHbQPKPzY7U3PEffDfwDf9H4BTSLqFnI+jJYqd5Uo1Dew=
X-Gm-Gg: AeBDievWi4IeJkLzIQUdMl+oQwwbQqSBUfnFEK/PGUnZtw0C3E3N+g1Gg5KspriYs0B
	6r2IdWndti43fhM/elJft58k6V7CLZ9IK/HT5lCMEEXamfSOhxDSDT3CtL1iPZdR1+iO+iC3rWb
	wKZwx9QxAKWU/uuhYqK8BegPrmm9ZoaGeI7+Ss4b9bm+dyc8Ax3sFcKP/xVrha0BSRNPD9XTbbW
	WfAbb2/2K29RKveVE/wpAJtAZz5O4emEPXvfzXIXtpzq3UVJ2Z++FSKmzmxXb+RezPsyNQ6i1yU
	UbN1HVKaWLlRoRqGB4bkmvg8mfB8P+FK4gKjlxg5A0H9HKNmLxFr7br+gcLZavZMJGWuf4RfpDd
	uySAlVbxBgi1t1PiAte1/ho7TQQyxHlIKIyUSaNdXoetn4ezMb6UrAG9roygZe08+rN23AgFQQJ
	DM4smMgqEHNYDN7X7DMME3QymwN9aA6N5uo4hEn2LNjs3NDkA3SC/ogNmZ+tSG89wHHIXu4kU2J
	gW7JRFyQg==
X-Received: by 2002:a17:907:96a2:b0:bad:d21f:904d with SMTP id a640c23a62f3a-bb804728021mr128052966b.31.1777368776278;
        Tue, 28 Apr 2026 02:32:56 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bb808f2dcdfsm73240666b.22.2026.04.28.02.32.55
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 02:32:55 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-67389cf78b0so19508071a12.2
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 02:32:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+SqJTFmkv/5RN6t5eQxHeGcZGeblKsIms5a+kXmcJZJiP4+zwBgOiWS/nI8eKcgh4TjxqyX4JyETE=@vger.kernel.org
X-Received: by 2002:a05:6402:5056:b0:676:d8a1:7a04 with SMTP id
 4fb4d7f45d1cf-679bb09a4admr915149a12.23.1777368324094; Tue, 28 Apr 2026
 02:25:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777306795.git.chleroy@kernel.org> <c73b90236f2810edd47c84edd2a8d8e8e0c816da.1777306795.git.chleroy@kernel.org>
In-Reply-To: <c73b90236f2810edd47c84edd2a8d8e8e0c816da.1777306795.git.chleroy@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 28 Apr 2026 11:25:11 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUvTBWoDN_wUo2n8-gkoheJ+-rbwew53OvoAwo8G5n1qg@mail.gmail.com>
X-Gm-Features: AVHnY4JEWBVPw4tSjHgbQTia8gZd2WGJ1sv6qLdKJbtvs4hms1blpvc35yb0VWw
Message-ID: <CAMuHMdUvTBWoDN_wUo2n8-gkoheJ+-rbwew53OvoAwo8G5n1qg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 4/9] uaccess: Introduce copy_{to/from}_user_partial()
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, David Laight <david.laight.linux@gmail.com>, 
	Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, 
	dmaengine@vger.kernel.org, linux-efi@vger.kernel.org, 
	linux-fsi@lists.ozlabs.org, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	linux-wpan@vger.kernel.org, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-staging@lists.linux.dev, 
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Christophe,

Thanks for your patch!

On Mon, 27 Apr 2026 at 19:18, Christophe Leroy (CS GROUP)
<chleroy@kernel.org> wrote:
> Today there are approximately 3000 calls for copy_to_user() and
> 3000 calls to copy_from_user().
>
> The majority of callers of copy_{to/from}_user() don't care about the
> return value, they only check whether it is 0 or not, and when it is
> not 0 they handle it as a -EACCES.

I think the "a" can be dropped.

> In order to allow better optimisation of copy_{to/from}_user() when
> the size of the copy is known at build time, create new fonctions

functions

> named copy_{to/from}_user_partial() to be used by the few callers
> that are interested in partial copies and need to now how many

know

> bytes remain at the end of the copy.
>
> For the time being it is just the same as copy_{to/from}_user().
>
> Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
