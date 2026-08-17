Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4673E025C
	for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 14:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975717; cv=none; b=szf3UvgDfeSISz8IvVqyCPeCwZej9RCuxf5pKd1cnhnR0v72Vsl6VYOa9qspQ3s/zJx/JFgnTyq3WN+hVf3etD8OXAi6qIT8iHGHOMrIYjc9d7zEEw8QSUBBAlCSLAkrK4044TXrkZqXeVUlQFzNkhfKW35wijh2riRCZvlSRLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975717; c=relaxed/simple;
	bh=staMQ8i21aT2qMLa/ScVjoos+mmOTXL1+Zprb3aTHN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sUP+hUMHqHFgBXn95d6KAcLNFtP1squJkePeFMghmD7VokRKDKvak3MIhmMKbgOIfz4tJOCdNdz1kM1Uwd4bYr4aUCvLXAJ7Lc5kZDM1GywprRsOIU3nN1b6ll5DnwGvHbBZ0Yha1fWbPPhzn9Dsfv3REh9XQsqtT7xonH1nB6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QgYlvCG7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jjHY6Cut; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QgYlvCG7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jjHY6Cut"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HD6Je02431653
	for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 14:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=w73H4Wybt7wskLAo+yX+hGB0
	G0F78nZdnr+eiPJjGEk=; b=QgYlvCG77oGFmR4vVaqFYH/eiCpR963MafF/bOUm
	04BXHqtg/a5OQatFvxFIdmmlEqlipC1WKdAZ5iudgpTVdGX1p9flt5QMxjuCo5Qq
	dV8XMQo4cwSkBMF+lux6buXG/6QcfEsD5Lf2etMo48byMhPgSR16Es8ZeQp8Pk+C
	gTdp3jhKUaKvQIMEZEtiHDDw/ziUzjIhd8d+iI1zCPc+CdoI5G7zUgeqMtwmzwMO
	hbEVNpk7Rpe9BF4c6wqKAUS0rm6+HKN5PNYFJMFlVXdlito84jeMei35Gd3kuaup
	KGfx2rqMeAZgiWmvskKTFxifbEHAHFPZnn6VwWe6hKjsmw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g3wrehk3u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 14:08:34 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-930b6bdcb4fso502871885a.2
        for <linux-efi@vger.kernel.org>; Mon, 17 Aug 2026 07:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786975714; x=1787580514; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w73H4Wybt7wskLAo+yX+hGB0G0F78nZdnr+eiPJjGEk=;
        b=jjHY6CutSUNw00nzRI6Kyuedm5z2G1+eKCHMiLwkl9BuGcBeQtghIVHtnfbz2KSAdR
         Y8Eh4VOsh3jH1L5nSjB8JeP1BsBvDbCk5DaTUhekfLZm4CmWejRRf8hUMGmCrRCDMHdo
         hOncKuUpXAJmPHQ9wp4a8ype0Q71B6zXnB9+JUowZjnSktmnPBXrUB/TYvUxHyNdCxLO
         ZyRBiWaxwkiXD23Zy6bl9mnd+udaQKOMjuSsCqdA1Jwo2GF5o90jdb4pjvcuV+KDg9il
         8d0+qtMBBi++u4mn0Jn0TyMBapj0FvSBSo2Zhg5MLHCk0Uf01NVjLFxcImGhf9AeTMk6
         UwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786975714; x=1787580514;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w73H4Wybt7wskLAo+yX+hGB0G0F78nZdnr+eiPJjGEk=;
        b=bNPk5F1ur5y4qytqAbHLlLqwu2+djt/Gzga9LX6x+XFSXHc1S4O5PJxa9FTe3Sd17y
         K0uH3xujp8Z4YmBQVDtNL5iuQ9Akcll6pBf8Rw4nqcPQr/TCpuj4K9TQbwi8jMSGv2Io
         Tud1yKqzzjcMcOlDxXAlIFocWy8B/+KCr8iK/EFXOk537+ejNGC7wdI4lU4uC6xlLJEN
         ieJK09ye1VYwxN+JzBln2Nan8VYKSSaY/pbYwY0LyJqAwfIRmr3CdBhit1FA4Y4jyBHZ
         yEGVDVRNapOXOI01/Cm3tkk60VYXnPCPcS67rgWtcVAfNLQ50+fYDmC1Ex7yaFKvDfoh
         y9Ww==
X-Gm-Message-State: AOJu0YyCa40oSlosatPumQoFP9wBnH8QgF/ev0QN0J0U9s7iv70eGQUX
	HjaqzBAyLcMiczFSFvzQ4XvJJAg9PpLiFlc9uKXztkvLYNTp1bN9SjAjIqp2K1pTCiKWUw11pyM
	51HYevXCzNSZnZic9HphOuATB8W3IU0jZAuA71QLLxqkm6iplvoewRC3apWAKelA=
X-Gm-Gg: AR+sD13s/9uxCTA8tKSRLS6Na1x9cqcDTY8tT12Uj+j6uHMalt4Kdis+buJkBe4bRt7
	ObVCyKU1DMcn5sHOdGUW19Ml8YlXOFI0SCNlCBsGw2u1MIwnc3UgwzM2rr4EOpj1mII+ihmCFSa
	233Ty4NAty1U97+i5l+jqbv3VZrrapp0pEIN365oReSujnvCCn7rL5xRiFVVPVUU8dXPZTtO+JY
	mpdDnOM71ZxDFvwmTnAFP3P7YrqqTksQfD7HrQkjJCjuBjNvAo2O9qDZvyd/GN4+OFIJmEdQk14
	9LDxb25Mk+6oj/mcJ0DRjdSnhgYIyVT9b0EBRehJTUtQttYzVs+vzXuorrmv6xOeFgzU0/osM3z
	7iFVu/T2Onp+R86/4+hCfI08sXXZXCiEbIYhP17YoqMssyqtfZjwmjgPZZAEyHIxsYyeoEc2yu+
	U=
X-Received: by 2002:a05:620a:231a:10b0:923:8612:f15 with SMTP id af79cd13be357-936d2025d63mr2020356685a.18.1786975714248;
        Mon, 17 Aug 2026 07:08:34 -0700 (PDT)
X-Received: by 2002:a05:620a:231a:10b0:923:8612:f15 with SMTP id af79cd13be357-936d2025d63mr2020345785a.18.1786975713522;
        Mon, 17 Aug 2026 07:08:33 -0700 (PDT)
Received: from leviathan ([2a0d:3344:316:5100:f22f:74ff:fe21:6f68])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5a31543sm5005404f8f.4.2026.08.17.07.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 07:08:32 -0700 (PDT)
Date: Mon, 17 Aug 2026 15:08:29 +0100
From: Leif Lindholm <leif.lindholm@oss.qualcomm.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
        loongarch@lists.linux.dev
Subject: Re: [PATCH 2/3] efi: Pass EFI boot memmap struct address to core
 kernel
Message-ID: <aoMV3TX0hgTsj3_m@leviathan>
References: <20260813074506.643472-5-ardb@kernel.org>
 <20260813074506.643472-7-ardb@kernel.org>
 <an8xTBiCy_PEuwZi@leviathan>
 <a0d10b63-bf9a-4ad7-a9d8-ab748a9c0c2c@app.fastmail.com>
 <aoLR9BPGt4Kzbr3y@leviathan>
 <92baff04-d30b-4174-b5f5-87b24e6a1cc0@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92baff04-d30b-4174-b5f5-87b24e6a1cc0@app.fastmail.com>
X-Authority-Analysis: v=2.4 cv=FqI1OWrq c=1 sm=1 tr=0 ts=6a8315e2 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=otMJZyyn8YdxdvHBrc4A:9
 a=CjuIK1q_8ugA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: dblSLkjDz4RhbJ6wsXoQSI7-DUZTkK2m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDEwOCBTYWx0ZWRfXzn4C3Xm44KwN
 k9cS8nNw/lZ0fSIPuIJ7JuXtxZCOmHAkJRvMrT+kimQcpNwHDiOBR4XkttoWoYai6N7U+okNRwm
 45L3PpbWAVlc7qJFOAvLggT6KdIE4X3gtYpvOVBnzaI0E/QRWyk+trUDDbfrgvg8HpVD99x1wDe
 gOPamPG5ceZ9+INVpTri7mXa45BBt9hP5cWGgxCMFP7e//hICJoMsbpxFkZHuXINQ40yEQ+q/jL
 RD9GyMpQ935xD8sR5z5ySfCkwgHVhtGX6kgx0rZp5wuImi2h1Ez8Q5OoOaJBsJ/DCzoXcUahjGV
 Z6blXggBMCMtKzQafPUHYfHyOkuEWKQtvhfZk1vQogL4Ov+FoDHP0NR52or9vX8Q5rQoMPCM4NZ
 1H69+f3V8oglpYtzr/hcAI/SIg1AnRFSAU9Kq6MZg58ALCbZJpyy8h8xWpYs33asJ7Kl3tTsF50
 TRX9VTZI3LkZOOXf/Hg==
X-Proofpoint-GUID: dblSLkjDz4RhbJ6wsXoQSI7-DUZTkK2m
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDEwOCBTYWx0ZWRfX9ZbT17XkzdD7
 USMsghGcuwfRwB9upWhixqEOFQWjpV8rwy6mAAIKnYE2e4aM7/iEnFBTMSgtFotFCCF5r+CZXNu
 0IzUsZqDdZqd2uaXnVmHw354cEAfHbQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170108

On Mon, Aug 17, 2026 at 14:00:16 +0300, Ard Biesheuvel wrote:
> >> > Is it time to update the boot ABI to say x0 will hold the physical
> >> > address of "device tree blob (dtb) or EFI System Table in system RAM"?
> >> > They can be distinguished by 0xd00dfeed / "IBI SYST".
> >> 
> >> Let's avoid 'boot ABI' here, given that we are talking about an internal
> >> interface between the EFI stub and the kernel proper.
> >
> > It's an internal business in the topic under discussion, but if we
> > were to change it, that would mean updating booting.rst, which I
> > consider an ABI.
> >
> 
> But not an external ABI. It documents specifically how the EFI stub
> interfaces with the kernel proper. This might change at any point,
> without any obligation whatsoever to remain compatible with the
> previous method.

So you're saying if the kernel proper decides to use x1 for something
else, we'll move to x2?

I agree that in the context of how the stub calls the kernel proper,
this is not ABI, but x1 is one of the registers currently marked as
"reserved for future use" in booting.rst. So it feels weird for me to
allocate one of those registers for this internal use then not mention
it.

In that case, couldn't we instead pick a register outside of the
reserved ones?

> ...
> >> > Minor bikeshedding below.
> >> >
> >> >> @@ -123,8 +134,24 @@ u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
> >> >>  			pr_err("Can't find property '%s' in DT!\n", pname);
> >> >>  			return 0;
> >> >>  		}
> >> >> -		if (dt_params[i].paravirt)
> >> >> +		if (IS_ENABLED(CONFIG_XEN) && dt_params[i].paravirt) {
> >> >>  			set_bit(EFI_PARAVIRT, &efi.flags);
> >> >> +		} else {
> >> >
> >> > This condition branch doesn't in fact have anything to do with the fdt.
> >> > Should it still live in fdtparams.c?
> >> >
> >> 
> >> I don't follow. The EFI_PARAVIRT flag is set based on whether we are 
> >> using the generic or the Xen-specific set of DT properties. What would
> >> be a better place to decide this?
> >
> > Apologies, I may have commented confusingly - my comment was about the
> > else branch:
> >
> > +
> > +                       bm = early_memremap_ro(memmap, sizeof(*bm));
> > +                       if (!bm) {
> > +                               pr_err("Cannot remap EFI boot memory map\n");
> > +                               return 0;
> > +                       }
> > +
> > +                       mm->phys_map            = memmap + sizeof(*bm);
> > +                       mm->size                = bm->map_size;
> > +                       mm->desc_size           = bm->desc_size;
> > +                       mm->desc_version        = bm->desc_ver;
> > +
> > +                       early_memunmap(bm, sizeof(*bm));
> >
> > So to restate - this function is called from efi_init():
> > ---
> >         /* Grab UEFI information placed in FDT by stub */
> >         efi_system_table = efi_get_fdt_params(&data);
> >         if (!efi_system_table)
> >                 return;
> > ---
> >
> > Before this set, this function called get_fdt_params() indeed gets
> > "params" from a device tree. After this set, this function gets params
> > from a device tree in some instances, and not in others.
> > Which feels suboptimal.
> >
> > We could rename the function, but then there's still DT-unrelated
> > code held in fdtparams.c.
> >
> > If we go down the route of passing the system table in x1 on boot,
> > then I guess the effect of assigning efi_system_table will already be
> > broken out. But should we then split the mm struct initialisation into
> > separate DT and config table helper functions?
> >
> 
> Not disagreeing but I think it is fine to leave it as I suggested at this
> point.
> 
> Some additional work is needed to get rid of linux,uefi-boot-memmap
> entirely, and until that happens, passing the EFI system table via
> X1 and linux,uefi-boot-memmap via DT is not a huge improvement.
> 
> linux,uefi-boot-memmap is needed when SetVirtualAddressMap() is called
> [with a non-1:1 mapping], as the EFI system table contains a remapped
> address of the config table array in that case.

Of course, the devil on my shoulder suggests the stub could always
add an address fixup handler for the config table too...

> There are currently two remaining reasons why calling
> SetVirtualAddressMap() is required:
> - some Ampere boxes crash otherwise (but these systems tolerate SVAM
> being called with a 1:1 mapping)
> - kernel configs with a VA space < 48 bits are not guaranteed to be
> able to map the EFI runtime services 1:1, so there, SVAM is still
> needed as well.
> 
> Both can be fixed, and I have been meaning to address the latter by
> always making the EFI runtime map (which is essentially a 1:1 map)
> use 48 bits of VA in all configs. (The ID map already does the same)
> 
> Then, the former can be addressed by installing a 1:1 mapping when
> calling SVAM.
> 
> That would remove the need entirely to ever call SVAM() on arm64,
> and therefore the need to pass the address of the EFI memory map
> separately.

Makes sense.

/
    Leif
