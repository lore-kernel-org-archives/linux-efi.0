Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B505335BBB;
	Mon, 12 Oct 2026 05:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791782659; cv=none; b=YFaHGIrD64QXPklsGxAn96ykxyLRpaKONhp76CZ1ECgMejgJgzrxLptyeOugMoY/3kjRV8CPCSgQbbZPUKqrn7ReExAYajzDC9vPXTgLCc9eEH5qFT0O/fO2Ie0sbdKsF8jA8zifpTreyHREDF78mSh0TlYusDd/mStkbwqQIX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791782659; c=relaxed/simple;
	bh=3pIIvHCbxNMkC/po4GFoEQpmK28rrT0Qh7BRGS/dtOE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=SWH9LXIxObPM9OJozixTYApkQct435U6+W+x6craF/h4ydo/pDbm4fCqohOuvoku14hipoJ5X1G0ppojiJbolGppseN1PZ4uJzirJ3d4srsupX1+zMuSgzobZslIqUeP3dlGluRLGb4/vvBj2vvAsAyMOM+Cras5a8ClKsq6/S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YNZny11G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YNZny11G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FCA1F0089D;
	Mon, 12 Oct 2026 05:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791782657;
	bh=yJGhwlLTK0d4yy/MBBGLML1Cs0DaKc+Cn3G63cOol+A=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=YNZny11GI0WywiCWQzSF+gvwJv+pX0HIHxehUcP+VJpumbJ22eRzMne3r3fxO6Tpv
	 uTudD7HdOLhdhiNzc7B5FOBN5l+Ms+Ny30Ob7X+phZ9C2V9fw3eYdBlBT22HByBHa4
	 XBC9qkrn/BI8LsZ0lyIxUc9b5toEBawIX34W8OiXSVfdoJL4e1B5KlGPivjbQBisTL
	 +Jsb33ckImz9tiSt6FRJoC9vzLx7HXtQdQqru6eTjUPrFVcUh30IA51rxIfovqavSe
	 3y/9eWmg7E4v8TlQzcaQe4BbtdXjYCSKB61NCqpFrgKQpXjhOQgQouQlJG2QN7uAxR
	 P7VWUuZkheaMQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id EDF0B198003A;
	Mon, 12 Oct 2026 01:24:15 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 12 Oct 2026 01:24:15 -0400
X-ME-Sender: <xms:_m7MasxBCtVxETh-n2g4skIhkTBxqB5Z8ZtiuVnjK6e2Tg47fhQfAQ>
    <xme:_m7MarEfGliYpBemg10EJiBOPiYSAe0zqoDSuiEHTbkOzGpT3qn9mMRmWJMTtOxrg
    x2sU0E2WrMG7TP16da1ncf15JMUiDdkoCdI_-5qhzsBq51aMCXRmHgX>
X-ME-Proxy-Cause: dmFkZTGlfhtDQkV+qAWhCvrY5sRWB3UZaeINvPK7YGM+rrLNLfWSJx6StN+lG9gDCU7CPl
    s9YyBBwqfLtD9pAjoQmUgPPpjv7TJZ1DnksmiuFJPydJfzWx3nXYHB8KdebnJuKhBkuWFf
    pKoME+/P0bclvBdGGi80Vrs/DQz339g+LYItkd/Zcf9gusUKMwxJuDEuKctmgvD7zmuI51
    tpm2ZO+74Nowi7W0QzHTYh5A6N0r08e2SH/7iQb8+jE9RZjTBbkwpN1U9qnS0gUYpcUqgi
    F1ulP33YEpr2CAy9Rw3eIEItU3sOTeeDPDm6q0b72ZdLmtXV5WiP4jqdvUK9k5hT+WmeHh
    kAU+Hp6WznihQok07azHEt5z2LlF6vTBUPdCN47IabxmLcDtleiIuUYkDWFWiOjVMbS6OX
    TO2vjQQyMEAGr+e53rnSFZiYBxNIp5C3i8+UqQTMhtEAjfYMa1tPmfmAoFCCcSsVIDhDUd
    B5tJUvgvZGSABfzXqvab6tFOO/zqxMOvXEMcQWGYKNRm8IF4ue8Jy9nq5XAKgfxQrc6YNw
    CET06WDCp5SFw2G31g+siM0bI5ZI3/O/EUiJRrqSreNpl/QCy0LVEL/CTIEi+/pJhl2e7n
    /Z+eDXTSLjnX459qImAHWhOrEiTP58FviAmNwRBkAxWt8mVMCJModfUFUsNA
X-ME-Proxy: <xmx:_27MaoaaBna4RpQg6sGdcoOWNRevsX8giiV8TYcc_96SRShY4mBYOw>
    <xmx:_27Mau18wiVkca4zhJM1scKechAOiaHkKOk0GbT6Q7mo5IrenKZiAw>
    <xmx:_27Mamcycwjfog0G3ndv1NiIiy7u86SN143mbxVlcaZFVwyUyInTjw>
    <xmx:_27ManHmdfwP6_tb8p2Q6nz2KU9UiXq6KZBeQDOzPpVWjSQB6fajzg>
    <xmx:_27Mav02e3wWpJyF8RwrbhV7hXx-7QfMtJH18eT1691F1OrqK08pN9dv>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 99CC9F80086; Mon, 12 Oct 2026 01:24:14 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 12 Oct 2026 07:23:53 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "MaeeFilho FL" <joaoanandalima@gmail.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Kees Cook" <keescook@chromium.org>
Message-Id: <060961e6-37d2-4343-ab11-be94c728c19e@app.fastmail.com>
In-Reply-To: 
 <CAFA5sMdbmqyqPhQ7Bqayd4-PBbA6RGHxgy7kFa_uF7mJWtFDLQ@mail.gmail.com>
References: 
 <CAFA5sMdbmqyqPhQ7Bqayd4-PBbA6RGHxgy7kFa_uF7mJWtFDLQ@mail.gmail.com>
Subject: Re: [PATCH] lkdtm: Add more EFI runtime tests
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Sun, 11 Oct 2026, at 16:48, MaeeFilho FL wrote:
> Hi Ard,
>
> The Code is excellent. A few points worth highlighting:
>
>> Two bugs were found in the arm64 EFI runtime support that weren't cau=
ght
>> by LKDTM. The existing EFI_RUNTIME_CRASH test instructs the firmware =
to
>> write to kernel memory that is mapped read-only, which usually fails =
as
>> expected. However, this does not exercise the runtime mapping logic in
>> the kernel, nor the fault recovery logic when the faulting address is
>> inside the EFI runtime memory regions itself.
>>
>> So add two more test cases:
>> - a write to R/O memory test that uses the firmware's own executable
>>   memory as an output buffer
>> - a branch to memory that is occupied by the firmware's runtime servi=
ces
>>   function table, which is usually mapped non-execute.
>
> This is an excellent addition to the LKDTM suite. Forcing GetTime() to
> target efi.runtime->set_time is a very clever way to ensure that the
> firmware page tables are strictly enforcing permissions over its own
> executable boundaries, rather than just testing general kernel mapping=
s.
>
> The execution tracking via the anonymous function pointer struct conve=
rsion
> to trap NX faults on efi.runtime data object is also rock solid and pr=
operly
> exercises the arm64 translation tables validation logic.
>
> Reviewed-by: Jo=C3=A3o Guilherme da Silva Freitas Lima <joaoanandalima=
@gmail.com>

Thanks, but next time, please don't bother with the LLM generated reviews
unless there is actionable feedback.

