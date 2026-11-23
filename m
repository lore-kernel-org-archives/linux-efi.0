Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795475405;
	b=XdmdTWnnt2LEvwF8ViIxfxAcgjxOllr4l6SqDlu185LBbC5CWmgbZUmy3JBLhrLJsGOF
	 14++dOamYZpzqqz7EUezb8x1QXw0LNUJ40lgSgvN+UxJ7XxohKb8FcAfZQGEiytwbZ0R5
	 NVvSYmJ6aQdm55D6Sp0wkZxRplFEQGogDAv2/JO8SnLGNy5D9hwLFCjmbglK93WCms3mL
	 6njvE8YKowz06dSZ/E0Smb6nh6lgScOpfyWrZ+52gnZprg9vYT1qUcGS/gploYtxhhvtM
	 MC2qrDiEB1cIrjGUq0gKf5XmRAK7s4APRjGnqXlrxTlSFDkDtFJpCLwMpVjjUrCSrDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795475405;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:
	 X-Google-Original-Date:Subject:In-Reply-To:CC:From:To:Message-ID:
	 Mime-Version:Content-Type:Content-Transfer-Encoding;
	bh=yJZxE8UsaiowVdwt1YcdicPZ3NQW6lymxuwD7Hxpfzg=;
	b=ateSX0WHWSWGW8LgDWZbNFmSs5P8OQY2/01Wqi7YwvFMqIimVc1KL0/MCsR4LIkGvkl/
	 dfUwRUCSLzJ5hxnDJT1HdGBsnL/p5t5pgQO2q9oGXsEeGVY7rlDN2g+ZYSpW713e/Sh99
	 GJ4Wrk9e+nwvqg+kS+zRZHUpFPtDW9JfkcK4J7jiGiIWC3xXk9SzMwq/ZsDFfHf6m+1sT
	 VoanGWByD3QPq40Kt+ufItf8DYadkadZ0KgdXyzRikkX4iUD1YVXC81CE51Nxm9ka/Hg4
	 dorvl/WO5FZRn2H8xn45sK6MgcTzg4ElU1lPKryw9Sa93mLsIWi4PTyi1UP4KCDuk5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dabbelt.com;
	spf=pass smtp.mailfrom=dabbelt.com;
	dkim=pass header.d=dabbelt-com.20260707.gappssmtp.com header.i=@dabbelt-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=avT+TKi7;
	arc=none smtp.remote-ip=74.125.82.44
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72895606A31E
	for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 23:10:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72895606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dabbelt-com.20260707.gappssmtp.com header.i=@dabbelt-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=avT+TKi7
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1ae58d17cd9so3731940c88.1
        for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 15:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20260707.gappssmtp.com; s=20260707; t=1795475403; x=1796080203; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:to
         :from:cc:in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=yJZxE8UsaiowVdwt1YcdicPZ3NQW6lymxuwD7Hxpfzg=;
        b=avT+TKi72C37SRykW5Vz12DFcHwGnvtp3bNfxH8ZIeY1FNgVB8LxaMk60pByKAxokz
         04gDrReg0C6ZMolPBm4SPdDYUHgTbS0Zqw7U2rOorBalIcA2CJs+L6/xO9hT0+CwfZPG
         4+l5XJbjuZB0diHRiw401jrQv39NOo1tEoKim4ovJSz6HYIukoA9LImvCt/0qVDXCA76
         Jxx7VaLXWYmZojV/nECvK4JoF/TImxl0jGgmvFOXGb1QH7dZOYFkTp0l400x1mWlFBpH
         6fZqtt9YYnG/lqFbXih8UD5Mo8yQLxPXO6K3NJD4JNiQX9Oz1mFZql1WkDRUQqnp7Zks
         AYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795475403; x=1796080203;
        h=content-transfer-encoding:content-type:mime-version:message-id:to
         :from:cc:in-reply-to:subject:date:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=yJZxE8UsaiowVdwt1YcdicPZ3NQW6lymxuwD7Hxpfzg=;
        b=QTA9LQ9VCQB9iJ1F0TxMn9bCuJqLjVTIhdur7PpLddLMmCN36sQ/L9h2tXY61EsqP3
         3k/I8Xcx3eTQxuvB34kUDYUS8oLn1jt91tRvoBq09OYdUvJa9FhtaDDl0Yw/LgJgNkrw
         bpExo8iD4ngqV7Ln9UNv33dOEeZ4MGd7gwJruvAXb70C+x6ELa0JUbSf5MAenKwXU1lA
         YgWusrsvw4K7uV1YB354nltQC4pkOE/yiWdk4bbvF7Ws+nInviNGYZzu1XpXxmssqhrr
         cocX9VDiVZ5UQ6M+wM7CUl6+631uTs6BHL8mRHxahwlT/rtXDkMWfcY5bHdiSzlmW93y
         1Xow==
X-Gm-Message-State: APuU4Z+Xmr2oLxpyxfaDDlDUAX93a9XXTPUbUP0vjMRtc+Ce5g5lv/+5
	7BiUu7j4VcVPBmyuYoaPmQWNAUykH4w4/bPy2AdiJErExP4a/XWFFmdlfiJRZg6r8gxUVTNx/yD
	xbAPzFd0=
X-Gm-Gg: AZFdTZcULCeCsji+zmq02Sjle8sqiXJ7IeGDjn8ZKrYHkdD885KLhnq8UAS67CIAiXv
	uWvQUAZxahmq22TDD5z/BnRJW6DP4ylpcJHbZ9gbhfbI3B1eRCwnz//GSJvcrjgZ3IABwJm0vEI
	U8jt+JnF6rVAtSfyLhoXtXmbiBXJOW3k/JbJel7aFetsBA3yeB32Z/QYtOAzB7j6c5hfsI/32qr
	xfoQFXEQZAdxfI1erhwLHELugEQR1xfmkzZnNISkl1luvCrwcdwOXVEruERafzZ+pT3yZ1Hqya8
	fRX/dTXX6oQ/AlgbICuqQTBtevnb516Wvno+fapMtbR1RWyROXuaov6bYn0YOCjMr5dK94vGiPl
	3sG8+L2jEV7lfjeJgMNLxE/6kSsy/EcR83tDsB1miogHexUD9xGqiXomKdegAowStP8MF2dXN0r
	/rmbnwZyYvfMgFIGEfu9PPxEoX+n8hlt/BKTojcK41xQbd1Vx+rOtTsrp8eRu3eDhH2xQVRpr3d
	ymdezJU8FWquFP02r7FjP9dKMPyrLZQrpcFLBI3M7oxq98N9gISeKVlL2giXubKI6QmjeMBWS2a
	jQBhxbw6pJDbLvlP9F6H3qYcbHWYgrmb6eBPvFW/cZ57oz3grpz2dkP/FDo+YB1t1QsIMHWM5rc
	2GK7GCNgX/76reAkUkaMOlCQ9Cdk=
X-Received: by 2002:a05:7022:e0d:b0:1b5:b04:139 with SMTP id a92af1059eb24-1b55668c573mr18309442c88.0.1795475403196;
        Mon, 23 Nov 2026 15:10:03 -0800 (PST)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5568592adsm30075627c88.15.2026.11.23.15.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 15:10:02 -0800 (PST)
Date: Mon, 23 Nov 2026 15:10:02 -0800 (PST)
X-Google-Original-Date: Mon, 23 Nov 2026 15:09:00 PST (-0800)
Subject:     Re: [PATCH v4 02/19] riscv: Use _stext not _text to denote the start of kernel code
In-Reply-To: <20261118182105.1633603-23-ardb+git@google.com>
CC: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
  Ard Biesheuvel <ardb@kernel.org>, jgg@nvidia.com, pjw@kernel.org, aou@eecs.berkeley.edu, chenhuacai@kernel.org,
  loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
From: Palmer Dabbelt <palmer@dabbelt.com>
To: ardb+git@google.com
Message-ID: <mhng-EF917BD5-807B-4931-A0E1-AE1732E69C0C@Palmers-Mini.rwc.dabbelt.com>
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

On Wed, 18 Nov 2026 10:21:08 PST (-0800), ardb+git@google.com wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> On RISC-V, _text and _stext currently refer to the same location, i.e.,
> the start of the .text output section, which follows the image header
> (.head.text) emitted by HEAD_TEXT_SECTION. _start is the symbol that
> refers to the actual start of the image.
>
> On other architectures such as arm64, _text refers to the start of the
> image, and _stext to the start of the kernel code, and generic code
> (such as the EFI stub) may start relying on this distinction.
>
> So switch the only user of _text in arch/riscv, i.e., the "Kernel code"
> resource that is exposed via /proc/iomem (and from which the "Kernel
> image" resource inherits its start address), over to _stext. This is a
> no-op given that both symbols currently resolve to the same address, but
> it permits _text to be moved to the start of the image, making it an
> alias of _start.
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/riscv/kernel/setup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
> index d79f99b86033..e6112d424fde 100644
> --- a/arch/riscv/kernel/setup.c
> +++ b/arch/riscv/kernel/setup.c
> @@ -91,7 +91,7 @@ static int __init add_kernel_resources(void)
>  	 * child nodes.
>  	 */
>
> -	code_res.start = __pa_symbol(_text);
> +	code_res.start = __pa_symbol(_stext);
>  	code_res.end = __pa_symbol(_etext) - 1;
>  	code_res.flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;

Reviewed-by: Palmer Dabbelt <palmer@dabbelt.com>
Acked-by: Palmer Dabbelt <palmer@dabbelt.com>
