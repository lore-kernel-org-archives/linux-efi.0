Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC6C3CC7F4
	for <linux-efi@vger.kernel.org>; Tue, 16 Jun 2026 04:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781584213; cv=pass; b=sMJL9XdSqewKS0Nu75aNFNAWaiug3x0IYVA0twyY4T60PE/LlV+QviJo3jT+Cxc50VjWE0Vk+gOgaMmG8jIvzqdHHXeTyj0ZXj02PWgTLeKXYtlTkNVtsYZryc9j3AMmM/3IolL0qXjBYIYIvQDdDx0BW34uUBDiVPG1JGXcAWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781584213; c=relaxed/simple;
	bh=dm2f5XMm+CeDkHfIBPC/2K0xWs0/egYdy7hfJEoo7AY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RyRkXL/ln/+zHJ2kQQpIo4+zktrd708VJPJe1CmgZhrRwPH2ACuKAZQcw4I//X3H+xFno/5LXw97OSZTFbzLzKuTtQY4BUFAv02j6yECbP5jwUrQ9pZkUtUyJnYiR609Fmf8dhaZFteXkY5WgRffrjDbiCZaJ3VkhQbK/1t/rAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DCBpk3uC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IOLacqqP; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DCBpk3uC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IOLacqqP"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65G1xmVd2300359
	for <linux-efi@vger.kernel.org>; Tue, 16 Jun 2026 04:30:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=UKLHuG7I8+uSwaC0t/8nMhKrQXsWi0ZYpQKJQdQ+Z7w=; b=DC
	Bpk3uCIW1PQs0AKKOiqVuhYcxyuLhNDT5QWyAkSVoLhUqYkMgbwr0u7tMitr/b84
	IooXYHSxWH9G4R2PT3276e0mPG3y8n95G+Sc/Q8PebH41xoP7l4Ve++vMGd+3KfZ
	6Vgjj9cu7aBJ9Q7lmbAm9ltQlPvAEDp3/1EDXAzvYI52eLZpPuOesQKpN4XIKcwM
	3g2+f9ePjgyxktdYnzfHtxQDcR6gFnXQ/M+6hiaJDyvB5+UmRRgZkqTR8BSd2xRy
	wwH0U95cu6oo3L5gc8GuK5o8nlXfoXNLopoePVSzTeJ6P6R3pI5WJJu7oazDcEVV
	HskBhCz29C2YC6JZ+Lmg==
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com [74.125.224.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eter24srs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Tue, 16 Jun 2026 04:30:10 +0000 (GMT)
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-6605ba3afcaso664246d50.0
        for <linux-efi@vger.kernel.org>; Mon, 15 Jun 2026 21:30:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781584210; cv=none;
        d=google.com; s=arc-20240605;
        b=imN0khAw59MqoW/ihTbOO2dYQkKTTKCT5g35uibaEYy40jDoOx/kNdX3F5jL1O2tnm
         Ri7t5dYs43QCQ2XtxGkiJ/BaMI1ADmFIFcjDM/XeTSJvD8Au+7chyPrS4yRWpnijpmml
         MlRo55hns90jm3ledhYOTjZZ5CvyO9u7YqUe2gHGjiCeatATRW7VhcGQQdyU9k8fxchT
         Out5/Sb5Us9017ihKUHFUC/K2fgIVFrmEigZ7tOUAUQSqP/qOedQR8Jb5xwisv8pcMB+
         MVa1ZHMXrvOFUJCXExYq/xICQVxjaRvwYytwPHaG5c9y/8Sa5ABXzR+/M7zgEtJPC/Dp
         axUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=UKLHuG7I8+uSwaC0t/8nMhKrQXsWi0ZYpQKJQdQ+Z7w=;
        fh=xEKlaWkcb9kbInwSw4OPdxgM7T/zHSIEINhTCLC03Js=;
        b=arMfEqp3+sZeaZd4e4k6pb3D6VtMDy/Uy7AMaB91CBf2XRI0SzLG4zfEZxJLKMq3au
         +HyC+ylhaDYxqB4lcqxfyk7tGxJu+RwpvSS+dSI7fdKBjTYWSC7mg5Gi/lNp0INW5kyI
         7DiSoq3pa23MrWXm8ZoCHnJDXYi+JQk1+n/qN7nkzMcY7GqbMvKJ+rSVcJGLIkTx4eYt
         fUQ2gCjf3jNIiirL+5Q5Euu3O64QHDzHX+m8w38g2GEvL2afo42pRUqHDxZhXL0sifVU
         01FC/wEPmESVtuKbkq7g110EKs5jaIJa1Tm4PUqzz4WV6uxsKKIQvDq83FBIvvlv+pF9
         chUg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781584210; x=1782189010; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UKLHuG7I8+uSwaC0t/8nMhKrQXsWi0ZYpQKJQdQ+Z7w=;
        b=IOLacqqPohpF5MkbeUU40+Wq+gXrflhMN2VgcDianDOHMJ1wbQ/+IsBmgBAq93XNZq
         y6awO5McdN3duJn2VCeVcpH6clOTZFO14fydbYo9gdaAEZBAe/8MuXZZgNGmKSxEfSo1
         S/U8BrpEkD1J3KHIUUdzSwIvl3ZYdfTuD3W9iwO/7pfhQJQUKACEd8fmY4EcyRbS0C3n
         sG6htG2oVptZpLiGRXhiUBs6d4ZLJsy2ADDvhluT0LCgjl2Y18/zPTQwi25J1s9gu4yk
         P6VSoH0BdCKwVb9cW3vpC6S32kiXIeDrHfgmS/1wRe1Hqh7g40q+GckFeZiZWfvZrRen
         T8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781584210; x=1782189010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UKLHuG7I8+uSwaC0t/8nMhKrQXsWi0ZYpQKJQdQ+Z7w=;
        b=PmwlCuqPxR/0d4Wzkce5/MwXWoigPKgkeuZ80UhU+6J2C22Zg8hOMuOz1IrTaatvFR
         U27mFBPhvFqvtTfJP8fFu89Ch4nHCUC3xOUIIoSXeVPiT8p7uzpAkTjK39AeZj5uo4lD
         ZJjskfSf6MyKWAfAONHM3jjrtpaJlrvNdd+sLI87jNZkSYZq4strIRdU6k7AqiGIlULn
         zxMu7Ecq841wQ4lGrhkURy6E6HitY1eWB4xd68IckDNGajKp3jSkAeTMb5/gyFjfBasy
         JKduJrMgSyao6GEpKm2HzmbOfS+/1m1sf9ZN8vRFKEVTJltq5hEf0oxWIQpvmP3WpMi4
         CnZA==
X-Forwarded-Encrypted: i=1; AFNElJ+wOPHgecmROaZ9Wyt3/uynHg64oB/6ywS0gVdu4Jv6Q1Uati96mWl+rkAjKTPESYeYaW9a7b1SiRU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+pUQx70uDHwoMY2MmQACCrV16I1g3tW9geqoXdldgru10tPx7
	FkAJtnEL4UJSyrYEmkbvxHZ7cJsybiNMIxGcpABfcsA+OiqGrEyCD+YU/99xXj5PUT9wKC5Cj0K
	r1dvRpiaXFKymp5Q0RhgAQAJmvtloZSrCRxD6Nf0UKmUNu09dcXnGaqHcwd5thAmbfDkvWRkTur
	cbTpq+wfHrV/Rrpg9PAuVPPsGw0kgS6HlU/OanoA==
X-Gm-Gg: Acq92OFE78eGUwYQdVy9qabeLqUg6cyZi/ceof9u93F6PFB2u05RpjNRnIOjK5e+MBe
	0908QjF/owVcDnIVALKVRycycVL5UER37TIiZ6iA6aqU404PjNd5bTfoP+CqE4epV+wlmAcTvem
	q8fB/0IjxaZCsSWaj+oDLddOogWCgkNKn2RdugNLogHejsMctt7bO816mTuvhL39SF5jRTOfm6T
	NJN3/Re
X-Received: by 2002:a05:690e:4850:b0:657:a0f4:ac1d with SMTP id 956f58d0204a3-662b5f55649mr1162535d50.12.1781584209757;
        Mon, 15 Jun 2026 21:30:09 -0700 (PDT)
X-Received: by 2002:a05:690e:4850:b0:657:a0f4:ac1d with SMTP id
 956f58d0204a3-662b5f55649mr1162527d50.12.1781584209338; Mon, 15 Jun 2026
 21:30:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260615-efi_reset_shutdown-v1-0-9414edcbbab0@meta.com> <20260615-efi_reset_shutdown-v1-1-9414edcbbab0@meta.com>
In-Reply-To: <20260615-efi_reset_shutdown-v1-1-9414edcbbab0@meta.com>
Reply-To: sunilvl@oss.qualcomm.com
From: Sunil V L <sunilvl@oss.qualcomm.com>
Date: Tue, 16 Jun 2026 09:59:58 +0530
X-Gm-Features: AVVi8CcsjFOU3QW7M2B7U9IEgIu5I07vgt8Rowm7Ah-Xi1yMdGZKM_TLdNd9Ovo
Message-ID: <CAB19ukE7QEVLh8-vbAMbEXemnH6ENREWNTFQ1vBBD3GZyF6i0A@mail.gmail.com>
Subject: Re: [PATCH 1/2] riscv: efi: Power off via EFI runtime services when available
To: Atish Patra <atish.patra@linux.dev>
Cc: Ard Biesheuvel <ardb@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
        linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Atish Patra <atishp@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDA0MSBTYWx0ZWRfX5BlV/DA3SXd1
 oWQchfQT05oF2co96pAkWrbZqXm3kw0gZpbxGrF4ymQPgXBMtShkhjeD+/PpF73YTz74Fgn8A0L
 lgBtbgbOKNVt1TapKH/g6NK1HXAcwK0=
X-Proofpoint-GUID: ZS_e6WmJjKVhBekvzCrNukDuJa1jqkFc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDA0MSBTYWx0ZWRfX2uOBE2HMzQi3
 85eBNYyrDl8frimizjDh1j6GxBJrY9QHOQWnUaMrpt3w4JFEdXGDPWFhiF3h9bD3RQCsOLQItUe
 aM79KTlHUzZ9pwpiZUieF4Hx7O5sz11CCaoLUQpFPUaTwNvnWKc7caHe8AEbWA6+4o95bDqA/Ic
 h8GwljwXRmzux7P7aU3dcFbgOFSaASJklvOtg8XRGQ0cm9zkDVdRVPryBMfxPwki2yjnd2YgsTS
 ZTODTJi2qnK7z6hzSF22NT8ffX75l/nHOQ6TMo6yLT53ApRzS/sMu/8XldAtSAUpFO4LU6KNh4a
 R2WQeAMcZTQm4Hjqh7pIA9lJmVq3pfUviOzOAUyCbH2E0kInTU1TLyzAxtxZCtfzVDP/R7hdnD5
 mnIVbiDaCqFxQZkj/Ju42EeMij0hzsSDvnBFcyKKnIR6moi7sFxzFDQxpX4n6X7vABlAqyNas73
 pRBI/TmkDBncK4BBimw==
X-Authority-Analysis: v=2.4 cv=F4tnsKhN c=1 sm=1 tr=0 ts=6a30d152 cx=c_pps
 a=VEzVgl358Dq0xwHDEbsOzA==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=rJkE3RaqiGZ5pbrm-msn:22 a=VabnemYjAAAA:8 a=EUspDBNiAAAA:8
 a=_0tRYTEA66ICOSDQ-zYA:9 a=QEXdDO2ut3YA:10 a=uujmmnXaIg8lM0-o0HFK:22
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: ZS_e6WmJjKVhBekvzCrNukDuJa1jqkFc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_01,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606160041

On Tue, Jun 16, 2026 at 4:59=E2=80=AFAM Atish Patra <atish.patra@linux.dev>=
 wrote:
>
> From: Atish Patra <atishp@meta.com>
>
> When booted via UEFI with runtime services enabled, EFI Reset Shutdown is
> the firmware-preferred shutdown path: it lets firmware run its own
> shutdown hooks which may invoke SBI SRST extension internally. However,
> RISC-V always powers off via the SBI SRST extension today and EFI runtime
> path is never used even when firmware provides it.
>
> Enable the poweroff via EFI by overriding efi_poweroff_required()
>
> Signed-off-by: Atish Patra <atishp@meta.com>
> ---
>  arch/riscv/kernel/efi.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/riscv/kernel/efi.c b/arch/riscv/kernel/efi.c
> index b64bf1624a05..2d3cc57b4535 100644
> --- a/arch/riscv/kernel/efi.c
> +++ b/arch/riscv/kernel/efi.c
> @@ -95,3 +95,8 @@ int __init efi_set_mapping_permissions(struct mm_struct=
 *mm,
>                                    md->num_pages << EFI_PAGE_SHIFT,
>                                    set_permissions, md);
>  }
> +
> +bool efi_poweroff_required(void)
> +{
> +       return efi_enabled(EFI_RUNTIME_SERVICES);
> +}
>
Reviewed-by: Sunil V L <sunilvl@oss.qualcomm.com>
