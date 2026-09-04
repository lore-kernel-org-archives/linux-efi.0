Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E833EC6BF;
	Fri,  4 Sep 2026 13:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788528233; cv=none; b=XUXOy796OrTG7optABRJZPVU4mgKVlEzla0Hk8bEDYzy61G3kbB1/rClvYIcgHn0dXLfgB1qZxCZA92o6oe1SVLkHUeSF1st9MMC2Qhyyft0njXGW8eM4z4gEIhLO2Dzb5mbrjIt/vMxKCTRKnTbkCNJVjm/QkDcF9q2khtmhjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788528233; c=relaxed/simple;
	bh=8YE3RTcEQOT2wg9tiSKtHLR1BMZmM5nI/dktz9GEYEo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m5NWKIIQzPG1+QCmzwHr2BH09NxH2cIwHU60U+KFUgKcae85cMRvjHpoh7ylJ2SCPoWGWXbMYS0cED+ORoVa4KlilZlo3BeyA/BnSrAjNdLV3/2sTM4ZoM8ByQOD4lYHAIj+WBWem/57TzgmMsRPwe2KyW2Yw0wOeCI9qlgjOsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Z3bL5PbI; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Z3bL5PbI"
Received: from [100.96.208.22] (unknown [52.167.115.14])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6970020B7167;
	Fri,  4 Sep 2026 06:23:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6970020B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788528192;
	bh=zfRaYwBzvlDKBWnDTPbexJcpzSMnPjXd9cjuSU+tmjs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z3bL5PbITFFrFgjUmanXIkANPtZwXRXlS2ZyvDmpNZWGzFlIGGoM2Ve+LRqDMAbKd
	 9Vs3ZKMCy+mzV0CW/ZUc2MrxTeRK0tj7FFFZidt19fesEkM8zeo4tO2shq/Qy9vlAJ
	 E3FBgZ7zGr89MwHFyRHFVCkJD6s3TG4dOGsZOxf0=
Message-ID: <6dda6876-a757-4eb3-a234-8e9fe6f8d870@linux.microsoft.com>
Date: Fri, 4 Sep 2026 09:23:44 -0400
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 06/12] drivers: hv: Add VSM boot driver and enable
 VTL1 at the partition level
To: Wei Liu <wei.liu@kernel.org>
Cc: kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, ardb@kernel.org,
 ilias.apalodimas@linaro.org, James.Bottomley@hansenpartnership.com,
 javierm@redhat.com, lszubowi@redhat.com, francescopompo2@gmail.com,
 tgopinath@microsoft.com, x86@kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
 <20260901165647.3160413-7-tgopinath@linux.microsoft.com>
 <20260902044335.GG2583463@liuwe-devbox-debian-v2.local>
Content-Language: en-US
From: Thara Gopinath <tgopinath@linux.microsoft.com>
In-Reply-To: <20260902044335.GG2583463@liuwe-devbox-debian-v2.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/2/2026 12:43 AM, Wei Liu wrote:
> On Tue, Sep 01, 2026 at 09:55:20AM -0700, Thara Gopinath wrote:
>> Linux VBS (LVBS) uses Hyper-V's Virtual Secure Mode to run a small
>> trusted kernel in VTL1 alongside the regular VTL0 kernel, so that
>> security-sensitive state (e.g. hypervisor-enforced code integrity,
>> credential isolation) can live behind a higher-privilege boundary
>> that VTL0 compromise cannot cross. Bringing that up from Linux
>> requires the VTL0 kernel to drive the VSM setup itself.
>>
>> Add drivers/hv/hv_vsm_boot.c as the entry point for that sequence.
>> This first step handles partition-level VTL1 enable only:
>>
>>   - Probe VSM / VP-register privileges and SynIC availability before
>>     doing anything.
>>   - Pin init to the VTL0 boot CPU so VTL1 comes up on the same CPU
>>     (later patches rely on this).
>>   - Read HV_REGISTER_VSM_PARTITION_STATUS, and if VTL1 is not already
>>     enabled, issue HVCALL_ENABLE_PARTITION_VTL with MBEC and confirm
>>     by re-reading the register.
>>
>> Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
>> ---
> [...]
>> +	cpumask_copy(mask, &current->cpus_mask);
>> +	boot_cpu = cpumask_first(cpu_online_mask);
>> +	set_cpus_allowed_ptr(current, cpumask_of(boot_cpu));
>> +
>> +	ret = hv_vsm_bootstrap_vtl();
>> +	/*
>> +	 * At this point VTL0 has already advertised VSM support to the
>> +	 * bootloader/firmware via the Hyper-V OsLoaderIndications EFI
>> +	 * variable (see the x86-stub change). That signals the platform
>> +	 * that a trusted VTL1 will be brought up. If we fail to actually
>> +	 * set VTL1 up here, the partition is left in a state where an
>> +	 * attacker could race to configure VTL1 themselves and gain a
>> +	 * higher-privilege foothold than VTL0. Panic rather than continue
>> +	 * running with that exposure.
>> +	 */
> 
> Okay, I think this answers my question in the previous patch -- if VTL1
> is not used by us, that's a security problem.
> 
> It is unclear to me, if this code is enabled, how a generic kernel can
> work without a secure kernel. There should be a way to configure the
> system such that not enabling VTL1 is okay. Is there any pre-EFI command
> line parsing we can do?

Yes, we can do a pre-efi-exit-boot-service command line parsing and not set
the OsLoaderIndications EFI variable asking HYPER-V to allow VTL1 setup. We
can rename the securekernel command line option to mshv_securekernel and
repurpose it for this as well. Basically if CONFIG_HYPER_VSM is enabled but
if mshv_securekernel command line is not set VTL1 support will not be enabled
and kernel will boot. I did quickly prototype this and it is doable.

Having said that generic kernel should not enable CONFIG_HYPERV_VSM at all.
I can update the KConfig to state the same as well.

Warm Regards
Thara

> 
> Wei
> 
> 
>> +	if (ret)
>> +		panic("VTL1 boot failure caused kernel panic; consult log for more details.\n");
>> +
>> +	set_cpus_allowed_ptr(current, mask);
>> +	free_cpumask_var(mask);
>> +	return ret;
>> +}
>> +device_initcall(hv_vsm_boot_init);
>> -- 
>> 2.34.1
>>
>>

