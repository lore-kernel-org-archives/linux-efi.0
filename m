Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.160.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792813446;
	b=VQkTVfcuReETwTIkp+Hk0XnpIO/SIuOGH3QYP+ENAvgDjKEA2xJJHPBXlTyb8kRYK4ui
	 Q2j2r7b2EslAriE6r2TLtFERmCiEn9OxAJtTXYQ3snMmJDaDDOXa94qsJD8HIjyN5GwAd
	 Q57o+YPJCvW/ht5G9sVjjhsyOuj30YZteyUzG+j2dt/jfqBwDpxRDmT33pHlTXkITkoOi
	 XVV3asLD1jPUPwk/4JXU85MBQhmbAyfmuEwJeHfMW8QGoEj/Z+uxvTZlJJkg1hRogxmRZ
	 SxcxDnw191VWdNQPUAUfn0cqKvpF0mICYMpiF2xTTTDYrsG7X0pBPlA4fki8SLVsnyw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792813446;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Content-Type:
	 Content-Transfer-Encoding;
	bh=D1EfrUVYhMkemv76adwO/TrD45i9KqtzMIzJ/at72g0=;
	b=TdmhJo6TY+8odJaaGTONcM4IMushFgSL7u9lGH12FLXQI3cZbl3EO6lwZHXbKe7/rj1t
	 0y9O/d0r+eTaam8mo2LXBsFrt45w2AQPGgkGfLJX8PymLzyDHbJ0E1F4BEqPnJ3bkrlOE
	 o+LnJeb5rDRhRjpv8fNjtYShLGKWFTJgEVFgDxAE17cHbjiowI+Jgz0hrYCP/RRbhHxJt
	 UfcQFe9+nUIY7F9XqDv/gmjNO6gLj9KxEpeM++Z++0b6/OpLG0F6Gf1hstRwT0/CNXTFQ
	 IlIswdxIv77zSR7HseWrr/iCWhmqhbBGSkMj7UOPfhgUhfkYA7VnpmOP6zgsHdLlFrA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Dsq94QfJ;
	arc=fail smtp.remote-ip=209.85.160.44
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE83C606A31D
	for <linux-efi@vger.kernel.org>; Sat, 24 Oct 2026 03:44:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE83C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Dsq94QfJ
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-4a76f63b243so1854786fac.0
        for <linux-efi@vger.kernel.org>; Fri, 23 Oct 2026 20:44:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792813445; cv=none;
        d=google.com; s=arc-20260327;
        b=XBJNcEFbl9/jzzbWvep9Rq2aAPTQY+fWglPhA/hF+dcQt3zbk46xWHMR5QdCzIuApP
         hUXHn+2rGNsmr+8/9MCE85E7UheJ38HED0Ow+DF5kA5oJf/XI9K3FaYK/vz2aLk+qiPP
         +TQdvEi9mSO6lwDq30pHXBm0wDsYdIMvlGPw86kxiae2jQbbUKoxwxtFDiwzXc9yC6Wt
         6R8SwcKZ22eOF4edXlcTvhkKHbb6TySgWX2x8bkz+8n0dy4yA7vFiVOjVcpS+GqvcF9K
         t/oldvpNXMD2EGLfKfQqTMDpMA3NNQEh77IR+ggQImxAhf4MI70OistiVTyMQhXythh0
         mlPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=D1EfrUVYhMkemv76adwO/TrD45i9KqtzMIzJ/at72g0=;
        fh=ysDzlSwIG80Hh9o0USSFx1bi9+DRTjv83/2h47zK5qI=;
        b=UZQZZTAhZ2ctg83TV3I/8iNVTY6VuXBO6pC1UfVu+xeOCI1cgEa2E+hWp8EJ4DUSaH
         p8PvhINMlT7Y6TO0aZyqOOnmZzjPWNbo5LJV83PpTe762Ecgi3mpdcG2OXYg9hf7JAtz
         UCfkujN0p3LR6zh3kLfuHSc5iQ4cWAgakn4K4WrheCkgodbT5sxlSPgJ/+i94wJzMfVX
         CfgSD7hi6uyXZs3Ty3hCmwk//MwHhZ7K1MsVdqIQgYyYwFyYbVd6oDJCRBHjLPV2eN4d
         C/n8CI2XBKmpuSgyNPCLr4IJE+5KL/dE1dTZQYjCZNLfg235qw+eFaCIuIvr0D/7Hk1p
         KhFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792813445; x=1793418245; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D1EfrUVYhMkemv76adwO/TrD45i9KqtzMIzJ/at72g0=;
        b=Dsq94QfJwuxTXWfcWbJgISmpq5FjyjAioasRFdAxllP/qjxzZBiqk61NzPXHzvQJ9g
         KeYQcvhK2rYrU4UWIl/fq0HzOJ3IpNMptHLszl+cnhvQhUeAWNSOdytcduFL9fG4cTRw
         rl3AEyCPBswgrr4UvmxyQgB/i/AeM8DCVRP69Peo5QB22tFJaaEnf/Nekl2wE+JsRaXl
         7oCzA7FFVU8uWHhyoxkfw2+V5Jp3opmBqUr5EI6cvfnUYLO1wwmw++XA92IHK3XGuZkM
         fIkXDzbe3NkN/adKsoPVao3xCKZ0mX5JoqrreqFrbH27cayJ90Ic7Mht2Mr8WL0KFzeP
         ndPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792813445; x=1793418245;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D1EfrUVYhMkemv76adwO/TrD45i9KqtzMIzJ/at72g0=;
        b=15BCiEyHJTA4nzwbPkcOaoUQsumjpf40IiOLppIiLyvM53Lv8+KSVGQ22o3mgR47LV
         CMi8hmddvM71wQgNgYA3k7kjKC56y+CzS1wk+ho8Jz9kIu+oMB3gtwMBPBZ7vSPNeXIc
         xrwgkxx+Ld7FJlwJWXNpE19DTfO+N5czNwBbEVTcPOpw6v5bv0hsUlznShNg7vAnQKG2
         II/8W71+qqhc3XPRT9BUyJ/MxrFD0P8HSEgSnzwnCRoA5MsPVvcK+qfBxl7YjC97eMjl
         /hAQje6IY/eLVYCohyvDzgh4V/M9HIGeEa2IHwbQjVNUTpHVW9HvIVgxdhyhBIWbvF0L
         4lTw==
X-Gm-Message-State: AFq9FYLe2yRDlWXg5T1ZXeLqkGG/arDnsL8kTbHrzwyTd7GUHs/YFb8G
	Q7TAxb2/k3lK8G1xj/QawlegWO4YOa989/Fnm9mvduUY26Mft8Af3RGT3HwoQpGk6gUZ97FJc8u
	1H2bY8JIQFheisgkBi9Xv1SP9lIY30kOPm7K4
X-Gm-Gg: AYBFou0/dWP+8BThmgWdTHtqtLikEWN3LvSagaGDxZ9fMJRnoBZJZn19o+cwciFcBvG
	QX5dH3Bj1aMsWxuTmSD8dNVCWL+Y3hlkCPSlRbRqebERo55ua+SvDs7UR0UVWLMjxVryHYzERUZ
	UWF19IORmkjRaLRJQ8y3c6uh3NyOuh5PTie+GewSvZ/dfovC2WniRjryI0e5Zl70HaVIfX0j8YL
	L47MDTIrioE+nhs+fxbpFxnJgakAcuPbRSda9pqRe/48K/EdR95DXEeUR68fH7OFzk79p1uU8rr
	eBw/epSqKLGuRxbo+YMawjMO+DrysQZPXTdnBKuqIJzqbPvbL7qZgRimdIM4hOwD5KD3NmboIdK
	fdP2ePj97BBPi4jNCroZ5q9uEtySXPGrtizoQuQ==
X-Received: by 2002:a05:6871:b2b:b0:470:e97e:8f84 with SMTP id
 586e51a60fabf-4a83f524928mr628402fac.20.1792813444700; Fri, 23 Oct 2026
 20:44:04 -0700 (PDT)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: MaeeFilho FL <joaoanandalima@gmail.com>
Date: Sat, 24 Oct 2026 00:43:52 -0300
X-Gm-Features: AclHuK_AGq1lvNz9W2OO7Eg_BHM0lXyGPTbv0z4Ci5LFM_mC0rlj2Yh3p9Rsm-Y
Message-ID: <CAFA5sMeMcqawompHuzrokwhP8icaNVtghqFr0GYxuqUm1TaB_w@mail.gmail.com>
Subject: [RFC] mm: page-fault: overcommit: PPM (Page-Plugger Under Memory)
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <keescook@chromium.org>, linux-doc@vger.kernel.org, 
	jgunthorpe@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ard, EFI Subsystem, Kernel Subsystem, Doc Subsystem, Jgun NVIDIA, Kees,

Actually, the Kernel Linux memory management subsystem introduces
significant latency spikes during single-use, high-velocity volatile
data streams due to speculative overcommit tracking and reactive page
fault allocation handlers.

To eliminate the cycle overhead of the page fault handler (vector 14
exception routines), this RFC proposes a localized, pre-mapping bypass
called Page-Plugger Under Memory (PPM).

Architectural Overview:
The PPM subsystem introduces a non-destructive hardware plug mechanism
within the core page table layer, targeting the upper execution bits
of gfp_t allocations (allocated within the Bit 54 and Bit 55 matrix
limits to avoid legacy subsystem collision).

1. Allocation Handshake (ppm_kalloc):
Using the GFP_PLUG_MEMORY mask, the allocator completely bypasses
passive overcommit verification. It instantly isolates physical frames
on the RAM, maps the page table entries s=C3=ADncronamente, and forces the
Present Bit and Writable Bit to 1 before returning the address block
register to the CPU.

2. Desallocation Cleanup (ppm_kfree):
Triggered via the GFP_FREE_T parameter, the release phase executes an
immediate length truncation to 0. It forces a synchronous TLB
invalidation (via invlpg execution) and flushes the data out of the L3
cache lines using clflushopt instructions before moving the hot clean
pages into a dedicated priority recycling pool.

Performance Target:
- Elimination of page fault latency penalties on performance-critical pathw=
ays.
- Deterministic allocation timings with localized hardware cache purges.

This header infrastructure is prototyped inside
<linux/ppm/gfp_types.h> using global tipified configuration masks
(GFP_MASK) to enforce 1-clock execution checks inside the allocation
hot paths.

Feedback and architectural review regarding this memory plug
optimization layer are highly appreciated.

Signed-off-by: Jo=C3=A3o Guilherme da Silva Freitas Lima <joanandalima@gmai=
l.com>
