Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794970672;
	b=kMWTODrqcn/AAPwZcUPoWxM+MNybyptTmwBKSGVyWIyyud81B+R1Zd634VW6GIM17EYk
	 K1E7W64xij0GxYVKoEvEooXlyX49/0IxhIRPww3P1Ucfx4LfHYggENyGfPoB0My/ZedgE
	 uaCwZ6urwBD1O1KV+WYAO4oAep7h8skgjKOAxXXtPZrNTIyf1LnfIfQo0TShyoHUY3FyW
	 AgzYibDZkrrw0A+V/NYGC4ZB40Y5hr3HD2JyMqq1wArA9d48yIEr6NQwohRWVdKlr7iXy
	 qdmPhPgyQkEjJR++TVRH9xKXvQBTgKOZU2ymbwYPRXUNpWbcNIN7/m4rjFL9STEresQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794970672;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Message-ID:Subject:To:Cc:In-Reply-To:References:MIME-Version:
	 Date:Content-Type:Content-Transfer-Encoding;
	bh=bO2RWsrTZU9/8/kLKqxB4AnDL75UPDOIFIHs0b1+ZVs=;
	b=q4CLa0lx4HW2BVvZS9BLOyzKUu5x7UK9O0LXStrjc9kKz1cq//qh7vXQo4GgGLwM6MpQ
	 +mlrtkR3gvC26cGqF81JSbGDM1HeYEXcF7b0wsziPsgv8lny8xGP+2ClZadbXIdKnrPWB
	 Rm2kf7M36WVV8ztMcief+Mohnegk6Hv0QB+DSMugO88iB8aNrwgRXsIguEWSHwkmwY/M0
	 lBEINhrBV7uz6Lx7Wz1cJDYUwQBTlKQFtv9RjpCBnTBBasROilb62oS22Mj+AnqJ8bCxd
	 BQLO0YLlhha+Ez5tv8Lm/CH5SyX5kA95TgoZ17eCeZvnimo7Pd6p+Uo/QjP2WNjb+gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="bp2g527/";
	arc=none smtp.remote-ip=74.125.82.49
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7665A606A33B
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 02:57:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7665A606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bp2g527/
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1b3beeaf6f9so727769c88.0
        for <linux-efi@vger.kernel.org>; Tue, 17 Nov 2026 18:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794970671; x=1795575471; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:date:mime-version:references
         :in-reply-to:cc:to:subject:message-id:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bO2RWsrTZU9/8/kLKqxB4AnDL75UPDOIFIHs0b1+ZVs=;
        b=bp2g527/ARbDwTJJQ6GrosRpfFohK/WyRrzMxTKTetMG+BYP7QN9BV6t6W0A5ERLEH
         eI3YKVNWz39t1JQ3DohuDz2PlpJv7YGg3y9b9852AnnC6S/ezbeTWOWZd8dsF5rCAM7i
         tATIN/lUIAq52xeF5ohr/xtI386yiTqCAlXTSEgSf6h/7NKvNHRRidJ8In3hpIyVhu0g
         ZSqrGqk61+a6gnvHPxlGXJnxFUW20HhpVoe2APUn2JTUBWCg4LqcVdmENOaQLoMoxFIY
         bo0kWCm8rCJbDT3hsgv3yl0ZG5A7fZDOgF540hGAbJO9x3ZkjQJTAnizil5FXPmcbmzS
         Ancw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794970672; x=1795575472;
        h=content-transfer-encoding:content-type:date:mime-version:references
         :in-reply-to:cc:to:subject:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bO2RWsrTZU9/8/kLKqxB4AnDL75UPDOIFIHs0b1+ZVs=;
        b=B7Zm6V24FhpbUl8ZPsBmCUtAgC5qhIA7O+8aBLQBoZQkk/jW0xjKO17g76faQ6jT6E
         qs29M9jBZfJCa3Mh52GcP1OeprRzho9LFZIDus3gD59AzDzkwlHuNtq4rg/sX/dT/rwe
         hektiEijT8QfYkIYCcVkrMY4hInnuenbe1asx8e5aW3eqr3QbwHcajjM82z5500YUg1f
         YjQD0jmkQVg/lMVP9HvVApk7Gbzb2krJ+wb2hK5ICqek/KwCU0UVnlZxjzBxsqmy0iLM
         AOH05NBw7dEIb2Cy9IUuatFkAjmkBuIVQZAqmWNuoIcvgQy0ILICz8WWZcu7U9djIPie
         4QZA==
X-Forwarded-Encrypted: i=1; AL+hErEiIaCsSDIwYLzE8HJdUi+CG91FuyEKFYQ0zhw7pJQEOPQT1X2FYtstsiNUEAB625pOyZw1Iewi+/M=@vger.kernel.org
X-Gm-Message-State: APuU4Z+8dr6xp8kkH+lEXlBN+LIZzErGZk5w1zvyxDavjKIUwVNj8+dB
	wOZm6DtJO8xTgaXTwsoCKAfXjx3yRDTIsWSYK5vp4zs3USpUZESUrl3B
X-Gm-Gg: AYBFou3xkrkIz9OVVnuvEVd2IY9dtTQhktuhVZKDOyxUrdN2B5o9XkmMASohgYRMmET
	5csIDKiaRahT2l689rw5IVdXmdcPFBMTQeejb4raCe5YNCDVj80Vax7LIGAAZLcRYkO57qVS/go
	+BtjC+WXW5ppUpJ6SrNpoKfw16AFey7kVUuv48gJOvg7CYooE6oS3qQGSRqsXqNe/spkph6ErNU
	sgnmwIROedOFbCexMOhtuPKpP1YvWiaqQU0yxfmOyH40hgjrUPPN0XvPx+EsUiL5iHWj4tI4vtD
	Dz0k4ey67Z54sSwnX+3sWFpclSf//7gZXH8twKV4uxF90Me5RndBo1B8cFmiuZUAtqh3ItV049Q
	k9DtCp4SV1+fMoMi9LaExb2Y3VPk2pHQIHZVw3cZuNPjSROH+XJPX5NYMOZtLjkEcKDcTxj91Hz
	fArITu+L2GopMTv3gFGpw/xaZ3dCo40i246dqhVAp1HfHuqmA/RUsBSHaJxY0l7mxJfr9CY95KT
	+C7yFMZeoP9Iuk09xeOOE7EAK4P49zwru9nxPiPhs9y/lkvSmoH/z4h+JbHRwM4v5xyDkBsF3S8
	XI0sWadUf0lg6TRP3lFFqQLK8ZJ5B7xJXJs+5wKDAOxImYbAI4iejqwBQOBt5raTdyWCGX6EIbt
	SWye4VuP8NesP3Wvq4gIyWDxQ2Xln
X-Received: by 2002:a05:701b:2718:b0:1b2:6a1d:bf58 with SMTP id a92af1059eb24-1b543d4b410mr1535044c88.38.1794970671342;
        Tue, 17 Nov 2026 18:57:51 -0800 (PST)
Received: from [127.0.0.1] (ip68-107-67-45.sd.sd.cox.net. [68.107.67.45])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5446f589esm2621578c88.1.2026.11.17.18.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 18:57:50 -0800 (PST)
From: jasmeet.bhatia.us@gmail.com
Message-ID: <b66f68b5220ddcadddb41340d3ea3388@gmail.com>
Subject: Re: [PATCH v1 0/2] efi/tpm: Preserve event log without changing x86
 E820
To: ilias.apalodimas@linaro.org
Cc: ardb@kernel.org, rafael@kernel.org, pavel@ucw.cz, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAC_iWjL9jDsRaU7kEemYfwk292Nxa49cK0Rq=81pC=FWNRDhvg@mail.gmail.com>
References: <cover.1788259938.git.jasmeet.bhatia.us@gmail.com>
 <a9e23066-aa75-44be-ac3b-9a15f4cf6047@app.fastmail.com>
 <DL6NCV1KQ9F9.6K6XZQCS4AF3@gmail.com>
 <c3ca811b-a6eb-4f4d-bbb2-4feef02e3db2@app.fastmail.com>
 <CAC_iWjL9jDsRaU7kEemYfwk292Nxa49cK0Rq=81pC=FWNRDhvg@mail.gmail.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Wed, 18 Nov 2026 02:57:49 +0000
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Ard and Ilias,

I wanted to follow up on this discussion after a couple of months.=20
My bad at being slow, at keep this discussion moving.

Has there been any more considerations with the preferred approach,=20
regarding the EFI TPM event log reference and kexec?=20

This issue is still relevant to Framework 16 owners and the temporary
fix has been confirmed to work for other users despite not being a=20
proper fix to this issue.

I'm always happy to prepare and test any patches once we decide what=20
direction we want to move forward towards!

I appreciate you time and patience!

Thanks

Jazz

On Mon Sep 7, 2026 at 8:57 AM -07:00, Ilias Apalodimas wrote:
> Hi Ard,
>=20
> On Fri, 4 Sept 2026 at 19:39, Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> >
> >
> > On Fri, 4 Sep 2026, at 17:45, Jasmeet (Jazz) Bhatia wrote:
> > > On Thu Sep 3, 2026 at 7:18 AM PDT, Ard Biesheuvel wrote:
> > >> Hi Jazz,
> > >>
> > >> On Tue, 1 Sep 2026, at 13:34, Jasmeet (Jazz) Bhatia wrote:
> > >>> The EFI stub currently allocates the TPM event log as
> > >>> EFI_ACPI_RECLAIM_MEMORY. On x86, this becomes an ACPI data entry
> > >>> in the E820 map.
> > >>>
> > >>> On a Framework Laptop 16 (AMD Ryzen AI 300 Series), the EFI allocat=
or
> > >>> can place this allocation at different physical addresses across bo=
ots.
> > >>> Since x86 hibernation validates architecture-specific data from
> > >>> the firmware E820 map, this causes an otherwise valid hibernation i=
mage
> > >>> to be rejected on resume with the following error:
> > >>>
> > >>>   Hibernate inconsistent memory map detected!
> > >>>   PM: hibernation: Image mismatch: architecture specific data
> > >>>
> > >>> Allocating the event log as EFI_LOADER_DATA avoids changing the E820
> > >>> map, but doing that alone would regress the kexec corruption issue =
fixed
> > >>> by commit 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for e=
vent
> > >>> log to avoid corruption").
> > >>>
> > >>
> > >> As I replied in the other thread, I am not convinced preserving the =
TPM
> > >> event log across a kexec makes sense to begin with. This is the firm=
ware's
> > >> view of the state of the TPM PCRs when it handed over the system to =
the
> > >> first OS.
>=20
> It doesn't make sense imho. The only thing you prove is that you
> kexeced from a 'previous good OS', but without knowledge of what that
> OS did before kexecing.
>=20
> > >>
> > >> If the first OS boots, loads a kexec kernel and then boots it without
> > >> measuring any of that into the TPM, the TPM event log will match the
> > >> TPM state, but this is meaningless because of the missing measuremen=
ts,
> > >> and the attestation chain is broken.
> > >>
> > >> If the first OS does perform TPM measurements, it would need to reco=
rd
> > >> them into a log and pass that on to the kexec'ed in some implementat=
ion
> > >> specific way - it cannot use the existing TPM event log for that.
>=20
> Hrmm, that might be problematic. The EventLog needs to illustrate the
> state of the TPM PCRs. IOW replaying the EventLog in memory should
> match the current TPM PCRs. But that also means we'll have to teach
> kexec how to properly extend the PCRs and update the EventLog.
>=20
> > >>
> > >> TL;DR perhaps we should just discard the TPM event log reference from
> > >> the EFI config tables after consuming it. Or add a special case to t=
he
> > >> kexec code to disregard it.
>=20
> I can't decide what's best here. IIRC we don't expose the final event
> log config table in systab right? So we won't break any user-space app
> that depends on it.  We just copy it in
> /sys/kernel/security/tpm0/binary_bios_measurements. In that case
> getting rid of it would work.
>=20
> Cheers
> /Ilias
>=20
> > > Ok, honestly that makes a lot of sense I see what you are saying and I
> > > tend to agree. I'm treating the copied event log at something that
> > > survives kexec in this patch because of the corruption fix so I'll lo=
ok
> > > at dropping that LINUX_EFI_TPM_EVENT_LOG_GUID reference and rewrite t=
his
> > > patch. Hopefully, that will avoid that x86 E820 instability as well.
> > >
> > > Appreciate the guidance!
> >
> > Please don't send any patches yet - I'd like to get some input from oth=
er
> > folks as well.
> >

