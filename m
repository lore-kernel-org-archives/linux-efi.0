Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DDE0485CC1;
	Wed,  2 Sep 2026 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788359298; cv=none; b=pb2oBn6AuS+hOHU8z05YleN9ESVFgCqCIc9gWBXVpZ9dqreMrd/UhU5hY1cSBNG2krzfQPiNpwLW6eOGumS+ZR90FC1YPNFP9vowWn8HGbRcZbTctUIYXPGARZTWn7QAJvw/2VAP3fybpaehWkMBP5TTBdnYyxyqoEVr8BjrhEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788359298; c=relaxed/simple;
	bh=vbTH9s3/Ul9URmPb77ibABQUHQKlxUKRIAYaw6elQlk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d2K3BvX0IN40ohGlcRkph2B6OKFSNZEHBvLzqgrA1329VL94We61ZPERiYTlsYomAkGWZfeyjAI8wyIFb3GJGx4bVuhIVIsn0msA2TKNNx+woLw9BMV4ksnX0WMD8TxCqlkAf4FjoPe79fDaFIAmBZwSUov5UvYQRdU/MJN3OSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=g1zVRjgG; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="g1zVRjgG"
Received: from [100.96.96.2] (unknown [52.179.129.152])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5F7CE20B712B;
	Wed,  2 Sep 2026 07:27:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5F7CE20B712B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788359260;
	bh=RsO9jOUjp4ZqsgNR1mF+Sy/j1D4ROE1fJderrlIJWwM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g1zVRjgGrvdjBsGRigSkQBTxrfFVM/bmlWG4MrVdKmqbq76M5J6rZ6I78/1cZnd76
	 9iqadtW3UX6Og1YjMOKekkuW/XsxbZWNVlG5/ziwC1+SnrRgrkXmSQ12M5BYcXISOq
	 XkDQojmsOwG/h0JhoV+ofx7T0q5Yt1nRZTBU3WpU=
Message-ID: <7f233e48-69d8-4132-8cc6-a24908fe304e@linux.microsoft.com>
Date: Wed, 2 Sep 2026 10:28:11 -0400
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
 <20260902011615.GE2583463@liuwe-devbox-debian-v2.local>
Content-Language: en-US
From: Thara Gopinath <tgopinath@linux.microsoft.com>
In-Reply-To: <20260902011615.GE2583463@liuwe-devbox-debian-v2.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/1/2026 9:16 PM, Wei Liu wrote:
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
>> +static int __init hv_vsm_boot_init(void)
>> +{
>> +	cpumask_var_t mask;
>> +	unsigned int boot_cpu;
>> +	int ret;
>> +
>> +	if (!vsm_arch_has_vsm_access())
>> +		return 0;
>> +
>> +	/*
>> +	 * Copy the current cpu mask and pin rest of the running code to boot cpu.
>> +	 * Important since we want boot cpu of VTL0 to be the boot cpu for VTL1.
>> +	 * ToDo: Check if copying and restoring current->cpus_mask is enough
>> +	 * ToDo: Verify the assumption that cpumask_first(cpu_online_mask) is
>> +	 * the boot cpu
> 
> Can we get closures on these todos?
> 
> I see a bunch of todos in other patches, too. It would be good to close
> them as well.

Sorry about those. Most of them are remnants from the when the dev work was
started and are closed or taken care of. I will ensure that these are fixed
and the comments are edited properly in the next revision.

Warm Regards
Thara
> 
> Wei


