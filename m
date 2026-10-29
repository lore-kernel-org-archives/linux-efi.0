Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793302109;
	b=B1G27VHzgPKbZxOt/PCBTTyzx2PtfsO7Qy95D2ExkE7b82PVhkRCs+sLcvXmRQ1jdyVG
	 fR9Oz5oV6JnRLp9WXJEiUg+f5c0I0VfBWICjQtNFEbqhzJvWgk4kZrYn/L76IsBts8cA/
	 g/r1M7m0U9H+nA5zRtUyrdqtVPzyh1Be3vQcVcbWQvU1+4w6XZSB5a8bUHMFJe1AX3vP3
	 j6y6yKNQQSHJPP0dwBHsbpPAaTgthJJ4Hisd/4nY9zMgk6KpW1XlXaAxljXyNnc6SUcIV
	 NFqSCRVrHqdiNXA7+B/4R2rlt00Ik7iMD3hjngSPofVWcEcq5R8N/+uXlTmI2NB5e0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793302109;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=l0+5ubFd1J4lsWZ084UYpuCIbDZPJCuWoPpCJ9/g/fE=;
	b=dBCEsI+tnnlpP9y+yjZd1S5YG2OPExKJlMR57j8ZXLLED2P9FJq7VhYwxo1e7WE9GoCQ
	 +6ZJiZubL8/slx3BKQ0Qs7q5R16oIkxl8P0CUmN0dvDX5EOz71Ea5v4KQnY48jzzIGuxD
	 JQLugwn+LcIGZBFw3W9Byif8XoXFcfRfV1SaHDRKtbUgBM9mjSMgRjfRLUJ4JufSRvIo5
	 4BWZzdXmHLKmsUCIrpyqFf52ajv9wBXG9Z0WDSPUfPbDxul7WpLz5xQ2Hpq4GeZ++T0jy
	 X1NEiohruTPLo7dtYGvTgdcXgbITVJWVFM346hFJ/cj6rBPlVNeN5IY3mmU8LP4ZdQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RGkwUZO4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBE3606A31E;
	Thu, 29 Oct 2026 19:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RGkwUZO4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BEB1F01825;
	Thu, 29 Oct 2026 19:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793302108;
	bh=l0+5ubFd1J4lsWZ084UYpuCIbDZPJCuWoPpCJ9/g/fE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=RGkwUZO4lk0dRv+GCt6hx+Fa3JOBxQ5LpFilAhtlj+7EgNtaLZsNIsmN7bBZoimWF
	 mbYVmeEC6H8Wal5rW6OFzXmN8XqQHluMk/wmMoiH7gkBHSF8eJ0ss1U8W/vFZnIjY0
	 J9etYb5B/EbNd0+VKAQdCBGYywn3pjsITdP8ljx0ZZjnWMLsh/h0q2Xmya5JARAT/e
	 G/03IGzogJXIVC6ACnxCg2WckjZFCOVBszefNj4FOk0Kp3mOnXAtdZz/E2F9FSisRn
	 k/+IkAHFs4FpgJkfprKkYtiyXUKTuK6I+YkkcS8nHysmEKvq/kQ9WUkcGsmDERCUYJ
	 yxpeOhPFPCKQA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 84372198003A;
	Thu, 29 Oct 2026 15:28:25 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 29 Oct 2026 15:28:25 -0400
X-ME-Sender: <xms:Vp7japqDDH7MTBpj2o1_0HawlWVyvY0FOU7D8Nd9IguEUhdaix0NLg>
    <xme:Vp7jamc4F6MAAJVzCkF6_bNAJ-7k-8SOvhUA7n3HuyFOvMyH0BMFlNP5K3bDlVkmU
    _MmSSbFPwfBRpUeSAyALsDRKfHwP5svjvMMMnJX_-T0oDwT3xHlOQ>
X-ME-Proxy-Cause: dmFkZTEUgvLRPruJWwMD4Akvs3ZiKwYmL4oDztPDoA8hrr5wiy3BkBr/L+J8ffIc495+a8
    sVhiVVtwPIuNAOKAlOpndG4mY3OFBA0yxH/iDkko4Iw92VWlZpDVx91SpbqSTdnJwCsCmq
    fNWy+5fryrK9SVPiry0Lo1zBi6buqOp0lcoqLNhSe+EeqeBh3swNKQj473ROSt/e3Q3YzT
    Y6Vqe3oHE7LWnGQ7fdLxgfCMkC2+Mben6NfQDOT8lpSGnMgUR7e0byjD60bSFe5B3Hne7U
    w5Gfiok6+D9TuVISthJHKLQtTSjEFU84bn3lh0P6LFT1Swa09hrw4mNbqBD5zejN/EOIVm
    llqnU5WA+hypRMru22igAtp2EarCpc/fa5olztzEdkS0JpQS4cjmX6GqUrUxqz7IITIK4z
    K3yxyQbcBGMl04ZmpOqisSGPU9G/2asCSPnYRTSQLv5jInUHP/+yzOxTPG2wbvC9GhIS8Z
    nwAjnIxctRgMiScIn7m6OoJIyndLKBXCkesgX55ummn8NiOto5buDBM9zYGYlz6iHP3oCs
    7guFdH0nVF56k6/788zHoqITj7rHth1rQqq8VphlCPUZPp0f0Tf2V7S+aum5FfPDPzLsPo
    sw2J/w3694XUXfHo/Js1a6n736sSGucGslN4UA8hN96a5+o4rLIesRyiQSiw
X-ME-Proxy: <xmx:WZ7jam3_6jP7JYZKi7_ncq2u7jb1GraqdICHIIEXhUjfDVgazjJ8Gw>
    <xmx:WZ7javjQ0EQPb0oalPZ_Y84GSb9fuBCm5hcsd0-_BmBh8nf4QJ4h4A>
    <xmx:WZ7jasZ9VmdjIbSXaeztyyyt16GVwnJztwEObzWgR8yzA6LOMR-XqA>
    <xmx:WZ7jagN_FdpPrbKtzGVUnXth4ieCquH3vlgtCHvjBwW2p6cxqSnNgQ>
    <xmx:WZ7jaoR32XkuWPNxMvWbVBj2VFK7d4bzjxxEq1WJNsRrSY-uXsbr36X4>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id F28D7F80093; Thu, 29 Oct 2026 15:28:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Thu, 29 Oct 2026 20:28:01 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "George Guo" <dongtai.guo@linux.dev>, "Mike Rapoport" <rppt@kernel.org>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>,
 "Pratyush Yadav" <pratyush@kernel.org>,
 "Huacai Chen" <chenhuacai@kernel.org>, shuah@kernel.org
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, baoquan.he@linux.dev,
 ruirui.yang@linux.dev, guodongtai@kylinos.cn,
 "WANG Xuerui" <kernel@xen0n.name>, "Alexander Graf" <graf@amazon.com>,
 liukexin@kylinos.cn, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Message-Id: <2382a0ee-cb6d-4572-be6e-ce3cf4d006e5@app.fastmail.com>
In-Reply-To: <20261029172956.20791-2-dongtai.guo@linux.dev>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
 <20261029172956.20791-2-dongtai.guo@linux.dev>
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a configuration
 table
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Thu, 29 Oct 2026, at 18:29, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
>
> KHO has to give the next kernel two addresses: the KHO FDT and the
> bootmem area list. arm64 and riscv put them under /chosen in the boot
> FDT. LoongArch systems booting with EFI and ACPI do not require a boot
> FDT, so KHO needs another way to pass this information.
>
> Add a Linux EFI configuration table for them, under
> LINUX_EFI_KEXEC_HANDOVER_GUID. It points to a struct linux_efi_kho_data.
>
>   - On a cold boot, the LoongArch EFI stub installs the table, zeroed.
>     Each kexec'd kernel is given the same EFI system table, so it finds
>     the same table.
>
>   - In early boot, efi_config_parse_tables() reserves the table so
>     neither the page allocator nor kexec segments use it, and calls
>     kho_populate() if the table holds KHO state.
>
>   - Provide efi_kho_update() to update the table before kexec. Map the
>     table during boot so updates do not require allocation or mapping
>     at panic time.
>
>   - efi_kho_table_found() tells architecture code whether the table was
>     found at boot, so it can turn KHO off when the table is missing.
>
> Only the LoongArch stub installs the table, and only with
> CONFIG_KEXEC_HANDOVER. Elsewhere there is no table and this code does
> nothing.
>

Can we handle this as an arch table then, and handle everything in
the LoongArch arch code?

