Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B224AA3F4;
	Wed,  2 Sep 2026 16:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788366163; cv=none; b=Tvh9TnihxDqUk3jfEflBy3MT6lADhfIVt27uYnx1BG3U+jQpsCw4MPLd5ptznzeCByMq/DgRaPMIJFxwpOnAsr/uyZCTbLv7G3hmr7CNkhbXn+OSfvu1ZDBzYQF10Hf2m172O5zEPd4uveVI2T98ljnGj9PqVris3pC4S+4zd6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788366163; c=relaxed/simple;
	bh=35EstDuMwFTJkXwd8XjJdaRQlR2EtnmI53sCU5QGR1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EhFQfmpoPAqmyn7ShRyP2DLk/LXhKIVOylGQFFBAIOoCSlB1IwX1LUpt8eDvSLcxt+bX6DdnD/+tYjI+JBPsj9BVT0nmF8cJnd3+kLbQe+wchgTCozkZFCfbmbHv3JHyS7SkOfXx17LjViRSPIcE4zjFw/SWv7pyl4XdnSWTwmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=qqWUyDXO; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="qqWUyDXO"
Received: from [100.96.96.2] (unknown [52.167.115.14])
	by linux.microsoft.com (Postfix) with ESMTPSA id ED13E20B7129;
	Wed,  2 Sep 2026 09:22:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ED13E20B7129
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788366123;
	bh=DL4LgKzmMK4nAxsWVXsvmnwn/GSFB1ohXTsW7Q4KrOY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qqWUyDXO51H2V/XbTG6/ifa4WYin+SOWbYNDEefYkEF21tN/x2SIEsySCd5YcGFNr
	 u7wMRiEKi84H7lYcH2ETf2ceadiAzDsLlC3ufpZhkYjDCh7E0IhWQMlIa9EbjSG/ak
	 QPreynUFWxvj6DokkLUcMG7GM7r86X7rf3YxxwOk=
Message-ID: <4d876bd8-3885-4d65-a272-d846ae0d7d3d@linux.microsoft.com>
Date: Wed, 2 Sep 2026 12:22:37 -0400
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 07/12] drivers: hv: hv_vsm_boot: load secure kernel
 image from firmware
To: Wei Liu <wei.liu@kernel.org>
Cc: kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, ardb@kernel.org,
 ilias.apalodimas@linaro.org, James.Bottomley@hansenpartnership.com,
 javierm@redhat.com, lszubowi@redhat.com, francescopompo2@gmail.com,
 tgopinath@microsoft.com, x86@kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
 Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
 <20260901165647.3160413-8-tgopinath@linux.microsoft.com>
 <20260902043732.GF2583463@liuwe-devbox-debian-v2.local>
Content-Language: en-US
From: Thara Gopinath <tgopinath@linux.microsoft.com>
In-Reply-To: <20260902043732.GF2583463@liuwe-devbox-debian-v2.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/2/2026 12:37 AM, Wei Liu wrote:
> On Tue, Sep 01, 2026 at 09:55:21AM -0700, Thara Gopinath wrote:
>> LVBS bring-up requires loading a secure kernel image into VTL1 before
>> starting it. Add the VTL0-side loader that stages the image in the
>> memory region reserved by hv_vsm_securekernel, in preparation for the
>> VTL1 bring-up.
>>
>> The image is a 64-bit ELF fetched via request_firmware("vsm_sk"). It
>> is expected to ship inside the signed UKI/initramfs so it is
>> authenticated end-to-end via Secure Boot before the loader consumes
>> it; sourcing it from an unauthenticated location would break the LVBS
>> trust model.
>>
>> The loader validates the ELF header, stages the PT_LOAD segments into
>> the reserved region and records the entry point as a physical address
>> for use at VTL1 start time.
>>
>> If VSM support has been advertised to the hypervisor but no secure
>> kernel region was reserved on the command line, panic: LVBS bring-up
>> is committed at this point and there is no safe way to continue.
> 
> This conflicts with the memory reservation patch, in which there is an
> automatic allocation when no kernel command line is specified.

Ah no.. So securekernel= has to be specified in the command line for
__setup() to be invoked . It can be left blank without parameters like
securekernel= or with parameters like securekernel=256M@0x80000000. The
reservation logic will take care of reserving the correct memory if there
are no parameters but if there is no command line specified __setup will
not be  called. The other way of solving this and invoking the reservations
unconditionally will be to call it from setup_arch like how reserve_crashkernel
is invoked. I am not sure if we want to do that now ?? What do you think ?

But I will reword this and state that the panic happens if there is no
securekernel memory allocated (either because securekernel= was not
specified or because memory reservation itself failed)

> 
>>
>> Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
>> Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
>> ---
>>  drivers/hv/hv_vsm.h      |  17 ++++
>>  drivers/hv/hv_vsm_boot.c | 201 ++++++++++++++++++++++++++++++++++++++-
>>  include/hyperv/vsm.h     |  21 ++++
>>  3 files changed, 238 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/hv/hv_vsm.h
>>  create mode 100644 include/hyperv/vsm.h
> [...]
>> +
>> +static void __init hv_vsm_get_sk_mem(void)
>> +{
>> +	/*
>> +	 * The reserved secure kernel region is mandatory once VSM support has
>> +	 * been advertised. Without it we cannot load the secure kernel and
>> +	 * bringing up VTL1 is impossible, so fail hard rather than continuing
>> +	 * in an unusable state.
>> +	 */
>> +	if (!sk_res.start)
>> +		panic("No memory reserved in cmdline for secure kernel");
>> +
> 
> This log line is wrong.

I will fix this 

Warm Regards
Thara
> 
> Wei

