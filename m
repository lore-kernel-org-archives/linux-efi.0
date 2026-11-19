Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795085897;
	b=ZDp1JjGtBzueTNwrKc9B3Ma+Kb71/yTlsjXdkHrw2+UbjupEV/Jr4pyVDg4Q6a/QEjSf
	 FaLFWNraJ2hF8mIgknb1VIHN7gO0rkIIw5zNbBRjCbQ5kQJGB/p2ecXEQWpH+rPhsUTNQ
	 yN8lroyXUI1fZU5LRUlJVloZvRZsZlz9Ws8adAftX5BOcgQCH0vdVTN7UagnqQ6L6fkFu
	 kr3tWBpJatIQVVc030y87gLfNhPB+SEyTM+mFtR2JFsJoDC/y+Oh0ImSCrSVpyJ9QRf0C
	 wqKGSxt/Irbb0mh6eGtXr59RxgVdpZrNvQSCWZbVWFPBB9M6gDike39wqU3+jYOvr6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795085897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:User-Agent:MIME-Version:Content-Type;
	bh=+o0bQUd8q0A+WRUXZxAmN8P7csYU6Eu6m9jj0vuUv3w=;
	b=nG7GbMg5/iu6PhCKeQ6D6zePghhxP/fBp8NVXzMBzaaJVqotauIbdlHIVhgaeRyKnRlw
	 quhFm8/8f7zCX7fMPCxafgVyrb25jo+23Ryuhh3k0G00DSpcLfHWMCmpiXkWIO/pWsAOx
	 P3dWSMckHfDwPpRuDXQIQaavG7WuLq0R4oy238Ngq1+SldS7ylwwodxojLg/1liG2UWgc
	 q0RB30HHoRXfn/w8AwfhFL+vpGBXSDQMvpUUwLRnXpgfQj/UC4ocCpoSyHo1X7h+KI3//
	 sPZ0iTB099UjoqNdHThM5LT91IkPzZR4UezVV6hSmGD2ekfRLH+vE0NIkVzeK+VxkAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MIHzLV8A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240C8606A324;
	Thu, 19 Nov 2026 10:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MIHzLV8A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA28D1F000C4;
	Thu, 19 Nov 2026 10:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795085896;
	bh=+o0bQUd8q0A+WRUXZxAmN8P7csYU6Eu6m9jj0vuUv3w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=MIHzLV8As6nXxtqY6me3mqzdXMBaRaBOWQfGJwhvK3jossC2GDG2Ra6MFKWW4G+PA
	 FSE2j3Y2nrgYKsoZRqeaQlmmR8HldEkKQX/ibJlGfPtyxwuDyYtL+xn/5wmzzz9v7l
	 5FGWgzmXPkWsCVt8Us7AHZKoM27j4CijTLiDv3A5kZZVUgHGXiPdfaNJLoY6UIIyb3
	 5zUQWEG9CGNQ5rsRZ+yKBwxyMv1MVd/HvFPW6rmUc8+i1/G3rENaOYczrKWZpdGWCp
	 PdEYWVcB7FsPeI2kwfT60Qzmw+M8L3OMHvVFc0+jgQvHEL/6alUpmO0kf3kFqCnvDg
	 nyLPMZIojBYvw==
From: Pratyush Yadav <pratyush@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: chenhuacai@kernel.org,  ardb@kernel.org,  pratyush@kernel.org,
  rppt@kernel.org,  pasha.tatashin@soleen.com,  shuah@kernel.org,
  ilias.apalodimas@linaro.org,  akpm@linux-foundation.org,
  baoquan.he@linux.dev,  ruirui.yang@linux.dev,  guodongtai@kylinos.cn,
  kernel@xen0n.name,  graf@amazon.com,  liukexin@kylinos.cn,
  loongarch@lists.linux.dev,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kselftest@vger.kernel.org,  linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a
 configuration table
In-Reply-To: <20261119082252.9120-1-dongtai.guo@linux.dev> (George Guo's
	message of "Thu, 19 Nov 2026 17:22:52 +0900")
References: <CAAhV-H5Vse=pKC3Beqhqxa7fqadiGVNqkSy_06HZ3Luw2Pmj5Q@mail.gmail.com>
	<20261119082252.9120-1-dongtai.guo@linux.dev>
Date: Thu, 19 Nov 2026 10:58:11 +0000
Message-ID: <2vxzecch3x6k.fsf@kernel.org>
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

On Thu, Nov 19 2026, George Guo wrote:

> Hi Huacai, Ard, Pratyush,
>
> On Wed, Nov 04 2026, Huacai Chen wrote:
>> I prefer to keep it in LoongArch until a second architecture, and I
>> think Ard is the same. But this is not a strong objection to Pratyush.
>
> Kexin Liu and I have tried x86 as the second user, to see whether the
> common table holds up. It needed only small changes:
>
> - The x86 EFI stub installs the table, as the LoongArch stub does.
>   install_kho_table() moves from efi-stub.c to efi-stub-helper.c so
>   that the x86 stub can call it.
>
> - kexec_file_load() skips the SETUP_KEXEC_KHO record when the table
>   exists and the next kernel will get efi_info. Otherwise, for example
>   on a legacy BIOS boot or with noefi, it falls back to setup_data.

Do we even care about non-EFI boot? I'd say ignore that for now until
someone comes with a real use case for KHO on such systems.

>
> - When there is no SETUP_KEXEC_KHO record, the decompressor's KASLR
>   code looks up the KHO bootmem areas in the table, so the kernel is
>   not decompressed onto preserved memory.
>
> The table layout did not change. The only change to the common code is
> that efi_kho_table_found() is no longer __init, since x86 calls it at
> kexec load time.
>
> Tested in QEMU on x86_64. With OVMF, the KHO vmtest and
> luo_kexec_simple pass, and the second kernel finds the KHO state
> through the table. With SeaBIOS, the KHO vmtest passes through
> setup_data.
>
> So I would like to keep the table common in v7. Would you prefer the
> x86 patches in the same series, so that the generic code comes with a
> second user, or as a separate series on top?

This should be a follow up series. Don't get your series get caught up
in x86 changes.

>
> Pratyush, does this match what you had in mind for x86?

Sounds good to me. You will still need to chase Ard for an ACK on the
generic EFI table though.

-- 
Regards,
Pratyush Yadav
