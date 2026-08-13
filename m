Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549D5413D62
	for <linux-efi@vger.kernel.org>; Thu, 13 Aug 2026 08:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609561; cv=none; b=lOxYq3QXsHfWwP9afmJBn+Mwc46YGr7X+9HMafpE3BDxEyXENtcPztTwi1fbC1+hVIWRC5WsuBkKq5OEAVejfIK3A2D4pR8VbSDtJzhT55wBiPoAtizYH6MainnJAZs/NvS65pN2N3PoH+Z6NNrWQsXsFxJ2VxEWLqmP+zwwXJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609561; c=relaxed/simple;
	bh=KA2ruE16PN9H+yf8WYCIc8Pu9NRx0u91ZqkzR5Q/MQ8=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MA9dupkCBvg/qfKOO0yfpCibzRhOei9QqZbaZcy3yM0j1LS991nD/OfciGqbJial9xtix3tsFxZQgZtEWxYKrpB1732sdEOHCnfJNwolAv/57A+na94KIdmG5rdb9lHbx9yP945MbyE95hYBHPQ6RDxgNCup054squ+gPBR6F6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MLEMPJpj; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MLEMPJpj"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4954aff6088so13137895e9.3
        for <linux-efi@vger.kernel.org>; Thu, 13 Aug 2026 01:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609558; x=1787214358; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+SYyR6EQQIsM2Vg2lfNRN1vzD/kfGQIxnSaF9qwESjU=;
        b=MLEMPJpjvGsSq98viLqZVm21oOjMcHObZUE6SVTjkHsmxjvDwdFD/A2mM23fiXY3KZ
         hDyqZzyLGze8OWcZ+9wW/oAQ7hK6j+cZ/jnYB1CAJll2L/Qxxn7qKMhqRHUns0x9f+EE
         Z0MIeM3jH7idc3vbTuMRa6YCib+wzKfLqTr/8R9qOxZIDCs5F3I2F8LTc6EY/sJ29uW5
         z8sroN0I7oTLdLHsPaJtW0gPFVmZkEhvYxxDsGZfUfk5AM+WXw2VC+qibAPei3vjMgcO
         ioJFt516GmlhFDn/pw7sE7DSYppMT+pfh7W4Cp5w5o+CVdQz/cahNaGgLFZppK8r62KA
         md/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609558; x=1787214358;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+SYyR6EQQIsM2Vg2lfNRN1vzD/kfGQIxnSaF9qwESjU=;
        b=MBH7BSYr7b6sHjNYZ+opLu3Z1mmGuG49AwX8nQ1HxDBJcrwRVjv0GWkbq4swCYt8IB
         Q53pvG7ppNVKwxCYcv0IoBblori0GWRA8wtE3uhjySt00SEyMt7CTre8HJ5jgtWI1WI0
         7ffehBfoqfBXqT0ynK8Szdp6fmrK2v6fkNf7U1F5Hn1r0ul1tmpwXnl4LS/w6ek2WfXg
         C1uC6SlcbL+I/3ix5cgJIHmxOzcPY6nlBbKNrJ3IEJUORe14izd4z0YZw4E6FwC8B9Vb
         afOqWKEU+rTIaVVz36Uxkzrrb4F02lzhCKpWu2ePcimp6Qq3B7mA1U8BMOkQlIUX+vcH
         QeUg==
X-Gm-Message-State: AOJu0YzEu0zahDKJV9cHdTSPszAPAtTPhng96nhFXzQIHfSnut/k/Okf
	Q7ff0XA2xSsrEv12q7NPiOAfo6sy8i6iUbdV34Ek2mIU7Adzff4rRvh5ce+w9ePl+n4=
X-Gm-Gg: AR+sD13LO3IypTu0xjRsuepsYBzqsz5988zZkDkeT5tUeHpDZxHlbIm13kRZEkHyx80
	nJQBwQj5IvScSaOuU4i8/DM20Z1PKLdQ26eu3t0CrrOTymXmyoYEBjr6giiVTk6lxYqBnFw8OSE
	zXqfZbyc8M+bPKw0nxYNQ1bK1GlKGh21XgXdMBC7V3XrmsGSqRnNZNNtCfgJq95GbpmpEf9RBD6
	gaKCB6kJqJ20z/taqBCpGbOi6V9GFikC7zqDIOU1LA5UJbloH8YV6+VfMkG1A3mpCo2/ElDtEXR
	NckVNLCSIoRnjlolQ6O/yFCoivSsF8qcl0NA/e+AxW/8A7JPLbjJKicvlAdWdJI0EQH90gP45mp
	g6AOyQ7qfihyWrtemLTRqaHZHu6d9XgKvoblv6BqsOrDXfWHNt+wYDOo9mKCTYn0VXGJNLFRw8u
	kX/nf/1rfwWQHXXxkkszgOiAtdc+BLzT9dvaRxIj+w3kYLmmAf3BULKsGx+FyU07kVGVSklWgbh
	spuXPs=
X-Received: by 2002:a05:600c:3e8e:b0:499:79ba:ed92 with SMTP id 5b1f17b1804b1-499821d0652mr48629115e9.13.1786609558388;
        Thu, 13 Aug 2026 01:25:58 -0700 (PDT)
Received: from r1chard ([61.222.76.173])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3931cefe5fdsm2416153a91.13.2026.08.13.01.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:25:57 -0700 (PDT)
From: Richard Lyu <richard.lyu@suse.com>
X-Google-Original-From: Richard Lyu <r1chard@r1chard>
Date: Thu, 13 Aug 2026 16:25:52 +0800
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev
Subject: Re: [PATCH 3/3] efi: Make the 'linux,uefi-boot-memmap' DT property
 optional
Message-ID: <an1_kKjIWebhWVT5@r1chard>
References: <20260813074506.643472-5-ardb@kernel.org>
 <20260813074506.643472-8-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260813074506.643472-8-ardb@kernel.org>
User-Agent: Mutt/2.2.16 (2025-11-22)

On 2026/08/13 09:45, Ard Biesheuvel wrote:
>The 'linux,uefi-boot-memmap DT property' is redundant in principle,
>given that it carries a physical address that is also passed via a EFI
>config table entry.
>
>However, if SetVirtualAddressMap() has been called, the address of the
>config table array has been translated to virtual, and so the memory map
>is needed to translate it back to physical before it can be located.
>
>This means that passing the linux,uefi-boot-memmap DT property is only
>needed if SetVirtualAddressMap() has been called, which is a terrible
>idea anyway, and if it has not been called, the config table array can
>simply be parsed to look for LINUX_EFI_BOOT_MEMMAP_TABLE_GUID, and the
>address taken from there.
>
>So permit this, and make the boot memmap property optional.
>
>Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>---
> drivers/firmware/efi/fdtparams.c | 42 ++++++++++++++++++--
> 1 file changed, 38 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/firmware/efi/fdtparams.c b/drivers/firmware/efi/fdtparams.c
>index a54a76a6aaeb..89ffccf35fd7 100644
>--- a/drivers/firmware/efi/fdtparams.c
>+++ b/drivers/firmware/efi/fdtparams.c
>@@ -89,14 +89,15 @@ static int __init efi_get_fdt_prop(const void *fdt, int node, const char *pname,
> u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
> {
> 	const void *fdt = initial_boot_params;
>-	unsigned long systab, memmap;
>+	unsigned long systab, memmap = 0;
> 	int i, j, node;
> 	struct {
> 		void	*var;
> 		int	size;
>+		int	optional;
> 	} target[] = {
> 		[SYSTAB] = { &systab,		sizeof(systab) },
>-		[MEMMAP] = { &memmap,		sizeof(memmap) },
>+		[MEMMAP] = { &memmap,		sizeof(memmap), 1 },
> #ifdef CONFIG_XEN
> 		[MMBASE] = { &mm->phys_map,	sizeof(mm->phys_map) },
> 		[MMSIZE] = { &mm->size,		sizeof(mm->size) },
>@@ -131,14 +132,47 @@ u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
> 				continue;
> 			if (!j)
> 				goto notfound;
>-			pr_err("Can't find property '%s' in DT!\n", pname);
>-			return 0;
>+			if (!target[j].optional) {
>+				pr_err("Can't find property '%s' in DT!\n", pname);
>+				return 0;
>+			}
> 		}
> 		if (IS_ENABLED(CONFIG_XEN) && dt_params[i].paravirt) {
> 			set_bit(EFI_PARAVIRT, &efi.flags);
> 		} else {
> 			struct efi_boot_memmap *bm;
>
>+			if (!memmap) {
>+				unsigned long tables, nr_tables;
>+				efi_system_table_t *st;
>+				efi_config_table_t *tbl;
>+
>+				st = early_memremap_ro(systab, sizeof(*st));
>+				if (!st) {
>+					pr_err("Cannot remap EFI system table\n");
>+					return 0;
>+				}
>+
>+				tables		= st->tables;
>+				nr_tables	= st->nr_tables;
>+
>+				early_memunmap(st, sizeof(*st));
>+
>+				tbl = early_memremap_ro(tables, sizeof(*tbl) * nr_tables);
>+				if (!tbl) {
>+					pr_err("Cannot remap EFI config table array\n");
>+					return 0;
>+				}
>+
>+				for (int i = 0; i < nr_tables; i++) {
>+					if (!efi_guidcmp(tbl[i].guid, LINUX_EFI_BOOT_MEMMAP_GUID)) {
>+						memmap = (unsigned long)tbl[i].table;
>+						break;
>+					}
>+				}
>+				early_memunmap(tbl, sizeof(*tbl) * nr_tables);
>+			}
>+
> 			bm = early_memremap_ro(memmap, sizeof(*bm));
> 			if (!bm) {
> 				pr_err("Cannot remap EFI boot memory map\n");
>-- 
>2.47.3
>
>

Reviewed-by: Richard Lyu <richard.lyu@suse.com>
