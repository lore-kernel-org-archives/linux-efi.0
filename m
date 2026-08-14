Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7256D3BE621
	for <linux-efi@vger.kernel.org>; Fri, 14 Aug 2026 15:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786720598; cv=none; b=qUUhiKg+Kfeb5I2RRjAibewtNT3W+bzu0+BhgePLcpiDBfujzLFnV3pqfaIwptgTLr3hUxAS0vWV02ySif1YdVkppMFVNyG/uj7aq2wnuU4W7Q+IRT3+hgx2244n92owOdblW4mgEnDEmYu7gbklNcXlCo8/HDAZRT6teqbDtS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786720598; c=relaxed/simple;
	bh=OJTA+d8/dcspmjp6Xw690y+AL4+ClhPJPyOCfwvbf3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a7On31+WaxwjFlJK2UUmjXt0kfja6yG/AKntkE61iHtOoS4f+6Uyfcx1LJ4YbEstTGe+8zgPASWemNWBv4BqRtDjuP4p1MvydDu/+01AsjeHdtBw0xrpRm3WuZ6BDygU9D0W014UGaRxHGkFJMi6HPYcfA5ZjbT5Ib7C0HH3CDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=l2X/4kUC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jlekRh30; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="l2X/4kUC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jlekRh30"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EDx4bY1935925
	for <linux-efi@vger.kernel.org>; Fri, 14 Aug 2026 15:16:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=kyE9VpOdIdaJ4nhDgsqi8sGD
	rAQp14puQ8jsBWnSrk4=; b=l2X/4kUCbRyW2naU8380mUkZRR7Ih7negTrhzcMO
	yO7pLFlYCLpT0U9KsQTB31rtB6qOAlOQ7tXmjr0frq3MhmYKk6QHtKK/50Kbqzjg
	GiQw2kKgjku0JBKi+OZS3Cq/Ynq4h6KmUjAMcP4sjne9TDOGPK5sNWX/FyGKJ2Y7
	SIuHlKEB1zWI39oSGe3/1Sk7fC76Ecp1snprsFR9kFyxK/HZdhOmKSykVqFCsEu1
	M8DJmwSZ6W/rRlf/Uwi6OHIffgtEmAdiOFIlO6HN+5SBb1OZAHEeduzf2jXrE8om
	rl6zCiFQTmuraJo6WGhom0/f1uPa0hf/WjjHEagZCSpQLA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g20gn9c7g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Fri, 14 Aug 2026 15:16:35 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-526da7e3c9dso12355501cf.1
        for <linux-efi@vger.kernel.org>; Fri, 14 Aug 2026 08:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786720594; x=1787325394; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kyE9VpOdIdaJ4nhDgsqi8sGDrAQp14puQ8jsBWnSrk4=;
        b=jlekRh30yk9YyymHwwStLCdw/BaTxsw1cnBWVCk8b6YEVh7O3oBwWPXufTUSHuhH5j
         gnplwl7sZQo18jBrlnZLOZQVvP67M9goCDGOefbFV+1TfuCa56pmM5EA1o864w+Bqfeu
         TD0N422wksGK1OZTbJYBqwHTce4fu90dPEmeEbgaOfeWnnz6S2ITKrXotEXtf26DsTbA
         XTVjUntMWwpHWlKr4RZvqMBQBjs1q3EDk+PeIPuHLXPkQ2APRs4++BZolV7S1GhxzLfZ
         3OweQJZ++Km7rayBndTYEBASIsumrbSK82oTM0Vv/WGrPK9aVYm1C2NB+ajmbfWvkE9v
         K/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786720594; x=1787325394;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kyE9VpOdIdaJ4nhDgsqi8sGDrAQp14puQ8jsBWnSrk4=;
        b=SBhac+Q9JnPltR0nv07/W6s8nl7dBM5ykmFq25NEg1RhGtqWbqjX5AiJ0heikBeUXW
         B3aM9fGVFu85cCnNL89zCloOpPUoFhIDmhXRCZX4u48tA89GeOQOe9VTHYZWtcfskScs
         HA4If6d1EhOtRlGVUtA4g8Fu0GArIAYvI0LRwLaIFmk3MBpQf5CoNEGoaGAOTXAHKEjO
         PAN/d/mnYOJ5mRR2HfoFnAtEuxyNKQftylyLAkeYDv2JtnM21yPt533X9p1QbToQkgHg
         JIUea5WIRYIb4vPzu4kU1bV7Ljgo3Ud0UN3gWBJB2wyeW6/iDhFpfo2Q6jmbWKbIwwtV
         H2Wg==
X-Gm-Message-State: AOJu0YyXtzFgJ6HWn2hSrk+0+6KznDX6egndgLkiQfb0WqtjZ0G5ZGRX
	iOt9zTTrP0kapv+7nn3I+ztSx2Y3bba7xa79L+mdekOcRQ9lD/ybnzjs8phnUHYDE9+oORuSSYM
	JcUjqdki31UZgI7z4gptQ3yeAT6Sq3h5qwALbNXPJQ5kvoL0WtK1Djl0C1oCLLZ4=
X-Gm-Gg: AR+sD10xCJoh2bqvSufqMr9v6XZEh1mUGErNYhc0kzRMLY16j6+d+owLLJPvX+UrmZD
	KSDtXBC6CvxE3CInZQqfD/qT0PN5yI6mxRJkC+BBu8DTI99oNiKCgE3OEcCVf3bMNp3dF7/7Tda
	MdqX5cP8+PU5FgA18FniN4cmGThw/ySgeTe2q/FvdFjUQGgyFFrazcbf+0myI3P0mMYlIv7amnQ
	hPtXj7YKPKmG34vleIpTl0174nnDzpfIhn55IsDgp2vec4FcZKS+YFxoWYeSQerPOC02i766weR
	o8VQiG97h8+W93aEk02MtANyPY/31EuJn8u3iotkb0MoFaGsaf+3Y2SlW+ghBJIaX7l+pCJ6x46
	JznZzBg8uzdVQ/mjsomo6DgXVBNgCxzBH2gNCD8Q5VcMfuoGCoz7HVkQrjJ202o6zubscclqOdG
	0=
X-Received: by 2002:ac8:580f:0:b0:519:efea:cf41 with SMTP id d75a77b69052e-52d85431a8fmr70899621cf.28.1786720593201;
        Fri, 14 Aug 2026 08:16:33 -0700 (PDT)
X-Received: by 2002:ac8:580f:0:b0:519:efea:cf41 with SMTP id d75a77b69052e-52d85431a8fmr70897581cf.28.1786720592234;
        Fri, 14 Aug 2026 08:16:32 -0700 (PDT)
Received: from leviathan ([2a0d:3344:316:5100:f22f:74ff:fe21:6f68])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815f2c1307sm9145087f8f.27.2026.08.14.08.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 08:16:31 -0700 (PDT)
Date: Fri, 14 Aug 2026 16:16:28 +0100
From: Leif Lindholm <leif.lindholm@oss.qualcomm.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
        loongarch@lists.linux.dev
Subject: Re: [PATCH 2/3] efi: Pass EFI boot memmap struct address to core
 kernel
Message-ID: <an8xTBiCy_PEuwZi@leviathan>
References: <20260813074506.643472-5-ardb@kernel.org>
 <20260813074506.643472-7-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813074506.643472-7-ardb@kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDExNiBTYWx0ZWRfX5Oq6SoQyusOM
 QUyHTKwBJILCnCGJvRYxjBK7PgWNnoRRn9Wwchmwo+nLiFcqJOMmhFUSNBhcbbdXEbmfiVWM3JO
 ZHO1GX+LG5YUzor6WzM+75nG8pWnnfAp2uojDq5PG2e2J+PI83Fcfm7/2zRipjcSyjHk0fwfUb6
 lBY0CdMY9G6UycYmClwK7PwyTMGwUXvlArNcH0CYEZPCJjmnIaU9BpxLJvIsd0JDekVaJKmvgwl
 FKDGA6GTVn3HEQ1X9SjYF8d1HVqkezeMPH8Z2F/oZqS1mI+uPDbjC5/tDnnBy27nIhyJUsPXrpw
 nyu2+3/lwQIt3zq9CsnbreZluhOTQ0KYDSIFxDIcnYs7ac599BN8lMQnc5JBlLc9gVq7xDf440x
 UahgsZLwfFrkYqevJBqVyZNg8et1OMg5mWOAs+gJDRbkbYWANAAyk4BuLuARMjiLDcLxul+eY0r
 yszjuyy0CrCM1P5sRIA==
X-Authority-Analysis: v=2.4 cv=DdMnbPtW c=1 sm=1 tr=0 ts=6a7f3153 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=VwQbUJbxAAAA:8
 a=7pfS4neli2E25kVr3iQA:9 a=CjuIK1q_8ugA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDExNiBTYWx0ZWRfXwKIS+l0/5OM6
 6e4uCQJFNzgQEXbQFeMhYckKGpJOjcHFUBdbOPSB3YYwDGEBOZLIXyK6gDGwJLJiuJTKrDt+kaG
 sxtPg6GnUzw87kEKzO3VUBMYU4EaYEQ=
X-Proofpoint-GUID: DmPG7cgzGDzM0zOTYH_N3GUne5utSGL-
X-Proofpoint-ORIG-GUID: DmPG7cgzGDzM0zOTYH_N3GUne5utSGL-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 phishscore=0 impostorscore=0 clxscore=1011
 priorityscore=1501 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140116

On Thu, Aug 13, 2026 at 09:45:09 +0200, Ard Biesheuvel wrote:
> The EFI stub already passes a struct efi_boot_memmap populated with the
> information of the EFI memory map as a configuration table, and so
> passing the physical address, size, descriptor size and descriptor
> version via 4 different DT properties is kind of redundant.
> 
> Instead, pass the physical address of this struct in memory so that the
> kernel can just retrieve the values directly.
> 
> Unfortunately, the scheme with four separate properties is boot ABI for
> Xen, and so this needs to remain supported.

To clarify, you mean boot ABI when running under Xen?

> But for the EFI stub itself,
> this is just an internal ABI that can be modified.

Hmm...

So this leaves only three properties that cannot be derived from the
System Table:
- The System Table address itself
- kaslr-seed
- bootargs

The latter two could also be given the config table treatment.

Is it time to update the boot ABI to say x0 will hold the physical
address of "device tree blob (dtb) or EFI System Table in system RAM"?
They can be distinguished by 0xd00dfeed / "IBI SYST".

The use of a generated DT when none was provided by firmware has led
to both confusion and shenanigans, and might be nice to get rid of?

Either way, it would be nice to get rid of all four of the
linux,uefi-mmap nodes if they're now completely redundant.

Minor bikeshedding below.

> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  Documentation/arch/arm/uefi.rst    | 10 +----
>  drivers/firmware/efi/fdtparams.c   | 39 ++++++++++++++++---
>  drivers/firmware/efi/libstub/fdt.c | 40 ++------------------
>  3 files changed, 37 insertions(+), 52 deletions(-)
> 
> diff --git a/Documentation/arch/arm/uefi.rst b/Documentation/arch/arm/uefi.rst
> index 2b7ad9bd7cd2..c19cf3720f27 100644
> --- a/Documentation/arch/arm/uefi.rst
> +++ b/Documentation/arch/arm/uefi.rst
> @@ -54,17 +54,9 @@ Name                        Type     Description
>  ==========================  ======   ===========================================
>  linux,uefi-system-table     64-bit   Physical address of the UEFI System Table.
>  
> -linux,uefi-mmap-start       64-bit   Physical address of the UEFI memory map,
> +linux,uefi-boot-memmap      64-bit   Physical address of a struct efi_boot_memmap
>                                       populated by the UEFI GetMemoryMap() call.
>  
> -linux,uefi-mmap-size        32-bit   Size in bytes of the UEFI memory map
> -                                     pointed to in previous entry.
> -
> -linux,uefi-mmap-desc-size   32-bit   Size in bytes of each entry in the UEFI
> -                                     memory map.
> -
> -linux,uefi-mmap-desc-ver    32-bit   Version of the mmap descriptor format.
> -
>  kaslr-seed                  64-bit   Entropy used to randomize the kernel image
>                                       base address location.
>  
> diff --git a/drivers/firmware/efi/fdtparams.c b/drivers/firmware/efi/fdtparams.c
> index b815d2a754ee..a54a76a6aaeb 100644
> --- a/drivers/firmware/efi/fdtparams.c
> +++ b/drivers/firmware/efi/fdtparams.c
> @@ -10,22 +10,30 @@
>  
>  #include <linux/unaligned.h>
>  
> +#include <asm/early_ioremap.h>
> +
>  enum {
>  	SYSTAB,
> +	MEMMAP,
> +#ifdef CONFIG_XEN
>  	MMBASE,
>  	MMSIZE,
>  	DCSIZE,
>  	DCVERS,
> +#endif
>  
>  	PARAMCOUNT
>  };
>  
>  static __initconst const char name[][22] = {
>  	[SYSTAB] = "System Table         ",
> +	[MEMMAP] = "Boot Memory Map      ",
> +#ifdef CONFIG_XEN
>  	[MMBASE] = "MemMap Address       ",
>  	[MMSIZE] = "MemMap Size          ",
>  	[DCSIZE] = "MemMap Desc. Size    ",
>  	[DCVERS] = "MemMap Desc. Version ",
> +#endif
>  };
>  
>  static __initconst const struct {
> @@ -49,10 +57,7 @@ static __initconst const struct {
>  		.path = "/chosen",
>  		.params = {	//  <-----------26----------->
>  			[SYSTAB] = "linux,uefi-system-table",
> -			[MMBASE] = "linux,uefi-mmap-start",
> -			[MMSIZE] = "linux,uefi-mmap-size",
> -			[DCSIZE] = "linux,uefi-mmap-desc-size",
> -			[DCVERS] = "linux,uefi-mmap-desc-ver",
> +			[MEMMAP] = "linux,uefi-boot-memmap",
>  		}
>  	}
>  };
> @@ -84,17 +89,20 @@ static int __init efi_get_fdt_prop(const void *fdt, int node, const char *pname,
>  u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
>  {
>  	const void *fdt = initial_boot_params;
> -	unsigned long systab;
> +	unsigned long systab, memmap;
>  	int i, j, node;
>  	struct {
>  		void	*var;
>  		int	size;
>  	} target[] = {
>  		[SYSTAB] = { &systab,		sizeof(systab) },
> +		[MEMMAP] = { &memmap,		sizeof(memmap) },
> +#ifdef CONFIG_XEN
>  		[MMBASE] = { &mm->phys_map,	sizeof(mm->phys_map) },
>  		[MMSIZE] = { &mm->size,		sizeof(mm->size) },
>  		[DCSIZE] = { &mm->desc_size,	sizeof(mm->desc_size) },
>  		[DCVERS] = { &mm->desc_version,	sizeof(mm->desc_version) },
> +#endif
>  	};
>  
>  	BUILD_BUG_ON(ARRAY_SIZE(target) != ARRAY_SIZE(name));
> @@ -115,6 +123,9 @@ u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
>  		for (j = 0; j < ARRAY_SIZE(target); j++) {
>  			const char *pname = dt_params[i].params[j];
>  
> +			if (pname[0] == '\0')
> +				continue;
> +
>  			if (!efi_get_fdt_prop(fdt, node, pname, name[j],
>  					      target[j].var, target[j].size))
>  				continue;
> @@ -123,8 +134,24 @@ u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
>  			pr_err("Can't find property '%s' in DT!\n", pname);
>  			return 0;
>  		}
> -		if (dt_params[i].paravirt)
> +		if (IS_ENABLED(CONFIG_XEN) && dt_params[i].paravirt) {
>  			set_bit(EFI_PARAVIRT, &efi.flags);
> +		} else {

This condition branch doesn't in fact have anything to do with the fdt.
Should it still live in fdtparams.c?

/
    Leif

> +			struct efi_boot_memmap *bm;
> +
> +			bm = early_memremap_ro(memmap, sizeof(*bm));
> +			if (!bm) {
> +				pr_err("Cannot remap EFI boot memory map\n");
> +				return 0;
> +			}
> +
> +			mm->phys_map		= memmap + sizeof(*bm);
> +			mm->size		= bm->map_size;
> +			mm->desc_size		= bm->desc_size;
> +			mm->desc_version	= bm->desc_ver;
> +
> +			early_memunmap(bm, sizeof(*bm));
> +		}
>  		return systab;
>  	}
>  notfound:
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index 23b3543d3041..417b1344bdd8 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -32,7 +32,6 @@ static efi_status_t update_fdt(void *orig_fdt, unsigned long orig_fdt_size,
>  {
>  	int node, num_rsv;
>  	int status;
> -	fdt32_t fdt_val32;
>  	fdt64_t fdt_val64;
>  
>  	/* Do some checks on provided FDT, if it exists: */
> @@ -102,21 +101,7 @@ static efi_status_t update_fdt(void *orig_fdt, unsigned long orig_fdt_size,
>  
>  	fdt_val64 = cpu_to_fdt64(U64_MAX); /* placeholder */
>  
> -	status = fdt_setprop_var(fdt, node, "linux,uefi-mmap-start", fdt_val64);
> -	if (status)
> -		goto fdt_set_fail;
> -
> -	fdt_val32 = cpu_to_fdt32(U32_MAX); /* placeholder */
> -
> -	status = fdt_setprop_var(fdt, node, "linux,uefi-mmap-size", fdt_val32);
> -	if (status)
> -		goto fdt_set_fail;
> -
> -	status = fdt_setprop_var(fdt, node, "linux,uefi-mmap-desc-size", fdt_val32);
> -	if (status)
> -		goto fdt_set_fail;
> -
> -	status = fdt_setprop_var(fdt, node, "linux,uefi-mmap-desc-ver", fdt_val32);
> +	status = fdt_setprop_var(fdt, node, "linux,uefi-boot-memmap", fdt_val64);
>  	if (status)
>  		goto fdt_set_fail;
>  
> @@ -148,33 +133,14 @@ static efi_status_t update_fdt_memmap(void *fdt, struct efi_boot_memmap *map)
>  {
>  	int node = fdt_path_offset(fdt, "/chosen");
>  	fdt64_t fdt_val64;
> -	fdt32_t fdt_val32;
>  	int err;
>  
>  	if (node < 0)
>  		return EFI_LOAD_ERROR;
>  
> -	fdt_val64 = cpu_to_fdt64((unsigned long)map->map);
> -
> -	err = fdt_setprop_inplace_var(fdt, node, "linux,uefi-mmap-start", fdt_val64);
> -	if (err)
> -		return EFI_LOAD_ERROR;
> -
> -	fdt_val32 = cpu_to_fdt32(map->map_size);
> -
> -	err = fdt_setprop_inplace_var(fdt, node, "linux,uefi-mmap-size", fdt_val32);
> -	if (err)
> -		return EFI_LOAD_ERROR;
> -
> -	fdt_val32 = cpu_to_fdt32(map->desc_size);
> -
> -	err = fdt_setprop_inplace_var(fdt, node, "linux,uefi-mmap-desc-size", fdt_val32);
> -	if (err)
> -		return EFI_LOAD_ERROR;
> -
> -	fdt_val32 = cpu_to_fdt32(map->desc_ver);
> +	fdt_val64 = cpu_to_fdt64((unsigned long)map);
>  
> -	err = fdt_setprop_inplace_var(fdt, node, "linux,uefi-mmap-desc-ver", fdt_val32);
> +	err = fdt_setprop_inplace_var(fdt, node, "linux,uefi-boot-memmap", fdt_val64);
>  	if (err)
>  		return EFI_LOAD_ERROR;
>  
> -- 
> 2.47.3
> 
