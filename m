Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B542C15BB
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 15:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788536736; cv=none; b=J0SQOnHaS4sSYTVq6Xx04KYTtJAhJMCKNxl+Q/UCkR9KshOmOEMgrTDTC4DCkQqAGLHstisi2RELKtBOb+npOJbkHO4B+ykuo+LhL3onV9RmmYM1iWTsKGwxOZPdKc29a/aJM6anS+K0kUkRXQ+YKePaW2L+qJ2lHX61HBrzC1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788536736; c=relaxed/simple;
	bh=0i2ur6bxtGesXmSKwhHP+Be/MOfypFS0q4OAYvJgvzc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:From:To:
	 References:In-Reply-To; b=ttEc7Tn5SO7HWzrd1ozkK1fdIfDFx2pzjOO0yxtvzajgGUerdoDvk1l6MfvIC0q94bEdM7WqadVeAofoJF44Uu/cZRSyS40BwkUpwX4CLQQel3faMVZX4PQ2p/VVQzIgb+6ifXvYtruYEWSYcycBoBoJpjvG0NBpEImEusRqY2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mdiRSc6r; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mdiRSc6r"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7f3ece23165so1042649a34.0
        for <linux-efi@vger.kernel.org>; Fri, 04 Sep 2026 08:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788536733; x=1789141533; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:cc:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BdtITZOav3pjxc4SwRDxA49yanevszl3jiRD/k4W2wY=;
        b=mdiRSc6r5WoW+yNAAv7KediiqRmlIppeS3eaO94ejHpsjvSAW2yR0Zc1wR79aVRtut
         VKgTA8RAM5mDy1KoCU92lEH7lz64uT3Ad5/BeCTbKAyTLRFhoo6qLFep8YsUk7hxAnLt
         SGp7UDRIdptJoEj1NkKVBnkqHss2bFkm07n7+72xeXcOnkpFMjKqLKmpM/nzAlY6tWWB
         cHq2nr9Iwlx2jEZOJ7iJ77GxHL8HQZwVKXbIK9qp3VcrFutLNDtXcG01Zm81CKqAeelq
         vVfrCeMKlpmD1plMZecK6c35rQVh3TzzOP4N7bk3eIATJMz5qkzny9VEMxXvYQ/aGK6i
         2zjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788536733; x=1789141533;
        h=in-reply-to:references:to:from:cc:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BdtITZOav3pjxc4SwRDxA49yanevszl3jiRD/k4W2wY=;
        b=CrvLoaJFuUxE2nqgkkReReOV8ke7etdUHDchuWKQXUj9VQDTLyNqKwhkifjSzHiunf
         rIzl7h9XGVawMc61vCmygOdwWEeRQ6DL1F/6V8o0LgS/D3mvotAgVGmt9vHkbiabPgKu
         IA9rVUbniBq3fJ0iZKKa+hiYu9uzocqYptL3st0WJiGyvCMYxFzjUDgcC/YNyvNkRQGV
         4p8yyTfjt/N/fQfZXcC1GUo0+EMKUPwItG1JAkmfaO0EQRjPNYwmmvuqDs6cUGxBJa26
         SrS4gbWHsg1ILwaMemo8RUUbsf0T9+330Yzvs2w7zCh2XxZtWQEONpDMoBirPYIHHLIk
         Cy2A==
X-Forwarded-Encrypted: i=1; AKwUvBzSA9TArXT3NqvqfowRSoOnGgagGYqvyZ94WogGg4y39HuMNEZXUuZjmkDTt/DGI65vBVTxqRVGr0g=@vger.kernel.org
X-Gm-Message-State: AFuF++lQCH0dldwyH295ZIq7zgtjDoELiNJ3QUoUqi3fXZpnS5WCwG7A
	TVXaJnEknq1+7fWxw37UkEQZkjInSDmUG4DPxxP45zwR7BH0YUf8HzDe
X-Gm-Gg: AYBFou2ttUr+GbjTflg1a4xEh4op9PhgsjAOTg9SBFjfv6HyId3wP7hfw8Kqw89atFp
	HmpO2V4RluTJ0yDw2U0fH5XctINONA3BCLkptYu37FDLJNs62ejbYx+LBYiXPc5TPfSlPWVkvac
	oZh4hwo044ZB3oLptZNIpjSxYGsrRszhQJCM55LodB3KIZaW3SyoHfnbZ0CXhsA1UhgT3EFseEM
	/Mt9AaEboed2u34w1B9mJs47vc5/vVfGlaHdxT9v1H5auvZeq9125OGE6KW5Nz69wuBaRxwKfid
	hXfKlDwiUcDdepT7la3GTtBPR7zHnWKzXBG/JNcu7sj6iEZhHgORu8otPaKO3Ws6fS/+n+fL9D/
	GMjk+KSQmvIShKHtcim7+/AsIxlg3Fe5AR30vzTh+NyvLrJ7uI9Kt4U7Wu6PFAWm8oCp/sm4hzo
	w+eA7XhrE0rrUhhe6ma2UqqNbbAd+k1Ip7rG5HwQ/a2acOwzuNNbD7lW4CU0CjrHn7ptIMt2o0A
	0u4+/H40I8vmsC8KdB2glA=
X-Received: by 2002:a05:6820:179b:b0:6ae:774d:45ab with SMTP id 006d021491bc7-6b6fd8cdab9mr5371183eaf.27.1788536733038;
        Fri, 04 Sep 2026 08:45:33 -0700 (PDT)
Received: from localhost (ip68-107-67-45.sd.sd.cox.net. [68.107.67.45])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243bfbe3sm7513320c88.11.2026.09.04.08.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 08:45:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 04 Sep 2026 08:45:30 -0700
Message-Id: <DL6NCV1KQ9F9.6K6XZQCS4AF3@gmail.com>
Subject: Re: [PATCH v1 0/2] efi/tpm: Preserve event log without changing x86
 E820
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Rafael J . Wysocki"
 <rafael@kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
 <linux-efi@vger.kernel.org>, <linux-pm@vger.kernel.org>, <x86@kernel.org>,
 <linux-kernel@vger.kernel.org>
From: "Jasmeet (Jazz) Bhatia" <jasmeet.bhatia.us@gmail.com>
To: "Ard Biesheuvel" <ardb@kernel.org>, "Jasmeet (Jazz) Bhatia"
 <jasmeet.bhatia.us@gmail.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <cover.1788259938.git.jasmeet.bhatia.us@gmail.com>
 <a9e23066-aa75-44be-ac3b-9a15f4cf6047@app.fastmail.com>
In-Reply-To: <a9e23066-aa75-44be-ac3b-9a15f4cf6047@app.fastmail.com>

On Thu Sep 3, 2026 at 7:18 AM PDT, Ard Biesheuvel wrote:
> Hi Jazz,
>
> On Tue, 1 Sep 2026, at 13:34, Jasmeet (Jazz) Bhatia wrote:
>> The EFI stub currently allocates the TPM event log as
>> EFI_ACPI_RECLAIM_MEMORY. On x86, this becomes an ACPI data entry
>> in the E820 map.
>>
>> On a Framework Laptop 16 (AMD Ryzen AI 300 Series), the EFI allocator
>> can place this allocation at different physical addresses across boots.
>> Since x86 hibernation validates architecture-specific data from
>> the firmware E820 map, this causes an otherwise valid hibernation image
>> to be rejected on resume with the following error:
>>
>>   Hibernate inconsistent memory map detected!
>>   PM: hibernation: Image mismatch: architecture specific data
>>
>> Allocating the event log as EFI_LOADER_DATA avoids changing the E820
>> map, but doing that alone would regress the kexec corruption issue fixed
>> by commit 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event
>> log to avoid corruption").
>>
>
> As I replied in the other thread, I am not convinced preserving the TPM
> event log across a kexec makes sense to begin with. This is the firmware'=
s
> view of the state of the TPM PCRs when it handed over the system to the
> first OS.
>
> If the first OS boots, loads a kexec kernel and then boots it without
> measuring any of that into the TPM, the TPM event log will match the
> TPM state, but this is meaningless because of the missing measurements,
> and the attestation chain is broken.
>
> If the first OS does perform TPM measurements, it would need to record
> them into a log and pass that on to the kexec'ed in some implementation
> specific way - it cannot use the existing TPM event log for that.
>
> TL;DR perhaps we should just discard the TPM event log reference from
> the EFI config tables after consuming it. Or add a special case to the
> kexec code to disregard it.
Ok, honestly that makes a lot of sense I see what you are saying and I
tend to agree. I'm treating the copied event log at something that
survives kexec in this patch because of the corruption fix so I'll look
at dropping that LINUX_EFI_TPM_EVENT_LOG_GUID reference and rewrite this
patch. Hopefully, that will avoid that x86 E820 instability as well.

Appreciate the guidance!
