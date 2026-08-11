Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7752D380FC7
	for <linux-efi@vger.kernel.org>; Tue, 11 Aug 2026 11:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786447188; cv=none; b=D3RKjRbzU2K1MbFsztsk3r/OIczy0kIqTHb5TU5K2jLgCBNxWXlPIdN6spyuIzKpkfWzrQX8/WQoGoL+7etdyWfQetsAZkzeprt+jdLCwK3/mkpXztZHb63QZ1jUuIedG9eUnlhfD+/Bo5PCKT54vOGWmo7r5QKbgEGusQ/Dreg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786447188; c=relaxed/simple;
	bh=1SHCK5t3ErZgbkd5/bMFTQiVvMK8i5VxwUfjw14JCqE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kRIEq6deuRX4Eqlo0Dg/OiTsh71MHJTWpmusUuKrLM1hMAhuUPL2P5sSAaEVskD3Tc+xUC6VoRX14S81zhsIvejnRrx3Z3UCgjRRQbmHTQi+vESVQuO9RTZexzdk5lipTLWK53mPBBW/+bQHLxmEJaN7sXKJse7SbovUkXBSmjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S2rxrJaR; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S2rxrJaR"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-481412f1828so682879f8f.1
        for <linux-efi@vger.kernel.org>; Tue, 11 Aug 2026 04:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786447185; x=1787051985; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WpHpX3dMx1OmUziffO2NidzvFmW3rlX7MNbm6J/WhK0=;
        b=S2rxrJaRRhZH/uITPBh/pasLsALBKQI5v8IfGdfU2m8kLw5IlGyZkMCp5cqNmfj1Wf
         V3BFIXB9Hp5zY9kSwFgVLs0OLJ5t7yykxgN0dkg9GaW/vLqNaUl+USBmAkzqJlwT2eR9
         nnrBYXAjqs1tZoqiHc5Pgbe/hct8/ZvtLC9K9csz7j80nRx8kjpczpY0mvKm090QdXl1
         wmjiKAUVSj/I+tO0d3/WOUUtM8DFfhz8KzIzxBan+XGcUbRqV0A26M6ghh+DSGQx7cUg
         bipk9Y6XuHKj9FF9Uzq1CEmtDxJ+h8f30elZkq4CINtLC6ULezdYmiwg02Wx0zrcZ5Va
         6JiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786447185; x=1787051985;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WpHpX3dMx1OmUziffO2NidzvFmW3rlX7MNbm6J/WhK0=;
        b=dyqxdg3TS1iLHYSd+C+PwT6EXMBCeo6mEOVKKGOxi1wGqUD6LUhEqOJShkBJ1ZVTs2
         JtpkS51nuFkGapJm0k7RO6Ru1dvhXZiaS+gzLsagCO3D0wNqceiURZll6IQpnH02u4q8
         MGko6OIyJV0MLDxyNG3LKeKT1LaLXMunBALkF6M5vQJDA0I/tKCTi10CKnTf/rFbS9EI
         zXTYpDv/4vjnaLRytK4vKQMdCNYij972J2uIu5wG4LrvHbSPJ6F/Kt/E2qE2uZu1ETd8
         hnUUTpl4v1wm9xpzEfs530FivFQ2mBtPa66z+ZUOau9438R85za8/0Iw7ij2GP1comvE
         OmjA==
X-Forwarded-Encrypted: i=1; AHgh+RpxYApDNG60nCNpbEB+TpsIcPMDXeGLmtp6YbS+9KzAFyPm66zigxe/mX8InMdOz3vvVUHhUeLtBCU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwflPqnOHEhwN012OGMnKSV27a0liQS7mk7MTc7QojsXAUCjuOH
	gwFUQZqzgBqqVu38GS6aehuOjY7lLMbB69rco4oAjBanXS/MxqBV/xYF
X-Gm-Gg: AR+sD12EDRpFTTPw196vGExzwsRA0EZbySayyZYt2HadrAyFMotpRt/zDGIBk6iu8fY
	Qyw5+IwynrhXl9r+oRXW1UsbQ4YPa+Is9mZMB83zMi3fI3G8UUPHMQCbMKmCY0rAzujBZz6/rfO
	J3ufvTp5rjyFfMo/gFttQWpTfeZb8Hl6kQ1KlYf6FZtaDJnf3M9zDgjCV4y+/p+n3IJzJEqeSD/
	IfPMdq8BngOrNnr0uopOKZ4fgZYBvK+M2XHlxue+yhS1t4FSpfxGL2XqAGPERd31jZAXB/cjz8t
	9bJF0bOpf/NKaU3KNvLl62GTkUB6gnJ8nQ08cKtmmU78WN4RdZi8okTQ8oB+dywHVRCZ8hF+0yc
	qW8sRypdUpPhEXnt6XEClGL0n3ZJYHy8uJAE52519K13iLMOdwMuAWPdRF8kC0CWqOVwdNo1BN2
	szFB/kz8/xPTgFS3RkKg5r/wRqJQT/BnCYXjHR9VFiem6jg/rxc5MarCVsTUIzHeKwRLEE/Zcx+
	5k0CXsvuS0XtUZsvblpoHcENA==
X-Received: by 2002:a5d:5e8f:0:b0:47f:6f6a:6a7f with SMTP id ffacd0b85a97d-4814ad890fbmr4370323f8f.8.1786447184497;
        Tue, 11 Aug 2026 04:19:44 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a5ac75dsm3318120f8f.7.2026.08.11.04.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 04:19:44 -0700 (PDT)
Date: Tue, 11 Aug 2026 12:19:41 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "Christophe Leroy (CS
 GROUP)" <chleroy@kernel.org>, linux-mm@kvack.org, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Ryan Roberts
 <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, Huacai Chen
 <chenhuacai@kernel.org>, loongarch@lists.linux.dev, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, Paul
 Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
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
Message-ID: <20260811121941.4ca20b88@pumpkin>
In-Reply-To: <643a624d-0106-44ed-a7f5-aaf9316f94fd@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
	<20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
	<01f07ea2-8bdd-4450-8a49-548f8b646cfd@kernel.org>
	<33fc9d31-2866-4315-9510-0004deb93994@kernel.org>
	<20260811091016.5ca67143@pumpkin>
	<643a624d-0106-44ed-a7f5-aaf9316f94fd@arm.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Aug 2026 11:00:09 +0200
Kevin Brodsky <kevin.brodsky@arm.com> wrote:

> On 11/08/2026 10:10, David Laight wrote:
> > On Wed, 5 Aug 2026 14:07:01 +0200
> > "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> > =20
> >> On 8/3/26 15:59, Christophe Leroy (CS GROUP) wrote: =20
> >>>
> >>> Le 14/07/2026 =C3=A0 16:03, Kevin Brodsky a =C3=A9crit=C2=A0:   =20
> >>>> mm code often needs to know whether some mm represents a kernel or
> >>>> user address space. This is currently done by comparing the mm
> >>>> pointer with &init_mm; besides not being particularly elegant, this
> >>>> ignores the fact that other mm's (e.g. efi_mm) may also represent
> >>>> parts of the kernel address space.
> >>>>
> >>>> Introduce a new mm flag MMF_KERNEL and set it for init_mm.
> >>>> Subsequent patches will use this flag to replace comparisons with
> >>>> &init_mm. No functional change is introduced for now.   =20
> >>> Did you consider performance impact ? This test is usually done in qu=
ite
> >>> critical memory handling functions.
> >>>
> >>> init_mm is known at link time. Before your patch 08/22 there is just a
> >>> comparison of mm (r3) with a constant (loaded in r10):
> >>>
> >>> c0014048 <assert_pte_locked>:
> >>> c0014048:=C2=A0=C2=A0=C2=A0 3d 40 c1 09=C2=A0=C2=A0=C2=A0=C2=A0 lis=
=C2=A0=C2=A0=C2=A0=C2=A0 r10,-16119
> >>> c001404c:=C2=A0=C2=A0=C2=A0 39 4a 03 98=C2=A0=C2=A0=C2=A0=C2=A0 addi=
=C2=A0=C2=A0=C2=A0 r10,r10,920
> >>> c0014050:=C2=A0=C2=A0=C2=A0 7c 03 50 00=C2=A0=C2=A0=C2=A0=C2=A0 cmpw=
=C2=A0=C2=A0=C2=A0 r3,r10
> >>> c0014054:=C2=A0=C2=A0=C2=A0 4d 82 00 20=C2=A0=C2=A0=C2=A0=C2=A0 beqlr
> >>> ...
> >>>
> >>> After patch 08/22 we have, it first checks that mm is not 0, then it =
loads the
> >>> word located at mm+528 then AND it with 0x1. This load might be costl=
y.
> >>>
> >>> c0014048 <assert_pte_locked>:
> >>> c0014048:=C2=A0=C2=A0=C2=A0 2c 03 00 00=C2=A0=C2=A0=C2=A0=C2=A0 cmpwi=
=C2=A0=C2=A0 r3,0
> >>> c001404c:=C2=A0=C2=A0=C2=A0 7c 85 23 78=C2=A0=C2=A0=C2=A0=C2=A0 mr=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 r5,r4
> >>> c0014050:=C2=A0=C2=A0=C2=A0 41 82 00 10=C2=A0=C2=A0=C2=A0=C2=A0 beq=
=C2=A0=C2=A0=C2=A0=C2=A0 c0014060 <assert_pte_locked+0x18>
> >>> c0014054:=C2=A0=C2=A0=C2=A0 81 23 02 10=C2=A0=C2=A0=C2=A0=C2=A0 lwz=
=C2=A0=C2=A0=C2=A0=C2=A0 r9,528(r3)
> >>> c0014058:=C2=A0=C2=A0=C2=A0 71 29 00 01=C2=A0=C2=A0=C2=A0=C2=A0 andi.=
=C2=A0=C2=A0 r9,r9,1
> >>> c001405c:=C2=A0=C2=A0=C2=A0 4c 82 00 20=C2=A0=C2=A0=C2=A0=C2=A0 bnelr=
   =20
> >> Is that a real problem, though? =20
> > The cost of the read is likely to matter most if the branch gets mispre=
dicted.
> > I'd also guess the mm isn't usually NULL - so that branch needs to stat=
ically
> > predicted correctly as well.
> > I'd also not assume that the mm is in the cache (unless the surrounding=
 code
> > has already accessed it), the L1 data caches are small. =20
>=20
> You're right, I didn't think about this the right way round - in general
> it may not be easy to predict that mm points to init_mm, and an
> arbitrary user mm isn't guaranteed to be cached. Repeated calls to
> mm_is_kernel(mm) in the same function shouldn't cost much though.

Depends.
If it is real function call the code will be in the I-cache and is likely
to get predicted correctly by the third call.
OTOH if inlined you've all the I-cache loads and that static branch
prediction might get them all wrong.

Oh, and saving the result in a local might cause a register spill.

	David

>=20
> Would some (micro)benchmark be particularly relevant to measure the
> overhead, if any?
>=20
> - Kevin

