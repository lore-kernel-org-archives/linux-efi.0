Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.32
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795076580;
	b=ZfTjt8jcfH63SLVHn4XbB7eA0zdBpLseZ9r6G8PRQ6kVcS+5yy+3W5/BbNxu3mwyY6Fe
	 shQdQ7KT3ANg0fj9c6qJGcC2aoslob0O6nro5nk+VIBIsd3FtnVP4q1WWaez9CIbqhxKg
	 QbH1nUUI3w0K9ym4IM24X1ipoQtvMge0S+oHqFdDhW20ikZCeUtOUrV5vLyfDiPCeUgUn
	 qo/VARITgIVHqUE0qDOrggT5J7rfr+RUlL9iI9eIk9rWn2/qSQb9BF4V+n8mHZPQ7I06L
	 1HQrHNVbDiRuWAzA04JRMLPUCqV5Jnql2xaRUUIwKKoAkdVn4tK1JWZ/QuadQNI7Uvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795076580;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9xtLTQESNoyZANIpHgUGyLeoukqSPARphk8aXo+VHwE=;
	b=w9x7Ct9Gt/jDPppcA5hqi+ut4+QA2FkJuTAnDipwAirgshuuNK8qveLMWom7YlcleU5H
	 CfOpmUkvWBTiQv9TpwncKbJ8ve5ofdZGNWmrDUv2NWvml3Nx+hckhV8YxzImTIOLOJXHo
	 TbvGoL2MvPGnl1SA1q/8QJJXLlOPyQD+3NoIXDrUA64s662dnfSNT8QdFAPDH1s5fFl5C
	 0k1dULu2O5dP9gWzJrPYYlL23Il/smqRK5mGmNKq8Mo2NVHOtWieBYA9400pYLLTc1H6j
	 mgAwTG9mlf85l7gNUP+JZJP7QoNbyreCduxAh54WREJ85LkAX1LoQkrvKqPux/ZlsPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BZTs81g1;
	arc=none smtp.remote-ip=95.215.58.32
Received: from mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BD3606A326
	for <linux-efi@vger.kernel.org>; Thu, 19 Nov 2026 08:22:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2BD3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BZTs81g1
X-Envelope-To: linux-efi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=v7j+so0A9nPKyNFG/7i7Z4Ia8f3AlnUzgV4OZVQCLNk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795076578; v=1; x=1795681378;
 b=BZTs81g1fEkSqitVV4t9rG209OAs2Z6LhOlMb1dhkVBU7JJoQwZXIU2UiNukIc56TNeEaEBM
 L8baLRDYMTM7od3Xy2umHbnTg015iOiVp/N89YCgaXXPX4oAXnJ005Nb8+5b3oISUwKx1XdjDmC
 JkG1KiwKHooWUcc9X1c0VmF8=
X-Envelope-To: linux-efi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 09da8324dc43e42a;
	Thu, 19 Nov 2026 08:22:57 +0000
X-Mizu-Trace-ID: 09da8324dc43e42a
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	ardb@kernel.org,
	pratyush@kernel.org
Cc: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	shuah@kernel.org,
	ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a configuration table
Date: Thu, 19 Nov 2026 17:22:52 +0900
Message-ID: <20261119082252.9120-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAAhV-H5Vse=pKC3Beqhqxa7fqadiGVNqkSy_06HZ3Luw2Pmj5Q@mail.gmail.com>
References: <CAAhV-H5Vse=pKC3Beqhqxa7fqadiGVNqkSy_06HZ3Luw2Pmj5Q@mail.gmail.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Huacai, Ard, Pratyush,

On Wed, Nov 04 2026, Huacai Chen wrote:
> I prefer to keep it in LoongArch until a second architecture, and I
> think Ard is the same. But this is not a strong objection to Pratyush.

Kexin Liu and I have tried x86 as the second user, to see whether the
common table holds up. It needed only small changes:

- The x86 EFI stub installs the table, as the LoongArch stub does.
  install_kho_table() moves from efi-stub.c to efi-stub-helper.c so
  that the x86 stub can call it.

- kexec_file_load() skips the SETUP_KEXEC_KHO record when the table
  exists and the next kernel will get efi_info. Otherwise, for example
  on a legacy BIOS boot or with noefi, it falls back to setup_data.

- When there is no SETUP_KEXEC_KHO record, the decompressor's KASLR
  code looks up the KHO bootmem areas in the table, so the kernel is
  not decompressed onto preserved memory.

The table layout did not change. The only change to the common code is
that efi_kho_table_found() is no longer __init, since x86 calls it at
kexec load time.

Tested in QEMU on x86_64. With OVMF, the KHO vmtest and
luo_kexec_simple pass, and the second kernel finds the KHO state
through the table. With SeaBIOS, the KHO vmtest passes through
setup_data.

So I would like to keep the table common in v7. Would you prefer the
x86 patches in the same series, so that the generic code comes with a
second user, or as a separate series on top?

Pratyush, does this match what you had in mind for x86?

Thanks,
George
