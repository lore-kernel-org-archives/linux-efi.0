Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F273ACA70
	for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 09:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786958332; cv=none; b=LLT5CZq4/3AwCUCaoKV7WP2zDu7vaMzrGanqk635xqNk61y2JzIZEVSwJ9S4hFhnmo+fhSzH+ivl/g9X62FEZMBRrYB2OaF7ZEMj8Mjg2dfebYevwtV+evqEG972Vvdz2+xTXY/h04PZI7iysLNLLVRdzX06ILhzHPWjzZslkp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786958332; c=relaxed/simple;
	bh=h96GbcJ+H2KiMkqz0n7zgVQYhpM7HYbdC/QaxS6PAjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fjENx8FClYNCqMq1moDxO8QyWnif0mZFuc2zsH/M3CpAihp32/Gw7p+w1Tu+Y6VmfnsNZ5hlTpF5TQQGQFq0S/GRxvHztMBLJPbOpix7znVdeE9Dfs0GbsQAqd3fap5pq8aiNv32M2TfRGriIh+TCT06MoX9fSx3WKuSxniMwiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oRsMzJcR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iAzdmroE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oRsMzJcR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iAzdmroE"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67H76H472123355
	for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 09:18:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=z/Re6YGkB/5+NfHRAlgNFlF6
	0vE4TkJcD1A6bUVVMlM=; b=oRsMzJcRJIrqyGSqbpQPaQbyEqlkYaQCNtdwFGF+
	GdB++fE8KnO1AVWprWX+sc+uxF0CNHcXfIPtHLd8mzMCMtjCHgtaraUhrV1uDwYP
	tEWvle6cEV5tn1ZRFGNVLi3y6h9wfI/SwZIZGzft30C0gsLAVxEhSNay3L2iOIhF
	k0qtiYcftyMyOLOo3WL4DsOvY14hvXIYCX85bw53/XPIH7wrdohhepHoDb7zsgjy
	phlUoGh5LW/WevwkenMKLhdmNI9zYYAqQtiSy9da2sTUP3RIdFK+hAU5SH/mOrfS
	ew1cu68JHzwB34Up/mdv5T2lHuh7XMEeR1Ip42GfLg95iw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g3wm7rgby-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 09:18:49 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51a8db414c7so45307191cf.0
        for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 02:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786958329; x=1787563129; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z/Re6YGkB/5+NfHRAlgNFlF60vE4TkJcD1A6bUVVMlM=;
        b=iAzdmroEL97r5P+y4ycl4BCvQYfT7Hw88OQfQuAp6ojrn97yztg1r49cc2txnRh65R
         jOrqYXsZBd0ErYjomgGNmgRJhtNX7+2u+bEsPpVIgUT4mzydBxMsG6zfW3wPsO2ttPei
         6efksAcyqVkb64DpZbAKIY+17MrcWvsIkZHKLyhpwjXHJfPZUClnDIB6RogOz1r88GlD
         i5/R1Xe7QjOp/XARrXbNvE3fnuHCYGJv9aB7VAFvcUUKwndirXIq7PCVWFlTevzFLgFF
         gtbtqMRLJeliD7gxq3yfoVa1bYVUKumW3wYLz/huHNeUuWds4iqL83nxJhx2sO6q+7++
         ysvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786958329; x=1787563129;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z/Re6YGkB/5+NfHRAlgNFlF60vE4TkJcD1A6bUVVMlM=;
        b=WxXnyKfRkQW3D/0LaDS6fFoMaSaATQ/bA9KYyZlUKvbzEc6BKu9rQ1jP3iGmUT3hNp
         1DdM6ASErGiWJpsCrAbFtDQftKoTMpNjC0tlydwYozEoxGwOYXwZJJZ4sb9EXXt5/lsd
         pb78fbtqgoSqfT3M/iKElCPz9OJyy0/DXzZ1t/uGr5J+uggPOK8yaWvNJZaXxRnhJwYt
         5Vs+O9kd1OgJoePwz4IldGSot3KNBycES+NLJQOK2kQ64Z/CTCcqQAo3VNVxGuv8A+Xc
         /YlssP4JNYGIc0GRpE5kwqzm/GlIbcXemk94wpVjxk0s0qfblh5HXwfgRolAjeS/py3G
         wPCw==
X-Gm-Message-State: AOJu0YzBDNDOyE1jWkYEEHQS7dxp7p4ri3MRgDaV0WZ+8aEANe4JvM1x
	eDNpvEhMpiu8gQx5LGWgIiKY9RqMHAbwnEoGWzNbWrb2NZC5Dd/gOmRstf0gPAXknmmEiYspAdE
	6HAcOiyM75ZBLWzh/LIfUbVqiOjcxYax3/Ci8b1PUIyK5W8sZi9EY87o6l0cDgUI=
X-Gm-Gg: AR+sD11gcUV3crSE/1Pq2D4FynbIyLz5Ya5yz6n1RIX7JwgF/cQJda6cw4jfdwQGClJ
	3r0S+OYbx/LE7kAN9CRGzO4lnKooRrV2DeaQ1hTeQDJjQINzCVsyRoz8pX9lErwcEd5p9LicQsy
	mdt4ImX48R/2UoG7E4/+CUZXBAqrVasHRHNn77gOgCPFcMUm1ridkodLeT6fa/LI80UyYtxjvLG
	D6M7fD26WeBu6jOpU9YkWV45d+vTpseyFrQ6aRU9R4U009QUsgQIaU3g8ECgpDclgd/WqnFBCtQ
	iWhs02Xc8r3hj7PHCY5ovdLZvDR585u9OtkLhPDpqRmN2fExD4tV1VvSGn4tm0RZ3VoXj+W/lDI
	3t5P/uoVlzz8XCMqN2QahmogH3UWxWA1+z6bGUjsy7bi4qtuLrd7iKp5GrK44jEUfUt2mVORLWQ
	s=
X-Received: by 2002:a05:622a:5c14:b0:516:e249:e30f with SMTP id d75a77b69052e-52d8557d9b4mr267662081cf.42.1786958328459;
        Mon, 17 Aug 2026 02:18:48 -0700 (PDT)
X-Received: by 2002:a05:622a:5c14:b0:516:e249:e30f with SMTP id d75a77b69052e-52d8557d9b4mr267661831cf.42.1786958327989;
        Mon, 17 Aug 2026 02:18:47 -0700 (PDT)
Received: from leviathan ([2a0d:3344:316:5100:f22f:74ff:fe21:6f68])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999d10be27sm32706235e9.14.2026.08.17.02.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 02:18:46 -0700 (PDT)
Date: Mon, 17 Aug 2026 10:18:44 +0100
From: Leif Lindholm <leif.lindholm@oss.qualcomm.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
        loongarch@lists.linux.dev
Subject: Re: [PATCH 2/3] efi: Pass EFI boot memmap struct address to core
 kernel
Message-ID: <aoLR9BPGt4Kzbr3y@leviathan>
References: <20260813074506.643472-5-ardb@kernel.org>
 <20260813074506.643472-7-ardb@kernel.org>
 <an8xTBiCy_PEuwZi@leviathan>
 <a0d10b63-bf9a-4ad7-a9d8-ab748a9c0c2c@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0d10b63-bf9a-4ad7-a9d8-ab748a9c0c2c@app.fastmail.com>
X-Proofpoint-GUID: -l6QG_ycdK3FGHHYYAs5qKzjg_egmWAj
X-Proofpoint-ORIG-GUID: -l6QG_ycdK3FGHHYYAs5qKzjg_egmWAj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA2OSBTYWx0ZWRfX4A4nWXzk6e5m
 5pG2bPmg53cmHyetdeiURQJtjCQwog6M+pYti3bZujlze/uhaVBB9XkXLo54rTznjaVHwNffy2G
 PXojeot/TQTqQ/R7s72fkWcAVKMnyU0mIE4Hclb9f9JUIUB6tPvK/EjSzrB/4BaCMA9S8nRwoQ6
 vs7M1XRngCszO4ME/TuKZhmV/rybL0w2BEqOaIb9Sj5TolDfjkNeq2PbDThq9RLdESB5idQ6M7C
 bN9b1GPBmyHocoLA2WV0JUQCbN8CKXwF66bRUimoPQYCeuI0Hi1khZYHxeqcDKXS5ii/Ql9wQOt
 p+U28MdbeBQR67fTIT9JrlektgVSFGLVkv7JKp9+qzdc5xz8r3MNKyGDhLCTXEKgt0g7MH9YzjN
 DlXpc8+mTS04DLayh1+vXZqMwVi/dBbAC6j9S0uX3rL3hcT2jqFfhGiQSIcAHS754rqmH27WCrh
 trToTuBzw4GTunkSFZg==
X-Authority-Analysis: v=2.4 cv=YqM/gYYX c=1 sm=1 tr=0 ts=6a82d1f9 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=TWCjO1UoqHXKrXYG5nYA:9
 a=4OldKtP1pka_piUj:21 a=CjuIK1q_8ugA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA2OSBTYWx0ZWRfX+cvoKLaDVq+O
 kmPLDtM96g/W3uRQ2FF+QhpfESqAxBru+ooC6Ct+/IexGsmrxcrHFpmtrHl+YLJwnPD5p5n7di/
 oiIMC6uLPMhuwv7zbbdZTkh8+yvTzpE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170069

On Mon, Aug 17, 2026 at 11:41:51 +0300, Ard Biesheuvel wrote:
> On Fri, 14 Aug 2026, at 18:16, Leif Lindholm wrote:
> > On Thu, Aug 13, 2026 at 09:45:09 +0200, Ard Biesheuvel wrote:
> >> The EFI stub already passes a struct efi_boot_memmap populated with the
> >> information of the EFI memory map as a configuration table, and so
> >> passing the physical address, size, descriptor size and descriptor
> >> version via 4 different DT properties is kind of redundant.
> >> 
> >> Instead, pass the physical address of this struct in memory so that the
> >> kernel can just retrieve the values directly.
> >> 
> >> Unfortunately, the scheme with four separate properties is boot ABI for
> >> Xen, and so this needs to remain supported.
> >
> > To clarify, you mean boot ABI when running under Xen?
> >
> 
> Yes. We've allowed Xen dom0 to omit the EFI stub entirely, and boot the
> kernel proper in EFI mode, passing the EFI system table and memory map
> addresses via these special DT properties.
> 
> >> But for the EFI stub itself,
> >> this is just an internal ABI that can be modified.
> >
> > Hmm...
> >
> > So this leaves only three properties that cannot be derived from the
> > System Table:
> > - The System Table address itself
> > - kaslr-seed
> > - bootargs
> >
> > The latter two could also be given the config table treatment.
> >
> 
> The latter two are generic boot ABI for the arm64 kernel, and there
> is no need to treat them differently for EFI boot. Note that we also
> support passing the initrd directly via DT when doing EFI boot, rather
> than via the EFI specific device path.

Ah, yes, noted.

> > Is it time to update the boot ABI to say x0 will hold the physical
> > address of "device tree blob (dtb) or EFI System Table in system RAM"?
> > They can be distinguished by 0xd00dfeed / "IBI SYST".
> 
> Let's avoid 'boot ABI' here, given that we are talking about an internal
> interface between the EFI stub and the kernel proper.

It's an internal business in the topic under discussion, but if we
were to change it, that would mean updating booting.rst, which I
consider an ABI.

> This internal interface uses DT under the hood, even on ACPI platforms,
> because it simplifies the early boot code. I don't think we should change
> this.
> 
> Also, the DT provided by the bootloader (if any) may differ from the one
> passed by the EFI stub, and so discovering the DT from the EFI system
> table is not straight-forward - they are not the same, and making them
> the same may have unintended side effects.

Right, but this confusion exists precisely because of the two ways the
device tree can be accessed with the curreent design.

> > The use of a generated DT when none was provided by firmware has led
> > to both confusion and shenanigans, and might be nice to get rid of?
> >
> 
> I don't disagree with that. But that would imply adding new code to the
> early startup code doing command line parsing and KASLR randomization to
> reason about whether these assets are passed via DT or via some other means.

I take your point about the invasiveness, so won't pursue that further
at this time. But I can't promise I won't bring it up again eventually :)

> What would make sense imo is to pass the EFI system table address via X1
> when doing EFI boot, so we don't have to get anything at all from the DT.

That certainly sounds like a clear improvement.

> > Either way, it would be nice to get rid of all four of the
> > linux,uefi-mmap nodes if they're now completely redundant.
> >
> 
> Indeed.
> 
> > Minor bikeshedding below.
> >
> >> @@ -123,8 +134,24 @@ u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
> >>  			pr_err("Can't find property '%s' in DT!\n", pname);
> >>  			return 0;
> >>  		}
> >> -		if (dt_params[i].paravirt)
> >> +		if (IS_ENABLED(CONFIG_XEN) && dt_params[i].paravirt) {
> >>  			set_bit(EFI_PARAVIRT, &efi.flags);
> >> +		} else {
> >
> > This condition branch doesn't in fact have anything to do with the fdt.
> > Should it still live in fdtparams.c?
> >
> 
> I don't follow. The EFI_PARAVIRT flag is set based on whether we are 
> using the generic or the Xen-specific set of DT properties. What would
> be a better place to decide this?

Apologies, I may have commented confusingly - my comment was about the
else branch:

+
+                       bm = early_memremap_ro(memmap, sizeof(*bm));
+                       if (!bm) {
+                               pr_err("Cannot remap EFI boot memory map\n");
+                               return 0;
+                       }
+
+                       mm->phys_map            = memmap + sizeof(*bm);
+                       mm->size                = bm->map_size;
+                       mm->desc_size           = bm->desc_size;
+                       mm->desc_version        = bm->desc_ver;
+
+                       early_memunmap(bm, sizeof(*bm));

So to restate - this function is called from efi_init():
---
        /* Grab UEFI information placed in FDT by stub */
        efi_system_table = efi_get_fdt_params(&data);
        if (!efi_system_table)
                return;
---

Before this set, this function called get_fdt_params() indeed gets
"params" from a device tree. After this set, this function gets params
from a device tree in some instances, and not in others.
Which feels suboptimal.

We could rename the function, but then there's still DT-unrelated
code held in fdtparams.c.

If we go down the route of passing the system table in x1 on boot,
then I guess the effect of assigning efi_system_table will already be
broken out. But should we then split the mm struct initialisation into
separate DT and config table helper functions?

/
    Leif
