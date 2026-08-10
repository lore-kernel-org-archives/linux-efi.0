Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188E8415F36
	for <linux-efi@vger.kernel.org>; Mon, 10 Aug 2026 15:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786376633; cv=none; b=rXMrz7h2oLuBItCKLa72iIyP+tKR5rcFsNayg/hY495VDovIX3wdcigoWl+LJz+tDCL1DBx3+a1ixWEhmBmOrgoCk23pWQOVJe0il3fiuIRl62GBZbxE1t+CJKxOpk9g8iNTY7YD0hSz7gkmrqZ5PjSBPqCof7jTkMHLxnPkH4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786376633; c=relaxed/simple;
	bh=YIZs804ULgvhPTfcv60vz7TxYe81em1M3QKFMAhpT48=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=jhOJovLi6UKFeXYkrerTNvDEC2aAITvuM894ICKMel1GEdJiGcyU+Bbp1D3GHrFLYxMcaa8JnaLmd7zAAmM1huJF1/kCtq689DSKeefCBjzTLoP8o8XaboFsvuDwCRLRjFsduufmzG8Q8oaSlvA4jEXusbWQAMPKQFifVQmrthI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JGd314SS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JGd314SS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454311F00A3D;
	Mon, 10 Aug 2026 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786376631;
	bh=05YK56mFtHrEuaFcPHkzwDatIY9V5n4yQHJVl624XGE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=JGd314SSxzNTgV0kF8sv7E9q+qKl1lRuwsg5ipHPh+VTTLODwZYeVepO+PsqzkZzz
	 j2LgdoiGtZocYdYBH3E4SjYLaKizcrROSG8fTglPdFk1f2yYAzC41O4xSUc2gL+Q9Q
	 ZkLSxPrytGsuPowWdY+as4vcqC8F4Ar2vEhvWa4RRX0sXcPk4eF0ZgnZNTGW3GjquA
	 yETuQLMrhDP7vX0DPaTWW4zP1lVGMaSZqQPs9fg8FuyEj7djUezUwuwXh6JSxyrM9J
	 8sBsHYq9lHOWhEf3tShXLwEsHu3h6Nh2gp+lrZhZ3HWIKubu/ZlNKRxGvSs1Dl++Ws
	 JftpWElfY0u1A==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id BE685198005A;
	Mon, 10 Aug 2026 11:43:49 -0400 (EDT)
Received: from ams-imap-19 ([10.64.2.39])
  by ams-compute-02.internal (MEProxy); Mon, 10 Aug 2026 11:43:49 -0400
X-ME-Sender: <xms:s_F5agwMLUhYZRg7a6-YjKHLqhoi66bPpSn_jXW6MP0-BUdBgOEO7g>
    <xme:s_F5avG8n5LTYaWYEQu2N-3e6dIKi0xH0lEpvJP2TCw_Wp2Fqy1lawWMofRuEH4zA
    TETZk5ytkhmSQHdPPWAcs3Ojg2-xykMM3DcQiEoOmSLKl2JCTJeUCHJ>
X-ME-Proxy-Cause: dmFkZTE74I8Lt/EZObcXqeW81Rvt2Zx8ARAuW+8n/TWZEgPsKNrz4nphPQ4lIEyYiB6h7S
    LHagim+WOIAmy5azWIBETOPfib40UL/0ozB491E5MorMU177tGnxDh9l+Jqge+hmwo+d6n
    VAaeJIZwhxAD4Dkoj1dxXOekxc33Mb84Jeb9ifb1o7D7qLKmdjxhT7io/G0LoK20+R0CvN
    7l1e9FDUhMXofKEhRIwi+F5FCtHiHpkh1cTu2nyS+QYvK3H262SQ6x9KMc9MYQzeRHD3WQ
    TkYj2QWtG+J3eHBnJOZFlSeSuMf6zyg2EfFU7HlOFG/WJJW0LaD2CRmNarCxnh2COZ0+ar
    WUpFZ9uRTfizBsuQNtK4Qk6lreTQCwt+LWezxZv9CAc2ItG8uqSMwliec4lEtOxoCXfEMI
    cJTNz5dpkr+/W45/CCDMCAP5+BsgNDsd90Q3WlapahV6DTbRhGxSeovuEJofpwobpkUyga
    MQluz5pQegqYqr2Dyo8mHRRrhz7dxYJPO3hYsawn7dlfctSI4W1NAeFSs/+dj76wezZCEQ
    4ZBVZAATlREqE7wblGh+9agiZM74waIVktQY3bdraPr/jh1Q22rWyWCyA5Adcntjy99Kdz
    J1tPxunSAeJtnvSbfw34gMU0y1Hbbfpt3zBh2H6BecQGvUVky8nAk5zmmAeg
X-ME-Proxy: <xmx:tfF5amunpkCOZAILHtXzL4Dk2W8-a7fNblfAS0Z0GrXrFisBNQ19YA>
    <xmx:tfF5agYgkG-J9jnh2-gc0L3tRARmLUIQSxCcsIFruael4gJMlmh42Q>
    <xmx:tfF5amA2KzgIM8kcgKKj-RxgnixTUEuAIZ61JG-7CHxuQkLMJt52ng>
    <xmx:tfF5ag8dYi8LbZVW7Yl07DxJDTf7bnA6zkPn7CNyGK7mJ9ya4yP7OQ>
    <xmx:tfF5aqTVvOelbF-JMfmP9HL83XYq7fLJd8uzWGhjAPblJvdIHauynxJ7>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id A58372F81643; Mon, 10 Aug 2026 11:43:47 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 10 Aug 2026 17:43:27 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Will Deacon" <will@kernel.org>
Cc: "gus bourg" <gus@bourg.net>, "Catalin Marinas" <catalin.marinas@arm.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Message-Id: <1473a7a8-7e96-4c7e-9973-98682b3f6999@app.fastmail.com>
In-Reply-To: <anmwTDnFR2cgxkqR@willie-the-truck>
References: <20260806000144.3388823-1-gus@bourg.net>
 <anXMug2_-vZl_pZ7@willie-the-truck>
 <30c5499e-8041-4e39-933b-c5220d53be77@app.fastmail.com>
 <anmwTDnFR2cgxkqR@willie-the-truck>
Subject: Re: [PATCH] arm64/efi: Do not call EFI runtime services preemptibly under SW
 PAN
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 10 Aug 2026, at 13:04, Will Deacon wrote:
> On Fri, Aug 07, 2026 at 04:56:00PM +0300, Ard Biesheuvel wrote:
>> 
>> 
>> On Fri, 7 Aug 2026, at 15:16, Will Deacon wrote:
>> > On Wed, Aug 05, 2026 at 05:01:44PM -0700, gus bourg wrote:
>> >> From: Gus Bourg <gus@bourg.net>
>> >> 
>> >> When PAN is emulated by switching TTBR0_EL1, arch_efi_call_virt_setup()
>> >> installs the EFI mm into TTBR0_EL1 via uaccess_ttbr0_enable(), and only a
>> >> return from exception ever puts it back: check_and_switch_context() skips
>> >> the register write by design ("Defer TTBR0_EL1 setting for user threads to
>> >> uaccess_enable() when emulating PAN"), and __switch_to() does not touch it
>> >> either. switch_mm() updates only thread_info->ttbr0.
>> >> 
>> >> Since commit a5baf582f4c0 ("arm64/efi: Call EFI runtime services without
>> >> disabling preemption") the runtime call is preemptible, so the EFI worker
>> >> can now be scheduled out inside that window. An involuntary preemption is
>> >> harmless, because __swpan_entry_el1()/__swpan_exit_el1() save and restore
>> >> the state around the exception. A voluntary reschedule is not: it performs
>> >> no return from exception, so the worker resumes with another task's
>> >> TTBR0_EL1 - or reserved_pg_dir - and the next efi_mm access takes a level 0
>> >> translation fault.
>> >> 
>> >> There is such a preemption point in arch_efi_call_virt_setup() itself,
>> >> immediately after the TTBR0 install: __efi_fpsimd_begin() ->
>> >> kernel_neon_begin() -> put_cpu_fpsimd_context() -> local_bh_enable() ->
>> >> preempt_check_resched().
>> >
>> > Hmm, can we move the ttbr0 toggling until after __efi_fpsimd_begin() so
>> > that this preemption point doesn't interfere?
>> >
>> 
>> Either that, or tweak the logic so that the switch is done eagerly in
>> this particular case (untested):
>> 
>> --- a/arch/arm64/mm/context.c
>> +++ b/arch/arm64/mm/context.c
>> @@ -266,7 +266,7 @@
>>          * Defer TTBR0_EL1 setting for user threads to uaccess_enable() when
>>          * emulating PAN.
>>          */
>> -       if (!system_uses_ttbr0_pan())
>> +       if (!system_uses_ttbr0_pan() || mm_is_efi(mm))
>>                 cpu_switch_mm(mm->pgd, mm);
>>  }
>
> I think I'd prefer to avoid special-casing this, if we can. I was just
> thinking of the diff below.
>

I think that should work, yes. I don't think we dereference any EFI runtime
pointers after coming back from the firmware call, so even if there are any
voluntary preemption points lurking (in the pr_err() inside
efi_call_virt_check_flags(), for instance), they should not trigger an access
that hits TTBR0.




>
> --->8
>
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 30cd7f804398..0ec90fd1754e 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -184,6 +184,8 @@ void arch_efi_call_virt_setup(void)
>                 efi_virtmap_load();
>         }
> 
> +       __efi_fpsimd_begin();
> +
>         /*
>          * Enable access to the valid TTBR0_EL1 and invoke the errata
>          * workaround directly since there is no return from exception when
> @@ -191,8 +193,6 @@ void arch_efi_call_virt_setup(void)
>          */
>         uaccess_ttbr0_enable();
>         post_ttbr_update_workaround();
> -
> -       __efi_fpsimd_begin();
>  }
> 
>  void arch_efi_call_virt_teardown(void)
