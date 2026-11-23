Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795475406;
	b=4G2x2ltZFQOt6GSe+cUAQnECfKVCjCp0OOYJsyISByrWP6reGQpzMWB07iDF5hEpcG+7
	 K833QTjFexrutOqyiFdwYASgQTqajXbe5/T4RvNkuZe+W8RzxIaM7zvoWE5Tjt4lSoSxD
	 fwtETFBdp2tgxLKqyKfsIAhARMSHyLLaRGAlrYsMy1BemiStWQfrAHjH2cf9lQ7e4YxV+
	 OcgkkLE5mjG3yMmOsIk9TeRH3/KkgZxuNFKpXZPs4Ei5ma8uFkEFw33Xyuwnnarx6QiuI
	 Q8A7Z0AXBvKZ7D/nAtrrwrkrJKsTTAOlQ1CUESJA2UL2SgFZTgbAJ2co/WagOo0KU2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795475406;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:
	 X-Google-Original-Date:Subject:In-Reply-To:CC:From:To:Message-ID:
	 Mime-Version:Content-Type:Content-Transfer-Encoding;
	bh=1b1ocgQtSvefIuPciX0StsHzdHu/105xpXIeUHjXub4=;
	b=mqw5aVbEQd4L25UPjldk3kOAfljQomK0EVM4jLCdPLKH6/ltqUKCZCjQFO3lnYJj6C3+
	 U2DH5MVuBdTR3x2VAvvDQZIKpcherh4ZkDd16tZmHMibKwvaYTTSQVTOCYQRfENjDKBvo
	 apkVVqpLiaBTwxFIH9VJRfYYelme3qYXH9m0FBaJkJ1Mmgv0qen0389SWT1XfWqhh07DM
	 3m0Rm9Q+TruxJ9G7m6K+Vtnd7kAVlrxYHioWB9Sd+8M2iMWdYf784EyGOakVHgTKofmJv
	 +ei30lQLPN2+1XFDDjer19mUdZ3UZ3qTqqmldatHN0ZJYh2LbLtg1/NT8vipehKit7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dabbelt.com;
	spf=pass smtp.mailfrom=dabbelt.com;
	dkim=pass header.d=dabbelt-com.20260707.gappssmtp.com header.i=@dabbelt-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=N+IFk09h;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69FB606A322
	for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 23:10:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A69FB606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20260707.gappssmtp.com header.i=@dabbelt-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=N+IFk09h
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-38564b4b017so4110456eec.0
        for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 15:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20260707.gappssmtp.com; s=20260707; t=1795475405; x=1796080205; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:to
         :from:cc:in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1b1ocgQtSvefIuPciX0StsHzdHu/105xpXIeUHjXub4=;
        b=N+IFk09hcnQKSO5HGhvZ6ZFzEywdtoc2Gx38KPsXZlFXDSbqtwmCjwnVs9SR7QZUtq
         Mo54KGFczpLNl0e3WD00oIBQQ96rS1HgVFLhu/rFiRvq5imPClIx4fKf/deDB0g0sgiz
         d6oVg95YH81uNBYOr77NdHRVSC+bDP7MXP5Wiwny5oIiJ7bpluSpmeGSrTQuc9fOwflY
         9JhNTVV2RDg959PVjbcCp4V2KZMFcGaKTmHuCcyh2YUnN/smJDB5+91HzyA7O5iScY3N
         pKrgRhe1jRt5Rr2e3CaOsnDtsLe1KbLDN6u0Q2gMw9pk8YGcygtk6whSbnuiuShS05OZ
         Na4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795475405; x=1796080205;
        h=content-transfer-encoding:content-type:mime-version:message-id:to
         :from:cc:in-reply-to:subject:date:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=1b1ocgQtSvefIuPciX0StsHzdHu/105xpXIeUHjXub4=;
        b=cj374t7InUjbJzhebxDFRPkMYKorYKKYmnK8zpkKVHVn0ylehMLI0LAu6HfPNeXO9N
         sm1iks6FdCa+1Dyj67Kua/C769PN+lDjXvifWj7s9uuHLCivZ9lOYyVk1pZuexaJ2eRV
         B/oKmg6ecxBUyqfMx5mW5CSSbaSUuKB7++OFQepJu9uxih1a2wuONaU0J7YI5Ihk9uAE
         hCHrMSOHp5I/GLeTJMAxLs5c8p5K6cES1s8BR4cRJJXohSQOag2Z+agDXPVU4VHChiyU
         k2lPeB8E4j0dmSG/P1jCZ1iLCwPBxT6RnZC4SlFJqbtzWxiDh+yvE0Dq05tXqdQFHJi/
         hXVg==
X-Gm-Message-State: APuU4Z+2S5GahDAqsO9jP+zs69NfCyARyQCnlm14XYoEarl5qoUaUycc
	WutsTb62gnOyXZHojZe0Tcuu8zwFKC3G7Uq72tVxzrdqA+niFC8jtdLvqV7yzzqQvmH6DmpbncP
	fj005PVQ=
X-Gm-Gg: AZFdTZdcgYXuQkmRjd7ZBYXxg2HpwTjGz71jErwLh0/mh+shziPIeQdFC7gdU/rVctm
	8NL5RNSQ6ziDgkiE/UEiVGEbX/0N696rTrwfeYzoLWdz0aLdkfrcHPx29EUlFBbl69/lqD1s1JU
	vy4JzDsbCNduKdisf9zGaPqKicXdu5/J4iCPnquc4Pzp0h79ql9HmZKyGjQdoU/BrKZYqPjqOld
	YC08EVXtJQg5eMUWAxF9OFEEM8cwrD/+XBJeNp/NAW4X+9MKbsLB43xF0vs091jpCq6tCTvr7SB
	+2+qI5ICj6gxVmXDc0tqiZDunkYF8kuVunYYxU5waSp/8lSYdd3FueBiiH7Q/Hm6uy0l79tb4EQ
	X/xQ2bgiLQHYBTDzoeO9m6wDqjpj7U1kgIIRRINR0pC2ypgykPsYbTO/0KotR2Biyx/pcC5DpGJ
	lVqo3IeAU8buzWlmm1vzXGsMC+9IJadQClz17Aiqg104cvt/IS1pBSIX0dq5WgazVAAeARDyXfc
	LNTAQTjP+Tt0xeV0Y60q75max4nRiILJ9q5uIuu/ziBKYByep8uIolkCmdRf4eWTsuJiX65KzTr
	FpvsAyrv3VEAXnk3TbsufwgX7vdPYcHfGR93bFHNK+Kt44fLME2Y/+wAwLKQHp3S2dpzey+GqDe
	dSHLQUp4ZUNpBbbRDPs3cQoOVHEM=
X-Received: by 2002:a05:7022:296:10b0:1b4:facd:5311 with SMTP id a92af1059eb24-1b5524972dbmr12954441c88.8.1795475404449;
        Mon, 23 Nov 2026 15:10:04 -0800 (PST)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b55684c85fsm43512853c88.14.2026.11.23.15.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 15:10:04 -0800 (PST)
Date: Mon, 23 Nov 2026 15:10:04 -0800 (PST)
X-Google-Original-Date: Mon, 23 Nov 2026 15:09:28 PST (-0800)
Subject:     Re: [PATCH v4 03/19] riscv: Make _text point to the start of the kernel image
In-Reply-To: <20261118182105.1633603-24-ardb+git@google.com>
CC: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
  Ard Biesheuvel <ardb@kernel.org>, jgg@nvidia.com, pjw@kernel.org, aou@eecs.berkeley.edu, chenhuacai@kernel.org,
  loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
From: Palmer Dabbelt <palmer@dabbelt.com>
To: ardb+git@google.com
Message-ID: <mhng-FE6551A0-F38D-4B01-9727-CAB9CE10B667@Palmers-Mini.rwc.dabbelt.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Wed, 18 Nov 2026 10:21:09 PST (-0800), ardb+git@google.com wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> On RISC-V, _text currently refers to the start of the .text output
> section, which is placed after the image header (.head.text), and is
> therefore equal to _stext. On other architectures such as arm64, _text
> refers to the start of the image, and is used as such by generic code,
> e.g., to describe the kernel mapping in /proc/kcore and in the ELF
> headers of the vmcore, and by the EFI stub.
>
> Now that arch/riscv no longer uses _text to refer to the start of the
> kernel code, move it to the start of the image so that it is equal to
> _start, and the distinction between _text and _stext is the same as on
> other architectures.
>
> This also means that the image header is no longer omitted from the
> /proc/kcore and vmcore kernel text mappings. Other users of _text, such
> as kallsyms and ftrace, only use it as a reference point to calculate
> relative offsets, and are not affected by this change.
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/riscv/kernel/vmlinux.lds.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kernel/vmlinux.lds.S b/arch/riscv/kernel/vmlinux.lds.S
> index 1f4f8496941a..9849a3e4d102 100644
> --- a/arch/riscv/kernel/vmlinux.lds.S
> +++ b/arch/riscv/kernel/vmlinux.lds.S
> @@ -28,11 +28,11 @@ SECTIONS
>  	/* Beginning of code and text segment */
>  	. = LOAD_OFFSET;
>  	_start = .;
> +	_text = .;
>  	HEAD_TEXT_SECTION
>  	. = ALIGN(PAGE_SIZE);
>
>  	.text : {
> -		_text = .;
>  		_stext = .;
>  		TEXT_TEXT
>  		SCHED_TEXT

Reviewed-by: Palmer Dabbelt <palmer@dabbelt.com>
Acked-by: Palmer Dabbelt <palmer@dabbelt.com>
