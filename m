Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795668789;
	b=sc8ozxB5I9S5x1Uy7cc7+LwRs9nkt+9Ac6Jt4l4UklWW0ERLmgWmUu0wJziQpE0NhNVL
	 QBulliLIkZovRc3YMC94UKkzl8XoqjV/9rhS06r7rU2E+SkwHUgLFpZSnQvQP8Lxlg2nX
	 adAayK/kQDQbk2tVTS2BaqPxsYAKxGdJu2a3e0i8MlB7PHHAYyCcQ+En7K/astnNR0oAr
	 7lm/juU5jIamUSUm2CJxEEkl7AsKKuAgqq5RdOs02GpuBMBJB1PqZklHF0Ak7FIo9mJ8b
	 5WlxQe08qObfqECQIHGKZft0xHgqyGNNailewSTkTchzsWQEBsij0YopzVv1Nhd6jdQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795668789;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=3Lt4WVagAGoPNQQ8sUuV+xbM6KmxoNVjHzW8jPpsfl4=;
	b=RLzZuPVQjy5Lo5ovl6XgUfpgJD7SkAth8sgMQIQ/MABN2tQBMA9DXYaOFKlMugKw2wMW
	 JrgTNo3yVawiJNrHsKs9tr1X9NNHQF83w+ldnpypj5+bdJgwlPfBxoeshMJaVQp36nKDO
	 FIxVwr6Ei2godHpPGm+TFTl8XK8vH+928xICm6Y5uYNcQGIBNOm2PDuC5jTum7RvwgaBT
	 yUeUxqCaY+7idzpK0FG+xqcRoT+ZWuwe3M3iTgW4Q12sCidos22BJDeKvTdQjL3wUROUe
	 yfilV22oZ9rR7CaZkIAOq9YkW4MmqJBNO3Tc/p7HYCpL6pTRYP2VH/l2SuBwvh1ELwg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Wt/H8uEX";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.171
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4E7606A32E
	for <linux-efi@vger.kernel.org>; Thu, 26 Nov 2026 04:53:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B4E7606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Wt/H8uEX
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-55c7445cf85so1380961cf.1
        for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 20:53:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795668788; cv=none;
        d=google.com; s=arc-20260327;
        b=OqMGZ8FR5y5lOVTz1yzretc73nYVJYeJ2dsMM6iJAX2lneeUCKhm7xbR0+EnE3q1Lu
         rUhGlg/OadRWDs9i4YBxJyZ+nJIbWByv8cw1kgTkOgv/igVE7LejHxrIbaF5TjJTU74z
         MeHTKkVi93tW7fkV44FZcuo6Y4ph1ypVtuapMm1GoDDYhQY81RChBR1aka9+eFFXiCb4
         VFXUWmFHude/1YEpyeeB8g5dbajffVDCSaDwPeo3xgktXOKm5SNgrGk5/E30lGaW0Xcd
         ftqKOe3jEQxx+lGnSJwPy6smn85syA43TDFZ2byEVe76it+e44xgtP8IqvLJNY53MObG
         ciFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3Lt4WVagAGoPNQQ8sUuV+xbM6KmxoNVjHzW8jPpsfl4=;
        fh=wKEo+K4twi3GCH8RATECiNKn2ztKkSxHIbhH7x04khc=;
        b=FHul6VkJqpMeMVhaw6k0DMMJhi7HxT7i1jFGU/ehsAn12uXh4qABTSNPlR/YYfQVU3
         IlCCyUIG/CL9Cm6UZAHQYhDSmbIdnIAvXm88CdPUQZbCyahToFwW/BK1h7Ndt/iiUCXc
         STKhYzspirkVWJhRtbvXRBGJsTlT80GEZ7eAo30n6tA1ALlSw47FjROtegV64ORP7+S1
         FEMwgJsRb4P+C2niO1z6kYTYJc3PlksBPSmcFx+8EoXfIdhD55MaXsl2py9mx5Lr3jBL
         C5s3Cvugc7EyzODsQWV4HbdLPlD0prR+szFjsbenrzidwlSjV54vAkJ2V0BLMhNo2Rxn
         RjXQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795668788; x=1796273588; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3Lt4WVagAGoPNQQ8sUuV+xbM6KmxoNVjHzW8jPpsfl4=;
        b=Wt/H8uEXeygfnRJXsnha4ogYR4WFdKKtucv0h74Hl9SvZ7ZVOZ8pyveIu/m+bbBuqU
         7pLEkyr5FS02oSIkkEdcPGP7aMYZHs2eR8ZbSslwbXiv4nig66Yw9zXIl5pT+EHlNoMU
         cQHBNyntCt6+GiY4hESZ00/HEKXKxMOneQnWVqwJdquEVsZ01fF3oKFb+IYLDHDd97P1
         5iwuBre8QUjJjwbIhiuIlmYLUamd902f2vsDR98ELoNLHrtAN91EmUr8k1YyhoPYh3J/
         v+aNlL3NNgtJeSDZE4JVJM46ZiSMrhfEMHEAp3euRyiB3I6N1f0aZKatBbawmZwgSrYV
         rmxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795668788; x=1796273588;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Lt4WVagAGoPNQQ8sUuV+xbM6KmxoNVjHzW8jPpsfl4=;
        b=SUdaJAoV3pTWqLURNbFzI3wxkGxaigSQVCnxC63JKIIqiuVqCAnI1ipgfBDmiNkJHm
         8ymUiLe3LF3CWBC2ZIxOCsCMlOGnO6lKEJr8Oke/e+pVI29iadQzheSMDYIc56CITr67
         ijrXVDfUlBKBE8M02BPuDRX3HKJ599vWPK+OiK7+8OQfCuF12WRk8nXUbPS9/BSXen3G
         Mj2buBmGOlAYn+Cnsr38ZH8jLjRhjMswjkSyYHO52UKabxC5p9JHxgayVPPvQYajcnA7
         wh6YdVsYXmao6gN1YgxxaL07/BuYSEw41+Y3dv03WFJoqJk7b8GswVD63QdBZ9ZPHm4O
         4LxA==
X-Forwarded-Encrypted: i=1; AL+hErHl2cgat74iVtDkSt9IrvpF+9xyQs41pEOIoXoeS31aI/4MwVoMv8OMmuE/mU59X/frAEgQ7KX1pN4=@vger.kernel.org
X-Gm-Message-State: APuU4Z+CyaXfJzrJrZEDJjs31fuSrBjHSM6WB9RmIb4ank8h5Jt+BBQc
	mDAoTNdJPXHFMMgQz4g6radxnkftycwU0Je8IQA8foeDZOyj1+9GFct1mK0KPofo3qjFTp/DanP
	t43+oygcGi5m87E06gfge77k1QkVySUi2DSKBymJi
X-Gm-Gg: AZFdTZcWlJk7gWNKXux7Z6cJZQrEfApsxIs0anXrqheKe2bkVQ+jCdYfw8fmKbgsl66
	DaY46hDO5ihDVE06gKaAHre0GKoDPJjjeh3deuxGa58RJoUKFd2jVQgwDqhXLA2JXzMAjJ4rXm5
	LqWN0WEwe95xdQ3K9uDUAT8ielP2/3IP9wOrJxMUfIDoRShp5l+qGPq0cKlzLbQfDeqMZbLS9A8
	xpfP7r6xHT2qnTIlrqatf0/PLmD48cbUov3Z3uCHgHGwFBZAMpaKflGBBxAy9OqzrjPD83Ol2To
	EBAmekWPPe/6l0KcQDazE+WWObLqnBBM6RUx1V3cy2FtinRU+/0NgFENN8V8WFUY35Z6qlBmgUm
	6zegt7ViwJltD6YfOoKsTpIJp6uEeI5Azi33F1ixQGo68aQXtHJyuFNe/Ng==
X-Received: by 2002:a05:622a:1e86:b0:536:3ee4:81cd with SMTP id
 d75a77b69052e-55d88127bafmr101738501cf.4.1795668787640; Wed, 25 Nov 2026
 20:53:07 -0800 (PST)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261125061523.1540234-1-irogers@google.com> <DN4FM3TBOJ9T.2QOOL77P5HETO@garyguo.net>
 <20261125132225.00254c37@gandalf.local.home>
In-Reply-To: <20261125132225.00254c37@gandalf.local.home>
From: Ian Rogers <irogers@google.com>
Date: Wed, 25 Nov 2026 20:52:56 -0800
X-Gm-Features: Aa3M54pMQmXw5Cgtc0EakW9NOiIZs8STgUuBigJfJMSZlzejGTE6XZMetCnzc-8
Message-ID: <CAP-5=fWkUW787c4dGx9rccucqD67dfRgwBB_SoCxFnfZXtXP-w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/30] unwind: Minimal DWARF CFI unwinding for user
 and kernel space
To: Steven Rostedt <rostedt@goodmis.org>, Gary Guo <gary@garyguo.net>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, jpoimboe@kernel.org, peterz@infradead.org, 
	mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, acme@kernel.org, namhyung@kernel.org, 
	linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, 
	nathan@kernel.org, llvm@lists.linux.dev, nsc@kernel.org, 
	linux-kbuild@vger.kernel.org, ojeda@kernel.org, 
	rust-for-linux@vger.kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, 
	wnliu@google.com, dylanbhatch@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 10:22=E2=80=AFAM Steven Rostedt <rostedt@goodmis.or=
g> wrote:
>
> On Wed, 25 Nov 2026 16:28:02 +0000
> "Gary Guo" <gary@garyguo.net> wrote:
>
> > A quick question: how do you plan to get this working on 32-bit ARM whi=
ch has
> > its own EHABI?
>
> Do we care? Isn't ARM 32 mostly deprecated at this moment? Or at least no=
t
> adding new features.

There has been recent work on both MIPS and Alpha for perf events, so
supporting ARM32 EHABI doesn't seem unreasonable. Devices like the
Raspberry Pi Zero W/WH, which use a 32-bit CPU are end-of-life in 2030
(according to https://endoflife.date/raspberry-pi ). It is
out-of-scope here, but extending the kernel and verification
infrastructure shouldn't be hard.

Thanks,
Ian

> -- Steve
