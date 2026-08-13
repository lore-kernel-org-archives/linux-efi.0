Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186B0416842
	for <linux-efi@vger.kernel.org>; Thu, 13 Aug 2026 08:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609460; cv=none; b=GpJg+0/kME9mRKivcRuneLRoj3LGbr34tcsG9/3yWvskDOYWDdvbsh+Qwa84EyUp81Ow0ki8DnIl+QZ2OEp5ej79VLD9MFkBHz8unLP7WIPEG0pcAzP+WuLJL0wiFdfVrt5RLy3RDdE8Q6YNWp/nbCahWcmFWOj/NyEiXALq+aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609460; c=relaxed/simple;
	bh=4pw2dwEP7DmxYnN1amH69DYxJG9Qwgx5J6dXh6dhPrc=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oc/F1OmyW7FGBq5hErfyzxDqJLOK/i0JhIeW2u5uodS293NGpo5zmN3HdsP+/trhJwMJiES2hTXrbyUIhcO5lyO6M0HjqJu06kun0cdgetioP3pmr0MJWm/BKtAoXWakMS4TPC7XeO0b+q0T//p9DhhffsFt7eaq63gJIHyDHj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZfgxA8UP; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZfgxA8UP"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4954a9e8490so3724415e9.1
        for <linux-efi@vger.kernel.org>; Thu, 13 Aug 2026 01:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609457; x=1787214257; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=EBP/Xp/pFJQAiC3TlKU8K995p72mwD8OldQHfVB1iwE=;
        b=ZfgxA8UPsgBOKekz/lkgeX8okrXstjasZaxa/j7wfUjZRkQN6sZe4nfi7EKab7/2uu
         Ny2DPnV9xW2hGAD7zQqIon5mj3uFJnvFrQTsWop9n7exNiPQXp59G+asFDZ8ZGf/HpjV
         lLUxIwYqmuctMMrG5/KxLcQbGpcIpOLw8WlAC8mpFmBZNYtG8LpcOAi5++CEf9anA14y
         VmWOxZT9BWnumcX/o+ff7H8pcENm3Xuq2UNHR0H1ZGOvc1MHs0wn3Njlh299Z558CIa9
         BG9QMVW/3DfZ9fzDL72QIW4k1/NouaIGdv3AJi38ALXEsZuMkfHQTzjx9FF18QzCbo1J
         xRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609457; x=1787214257;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EBP/Xp/pFJQAiC3TlKU8K995p72mwD8OldQHfVB1iwE=;
        b=lf+D/1wVmWxjlXztHJg9wdi2m0DkRuw/NKYK2iEKiWovgeQKBVCY73iyvkaFyPhBwM
         a6yBaqK24VPd7fIWsS04pTRgsrwVrghGGzDOE8iMl8c/jgOFX+kDn3j54d6I3sAra7pJ
         WedpPPhzXt4O5f1HpqieWfUN/ECH9CimVAFNinp6Cuy84oZvAO1BG67J2D9PVqBMcwpw
         6g4EkQ3g5ZTmRNnbg5HIByhv7afFNHYnlsX5zB0c6GUmC7fTMWy+1kqkEdOKjhUGB40+
         cYKxG5J7UBlkhvR1A11ALRwbh6MhF66cKbkdCggBhq/2DYPq8gwqOiycxG02EHbeKZni
         UvfQ==
X-Gm-Message-State: AOJu0YzbST7S5tOgpxm9vIa6b56lNpNr00C1HpoG0vfMauKnLpIOYJ36
	y1wwpQbz/fNwNBHKA0P+qA5+H4KijT0W1NOebbklBzezU6G74mYOzqXFh5TmanqGRx8=
X-Gm-Gg: AR+sD10GhbI1lNpixuxfdEomOD3TfVICpy4iBXfaRO+yj2aH0N+rgp+22n3yiTwZbi2
	fg/4NXJv0H9Y0t7kGEqBUP2Ihsbo1oiyaFB+i8Chqv02tWrx0++UndXKFhWPYjV6dv/MBpS7/Sh
	iMvUPRaxAdGned1EH6hEMAfRD9yVi7jsplLdN0Pecyd4gw6eWE2m1R/wNaSCMbTe1EBDRND6Lt8
	UdFmGqtumYOjDoBLJuu4qPYRhPhDyF4hXvY44lILrqYLdxEcNk7TCuG5fLt5ekmsHszGp9gB/n/
	zbXmrlRaeRMlp7kJ7C0BgKkBK/Gr6VkouFEZufrETxmH5jbx4Mtv2jmjWvUj5GWzK7/RXdWCPdf
	j1TfvGYE4zd1zvBrZvXdS4Ch7L6d3ia8al1h5Kc/nucJnZxxb/U+h/G0Db6GO0WGJSUrp5xc64k
	of8kz9U+m/fg09BixV8LNwPdEaHz06oL/+iNVxj5YMH0t9lGyZVaMN16kc3JehXo4dueEHRmVNi
	DxlYQ8=
X-Received: by 2002:a05:600c:231a:b0:495:58fe:88e5 with SMTP id 5b1f17b1804b1-4998215464cmr34432165e9.2.1786609457289;
        Thu, 13 Aug 2026 01:24:17 -0700 (PDT)
Received: from r1chard ([61.222.76.173])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84fc5a1cd6esm503849b3a.36.2026.08.13.01.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:24:16 -0700 (PDT)
From: Richard Lyu <richard.lyu@suse.com>
X-Google-Original-From: Richard Lyu <r1chard@r1chard>
Date: Thu, 13 Aug 2026 16:24:11 +0800
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev
Subject: Re: [PATCH 1/3] efi: Turn boot memmap handling into shared code
Message-ID: <an1_K40ZWobCkCky@r1chard>
References: <20260813074506.643472-5-ardb@kernel.org>
 <20260813074506.643472-6-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260813074506.643472-6-ardb@kernel.org>
User-Agent: Mutt/2.2.16 (2025-11-22)

On 2026/08/13 09:45, Ard Biesheuvel wrote:
>Move the handling of the boot memmap config table from loongarch
>specific code to code that is shared between all architectures that
>select EFI_GENERIC_STUB (all EFI archs except x86).
>
>This will be used in a subsequent patch to replace the clunky FDT based
>passing of the memmap parameters.
>
>Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>---
> arch/loongarch/kernel/efi.c | 10 ++++------
> drivers/firmware/efi/efi.c  |  4 ++++
> include/linux/efi.h         |  3 +++
> 3 files changed, 11 insertions(+), 6 deletions(-)
>
>diff --git a/arch/loongarch/kernel/efi.c b/arch/loongarch/kernel/efi.c
>index 69dd83f8082f..089378856bab 100644
>--- a/arch/loongarch/kernel/efi.c
>+++ b/arch/loongarch/kernel/efi.c
>@@ -28,12 +28,10 @@
> static unsigned long efi_nr_tables;
> static unsigned long efi_config_table;
>
>-static unsigned long __initdata boot_memmap = EFI_INVALID_TABLE_ADDR;
> static unsigned long __initdata fdt_pointer = EFI_INVALID_TABLE_ADDR;
>
> static efi_system_table_t *efi_systab;
> static efi_config_table_type_t arch_tables[] __initdata = {
>-	{LINUX_EFI_BOOT_MEMMAP_GUID,	&boot_memmap,	"MEMMAP" },
> 	{DEVICE_TREE_GUID,		&fdt_pointer,	"FDTPTR" },
> 	{},
> };
>@@ -132,14 +130,14 @@ void __init efi_init(void)
> 	if (IS_ENABLED(CONFIG_EFI_EARLYCON) || IS_ENABLED(CONFIG_SYSFB))
> 		init_primary_display();
>
>-	if (boot_memmap == EFI_INVALID_TABLE_ADDR)
>+	if (efi.boot_memmap == EFI_INVALID_TABLE_ADDR)
> 		return;
>
>-	tbl = early_memremap_ro(boot_memmap, sizeof(*tbl));
>+	tbl = early_memremap_ro(efi.boot_memmap, sizeof(*tbl));
> 	if (tbl) {
> 		struct efi_memory_map_data data;
>
>-		data.phys_map		= boot_memmap + sizeof(*tbl);
>+		data.phys_map		= efi.boot_memmap + sizeof(*tbl);
> 		data.size		= tbl->map_size;
> 		data.desc_size		= tbl->desc_size;
> 		data.desc_version	= tbl->desc_ver;
>@@ -156,7 +154,7 @@ void __init efi_init(void)
> 		 * Also, set the EFI_PRESERVE_BS_REGIONS flag to indicate that
> 		 * critical boot services code/data regions like this are preserved.
> 		 */
>-		memblock_reserve((phys_addr_t)boot_memmap, sizeof(*tbl) + data.size);
>+		memblock_reserve((phys_addr_t)efi.boot_memmap, sizeof(*tbl) + data.size);
> 		set_bit(EFI_PRESERVE_BS_REGIONS, &efi.flags);
>
> 		early_memunmap(tbl, sizeof(*tbl));
>diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>index 0327a39d31fa..d33760d6a527 100644
>--- a/drivers/firmware/efi/efi.c
>+++ b/drivers/firmware/efi/efi.c
>@@ -55,6 +55,9 @@ struct efi __read_mostly efi = {
> #ifdef CONFIG_UNACCEPTED_MEMORY
> 	.unaccepted		= EFI_INVALID_TABLE_ADDR,
> #endif
>+#ifdef CONFIG_EFI_GENERIC_STUB
>+	.boot_memmap		= EFI_INVALID_TABLE_ADDR,
>+#endif
> };
> EXPORT_SYMBOL(efi);
>
>@@ -647,6 +650,7 @@ static const efi_config_table_type_t common_tables[] __initconst = {
> 	{LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID,	&efi.unaccepted,	"Unaccepted"	},
> #endif
> #ifdef CONFIG_EFI_GENERIC_STUB
>+	{LINUX_EFI_BOOT_MEMMAP_GUID,		&efi.boot_memmap,	"MEMMAP"	},
> 	{LINUX_EFI_PRIMARY_DISPLAY_TABLE_GUID,	&primary_display_table			},
> #endif
> 	{},
>diff --git a/include/linux/efi.h b/include/linux/efi.h
>index aa15ff88539b..bc1cd005ca0f 100644
>--- a/include/linux/efi.h
>+++ b/include/linux/efi.h
>@@ -650,6 +650,9 @@ extern struct efi {
> 	unsigned long			mokvar_table;		/* MOK variable config table */
> 	unsigned long			coco_secret;		/* Confidential computing secret table */
> 	unsigned long			unaccepted;		/* Unaccepted memory table */
>+#ifdef CONFIG_EFI_GENERIC_STUB
>+	unsigned long			boot_memmap;		/* The EFI memory map captured by the stub */
>+#endif
>
> 	efi_get_time_t			*get_time;
> 	efi_set_time_t			*set_time;
>-- 
>2.47.3
>
>

Reviewed-by: Richard Lyu <richard.lyu@suse.com>
