Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEA33A6B6D;
	Fri,  7 Aug 2026 13:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786110992; cv=none; b=H5p/7VnKubgWrU8l/dNAiuBoqqjh9SB+8TJYyvIY4O2lZza8aYwh5Qne6TSMwiByyqhUacwA1aXj08BNgLFvUJKaf+7k6HCY8/Dw8sqTLGXDuNiZYIvtP8eeInrfV+AxMIyjwrIUAuJphnlFdzAQ9ISzZ8nq2cxB8wUvQxFe1C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786110992; c=relaxed/simple;
	bh=2mQrUTI+rJ8iB/E+cQvuWKZhDA4rbpTcHyEkMc1rn74=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=qDlkIyQO2cED2VsFksHnGD/fx3xQz3THkanAwK8jeDCkQMIFWd4qKNPyGnPe3hhINiGLXmlgA/CR87wA0K/XrklDNNw7XK9TWM5Ns/BkYp62AOfBbZ4r3nphf5TNmRwH7hfBpIIZS/Kr5oCjMHzJ4/fTrc3mJA7G+Y6NSWQ8OpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMbxb3v7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMbxb3v7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9DD1F00ACA;
	Fri,  7 Aug 2026 13:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786110985;
	bh=ju7RnRq+k/paTJJQnJ4wFhHYcKti9rbeLUqp6cbspV0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=EMbxb3v7XMe+wJ7m33vfflWCirm9BYjUUeexHFCM1HhM60j96jIDHOMRzWox53rEf
	 LW+WA5jez6QoMliGtCsm1R/Ir8YlIQ68XIMxrsfS6GLU5JNtYQQU9W3woJbK+zk34Y
	 /3uTvUd9FQz60ONdCIf5jBv9xijS+kN3/ND1QC2PpnqkZ0r8oPUNbtpX951Mjid1tx
	 +uMDJaSoMpzbDzRdfXGW6qJ6LP+wMRiZ0+urFNpblGh0WZVq2Iw/1APnAaIX7JGx8Q
	 zNhU6FEqKxI1qc5f9vgtfkgfgcsIeM2TTPRgkRpSdjQCh8XkfnIupKuVgA7HKC1mRD
	 DJs/Nqbz+i62Q==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 897161980060;
	Fri,  7 Aug 2026 09:56:23 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 07 Aug 2026 09:56:23 -0400
X-ME-Sender: <xms:BeR1akGVGsC3Ch1TBlhFrJK-pwnLrQ-yyh9daiTuH12ZvvVR1wws-Q>
    <xme:BeR1aoLG5H5Mw3-EDZBum7CLlfjse8j4hM8lJdG_7ZPQQgWwu5SyB0wKENV08anJT
    YbQ7VF15Yxjl_1d0H0AlZE-V7fFtAs5sR9YLOLlc6McA2IoSLgBoG2R>
X-ME-Proxy-Cause: dmFkZTFoi/FfTpwWxN1L7rzjkmioo0gHL67DDBJGGutW8A0r/xwmyy545V0359GA+WZcWA
    6HttZcQ24FDbdXsTyRd0gs4bv7mtViNxw+CgPi0ZVzfd2mz5Adz9I3IIFJ4ebpL5dYOCei
    9u5vXyUc3NoD5aueo7v5RIVkFoHYfpRU4kROdQgCkhRaEHBZD0QS9+O/+U/U3AKiz9h44N
    f6W4s22gTJWhrhi8UUnV+XQjfd0rdaQoAt3DVAJw5EiFWr79wMbMvjBFBgR2NOKXU/bSI1
    e0akCaB9PYxyCUg6JZ/sbAbKxV/nMCdP8Ial4dVsvwM1Dy0Rlh3Vv/3ywXAHtMpYQbuMgy
    sp0LqNE3QW2MYjT5EbYKRgSW6U7NBwlOhAje+zuXU6nHkWHIgWLW/XRppq/AacvdZdKftA
    hFM/DVrKPaqNlfZH71hNU70gpQdl6Pdyt5LlIM65XIGCHTpeEhg1B7oljqeAXs7yjJxC06
    N4mhrvzoVdcfoiVM9g4a65MaIhW8XRqs8SE8KwDZiEzojKQqTQJcbMCs6btD9zstnKWmvG
    SRuezJpeF4mI7xju9VCiFT5IfFZHArTPSNAY5GbophIc1Zn3CYka/AG2ZhbTQ707ECUJD/
    wX5uGj7yi5i9CP8SG3hNmQnSVGpxVXG6yZh6sujR0zjZsMq0ah0Hm4SBDw8w
X-ME-Proxy: <xmx:B-R1aoie0F7-_rYri2G13iXWIJUkKz930XZXlt9e54aQF-BkGwjp5g>
    <xmx:B-R1al9lLvAvH1EmDV_LZZxywUM2y6uRU2hdnJ-5x4VLyMlU_so58w>
    <xmx:B-R1akWz6EmMejLKTKAhdesC9zxDvkyDYe_sCO5VvKi_qcu-NDqmRQ>
    <xmx:B-R1apAIYrTG5C6kKDStoJxQSlzRCOwweIpUA1wrlCC9U068q67oiQ>
    <xmx:B-R1apEBNm_xkSKPIQ_qXFYfTAmdEKjsRlrZbYg_3xXeLgKFqb1iquo1>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 63221F80064; Fri,  7 Aug 2026 09:56:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 07 Aug 2026 16:56:00 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Will Deacon" <will@kernel.org>, "gus bourg" <gus@bourg.net>
Cc: "Catalin Marinas" <catalin.marinas@arm.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Message-Id: <30c5499e-8041-4e39-933b-c5220d53be77@app.fastmail.com>
In-Reply-To: <anXMug2_-vZl_pZ7@willie-the-truck>
References: <20260806000144.3388823-1-gus@bourg.net>
 <anXMug2_-vZl_pZ7@willie-the-truck>
Subject: Re: [PATCH] arm64/efi: Do not call EFI runtime services preemptibly under SW
 PAN
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 7 Aug 2026, at 15:16, Will Deacon wrote:
> On Wed, Aug 05, 2026 at 05:01:44PM -0700, gus bourg wrote:
>> From: Gus Bourg <gus@bourg.net>
>> 
>> When PAN is emulated by switching TTBR0_EL1, arch_efi_call_virt_setup()
>> installs the EFI mm into TTBR0_EL1 via uaccess_ttbr0_enable(), and only a
>> return from exception ever puts it back: check_and_switch_context() skips
>> the register write by design ("Defer TTBR0_EL1 setting for user threads to
>> uaccess_enable() when emulating PAN"), and __switch_to() does not touch it
>> either. switch_mm() updates only thread_info->ttbr0.
>> 
>> Since commit a5baf582f4c0 ("arm64/efi: Call EFI runtime services without
>> disabling preemption") the runtime call is preemptible, so the EFI worker
>> can now be scheduled out inside that window. An involuntary preemption is
>> harmless, because __swpan_entry_el1()/__swpan_exit_el1() save and restore
>> the state around the exception. A voluntary reschedule is not: it performs
>> no return from exception, so the worker resumes with another task's
>> TTBR0_EL1 - or reserved_pg_dir - and the next efi_mm access takes a level 0
>> translation fault.
>> 
>> There is such a preemption point in arch_efi_call_virt_setup() itself,
>> immediately after the TTBR0 install: __efi_fpsimd_begin() ->
>> kernel_neon_begin() -> put_cpu_fpsimd_context() -> local_bh_enable() ->
>> preempt_check_resched().
>
> Hmm, can we move the ttbr0 toggling until after __efi_fpsimd_begin() so
> that this preemption point doesn't interfere?
>

Either that, or tweak the logic so that the switch is done eagerly in
this particular case (untested):

--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -266,7 +266,7 @@
         * Defer TTBR0_EL1 setting for user threads to uaccess_enable() when
         * emulating PAN.
         */
-       if (!system_uses_ttbr0_pan())
+       if (!system_uses_ttbr0_pan() || mm_is_efi(mm))
                cpu_switch_mm(mm->pgd, mm);
 }
 
