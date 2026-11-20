Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795150811;
	b=zmm5SL7Wp/f5AM2/B8kotRPV7TeK4tZ+IBuQX1tcnoCXgvtjVKRVkkhcBbkq7xFetUEU
	 PM/31vtWsUzJ7UgFwMIzdttc7nXMhM9CFzr52EFCaiiMWCT3jhGidyQ/7z+VteTbBixCg
	 77IWaoCBISbM/L0TUmhdljmajmR+yM+5qKeo8JnvcF7V7UE2iZhxXBHyzVnXU3VZzKX14
	 GAsEh/rSjhwLUU1s9miiYfhNEHbYzYFJx+Ngy5GEleVbNOwFwoQKtYe4w4trVR1ZxGkB7
	 +YtU1atK12D3cLnDuOCHTBVPLBrn57VnY5lzisxRPGtFzzHMNM5m4zNGgcHU4sV2j0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795150811;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type;
	bh=qcKqx/660BDgHBKgHfBMjoLNxeFlmOefa7B0L19uKZE=;
	b=NUL8x8Q3YFgESguevHfE4AlQJyVbS+eZTr20Qq/cCXXt2aIii8/LYWIbn3zHB9rFQsBH
	 51Kg1AWoKmaCIbyPTLpLli4T1XWlcjp0uIikMwjV6X72i53BUcpJfO4A8dAr1NjGYnFSU
	 bDCZ44rCludZ7DhRa0eTmNgy2nXITQpLwKGbYoq1rWVTqioWl2DTRtVmxW7VTylWjDIxG
	 v/lJXaxZIbKcoorsJts30PHD37Dd2EnHjNWJXco8//JqKnSgH5GDRH0+NuYuLFixDgndU
	 PoWpFne2eia4B/G9BVFl87AIrGHyQ6aJ6X5XgcjM6645nvtPi11Yjli/YT6SoDe2LzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="nrqpGq/N";
	arc=none smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD719606A320
	for <linux-efi@vger.kernel.org>; Fri, 20 Nov 2026 05:00:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD719606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nrqpGq/N
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1b3a05f8b5bso684838c88.1
        for <linux-efi@vger.kernel.org>; Thu, 19 Nov 2026 21:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795150810; x=1795755610; darn=vger.kernel.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qcKqx/660BDgHBKgHfBMjoLNxeFlmOefa7B0L19uKZE=;
        b=nrqpGq/N2iUiYYMEf/i/WkkLRAdFUsb2Vq+7G0pffaAS/d/hVgfHndnJi7YL9ArRgY
         FQDSpCjXCOGD97vR18tik/3kcyZlykKLfPlqNqlGS6aXmE7keCAoh6m19m4YngKW5+oh
         hyjUj12iGtylrwJRSzXc4EOiniIRG4Z9Onie85fFox2KDbrrrrf2tPtnbTPyjIL7c0W1
         J8OWg2/dgg1wvoB7schDVkg0SotmA2GSSTjYmVicl+XS7oshpij1sq2Xpcvj68ddnlN9
         SnGGcmHuF2hRIosvjDP1JOFDxDuLLNbPA8BxvCAn4qin9CzkpdpT/708kXZuKBFYm4hB
         Kpvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795150810; x=1795755610;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qcKqx/660BDgHBKgHfBMjoLNxeFlmOefa7B0L19uKZE=;
        b=Pup64HY1kUlBQ5jcUE2r/Kp0xEVMTNfQZOousTNC5IFIS2ko3HqkC+3iSpykJyo7Tu
         SAUk4vZksmPWq8rdKCJ3tuxmEh84eHz3kxATR95uWj14b4PbluUEQYi7Blessreyncqo
         UvSy4cRptMwsgh5LpDBrFi9kYtE+z6AHHvT7v40nNMiolMloOkovecKYkHnABO5NRF3b
         LiKmOHZ6L5Kco5bSmOr0GAi5MW5y5Bn0cTOH5oDo0xyoRFHTCeyi14R6wNeGSM4wiwOK
         tGDQrbJWbBdiQdpe/k2tR2RoHrAMaU4vGGkcX/i2up6Ahrlzjo4uvzXwwPL0DDiTX4AV
         51oQ==
X-Forwarded-Encrypted: i=1; AL+hErH+vgYrxWR/YwAV30a1zgh4rBAGd5LLJq3J8RwAivNf4huZCTywFLUBM9C1nU2cdn2KbWhoCLNnIlc=@vger.kernel.org
X-Gm-Message-State: APuU4Z9R072+LYysu3PMpejJXUzwNQPPcIKrP2/v4Tir9ywQqqfsisNh
	NAwSPuPz6qkkuMDWvaFDleHT6YMCqxm1cyO9sRlgb2ucSSJPZ1+nEAi1
X-Gm-Gg: AZFdTZcYE8ln2H3X5s4hh6InnfR+gQxd8QetAIChJ0d3UV0BqchJAL5tU8n3LuBao7L
	OLIRTPUXqEDUnbNX+IXHh/vtWOUK9wrf2Avi2/wkLrzZCfGg83ubhQsezfcgBT6Ig+5elPDI96v
	+C9Qfmj9TTpUZS10LjVl0KsfEJ8ebx+nE3tZ0QfLZ8Unlr9u+5QHlNSdkFz6HSbmFzeR8aTZBVR
	Yn9B8Dd2TwqvrDtHDO82rb9CVhgPzEQYwRu+o28ju9/1fk9YLv9xmwXYAZGyC5MBfiofVyh5ICz
	k73u5461jswn8AcxDbNzgmi/aRV+3HOW2hzGO7zPRbFBUi7P7NQtU+68XI3Ipj9iUlCp0RkyYur
	Fi5Gd4bPX2BqZQSL4xH8CqqvwG+zIM18d7oHo/p661PzIE/AoBNZlc6Y6vj7ncQzjizF1CmoiFz
	1vQv7+rfM7J22K21Y5mPQNih3LOpk9ER2dlcR3UwG4BJVcEFMGLEJVilHxwH2XW9/1ytgmLR8ce
	1EY7o10U4gtwpBzitgAsR0DMvYGDE+ab2G7W8zYQHZJnkGRtaz0O5aI5K1S6W+/W4OvkinjrkBZ
	/eSoAblTa43pWCV+zbAugMf8iVKJ46Kn1VpaKoeZJX0gvY5nTfmtxEwIBmcNz+iY6hWIGUiTEyk
	FFtWRTR5zV8Q=
X-Received: by 2002:a05:693c:88c8:10b0:385:4637:5d92 with SMTP id 5a478bee46e88-3856f65de0fmr1475681eec.11.1795150809773;
        Thu, 19 Nov 2026 21:00:09 -0800 (PST)
Received: from DESKTOP-7QP7L26 ([45.190.211.142])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38566cd40c5sm4409841eec.10.2026.11.19.21.00.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Nov 2026 21:00:09 -0800 (PST)
Date: Fri, 20 Nov 2026 02:00:04 -0300 (Hora oficial do Brasil)
From: dev12124 <joaoanandalima@gmail.com>
To: sashiko-reviews@lists.linux.dev
cc: Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org, 
    Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
    Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
    Albert Ou <aou@eecs.berkeley.edu>, Huacai Chen <chenhuacai@kernel.org>
Subject: Re: [PATCH v4 06/19] efi/libstub: arm: Size the decompressed kernel
 allocation precisely
In-Reply-To: <sashiko-outbox-221779@kernel.org>
Message-ID: <0c221d69-fb50-e266-6054-7ce6360fd677@gmail.com>
References: <20261118182105.1633603-21-ardb+git@google.com> <20261118182105.1633603-27-ardb+git@google.com> <sashiko-outbox-221779@kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3760872-206-1795150809=:13716"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--3760872-206-1795150809=:13716
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Sashiko-bot, Ard,

A few points in arm32-stub.c in your patch:

>> ...
>> ...
>> + extern u32 input_data_end[] __aligned(1);
>> ...
>> ...
>> + unsigned long kernel_memsize = ...
>> ...

I agree with Sashiko Bot Review. In my current tree, I verified:

In vmlinux.lds.S:

.piggydata : {
    (.piggydata)
    __piggy_size_addr = . - 4;
}
  ...
  . = ALIGN(4);
  _etext = .;

In misc.c:

...
 	ret = do_decompress(input_data, input_data_end - input_data,
 		            output_data, error);
         if (ret)
 		error("decompressor returned an error");
 	else
 		putstr(" done, booting the kernel.\n");
...

In arm32-stub.c:

...
efi_status_t handle_kernel_image(unsigned long *image_addr,
 				 unsigned long *image_size,
 				 unsigned long *reserve_addr,
 				 unsigned long *reserve_size,
 				 efi_loaded_image_t *image,
 				 efi_handle_t image_handle)

 	const int slack = TEXT_OFFSET - 5 * PAGE_SIZE;
 	int alloc_size = MAX_UNCOMP_KERNEL_SIZE + EFI_PHYS_ALIGN;
 	unsigned long alloc_base, kernel_base;
 	efi_status_t status;
...

I. Analysis

    input_data_end sits immediately after .piggydata and right before . = ALIGN(4); in vmlinux.lds.S, so its address is only 1-byte aligned.

    Applying __aligned(1) to extern u32 input_data_end[] does not prevent an unaligned 32-bit word load when input_data_end[-1] decays to
      u32 *, which can trigger an alignment fault on ARM32 during early  stub execution.

II. Suggestion

    Declare extern u8 input_data_end[]; (byte array, naturally 1-byte aligned without attributes) and read the uncompressed size safely
       via get_unaligned_le32(input_data_end - 4) (from <linux/unaligned.h>).

Thanks,
João Guilherme da Silva Freitas Lima <joaoanandalima@gmail.com>
--3760872-206-1795150809=:13716--
