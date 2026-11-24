Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795535914;
	b=bkj0ur0cph+PID/ARW5Z10iBavIngUDYgnX6cK4splcPcRH0ik557mrtRKA3gjs8gENG
	 nHdlvEj1bJBDZMz1igH4OzF+BHsRQOyDXtXz34VZcjYmwQHQYoskIUE2tvVSNB6nawgFn
	 nC58iOCubiQynlC5RMrOikBG+S20ORA/+dp9TUdPOKYqDTSFQpwFRcBqoEpaVH7ryOj11
	 /1KKCWGVJ5MY0uGiJu/qyZljtnn3XgQxcZx92aKa9BVRvoDNgd20pbwGdkaYWlnCGnwF8
	 4uMaRp8nXPJrMS9FSwMs3vzf6swR48wj/c7q3HKkRziJEeXm56vgkUlDIvQQto3RXIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795535914;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=OGW1pesUgBXQRVvPeLaAto75CWDUmEXOH2vREiIu1hI=;
	b=KFpzeBzMjC8FYk5nmCWRZqHGzwER6dVMjKO/kWtdejEmjJ6J16F8Vj5bQvg6yiq5SKKt
	 /8PmgWknf86vJlamblvvUzLUbfB0PlaP3YLag/oHPa+fY8OGAaR/2gr8tq/N9Ky8fRMnQ
	 pArEyq8QtVQ/Q402Zt8/oPbK1At6fARt2uyc0dYIIN49vwewHotN+vNKOJ5AMLIzahhAS
	 9WOKKyFiQC0UFvOpCZI5+SvvIFSW4+fuz4HBC88DH4evNTTeQfsWS7gYI7vzvYBvHsM1k
	 LU/h0Wel/L/pUXUQw3y4t0zrHN5V9vhXjnGCEon74DaFRxsY13Kd0PVx9DUlvAuvmqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cPkqEExz;
	arc=none smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AC7606A31E;
	Tue, 24 Nov 2026 15:58:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3AC7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cPkqEExz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795535914; x=1827071914;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u2cm4iCPSe9XdaKEcS9x2ZNPfXRScR7FSXj0COT09zI=;
  b=cPkqEExzLtqPiRPPXmYWHwjwOuEphWhQP8TrBE30LyqZt3oDR/qNSWvt
   onMJ9GZBXcn0pTQ2pi3DfLIMTsVvkSdpGJif1gPoY9lz+lSr1A38zQkzn
   ksh1xZFD3QA4WnSfzd2OmSAEjSHACWc9fhJ2IaozdCGT8gB10DkqAH84N
   V3NTBJaDrYlUwIL3kBhHjJG7Ejae/L59FDopTLkrGC54xvDWh9nTpzOw9
   78ThUaW66lxg8npaeq7vJXSqiVPibQIytDG1o0sFMjBNAOB/VYocFc5Lw
   FfhgyK3uepYrQNtH3X9gY69BfXFLhyLbfDfT4IvHWZ2QLLI+KJCVbxjE+
   A==;
X-CSE-ConnectionGUID: UYjcsCQnTMuP5bg4gY1ENg==
X-CSE-MsgGUID: hUosqgtwTIe4l9ghTrTeGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4441248"
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="4441248"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 07:58:34 -0800
X-CSE-ConnectionGUID: 0Htf26JWQYCdoBHrJ102Wg==
X-CSE-MsgGUID: dXHu2Wf3RyGLbGT7u9pJkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="11577700"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.20]) ([10.125.110.20])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 07:58:32 -0800
Message-ID: <2dd40d0d-2e1f-4a7f-ba65-2cceccd82028@intel.com>
Date: Tue, 24 Nov 2026 07:58:31 -0800
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/3] x86/e820: Ignore memmap= and mem= in confidential
 guests
To: Mike Rapoport <rppt@kernel.org>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org,
 Pankaj.gupta.linux@gmail.com
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
 <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>
 <awWzrkLxfQ2_ODKe@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <awWzrkLxfQ2_ODKe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/24/26 07:56, Mike Rapoport wrote:
> On Tue, Nov 24, 2026 at 07:09:42AM -0800, Dave Hansen wrote:
>> On 11/24/26 05:32, Pankaj Gupta wrote:
>>> In a confidential guest (SEV-SNP, TDX) the EFI stub builds the unaccepted
>>> memory bitmap before the command line is parsed. memmap= and mem= edit
>>> e820_table only afterwards.
>> memmap= and mem= are debugging tools, right? 
> I wish they were 🙂
> But AFAIU they are used to carve out "pmem" or PFN-mapped memory.

I've used them that way for development, but production pmem systems
always had persistent memory in their BIOS-provided memory maps.

How are folks depending on these in production in confidential guests?
