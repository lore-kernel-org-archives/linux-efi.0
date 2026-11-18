Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026112;
	b=DNtjXhBkRTQPziZkBMMwiKmCJQ8X/8D6T4KiQ6fGGUYM2pcXClrH9X2IZMOm/3276U6F
	 Mwjpt7equ/D9QcQUbLI2Cz/7rz6j2tbDxejV7yzICal6UHXVNNa507sX5aIflPPyeDifD
	 PZy5avlVM3CKSdrQzSKNuuQmNseKqX+KqpB0dUrM02bwIQxiHLe/Y2g1cXBu2ZHbSAPlH
	 M6M0hz10Ci5JhCTJFLi2X4cZPnk28APTo5AYVyIUqkN58z3KPsWgs2Gc5LIuiMT4zLrJg
	 IkndSTRS25dj1DUhaPEZzsuwIhm7SsKjkZH1LNfW7VkgzAyOtHvRyWwAZlw8196YDGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026112;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Developer-Key:X-Developer-Signature:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=OIsEMXco2ZhYz3ZqDjy8jJcFD62W77oBBUIsxaXAIKQ=;
	b=0nmVEyH40MCn9243pv0DGS7caENIRa/tKcNhCpZo9ky0TzMFPv1GM442WFJ2fVOLmsg5
	 3hKdOOlrEooRmKmzZ9T8Jxyp9kRSKv456yNIE7SrEcH2m4OzxeXVyHVd1JWggxC7GR6M+
	 efKGqjpxXVAQWA308cH2RwfJaxCSuWujAcRr1+/nBf9wOENtoQLGb4W1LqZmsxFAjz8pJ
	 vpQOz53VdtVmVWCEDTMXKArYT1PO1JX0NcpgppSsnUUc3wbADzvTh7ZY6IqwraoELAoBf
	 o8XZ2TF/DjROqmx4QlNLKKWic3GEPFazpPUfpzINh3yL2K0NuN/Rr1h3IV+8NjXiN/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--ardb.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Mq38B7Pc;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0B9606A32A
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:21:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F0B9606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Mq38B7Pc
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a4654add56so10876175e9.2
        for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 10:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795026111; x=1795630911; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OIsEMXco2ZhYz3ZqDjy8jJcFD62W77oBBUIsxaXAIKQ=;
        b=Mq38B7PcUd30ziKKj6Crgj5H9rIOpy5wfUuILUWaYaOKpOZ4NQDn8Ql+yyMTS9MWL7
         gWGgnxarGQxJclZBJpbMyq8fcXNQgL95FLiIlZ/y22S+15JlThIWMcz3VTGj0ie/t9+s
         RMmSwK8uC+ZDQXGgI+TuikSZV6LvLAqg2yI7/tAeONwpRUn/9dklChDBnL8C1gNGAB65
         4SN9jX/hwY+tbYlbGYHIdOL1t/NX1nAASH3wPJNrSnxs05e42OshoEdVM+8vtGQqzIn+
         On7Dt7328YvWznxoY9wfZCcjgsr1umXg2kevdIqXZbVZuk/E+UQW3ciN/nZZCjYDIAsu
         YwPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026111; x=1795630911;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OIsEMXco2ZhYz3ZqDjy8jJcFD62W77oBBUIsxaXAIKQ=;
        b=s0IRzdGbhJPuUZ5aD187tlWulQzgFurw810QAapUSrTaxPyB5aP35zglFp3YfwtdNP
         rCxt2vc5qPq7+kksEVks/no/d7TRA0Nva2ScC6TDvLXiBKaGSLA2pg6mI7OZoywTehIH
         FQgiUKVfRKZFhpwlF+DV4AjmkDFygYeIUtuY4Je2xfrX0IgwBJ415oGB8HPwdPM3+THi
         y6JawaJMgI7YVeYO7eVxpo7m+CKwkXmK0UwIp2UBioc5uQ53AxML57ABYndsNriHomRk
         3V8dBovUS5You/HWn/pSEkiOcqVgG5hgMsipiBDJDfo2xdPRZNPcaD+9fb4IW5CfV68n
         O44g==
X-Gm-Message-State: APuU4Z8/uioHOAGvRU9Dw+ufRB2LiR0RkoLonqWeQ18lEk118pXMMDC2
	z0fk8tFhDEbRo8PSMLV+B59XqrxQ7SWLjHQXYt/GwYVzx5xcxGGAOnVBFpvCDU9oncyvO6XOgky
	7pIdVS80PmkVGoLW+YZpuLUCAOkihhBNsVLXmcFQXH5NF2vHW2VDyszTg40hjxr6E+VMRIzhTg9
	ZeXBrVwZFZTFaG19J57jB3KA1us+jGpQ==
X-Received: from wmbju10.prod.google.com ([2002:a05:600c:56ca:b0:4a3:5dec:ff72])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b6d:b0:4a7:6425:c274
 with SMTP id 5b1f17b1804b1-4bb7d6d1d71mr71002175e9.2.1795026110241; Wed, 18
 Nov 2026 10:21:50 -0800 (PST)
Date: Wed, 18 Nov 2026 19:21:09 +0100
In-Reply-To: <20261118182105.1633603-21-ardb+git@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261118182105.1633603-21-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1576; i=ardb@kernel.org;
 h=from:subject; bh=tNN7kvvvqrlVm6V6P5FGp3YhgkjQslREMs9fj1wtyFY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevvm2n9dqmF22tvpj8prrwkcChNKiwqKunG9i7vLGkGk
 5VvOHM7SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwEScZBj+mf9ey6hv/kNuk4P6
 Ua3fjPfW6spdF5s465ttrbKUheWZyQx/JTOspZ0caqaxyXeG69ewGNybOWHKr0bNpV0dTc9kUzb zAQA=
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118182105.1633603-24-ardb+git@google.com>
Subject: [PATCH v4 03/19] riscv: Make _text point to the start of the kernel image
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

On RISC-V, _text currently refers to the start of the .text output
section, which is placed after the image header (.head.text), and is
therefore equal to _stext. On other architectures such as arm64, _text
refers to the start of the image, and is used as such by generic code,
e.g., to describe the kernel mapping in /proc/kcore and in the ELF
headers of the vmcore, and by the EFI stub.

Now that arch/riscv no longer uses _text to refer to the start of the
kernel code, move it to the start of the image so that it is equal to
_start, and the distinction between _text and _stext is the same as on
other architectures.

This also means that the image header is no longer omitted from the
/proc/kcore and vmcore kernel text mappings. Other users of _text, such
as kallsyms and ftrace, only use it as a reference point to calculate
relative offsets, and are not affected by this change.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/riscv/kernel/vmlinux.lds.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vmlinux.lds.S b/arch/riscv/kernel/vmlinux.lds.S
index 1f4f8496941a..9849a3e4d102 100644
--- a/arch/riscv/kernel/vmlinux.lds.S
+++ b/arch/riscv/kernel/vmlinux.lds.S
@@ -28,11 +28,11 @@ SECTIONS
 	/* Beginning of code and text segment */
 	. = LOAD_OFFSET;
 	_start = .;
+	_text = .;
 	HEAD_TEXT_SECTION
 	. = ALIGN(PAGE_SIZE);
 
 	.text : {
-		_text = .;
 		_stext = .;
 		TEXT_TEXT
 		SCHED_TEXT
-- 
2.56.1.708.g77570a6a1d-goog

