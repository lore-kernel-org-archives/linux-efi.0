Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EF6F38654F;
	Wed,  2 Sep 2026 14:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788359026; cv=none; b=jf5ccx+/J2OVbGNQBcbkCZpZQE/1/dyqFh0eTFydWd6u2X37XxFhyTOdOLFaTEWopC5nXR2kzfaG6vP3rZakDRaThv8Qol+S8SCtD/KTcACjDtOUzLja6AF2tBBsCbslyn1uqiS333K0zHk+QhFHNM6SQrEWdd3q/fetes7SHR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788359026; c=relaxed/simple;
	bh=sEFIUMKWLZX+yQSOGmL3b78+J3hH2sZuSr6qBJ7C0T4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D2//XtRG3PAxrYsNkGrJTWLN8EjrkfXAQ9Nzdtrz4BT9snBJc9sFUn+dVjl2oEej3O0gCEBlKh2d2ZQQliXy/LwpPkTFV+4z69BgvzhP4ApmhnR69nS9GjP7hdBB+YCVwSfdboKpxhIb3+kHik6JyD24HeAedVl2iACSDiGKR20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=TQ/nb3da; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="TQ/nb3da"
Received: from [100.96.96.2] (unknown [52.167.112.163])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4B80220B7129;
	Wed,  2 Sep 2026 07:23:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4B80220B7129
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788358988;
	bh=pVoZDF50BWfJviZXzaFO4BEvT6efDhDjB+DPJrhRYpA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TQ/nb3daTCzAbiG1wXH8dmlcI4aHc/tTPkiRq3is0L8dFsA+BQURB3XW21AOJhAJr
	 0/dU1KsXyRoTDWNE26J5lOy8dHqKyfwUVUOF0En6K2E0fQ6YjqmR5b8bKJ/PI1mUCf
	 V2aCdYiQNoAn34K1O0fnJcV4iwOgPUtax2GuTisU=
Message-ID: <05afd579-c1ff-4c50-947b-a398bf6d1fee@linux.microsoft.com>
Date: Wed, 2 Sep 2026 10:23:39 -0400
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 04/12] firmware: efi: libstub: x86-stub: Enable VSM
 awareness in efi os indications variable
To: Wei Liu <wei.liu@kernel.org>
Cc: kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, ardb@kernel.org,
 ilias.apalodimas@linaro.org, James.Bottomley@hansenpartnership.com,
 javierm@redhat.com, lszubowi@redhat.com, francescopompo2@gmail.com,
 tgopinath@microsoft.com, x86@kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
 <20260901165647.3160413-5-tgopinath@linux.microsoft.com>
 <20260902010958.GD2583463@liuwe-devbox-debian-v2.local>
Content-Language: en-US
From: Thara Gopinath <tgopinath@linux.microsoft.com>
In-Reply-To: <20260902010958.GD2583463@liuwe-devbox-debian-v2.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/1/2026 9:09 PM, Wei Liu wrote:
> On Tue, Sep 01, 2026 at 09:55:18AM -0700, Thara Gopinath wrote:
>> Set bit 0 of the Hyper-V private OsLoaderIndications EFI variable
>> during exit_boot() so the bootloader/firmware knows the OS intends
>> to enable VTL1. Without this, VTL1 cannot be brought up from the
>> Linux kernel.
>>
>> The support bit is first checked in OsLoaderIndicationsSupported,
>> and the variable is only written when the VSM bit is not already
>> set.
>>
>> Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
>> ---
>>  drivers/firmware/efi/libstub/x86-stub.c | 57 +++++++++++++++++++++++++
>>  1 file changed, 57 insertions(+)
>>
> [...]
>> +#ifdef CONFIG_HYPERV_VSM
>> +static void efi_set_hv_os_indications(void)
>> +{
>> +	efi_guid_t guid = HYPERV_PRIVATE_EFI_NAMESPACE_GUID;
>> +	efi_status_t status;
>> +	unsigned long size;
>> +	u32 attr, val;
>> +
>> +	size = sizeof(val);
>> +	status = get_efi_var(efi_HvPrivOsloaderIndicationsSupported_name,
>> +			     &guid, &attr, &size, &val);
>> +	if (status != EFI_SUCCESS) {
>> +		efi_err("Could not read Hyper-V OsloaderIndicationsSupported\n");
>> +		return;
>> +	}
>> +
>> +	if (!(val & HV_OSLOADER_INDICATION_VSM)) {
>> +		efi_info("Hyper-V does not support VSM in OsloaderIndicationsSupported\n");
>> +		return;
>> +	}
>> +
>> +	size = sizeof(val);
>> +	status = get_efi_var(efi_HvPrivOsloaderIndications_name, &guid, &attr, &size, &val);
>> +	if (status != EFI_SUCCESS) {
>> +		efi_err("Could not read Hyper-V OsLoaderIndications\n");
>> +		return;
>> +	}
>> +
>> +	if (val & HV_OSLOADER_INDICATION_VSM) {
>> +		efi_info("VSM is already supported in OsLoaderIndications.");
>> +		return;
>> +	}
>> +
>> +	val |= HV_OSLOADER_INDICATION_VSM;
>> +	size = sizeof(val);
>> +	status = set_efi_var(efi_HvPrivOsloaderIndications_name, &guid, attr, size, &val);
> 
> I'm not familiar with the security model, so bear with me.
> 
> What happens if the VTL0 kernel doesn't use VTL1 at all? Does that
> become a security issue, that malware can use the VTL1 to hide itself?
> 
> Asking this because I think you will want to enable this in the generic
> kernel(s). Not all users have or want to package a secure kernel.

Yes you are right. If we do this and a secure kernel is not loaded, it is a
security hole. Which is why this is bound by the same config option CONFIG_HYPERV_VSM
that does the secure kernel boot and in that path any error / inability to load
and establish VTL1 is treated as a serious error and we panic. Generic kernels
should not enable this option at all. The CONFIG_HYPERV_VSM should be enabled
only if it is known that VTL1 environment can be established. Otherwise the system
will not boot and will panic.

Warm Regards
Thara

> 
> Wei
> 
>> +	if (status != EFI_SUCCESS)
>> +		efi_err("Could not set Hyper-V OsLoaderIndications to indicate VSM support\n");
>> +}
>> +#endif
>> +
>>  static efi_status_t exit_boot(struct boot_params *boot_params, void *handle)
>>  {
>>  	struct setup_data *e820ext = NULL;
>> @@ -768,6 +820,11 @@ static efi_status_t exit_boot(struct boot_params *boot_params, void *handle)
>>  	if (status != EFI_SUCCESS)
>>  		return status;
>>  
>> +#ifdef CONFIG_HYPERV_VSM
>> +	/* Indicate to bootloader that we will be enabling VTL1 before exiting boot services */
>> +	efi_set_hv_os_indications();
>> +#endif
>> +
>>  	/* Might as well exit boot services now */
>>  	status = efi_exit_boot_services(handle, &priv, exit_boot_func);
>>  	if (status != EFI_SUCCESS)
>> -- 
>> 2.34.1
>>

