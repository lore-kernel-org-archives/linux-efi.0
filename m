Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E102FE07D
	for <linux-efi@vger.kernel.org>; Tue, 11 Aug 2026 13:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786454714; cv=none; b=VZzlTQJPiVT0rwpEDNvPwQhzSRb4G8IRKS0BZyCtlvbsWBmgEUO1hZLgN5xSAn1NmbHZTVFfS5YVwNzBXH/bV30ZHjdojNpTk6tpr8zjRn314B156KHP/+zHFkGwJBibHOzb2c6ti+YCsKMrUwTQI8+HDEjL1906EGcpfKT/bvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786454714; c=relaxed/simple;
	bh=CJ25QsZC14Dq2xSASACZGaavy+QR/WSe/Ecg1RU88VU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FvYIRL6CXpArL1PY9zr1LZf3spfsIUqXWnH5KC5OfpoHoqJZ0/EhaHmwx1q4+S2Jlfde9XvwA8eKCBmo0EWi4fnFv1o5jP9xRD4spUTTXYSGEHplGLb3WQX0qd5IzwL49qQnuYkq9ce0qvh81IQkGCmIzHASs7gNsqnGhOCyZJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aVVjsB2J; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aVVjsB2J"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4997581cdc1so6526525e9.3
        for <linux-efi@vger.kernel.org>; Tue, 11 Aug 2026 06:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786454710; x=1787059510; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HfUDfNxB65XZqovwWVBLkrKpJgUq3OtZ1XoJNMhjK1c=;
        b=aVVjsB2JYhGhdx99qCJ6JBZOmcxQMEmi9wWgnD6r+EUogwRcu1yy8YWNfKWgWPnnk4
         PG0LxxqtTlbIcsUP+3sWkC5HfvgmW4/JCaUhOmj47vK1vUzIgtMdxM8lMYPwm5Wh93AG
         WJAbxCBoHdhfsuQfuLQPxHCQ4VDqnGdt8FEpbOlPmpKwyiQKvBWf1lrCOhhaA8qeJTjC
         5eHMxdFBJgGbASMEm+lwxcqDZlugSJmfkUVptnoSty0lP9trrO4eY2AjBhGBGPCruQk/
         9TGR0qvomoxLIvxSPYD6Lk5FkWNaBemcKJ0aaVlMg4sTyOLCJXU6Ul98oY+Rk433dFdx
         1crw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786454710; x=1787059510;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HfUDfNxB65XZqovwWVBLkrKpJgUq3OtZ1XoJNMhjK1c=;
        b=Bf6x1Cy19yBBp8ky0IvbRd+/EGrzdWh8VOWO+zBN5tTfh56kYm4bylvMPNdL8INSOG
         WipSZbmZaih7pjuczXZfqUCicDExFgI7a+wAnz2xoTIFA1vY+yVMjwfX+OC1Orqpc1PK
         6gASGM19fyewxqBliKkH660/WugHIFUNewTeDANyz97MxaGLHt5fmcKBfF9U3LxMDcQ7
         e9jrTGypUCFJtHT5Z/dntPe+DBA/fzHgGecVErySmR0eGztQKV6WhHSoXximSh6EAql1
         EhtuB4jNE/sfa+W+9CzwCXkCdkhmhwrGKq/ya0XvmkB2bsvt5FIj+gPXUKLxBjYmtQBk
         FPyw==
X-Forwarded-Encrypted: i=1; AHgh+RoGnnNZXKa6vV5+vLEKxAu9vOvzmCdC/U0xuJuHY2q1bCY8r/K4NvfdlNWB1csxb95j8nHdlVBvyRM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBZehnadAr4lPjHPwHrmZEJiF2Q2rH9n4guRG7NVpBdSLgMh9m
	a320LWwnQBIUyiEh7wqKmst/LBrYNekz/C0lnhQqOkLBHeumgnWMUq6s
X-Gm-Gg: AR+sD130Zjy3q4o5KeWpgZnrlCnspAiU3xuJeBLD9Z6Pv7d8dvjZ6z4yre5zDykr84h
	4x49D4oU5KtCZzNByPTN4WrSmoApEriL+/zxv3XBCl+nmolgUbX+NBoQPd3I9TkKp1d8+whQfov
	TANXFSl8Hs91JGeYLMM3IKfawjKzFYjAXvXFPL2Lo/Ec/24hZje7ZqJEU1De5wxMgdgd7eUKk3J
	jYpmeo5+qqrMJ5hsYcbOGg3sMVWnpAMd+Wj3pduPRyNsRSRYn+PtjEvkyD9+5xGZdF84eFzpKoP
	M1Ljc/KchyEV+TB0r01Zmi5/jYjU6rvjngAip5s71JAMJKuihbpUmv1ROkCr5MWRLDHlqyBDqM+
	iDOHjDIJOe11ZIPoPuE5FOjhS++IuqDL6tihYbocVLqKGjYGGEqufIGwab3RZ8kgr2f0F8+fPmP
	TcFMjUd8eJWgcnEZsV9drBRARIWBNyazX5h0xlv6i87RsENdr6CUr1NJP6eMdYtKTYtf1wZXGRX
	2KG+ORznZrl7tv3g1UG0h8CsUaXPQyjOHbH
X-Received: by 2002:a05:600c:4513:b0:495:3e08:ad19 with SMTP id 5b1f17b1804b1-49978468c2bmr48261215e9.9.1786454709883;
        Tue, 11 Aug 2026 06:25:09 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49977df9489sm83541285e9.1.2026.08.11.06.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 06:25:09 -0700 (PDT)
Date: Tue, 11 Aug 2026 14:25:07 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Helge Deller
 <deller@gmx.de>, linux-parisc@vger.kernel.org, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>, Palmer
 Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, Richard
 Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, linux-um@lists.infradead.org, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
 <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, x86@kernel.org,
 tboot-devel@lists.sourceforge.net, Ard Biesheuvel <ardb@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, Vishal
 Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 03/22] mm: introduce MMF_KERNEL flag and set it for
 init_mm
Message-ID: <20260811142507.4c6c760f@pumpkin>
In-Reply-To: <01f07ea2-8bdd-4450-8a49-548f8b646cfd@kernel.org>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
	<20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
	<01f07ea2-8bdd-4450-8a49-548f8b646cfd@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Aug 2026 15:59:35 +0200
"Christophe Leroy (CS GROUP)" <chleroy@kernel.org> wrote:

> Le 14/07/2026 =C3=A0 16:03, Kevin Brodsky a =C3=A9crit=C2=A0:
> > mm code often needs to know whether some mm represents a kernel or
> > user address space. This is currently done by comparing the mm
> > pointer with &init_mm; besides not being particularly elegant, this
> > ignores the fact that other mm's (e.g. efi_mm) may also represent
> > parts of the kernel address space.
> >=20
> > Introduce a new mm flag MMF_KERNEL and set it for init_mm.
> > Subsequent patches will use this flag to replace comparisons with
> > &init_mm. No functional change is introduced for now. =20
>=20
> Did you consider performance impact ? This test is usually done in quite=
=20
> critical memory handling functions.
>=20
> init_mm is known at link time. Before your patch 08/22 there is just a=20
> comparison of mm (r3) with a constant (loaded in r10):
>=20
> c0014048 <assert_pte_locked>:
> c0014048:	3d 40 c1 09 	lis     r10,-16119
> c001404c:	39 4a 03 98 	addi    r10,r10,920
> c0014050:	7c 03 50 00 	cmpw    r3,r10
> c0014054:	4d 82 00 20 	beqlr
> ...
>=20
> After patch 08/22 we have, it first checks that mm is not 0, then it=20
> loads the word located at mm+528 then AND it with 0x1. This load might=20
> be costly.
>=20
> c0014048 <assert_pte_locked>:
> c0014048:	2c 03 00 00 	cmpwi   r3,0
> c001404c:	7c 85 23 78 	mr      r5,r4
> c0014050:	41 82 00 10 	beq     c0014060 <assert_pte_locked+0x18>
> c0014054:	81 23 02 10 	lwz     r9,528(r3)
> c0014058:	71 29 00 01 	andi.   r9,r9,1
> c001405c:	4c 82 00 20 	bnelr
> ...

Thought...
Could the check be replaced by one that checks for kernel static data?
That would require that other mm that represent part of the kernel
address space be static (and probably not in modules).
ISTR there is an address range check that can be used - and might be
cheaper than the explicit test for init_mm on many 64bit archs.

	David


