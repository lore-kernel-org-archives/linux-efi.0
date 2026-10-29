Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793302959;
	b=TOz5mOBjAEqTPNSOZza0d+l4U+g/MB0iXVyIKAp/NMuug3wUeYyOQ2LfG4gJTyuGZiqW
	 te37Ud2EsCWMDMvtMR79zE7DEopVf7it5C5OlOBVdR4Xl5QBRXTVdTFs3M18KeCnvTrWL
	 wyu9jeDUt6iBKQUikgIZBLxuVJABk3PJbmD0/+Mk4t8Ms/TjLAguEy4EypzeRJm3xMPOc
	 KErFYfKOz5+jnFPLnQ6AgF/bFksjsQ9kZhFDke67aGt3iXcwSX81Kr5AiCFyA+sPbZJzI
	 WANhwK1+NAaRSze2x3LNWaVcgxbZ0Ib1jimOk2WS/zM6jG086RMEzmuUexZ7mxoD0nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793302959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:User-Agent:MIME-Version:Content-Type;
	bh=M5BOmtE/8D5RrPoWo6N/EKi/wginAI3FukwfrzZJ0T4=;
	b=xVepFKLYMzL9/ttQc1ICrw8jFn4RmmDPEjLjsEo1c+VAWxjFY7gRvvCnmNrwEzMLDhia
	 wJs0KECKMde35GXI3FrcoGVS+6q0LTUVZSEjDTobG0X/ojqS48zdI8hhhWKnfePwPB1Sh
	 aFvrIz0Mbhab4ON4s2XwrbkC2/mVu1hE79cY4bXagnadA0HSIXJ3ZHE4fPISaxUIBsfdj
	 j/MkNYzysbLe6yJA4iJm2YX9KglPOpqmhEwxehAyuuwQEBxMkmlnA7qr6Uez5mzSCjziA
	 /3XieAr2mxyphlEEbYN/65XYf1rc4+IhL/SQxKqAhwbGaHW4nyZ46xeGEqXyotkmENw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n039RvLz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EFD606A31A;
	Thu, 29 Oct 2026 19:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n039RvLz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BE91F01816;
	Thu, 29 Oct 2026 19:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793302958;
	bh=M5BOmtE/8D5RrPoWo6N/EKi/wginAI3FukwfrzZJ0T4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=n039RvLz2MQBp9BfxMGzLnlsnUbqv3QH+HRwNf04y8I98V0PpNABrMhrQJMeaVmvi
	 3zd85eM31AJtqMMB13jFkSzHv20sMetPAlDdCrnN+gI7jS+LzruLhraQXgfy47gOTT
	 wpDzerJy0E9A5ce5AyJDoETbe3jRVDdWzHquTqzoqF3fmvcdz0PyWTAygUO988r7Re
	 Dfc0Ff9jntdVerieMBs8hG4DiJnjUPBGUKeH9lxbkdygoBOOVImf8qmcqQVIOKmaO7
	 aLxl7AN2nZfGozNkzCESmg2v5yIhJ/KpKEP2Bt8IAMYBLHSy7y/tY1SFFm/cPJ17Yg
	 pNfHWjm/hb5jw==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Ard Biesheuvel" <ardb@kernel.org>
Cc: "George Guo" <dongtai.guo@linux.dev>,  "Mike Rapoport"
 <rppt@kernel.org>,  "Pasha Tatashin" <pasha.tatashin@soleen.com>,
  "Pratyush Yadav" <pratyush@kernel.org>,  "Huacai Chen"
 <chenhuacai@kernel.org>,  shuah@kernel.org,  "Ilias Apalodimas"
 <ilias.apalodimas@linaro.org>,  "Andrew Morton"
 <akpm@linux-foundation.org>,  baoquan.he@linux.dev,
  ruirui.yang@linux.dev,  guodongtai@kylinos.cn,  "WANG Xuerui"
 <kernel@xen0n.name>,  "Alexander Graf" <graf@amazon.com>,
  liukexin@kylinos.cn,  loongarch@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kselftest@vger.kernel.org,
  linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a
 configuration table
In-Reply-To: <2382a0ee-cb6d-4572-be6e-ce3cf4d006e5@app.fastmail.com> (Ard
	Biesheuvel's message of "Thu, 29 Oct 2026 20:28:01 +0100")
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
	<20261029172956.20791-2-dongtai.guo@linux.dev>
	<2382a0ee-cb6d-4572-be6e-ce3cf4d006e5@app.fastmail.com>
Date: Thu, 29 Oct 2026 20:42:34 +0100
Message-ID: <2vxzqzh8mgyd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Hi Ard,

On Thu, Oct 29 2026, Ard Biesheuvel wrote:

> On Thu, 29 Oct 2026, at 18:29, George Guo wrote:
>> From: George Guo <guodongtai@kylinos.cn>
>>
>> KHO has to give the next kernel two addresses: the KHO FDT and the
>> bootmem area list. arm64 and riscv put them under /chosen in the boot
>> FDT. LoongArch systems booting with EFI and ACPI do not require a boot
>> FDT, so KHO needs another way to pass this information.
>>
>> Add a Linux EFI configuration table for them, under
>> LINUX_EFI_KEXEC_HANDOVER_GUID. It points to a struct linux_efi_kho_data.
>>
>>   - On a cold boot, the LoongArch EFI stub installs the table, zeroed.
>>     Each kexec'd kernel is given the same EFI system table, so it finds
>>     the same table.
>>
>>   - In early boot, efi_config_parse_tables() reserves the table so
>>     neither the page allocator nor kexec segments use it, and calls
>>     kho_populate() if the table holds KHO state.
>>
>>   - Provide efi_kho_update() to update the table before kexec. Map the
>>     table during boot so updates do not require allocation or mapping
>>     at panic time.
>>
>>   - efi_kho_table_found() tells architecture code whether the table was
>>     found at boot, so it can turn KHO off when the table is missing.
>>
>> Only the LoongArch stub installs the table, and only with
>> CONFIG_KEXEC_HANDOVER. Elsewhere there is no table and this code does
>> nothing.
>>
>
> Can we handle this as an arch table then, and handle everything in
> the LoongArch arch code?

I think this is useful for all architectures that use EFI, not only
Loongarch. Today Loongarch is the only user, but this can very easily be
used by other architectures.

For example, I have been considering moving x86 over to this too. Today
we use setup_data. Once we get EFI support, I would like to get rid of
that and unify everything under EFI. It is much simpler to have a
universal way to pass KHO payload over.

-- 
Regards,
Pratyush Yadav
