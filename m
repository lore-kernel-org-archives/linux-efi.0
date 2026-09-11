Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFA53290AA
	for <linux-efi@vger.kernel.org>; Fri, 11 Sep 2026 03:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789095800; cv=none; b=qc+wMEoXaMHOO9O49ShcBnfethJkKPm67HQH+T1DDal61yz4k8ZDj9bME1CfafKXDQkFm/bTZzCtCglLT5NrwP7pp7dRLR/2hBj8rEttooaLh9qa+Bz7A/kYpvk+SGw+7CtQgWlEwjIQcFiq3NHNcYqZaHNQgJ5/U3MX+q/Merc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789095800; c=relaxed/simple;
	bh=UL4IaLvDYf4eZDrQo3pMfd8B5yVZDGWQIefeXbbQrAM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=V16/F7k7NxIe3kVZYcb9S4BpTEmztZYk5qV6C9lfMTlFB/bz4EOklv3OBfT4//0r33fLMWPRR9YhUtp6rjpZyZr/hJbuKRak/aa/2OXAumJbTLfJR5hTF10DFWimjzTTznyZ/ZtJ0QhRQCsQiD1+arY2B4/DXQDcgakjsfVNxJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JTTsMU2t; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JTTsMU2t"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6b1c75f0049so471334eaf.3
        for <linux-efi@vger.kernel.org>; Thu, 10 Sep 2026 20:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789095798; x=1789700598; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0nnirejavAbxn9gQ8vj1fIYctFpSqsa1QzZ3kmf8s7Y=;
        b=JTTsMU2tAVJBPl34IX0LC5kUjClmXfeInt0mwTvfREf920JKgGQnPQO9/KLi0EsXG2
         feMKvTyMWEQJVmCjtcE1OrAAzfvlZHXuGT22b4n9y4wyp4L/I9GdkmSZJzJvo6XmamZV
         1GLj75qZFGgZhRMmHtOBzLCTJpmRHzjQScmsdg71+CyzVIoBvh/W+OE7SuzLUwUDZije
         QPPiH/5/4W22/dW+xnmQXanAYNLlhIaDAmD5otRORKS5IxJ2dRBElrO5Z90bcDdbHt+S
         O5iV3m2xtBRTMLYHY2dwG/WGWm07tyFtEeON8Z7/gDOcGE3fOT5Ow13WA1N5gWVkXuKR
         ZG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789095798; x=1789700598;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0nnirejavAbxn9gQ8vj1fIYctFpSqsa1QzZ3kmf8s7Y=;
        b=SZbRQJEJi3nrH7VaZ4shztieqDcW9bdnSYJO4FoSrt6sa4oALEOVVfIjkthozGtuiI
         2gdcwGGCvucNPVJWCGi7eakQZpEytIv9ca1IvZjXXGa1/nWjYCsro96hi1jZjlGa2KVz
         BHKlfsMnDeNG7AixiI9cNTsbLNp8LbCgitUpxUxlZHiAvv4jLB3fHoKwv7rDMsPfYnot
         xYa/fKpW5/kOwpBuUtZZ8mOfLWCntnCH0ZIqwkay6sk6JkVeQFjwb1NzFi6FDdB6RRq4
         xfzZ8776nGw/rGYlzTsL1XWOAcLk+BFy2sfkrpa1+uphAc4GFm0z3uSErqMxYdp5hefT
         XtWQ==
X-Forwarded-Encrypted: i=1; AKwUvByFY26p5wEhzLsSuKEhQd2Pla3wkpZBYAo5OVhZdPcKcxzkaWlDaQrsq9YZJZWLxOPXb1oX44WfnuQ=@vger.kernel.org
X-Gm-Message-State: AFuF++lfebDSrKCyKYdZdtDZGjCYJTsLK5LPhu1Irkw1rDlIw4sdwfmv
	N8QGMZSVjrpHdnd0Um9YosfuCfmDlrkp1R6tXT2pLDm/fBCDu6ui5ipP
X-Gm-Gg: AYBFou1RKtyvEssaPArJND5+R64QdeWfw71UOTTFGmjeEzTlIUmoEIR+KiWnE9YHECZ
	jNYD4Ua45hsYNTMz/XEPYU1OClyBiypgyc2FVWwPKNRdpxYtYMpmrWL7ffnDJ7t9E6vkyyQgwkO
	43e03b8S0kHOoAcS2jCiz/Ynt7IyIFbum8AckVex84YbRbp82zSi46sR0+yKzSorfFFpM3wxojG
	hzCFHbqjN8poxL2DBVnK/ugt97CqDfddXYgf2fCFRQv5i5+sKW9CDMoDW9US1eNwD3716+CGtBk
	VJB9Oacr3sNobySrgQwr/VT7KUt0OxNm/vvKfAJpOjpjKsAhI/TBZcZQ1+gzxtPZe4P1XSiq3bs
	F2WPcSu/E3X47wa+U7KpVeAYDtylG8hoKISuLumOa/MxlIbOpYid8znJk7O1SXU35IyOX0nNKJQ
	WO6Sx0OziM+bVhyuzMFzavUtWGSPXfVzBIUxCb5qN+MyjT3rF+hpxKzy7awagL/lFSnD7YCHA7q
	AfZ17i3g3bDNIx7/UOKFeikmi4XZw1xvA==
X-Received: by 2002:a05:6820:61b:b0:6bd:fbe8:fb95 with SMTP id 006d021491bc7-6c0be1502f9mr1256940eaf.60.1789095797410;
        Thu, 10 Sep 2026 20:03:17 -0700 (PDT)
Received: from localhost (ip68-107-67-45.sd.sd.cox.net. [68.107.67.45])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4e9b359sm2093108eec.14.2026.09.10.20.03.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 20:03:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 10 Sep 2026 20:03:15 -0700
Message-Id: <DLC5J1TZ2XOC.NRYCTBZ72424@gmail.com>
Cc: "Jasmeet (Jazz) Bhatia" <jasmeet.bhatia.us@gmail.com>, "Rafael J .
 Wysocki" <rafael@kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
 <linux-efi@vger.kernel.org>, <linux-pm@vger.kernel.org>, <x86@kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 0/2] efi/tpm: Preserve event log without changing x86
 E820
From: "Jasmeet (Jazz) Bhatia" <jasmeet.bhatia.us@gmail.com>
To: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Ard Biesheuvel"
 <ardb@kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <cover.1788259938.git.jasmeet.bhatia.us@gmail.com>
 <a9e23066-aa75-44be-ac3b-9a15f4cf6047@app.fastmail.com>
 <DL6NCV1KQ9F9.6K6XZQCS4AF3@gmail.com>
 <c3ca811b-a6eb-4f4d-bbb2-4feef02e3db2@app.fastmail.com>
 <CAC_iWjL9jDsRaU7kEemYfwk292Nxa49cK0Rq=81pC=FWNRDhvg@mail.gmail.com>
In-Reply-To: <CAC_iWjL9jDsRaU7kEemYfwk292Nxa49cK0Rq=81pC=FWNRDhvg@mail.gmail.com>

On Mon Sep 7, 2026 at 8:57 AM PDT, Ilias Apalodimas wrote:
> Hi Ard,
>
> On Fri, 4 Sept 2026 at 19:39, Ard Biesheuvel <ardb@kernel.org> wrote:
>>
>>
>>
>> On Fri, 4 Sep 2026, at 17:45, Jasmeet (Jazz) Bhatia wrote:
>> > On Thu Sep 3, 2026 at 7:18 AM PDT, Ard Biesheuvel wrote:
>> >> Hi Jazz,
>> >>
>> >> On Tue, 1 Sep 2026, at 13:34, Jasmeet (Jazz) Bhatia wrote:
>> >>> The EFI stub currently allocates the TPM event log as
>> >>> EFI_ACPI_RECLAIM_MEMORY. On x86, this becomes an ACPI data entry
>> >>> in the E820 map.
>> >>>
>> >>> On a Framework Laptop 16 (AMD Ryzen AI 300 Series), the EFI allocato=
r
>> >>> can place this allocation at different physical addresses across boo=
ts.
>> >>> Since x86 hibernation validates architecture-specific data from
>> >>> the firmware E820 map, this causes an otherwise valid hibernation im=
age
>> >>> to be rejected on resume with the following error:
>> >>>
>> >>>   Hibernate inconsistent memory map detected!
>> >>>   PM: hibernation: Image mismatch: architecture specific data
>> >>>
>> >>> Allocating the event log as EFI_LOADER_DATA avoids changing the E820
>> >>> map, but doing that alone would regress the kexec corruption issue f=
ixed
>> >>> by commit 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for ev=
ent
>> >>> log to avoid corruption").
>> >>>
>> >>
>> >> As I replied in the other thread, I am not convinced preserving the T=
PM
>> >> event log across a kexec makes sense to begin with. This is the firmw=
are's
>> >> view of the state of the TPM PCRs when it handed over the system to t=
he
>> >> first OS.
>
> It doesn't make sense imho. The only thing you prove is that you
> kexeced from a 'previous good OS', but without knowledge of what that
> OS did before kexecing.
>
>> >>
>> >> If the first OS boots, loads a kexec kernel and then boots it without
>> >> measuring any of that into the TPM, the TPM event log will match the
>> >> TPM state, but this is meaningless because of the missing measurement=
s,
>> >> and the attestation chain is broken.
>> >>
>> >> If the first OS does perform TPM measurements, it would need to recor=
d
>> >> them into a log and pass that on to the kexec'ed in some implementati=
on
>> >> specific way - it cannot use the existing TPM event log for that.
>
> Hrmm, that might be problematic. The EventLog needs to illustrate the
> state of the TPM PCRs. IOW replaying the EventLog in memory should
> match the current TPM PCRs. But that also means we'll have to teach
> kexec how to properly extend the PCRs and update the EventLog.
>
>> >>
>> >> TL;DR perhaps we should just discard the TPM event log reference from
>> >> the EFI config tables after consuming it. Or add a special case to th=
e
>> >> kexec code to disregard it.

Assuming we drop the LINUX_EFI_TPM_EVENT_LOG_GUID reference after the
kernel consumes the log, is that going to impact any in-kernel kexec
path that expects that efi.tpm_log to remain valid? Or is that reference
only needed during the initial TPM event log import?

I'm trying to understand whether removing that reference is just for
stopping the next kernel from re-importing the stale firmware log, or
whether other there exists other users of that reference.

>
> I can't decide what's best here. IIRC we don't expose the final event
> log config table in systab right? So we won't break any user-space app
> that depends on it.  We just copy it in
> /sys/kernel/security/tpm0/binary_bios_measurements. In that case
> getting rid of it would work.
>
> Cheers
> /Ilias
>
>> > Ok, honestly that makes a lot of sense I see what you are saying and I
>> > tend to agree. I'm treating the copied event log at something that
>> > survives kexec in this patch because of the corruption fix so I'll loo=
k
>> > at dropping that LINUX_EFI_TPM_EVENT_LOG_GUID reference and rewrite th=
is
>> > patch. Hopefully, that will avoid that x86 E820 instability as well.
>> >
>> > Appreciate the guidance!
>>
>> Please don't send any patches yet - I'd like to get some input from othe=
r
>> folks as well.
>>


