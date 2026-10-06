Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A3B4A015B
	for <linux-efi@vger.kernel.org>; Tue,  6 Oct 2026 16:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791303063; cv=pass; b=GjhOt0rhSYKGEDKjIT5lCpYVyB5AMSX+WDNy2/MPtdDuM1LghhArA7yRyDI67kYH279bD8CJksXMqOUvS+Y5BpVU++bOIIrJAD+ldVAj1sHQuVrd87a5E+SaQk4+gsKtKq4+hz1EmSqdPc14Yh75PddK7P1U/ulvrU30ZFjCk/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791303063; c=relaxed/simple;
	bh=9WCkiE19cbtAuYYQ4uqsh1anpnBBbEDR9fWCfux10TA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mWIj73w5/S8D7/HpO77967TkblxGhyqVOiVVZ5q4iDrkGQVTEpPqapCjVtC+Elx005PBQRSEoD7ZNsi8KWA4D4LODwFE6UcJepi8ZOpHyqTFkaHNVnwRtOflywU9cC6s7pAQ/RJHKtdAFeurkYP8gj6H+facq2zFl6n5RMozcZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JwSdedkv; arc=pass smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JwSdedkv"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-885cf67963eso9928897b3.0
        for <linux-efi@vger.kernel.org>; Tue, 06 Oct 2026 09:10:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791303055; cv=none;
        d=google.com; s=arc-20260327;
        b=HPiy6mhx+MFfXCykibPo+kFMvkri6I2s+n/pjQ1IO/PoNZETSic0DpvTP9mfh41822
         3raooE/w1arb+d1qh8MpaTnQRPr2ZVSCcdgncBdPkwnDE4Igu5Z2wL9Ch3RgGE1jWyxW
         JAMaQvtAA1Jhm9tMBgSIsMpsB9Q8DEu8Yuxhh9AFsySxsKQRxl4ZoZCQmKetWAas+tK8
         lmvvN83yd9wL0h01oM17H4iwEoB7okiNfXgwYOIw8nDVTXYFm2X3DAw8au59MNMmt+XF
         npBY2YRokLM/yuJfHL0/jRJKBI80P8ZrtyLq2WZwQ0ZAJZpI4N8KfdvxcerkzYq2h+gl
         pdZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bfR6JmlAO4hB3DVN/nKPNuuxv4ZNwhQvNLDvwEb4/Vk=;
        fh=eP2upHSGFXDb3ks0k/a1vMMyqGaXnZZsFpmhL9+JinQ=;
        b=STchv6mB2KvD6Az9wE5mtS2DgCGQID/bBlhOhx39QGz5tDzZKr/nddMkO4VCsmBsx2
         X+PuA1BZ48Dqq59qkV3C4t2q3xFWn7dRI0FYiDPKSoGhUbh+c3gAn4ihpgc2XSQZ6Jvc
         az2aBRYmUEdkBMi2XQ6pUhYIbxMQ+nTNuqdrjdUFOBZs5dOvh3oQNmg7rVGu8CsgnCzn
         pym3zMXVC3vQ+WL4j9QrABo5c7FJElfib4YX/nZpH1DNcZHmz90EKvepKr8WI8GZuHfH
         6YhrY97Rc2AI3p5WzCb9+UrftG+hSl/NxMPgcehgRTXPc88KOJh5vx0hXJt5Dbra2mEb
         iO7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791303055; x=1791907855; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bfR6JmlAO4hB3DVN/nKPNuuxv4ZNwhQvNLDvwEb4/Vk=;
        b=JwSdedkvU4HWA2M3bRiTIb4yUJH/G/6j3Ze5FMckN/eew0613vcp0JMe9kvOi+DOuY
         2VJzaCNXVbhmEMLFz6cFCs7h7oitGNfA1aSwqYbeW7pgZpODcmm0Jue+hr9b2oDm501n
         YFu/7v3ZjFC5B4mBHIUBBRvViLNLpd6QNdEef7TYKwxV0YbvxDYboiaxERYPGWzfY4CL
         /bA1BJCQJgff4ojK+kBk71U266MY/VHGjuUp8u1J7YoxOxdFwqOe5njzUpnvGHfyG35H
         9xkdDE92TRGS6KGLsGVlfHDLoihWR7Qnz2PsOnlAFbDHYbmAOrkjhjhaMVdWZxHO+wcv
         Emow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791303055; x=1791907855;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bfR6JmlAO4hB3DVN/nKPNuuxv4ZNwhQvNLDvwEb4/Vk=;
        b=FlYGfaayP8KFaI1/DBIZhOP5ll8MAIALgBSvFxmeNz8L3YmjE1xZmWo3vnwf5nM+gw
         UimJuabX3QQN/geAoFkDtOgUjUxEuGJtC4sNAyiEA5FlbW/tkCHtr7K7lwveF0AriHiH
         OMj6F0Stg2C3CMDSXwPQYZWGD+G8b3OrEGHWS8mJiuhdCdUOQbsnmwZgN4ofx/DX2470
         KAUbfJgCdTyljpB6UY5X/LE2FCUsGpIv4PqsCsVNhccgpXFUGcoa76xkCYE45KQSjife
         5NgZLLnod0Akg1T2jnAQdqrW7XhLApZUWtwIXWKbX/yvHHqtyDxB3kfRDXtUt1u3gNV/
         LkqQ==
X-Forwarded-Encrypted: i=1; AKwUvBwJbUJsmzTcxbUJWrSK5o2d2XUCGZhS62wIl/y0uSgFWJHyzSJxRhrBMqgCbPy+ngxphGn6Mclo2JY=@vger.kernel.org
X-Gm-Message-State: AFq9FYIqunQxtU1y4YpIszXjqKqaRtriEqPkdfU872N2JnkJOM14YS2U
	b3rcxUAflDOu5pcr/DVXsjgL2YaAMDPu4hjvuibzkAnHGoJssgOZw2xLeUPCZlYbAVXKF8eltVS
	yOsFJ64zliIotIoyDVMgYK/QWYwHP1HG28HBnxXal
X-Gm-Gg: AYBFou273NaonI1UZAioo9lLUNZiC0ce7WBGpoArJpHNxNgNtzuWJF+8TShcKpiT1NE
	BGAipDiK7hTw4ITRJJZV/6CR+macZ6zZOKZ5co7FGE+5MrcyD7uFavZFNvStpRXG3v8xFI/868Y
	v024BbgLQzfkr6ZnMGNh+OyhL7tWcjFTGaP8kjxp6IFp5Vp2hsAAxX0RyJhmqfQXn/IGSpa6RVq
	S7T7Evap4nRJ3Go5bJ0GkxChdSy88+VwncH8zmk2sQT0bO16IfTP7KNPOIbqFn4Y3R9OPdwy7d/
	F6Eg/y/R+0bk04PcmQ6m3xr8Fmv6tvl4wQLyDT1Yew0NgD30xHADcg==
X-Received: by 2002:a05:690c:5302:b0:8a8:7e5a:dc2f with SMTP id
 00721157ae682-8b04f40f097mr9171807b3.12.1791303054779; Tue, 06 Oct 2026
 09:10:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00ed0b57-ad05-4c5d-b152-7c81df94b23a@app.fastmail.com>
In-Reply-To: <00ed0b57-ad05-4c5d-b152-7c81df94b23a@app.fastmail.com>
From: Marco Elver <elver@google.com>
Date: Tue, 6 Oct 2026 18:10:17 +0200
X-Gm-Features: AclHuK_OeB6Z7-eCIUVq_1RabrgIKOGeEVPLb2q2UdMqE46rpsfhYWgMuA5UU2w
Message-ID: <CANpmjNOaykC4McAj=gZghqPSQc9aGBP_CjgKmp3n2yjeJTxDSA@mail.gmail.com>
Subject: Re: [PROPOSAL] Replace gcov and kcov with llvm-cov
To: chuck@wolber.net
Cc: kasan-dev@googlegroups.com, nathan@kernel.org, akpm@linux-foundation.org, 
	anton.ivanov@cambridgegreys.com, oberpar@linux.ibm.com, ardb@kernel.org, 
	arnd@arndb.de, bhelgaas@google.com, bp@alien8.de, dave.hansen@linux.intel.com, 
	dvyukov@google.com, hpa@zytor.com, jinghao7@illinois.edu, 
	johannes@sipsolutions.net, jpoimboe@kernel.org, justinstitt@google.com, 
	kees@kernel.org, kent.overstreet@linux.dev, linux-arch@vger.kernel.org, 
	linux-efi@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-um@lists.infradead.org, llvm@lists.linux.dev, luto@kernel.org, 
	marinov@illinois.edu, masahiroy@kernel.org, maskray@google.com, 
	mathieu.desnoyers@efficios.com, mhiramat@kernel.org, mingo@redhat.com, 
	morbo@google.com, ndesaulniers@google.com, paulmck@kernel.org, richard@nod.at, 
	rostedt@goodmis.org, samitolvanen@google.com, tglx@linutronix.de, 
	tingxur@illinois.edu, tyxu@illinois.edu, wentaoz5@illinois.edu, 
	x86@kernel.org, peterz@infradead.org, sashal@kernel.org, 
	Aleksandr Nogikh <nogikh@google.com>, Taras Madan <tarasmadan@google.com>, 
	Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 6 Oct 2026 at 17:14, Chuck Wolber <chuck@wolber.net> wrote:
>
> Stemming from some hallway track conversations with maintainers at LPC
> 2026, I propose replacing gcov and kcov in the kernel with llvm-cov.

I know the origin of the discussion, and wanted to chat, but I guess
that didn't happen and instead we get this proposal. It would have
been good to understand the requirements of users of gcov and kcov
(more below).

> llvm-cov instruments at the AST which enables precise mapping back to
> source code regardless of optimization level.
>
> We have a set of patches [1] that implements kernel based llvm-cov. They
> need to be updated and some additional patches are required to address
> some stubs that are missing noinstr annotation. But otherwise I should
> be able to send a full set of patches (including taking on the
> maintainer role) to remove gcov and kcov and replace it with llvm-cov in
> fairly short order.

The hallway chat was supposed to figure out if there's a way to bridge
some of the gaps, but jumping the gun like this without having
addressed the requirements of kcov users does not make any sense at
all.  As for gcov, llvm-cov was designed as a better replacement for
gcov, so that makes more sense.

Ok, well you made me untangle the most important differences between
kcov vs. gcov/llvm-cov below so we have it for the record.

> If there is a desire to take this in pieces or implement other
> intermediate steps, let me know. Otherwise I can generate a monolithic
> set all at once.
>
> [1] https://lore.kernel.org/lkml/20240905043245.1389509-1-wentaoz5@illinois.edu/

llvm-cov is generally useful to have; llvm-cov is closest to gcov, so
that might make sense to replace.

KCOV, however, cannot be replaced by llvm-cov. KCOV isn't a coverage
reporting tool for users, it's a low-overhead interface for fuzzers
(syzkaller/syzbot and many others). llvm-cov has no equivalent of:

- per-task and remote (kthread/softirq/USB/vhost) coverage collection
(to avoid polluting coverage with concurrent tasks);
llvm-cov counters are global and polluted by everything else running;

- ordered PC traces (edge signal) and comparison operands (TRACE_CMP);

- performance: a per-task mmap'd buffer reset with one store, vs.
reading/resetting
megabytes of global counters after every program;

- GCC support (we may want to keep at least one GCC-supported coverage tool).

It's also UAPI (include/uapi/linux/kcov.h), with existing users.
syzkaller heavily relies on KCOV's features above to achieve good
performance and coverage; there's no reasonable way today to migrate
to anything else.

As-is, NAK on removing KCOV. Consider replacing gcov with it.

Thanks,
-- Marco
