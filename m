Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE28476CF0;
	Wed,  2 Sep 2026 13:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788356330; cv=none; b=RTiIEcIme4XZT7q3oCrwRjqQkJyWNijTovUmaQq377OurzX+IFRqqfU7yLjjRWZio3QCDjYhpSE7ebkY7w71A09BORyjh+1Tvmo1nWkILEb3g/UZ5EsyCbWxBCBldQSDdAEoiYL68AVyeGWn2dl0YENaDWk1flt7EtFF79DqfMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788356330; c=relaxed/simple;
	bh=09SrxbVHjiOopKPdnDYvLWbDpI4JQH9MlMSK1PWA3KI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OjCULhNZpPuzEgvGDVFkKrfaRZ2aqB38n+a+B981Obr1Ceqh97eB3soyhVgFazh00JzDtuMgehllHSJ0INCanSoJatub1jmtwDvAwsN57rUtKtu2AURFmOW3JEgPaDQ/4AunOyGWWq9iQAstz78BPPNjVUREBvIkmh2yM84SLNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=clLPEi6v; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="clLPEi6v"
Received: from [100.96.96.2] (unknown [52.167.115.14])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6C7A320B7129;
	Wed,  2 Sep 2026 06:38:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6C7A320B7129
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788356291;
	bh=6cjB3+17zYv22sxuC+UnrrMbAIEUmd0sJx5Q6VgAXps=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=clLPEi6vC5wbQ6hdyuegwh43O9FvZX8rjObAhCVnIZcFyswkT0AR6fh6a9sJybNNh
	 +w99y1TNHqUcxvNLloFRV8oPKs7oo4rgXYm5xltrmK1s13UgcMhn0VybHyiaQiR8Qw
	 yNDQEifu1lWSo5jZjbPZblg7pjrzDXFk59bCEbuQ=
Message-ID: <c1be10ae-227b-4461-9da2-dfda25c80478@linux.microsoft.com>
Date: Wed, 2 Sep 2026 09:38:42 -0400
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 03/12] drivers: hv: Reserve memory for VSM secure
 kernel during early boot
To: Wei Liu <wei.liu@kernel.org>
Cc: kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, ardb@kernel.org,
 ilias.apalodimas@linaro.org, James.Bottomley@hansenpartnership.com,
 javierm@redhat.com, lszubowi@redhat.com, francescopompo2@gmail.com,
 tgopinath@microsoft.com, x86@kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
 Anna Trikalinou <atrikalinou@microsoft.com>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
 <20260901165647.3160413-4-tgopinath@linux.microsoft.com>
 <20260902005902.GC2583463@liuwe-devbox-debian-v2.local>
Content-Language: en-US
From: Thara Gopinath <tgopinath@linux.microsoft.com>
In-Reply-To: <20260902005902.GC2583463@liuwe-devbox-debian-v2.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/1/2026 8:59 PM, Wei Liu wrote:
> On Tue, Sep 01, 2026 at 09:55:17AM -0700, Thara Gopinath wrote:
>> The VSM secure kernel runs in VTL1 and cannot use the normal Linux
>> kernel memory allocators — its memory must be reserved before the
>> general-purpose allocator takes ownership of the physical address space.
>>
>> Add hv_vsm_securekernel.c to handle this early boot reservation. The
>> driver parses a new "securekernel=<size>[K|M|G][@<addr>]" kernel command
> 
> We should add a prefix to it, unless you tell me there is a plan to
> extend this to other virtualization solutions.

Thanks for the reviews Wei.. Yes I will add a prefix hv_ and we can
remove it if/when this gets extended to other virtualization solutions.

Warm Regards
Thara

> 
> Wei

