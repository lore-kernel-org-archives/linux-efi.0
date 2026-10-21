Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792604625;
	b=ic2ld6Dkh6UZoEAWCAunZ5W89xmQRD1rFX2p85VMXwv1ts38M4U9y8+NfyR4zX0sngIa
	 ytvdXYjmY3UBbJJELdzeaXUhjsn0hVlYxhDDCfkekanhtxqGGvnMXvrAQc3qrBOtLLN0d
	 gLXYgCx8wMjNmE/FLcNy25WLiFHQyyYdfdroVMREeBWTX9qT4NGXHNU6aF0uhvCSp/Hfl
	 wLSgHNEm6LoxaBTfcB2v7J6K/ULtKXEv+z07tbT7H2p659zRwWqnDKj5dqnchGhQ8Kbj6
	 t9oaeILOzchyFrGmLlslM134vg9NIZQCAMmflOwy+O1H7vHxAyCsRHBwf3w9SjIniKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792604625;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=vilmZRHHMNfnexi+YGDujqWXf83C8yeE3BqzopJL6bY=;
	b=bwkd/y5o5gZIwAkp/U0kEA6i7dhS/KHdz0He2YyikBIVCLI84Pk6o20781FhZ+l9sAtq
	 b3ndHGJsGgYtYhep3WRmUEGVUlNgSnv6SChqOo5GbioE2/SyF8354I+gZj2qPmaxgmPC+
	 3AXxlwQlISbMLNpVbot2zkUZ0b71q9N6WTDqR+3f2bRlIPyubAfBEsqnfBm7Wu/r+/e3w
	 Xgb8EkEcTiFSzgj4ij6uqMMiBeOc4pGeNiAAU+XF5thCyybHWGUaGNSRr5a++NaCFkueR
	 cje6kyc4gysl81l8WZGiHKB1lz6cUsJ5pKoJHD4Utx969i/0vsi3kSLXZBg6Zu0CXBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=eoyi9og8;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=M0h7T2cU;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15788606A31E
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 17:43:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15788606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=eoyi9og8;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=M0h7T2cU
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFU5AW3727264
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 17:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vilmZRHHMNfnexi+YGDujqWXf83C8yeE3BqzopJL6bY=; b=eoyi9og8lE7X7gFs
	6zN8p4jNwkyfCNTayV/KpLYTog8YiPf09MNrJZcVJnd8ebBGnM3y90AF6J6wPsgu
	KIHm6p3JiNc6RZfwNDa4t1fGBEFrTEmAppjPtFmqqXsDcs6gCeSuRZZlb5bNDOS9
	ImS1uhcDnN727Uzxw2NojUhBmpaItcPZUTIJpC/20W36NsqozA/ILY/A7RqOC8Fa
	fp6nVz6bC6n4qpaiLw/MFEox+9rhuaWmCR3mtKA8Cekf76hFS10V2nlLwjUarK9d
	b3wbMfLBTWZOussj3TRqDPdEihPsXKcxNsCG7ejdilg63VQy4NSwejKyn6ahUKZG
	iSFgwA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hesy7aduk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 17:43:43 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3580c07911eso2719314eec.0
        for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 10:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792604623; x=1793209423; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=vilmZRHHMNfnexi+YGDujqWXf83C8yeE3BqzopJL6bY=;
        b=M0h7T2cUS8LbTHOdvJj49MvFXjuzRrwZGQL8cAfvPS67rUDQl0Uj95oYIsLVm90FBf
         yqSAG6195hBcQxzDw33zcLfzZbHb7DErFn0cUH94EPEaX0VOmsrUslXa6nrA7Xg6ZRL2
         Ob4skd0lIXNWp2vuEV8xPjuSp5JmfuCyDQshF9Hw4TUSMsZw7QDfnmQyX+hKO1voy2uy
         958cpu+fNvTRVhOmhEZYncgi+AeKXDmHUpq15qdo1JNo/UwSEwdJM83sFTsOo6L1Yxbd
         wFzDLMi975OgGQuxWEeS3xXLVdzd4xCx1iuOW3e0AhgDMkS/4qbUxOpilDsUVXiWUzeE
         jhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792604623; x=1793209423;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vilmZRHHMNfnexi+YGDujqWXf83C8yeE3BqzopJL6bY=;
        b=ePDQLe5A05W8saOAP/EkPICz9TlmV1925RL6KD30jq49FktxQ5l1/zezxCOqfNmeRR
         4aifKfAdCNlgJz/YxEBdgR/6Rc2ZYf6XcF/+HRGLgyfEpe/tsoEImzf/Kr59TIuZm0HU
         zfr+WRABpekyc4kqbu37oi0NGZ1UCWtxWb3HTje9DKWUcgvz19isMxMFvtiaIte5lagC
         ZSCMY29g/N0pZQnzwKfeWg4gsp1BNPNcLr4EvCtoCP7PkWxnT1dDQbU19uaG93iX5I6N
         qO/AlDC8AJVhnY8hIonQ99GJ/xqO9hN79q+FmpD/2O/Tk8bbr8nAZH0IpdOOp5rMhM6C
         uuMQ==
X-Forwarded-Encrypted: i=1; AKwUvBx4NcjDD9RSuiK7Qiy2LBF7Lia0ms0lTL2wQ0nBT8T1on2vwbiekuIPshcGtaGDL5BswMD9dTzjcTE=@vger.kernel.org
X-Gm-Message-State: AFq9FYIiEMwTjbpIA2M5oNn9quSaYbCA93lEHrUB8N18/zbAGfQ0vMpq
	ilCUXsOzZ8+aX7eqJ8JVkccGXJsicnSLAYYHKH5Vi14jSVbbtLNMAGLQvuIbE0GWbBYaM0P4Pnj
	wzSfi5S8BPSSvsWxyzk4iDBYTFQkY/16dC6OMN/EZPjW14L7ABR1k/FV+6zFRbiw=
X-Gm-Gg: AYBFou0Nzofztu6dckAgdzdaViXEp6ZVGwWodQamo62ls3AdO4xhyTCHrbLMDgWM75O
	HHh0m+tliDbRSy4vcaryJCDEknUYpx5dagBtDEUdHKp6j1dBI3rQ7qucAJwS4Zsv8dnxI66PQo4
	szuDKFsdTDL6EtvnR79aUPDBhnv6OYnnydXPU2K6TWfi5oUZJ7BJ5I/G685LrAvYSS5JG+X+6U5
	e7Zs+kpL1BZEXgZga89fbgWDh16JTuSj8TyL9LYrnW4guja+2+GgfXUnUQT3K7bl3JGxmKO1WXs
	3RuDnzlQX7jW5sfT1/9j2kfc9rZydm8DxNfgP210+mrHx0YJWzLrX3XnOUbrJd8Hhlqv7zHavss
	8G8A/1yYu0D6t/+JVQXcDNFNJlT/gaLA1HNyNHfYGpg==
X-Received: by 2002:a05:693c:65db:b0:366:8efb:bab9 with SMTP id 5a478bee46e88-3674e450f24mr4349158eec.11.1792604622260;
        Wed, 21 Oct 2026 10:43:42 -0700 (PDT)
X-Received: by 2002:a05:693c:65db:b0:366:8efb:bab9 with SMTP id 5a478bee46e88-3674e450f24mr4349127eec.11.1792604621677;
        Wed, 21 Oct 2026 10:43:41 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36741f753f7sm8840346eec.27.2026.10.21.10.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 10:43:41 -0700 (PDT)
Date: Wed, 21 Oct 2026 10:43:36 -0700
From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
        Ard
 Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Catalin
 Marinas <catalin.marinas@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, David
 Sterba <dsterba@suse.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-riscv@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
        Randy
 Dunlap <rdunlap@infradead.org>, Simon Glass <sjg@chromium.org>,
        Shuah Khan
 <skhan@linuxfoundation.org>,
        Nick Terrell <terrelln@fb.com>, Will Deacon
 <will@kernel.org>,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        Conor Dooley
 <conor.dooley@microchip.com>,
        linux-integrity@vger.kernel.org, Palmer
 Dabbelt <palmer@rivosinc.com>,
        patches@lists.linux.dev,
        Piotr
 =?ISO-8859-1?Q?Kr=F3l?= <piotr.krol@3mdeb.com>,
        Ross Philipson
 <ross.philipson@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Song
 Shuai <songshuaishuai@tinylab.org>
Subject: Re: [PATCH v2 11/15] arm64: drtm: Add macro definitions for DEN0113
Message-ID: <20261021104336.00000437@oss.qualcomm.com>
In-Reply-To: <11-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<11-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
Organization: Qualcomm
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: TjmHkQ8khvGxlpTmz0tB1gDuTIMqdQVx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA3MCBTYWx0ZWRfXxYzrK+FGVUw3
 wYk5LNaGmcoC+ULYBbdVNygXDxyAx3ZK/3N4ZDhbgWbS6q7mNO9Q+voroprFWhlqJHafYPg+sBj
 9bKkvh7NreztRj0/jxnrYoZ4lub0d+mqUuq0w3gUmw1yoVGb/AbbHszFLsxhlUzfNNOMbnibfsa
 WlR9eWZAGwnVj07EFmBnz1bo55hGB3i7vkrm5C42gkUwEXsvkZrV/ESg+8tY7p/caaN99HkciUQ
 AdaHh1BAKqmRgjgwMhAZtFY0wb0qZc8msPRqSYMj5e8nxiVzXncUu4YaVE+ixOr1eOZHmfAYvrr
 cbsJr7sY4+QP1rbtyuTA+Ak1gbaNCnrwyLEDLdTjZsoyNLmZJP8Nr+az9V8C93iUQtk8Mn2uz9w
 Pc5rHqLgcNR0fR8KB+uZDKUk7sP5pf2PCLZ8XyeaRALEWEGm1PL9WTZNoUNS/6ZxFOZo2VfdJAJ
 IskowIDhiWS6oRAtAKQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA3MCBTYWx0ZWRfX6b6MJj/rXEv7
 xmMK2NHWe19YGV16u3rxQa1Jac0R6rBLZqC2SmiB3OjLt65vN0+nnaB1m4yKZZejccgnk4I/C5H
 QIxfbsT9maz8wV65P/wLRO09B3Jg2tA=
X-Proofpoint-ORIG-GUID: TjmHkQ8khvGxlpTmz0tB1gDuTIMqdQVx
X-Authority-Analysis: v=2.4 cv=IPaXmQvG c=1 sm=1 tr=0 ts=6ad8f9cf cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=Ikd4Dj_1AAAA:8 a=EUspDBNiAAAA:8 a=cBdanpMcOxUnX1AP4g8A:9 a=CjuIK1q_8ugA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210070

On Fri,  2 Oct 2026 20:31:48 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Taken from rev 1.4b of the spec, following the SMCC register layout and
> constant names.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Nice - appreciated the spec references as saved a bunch of searching.
A few really small comments inline. Either way 

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

> ---
>  arch/arm64/include/asm/drtm.h | 304 ++++++++++++++++++++++++++++++++++
>  1 file changed, 304 insertions(+)
>  create mode 100644 arch/arm64/include/asm/drtm.h
> 
> diff --git a/arch/arm64/include/asm/drtm.h b/arch/arm64/include/asm/drtm.h
> new file mode 100644
> index 00000000000000..8188af1b582bb3
> --- /dev/null
> +++ b/arch/arm64/include/asm/drtm.h

> +/*
> + * The spec uses 4KB pages for sizes and alignment throughout, see v1.4B
> + * sections 3.3, 3.13, 3.14 and 3.15.
> + */
> +#define ARM_DRTM_PAGE_SIZE			4096

Maybe use SZ_4K from linux/sizes.h



> +/* v1.4B section 3.3 "DRTM_FEATURES" */
> +#define ARM_DRTM_SMC_FEATURES			(ARM_DRTM_SMC_FN_BASE + 0x01)
> +/* X1 input parameter */
> +#define ARM_DRTM_FEATURE_SELECTOR		BIT_U64(63)

Maybe define the alternate masking for function ID - for completeness if nothing else.

> +#define ARM_DRTM_FEATURE_ID_MASK		GENMASK_U64(7, 0)

> +/*
> + * PCR schema numbers. ARM_DRTM_PCR_SCHEMA_MASK is a bitmap indexed by these,
> + * and the Launch Features ARM_DRTM_LAUNCH_PCR_SCHEMA_MASK field holds one.
> + */

Similar to below. Maybe this dual use is a bit fragile.

> +#define ARM_DRTM_PCR_SCHEMA_DEFAULT		0
> +#define ARM_DRTM_PCR_SCHEMA_AUTHORITIES		1

> +/* v1.4B Table 6 "DMA protection features" */
> +#define ARM_DRTM_FEATURE_DMA_PROTECTION		0x03
> +#define ARM_DRTM_DMA_PROTECTION_MASK		GENMASK_U64(7, 0)
> +/* Only valid if ARM_DRTM_DMA_PROTECTION_REGION is supported */
> +#define ARM_DRTM_MAX_REGIONS_MASK		GENMASK_U64(23, 8)
> +
> +/*
> + * DMA protection types. ARM_DRTM_DMA_PROTECTION_MASK is a bitmap indexed by
> + * these, and the Launch Features ARM_DRTM_LAUNCH_DMA_PROTECTION_MASK field
> + * holds one.
> + */
> +#define ARM_DRTM_DMA_PROTECTION_COMPLETE	0
> +#define ARM_DRTM_DMA_PROTECTION_REGION		1

The dual use of these for bitmap indexes in one place and
values in another seems fragile.  Maybe it is better to have
different naming for the two even though the values match?


> +/* v1.4B section 3.4 "DRTM_DYNAMIC_LAUNCH" */
> +#define ARM_DRTM_SMC_DYNAMIC_LAUNCH		(ARM_DRTM_SMC_FN_BASE + 0x04)
> +
> +/* v1.4B section 3.5 "DRTM_UNPROTECT_MEMORY" */
> +#define ARM_DRTM_SMC_UNPROTECT_MEMORY		(ARM_DRTM_SMC_FN_BASE + 0x03)
> +
> +/* v1.4B section 3.6 "DRTM_CLOSE_LOCALITY" */
> +#define ARM_DRTM_SMC_CLOSE_LOCALITY		(ARM_DRTM_SMC_FN_BASE + 0x05)
> +
> +/* v1.4B section 3.7 "DRTM_GET_ERROR" */
> +#define ARM_DRTM_SMC_GET_ERROR			(ARM_DRTM_SMC_FN_BASE + 0x06)
> +
> +/* v1.4B section 3.8 "DRTM_SET_ERROR" */

I know I'm the one who asks for references, but maybe the SMC numbers are obvious
enough without given the name matches the spec section?  The table references
etc below are excellent!  The do no harm beyond a bit of bloat though so I don't
mind if you want to keep them.

> +#define ARM_DRTM_SMC_SET_ERROR			(ARM_DRTM_SMC_FN_BASE + 0x07)

> +
> +/* v1.4B Table 8 "Definition for error IDs (Bits[10:3])" */
> +#define ARM_DRTM_ERROR_ID_NONE			0x0
> +#define ARM_DRTM_ERROR_ID_PARAMETERS		0x2
> +#define ARM_DRTM_ERROR_ID_SECURE_EXCEPTION	0x3
> +#define ARM_DRTM_ERROR_ID_TCB_HASH_UNLOCKED	0x4

I'd use NOT_LOCKED to align with spec.  Maybe it makes a subtle
difference somewhere? UNLOCKED might imply a transition to that
state, where as NOT_LOCKED doesn't.  Meh, doesn't really matter
as I'm probably over thinking this.

> +#define ARM_DRTM_ERROR_ID_TPM			0x5
> +#define ARM_DRTM_ERROR_ID_SIGNATURE		0x6
> +#define ARM_DRTM_ERROR_ID_IMAGE_FORMAT		0x7
> +#define ARM_DRTM_ERROR_ID_VENDOR		0xFF

> +/*
> + * v1.4b Section 3.3.1 says:
> + *   A return value of greater than 0 means the feature ID is
> + *   implemented, and there are other feature-specific
> + *   feature or capability bits available in other return value
> + *   registers.

I'd wrap to 80 chars.

> + * And for FEATURE_SELECTOR all defined features return data in other
> + * registers, so 0 is not an allowed return.
> + */
> +static inline s64 arm_drtm_query_feature(u64 feature, u64 *value)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_smc(ARM_DRTM_SMC_FEATURES,
> +			  ARM_DRTM_FEATURE_SELECTOR |
> +				  FIELD_PREP(ARM_DRTM_FEATURE_ID_MASK, feature),

> +			  0, 0, 0, 0, 0, 0, &res);
> +	*value = res.a1;
> +	return res.a0;
> +}


> +
> +#endif /* !__ASSEMBLY__ */
> +#endif /* __ASM_DRTM_H */

