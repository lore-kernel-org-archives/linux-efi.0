Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792606302;
	b=hi8T2P9HMdQ2cGKBN3gpMHL2Vll6WdPbQQz5/ehe8y4krXOX6L2RDNH2LTIGkdUxnBe1
	 2bhDOkBLJIyAFUpqZ8Lvoe69i3D/T51BwfyNvLR/BN5BNyw3Jps5isVFtQueMmo6dzTFr
	 JuU7kKf/FpW5b8m1Pch+WCoECIchaTQonIi+hDNyUQ5kx2igj5uTYqanVDtFr48ylzxPu
	 +ifbSMpZeMtix9p1n5Qjh9RBqNTTeNyvJdsioGyWYuUyYHkPHAKdolZOuyVK69NTF2CzP
	 V6EWxpi04jxE4hPB1iaR/wHQ/06KMDbLMScFyE7Q8RGAZtq3sBoB9nLduPOwhgQE1/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792606302;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=zajgpZEWlkO9hnDwMwdkleexKLADl3q/zhIDBDjaWRQ=;
	b=D+DIRU7/nxSgXTSyghwTru0F85ey4PaKhl+PjtJIMJLfrmxiBxs8iUzcNlrAdsdLwv9A
	 thd2+fm3nUd97wuIRuhGTgKLGcB/lENIgm4SzzxbPA/BBsQr3OZiVPbkS8VmBMKtiIWQg
	 4I+RNQJO5KyICVUv2PUySgXCzum8uuHWocynzb4Q3Tjx0uEJ5MgClrhOzp8knLC+Ns5TF
	 CjNZzllhGp17ePpkLxmrHl5u8mJjyf0GC8pBeaPou5VyAfspDwClxGTnrxyyo9ebAxPaM
	 t5FBGnMPVgat3TRpcOV/1GfwuJDKWhwlTsHkG2aroOpnLin3aXYg+iDAsuu7yefV24g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=KBq8By91;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YaGqCK7R;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618BF606A31B
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 18:11:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 618BF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=KBq8By91;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YaGqCK7R
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LHpOow2384272
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 18:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zajgpZEWlkO9hnDwMwdkleexKLADl3q/zhIDBDjaWRQ=; b=KBq8By919CR0Wk6J
	i6AHGYv1uzl0plIu0g/ZjSagDkXy5EsbBsmzhImhAELaJ/l3SfReAUQpWiSHeVNf
	BufY1pa+JPkBGkez43hmPC7dSe/wTdocSPdgRHEIkjXg+77SAdYjTQAo3aTC702v
	wIJaXklJi5pC3EQlxvgOlS9JUMDPzA8ux1CypnFa/HaSbozJtLx5c4F1YuTj12X7
	fPuROybpD306YEcuArWKV69DugzhWLf5aBj0QG/MFJEbJRpq1GRrz3FGnTg4Sr+J
	HgvYZbYSilPrBWCFEs8avj6fFE58i34cFDbduqKYWVEMlX2iQVhEPuzZodKWCD3h
	tK/n4A==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf0ke0jmx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 18:11:40 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36803927a49so1619888eec.1
        for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 11:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792606300; x=1793211100; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zajgpZEWlkO9hnDwMwdkleexKLADl3q/zhIDBDjaWRQ=;
        b=YaGqCK7Rzl2stBiPjB2XmkxdVkbLq0gkYJ9dR/bWa3JZRJBurr9bJnuotCMi03y9Cq
         U7ZpsiBsl/bNdXEmBnovl8NsnMdrTHkBUuf6znyK+NvOdjqXH3ot+htk4K6DGwWEMkAq
         h2yX2eyn4loxTooaCw8uib2vTBjOxQCbQF/aLK/v6eHmPfqHwSv7LJvYfAhnCYeS5z5K
         2KxAyoZt7nbx3vZ/Og3QKQCmwFmz1BqHao11D64WPL1hhGNh1bqGI2utYOy/lDXyUunr
         kXnvirkudF3PNCnMhYh3KVkSw5GWdyIn0AA8DOxfFCpCCN55cxpU1bRvDab2OjSfZqq3
         Mm6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792606300; x=1793211100;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zajgpZEWlkO9hnDwMwdkleexKLADl3q/zhIDBDjaWRQ=;
        b=qRmx17mleaDcMjX9TGNznefSXo8t+Pi5WMyMNsgoP6/Xv5sLngtpgUa3tKu/tv5MYT
         QsFR8TvHa3ubu+KGumgnQnNrqMekdkNVyPK7QgdBJzKLeBMZ8x+NprE81hcxLhQGC6Qw
         2VmpGS/KtklnNz9x4tpkOM5ZzWZX+eW4JqKwGLRWHU5jv9OCB8Yz5ZT2Ze/Ls2oRhK0I
         U4FgThnlIDhh7jj1f+/vANDEqrBnsXAWjkenr8tS58ok/mdI8lfgCTJ91eSSixC7ih9x
         M4Q9Wq+EDQxaLFnxjPgM8iiA9XoQf+yFTkOgrOwHX6gcqNB/nr8AwqMLUQMm2aZXZ9OR
         SsUg==
X-Forwarded-Encrypted: i=1; AKwUvBy2sS9UJYDiYq6sQB1Lt0D69fKFhZhMX8uQbjJNnFexC2DPjzZvrDHARjq5seaKnjrzvnNRNNYy/Jk=@vger.kernel.org
X-Gm-Message-State: AFq9FYI6igmGuHPdDWerG9/p6eebPV1No5OaPw2Hrd7ns8EbZKxnTFlm
	VbnTFyzZN+FnXrwZttqd15wLu/FeesisptNSFUYJ+qkr7QzH5+9wp7HnfSQ/ePatZeU0FklWlPt
	upFo3C76lrktlysMcdbvUCj0rfqe/sJPtFtWdwJ7r4zY9Ac8eMPC6+HSeC8+9FuA=
X-Gm-Gg: AYBFou3Vjwv8VJJ681tst+oSwY2VO3/XSHcxKBV/9nr2HgZEwAQsFDFj5EMZL5ZGbMt
	2arr5VhtpDFw+KVIaCkm1x5oVJ6AKU+72HbJlFYVCXnmYRFAcju5l2DPPkOLQTSvvEKzjPu89Da
	JuZBTgmMOX+HwLqszochKt1HtDkwGX1/sWv3m7d7UCeJKCpB+L1HPE1lvTlT2KlxeqYzhzkOwC9
	PBXxco50CjOBpx0SOM2wK35lQuq8qfvuuxyi5VGdjNd9jay1Ozn6kZr7FfVLKUE2yuPz/EeQkp5
	4hVfsUv0UbkMpCEB0egNTsEhse4LjjTxYbG7hmDJ5chK/yuV79mtx3YhMnTzicGd7kzNsmk6Fqv
	hD4qP5P9l3aEPKy7+UtNV14zXqTdMLOevC9VKY/x5Lfw=
X-Received: by 2002:a05:693c:41cf:20b0:358:1f59:48c9 with SMTP id 5a478bee46e88-3674f21a97dmr3790635eec.24.1792606299615;
        Wed, 21 Oct 2026 11:11:39 -0700 (PDT)
X-Received: by 2002:a05:693c:41cf:20b0:358:1f59:48c9 with SMTP id 5a478bee46e88-3674f21a97dmr3790596eec.24.1792606298974;
        Wed, 21 Oct 2026 11:11:38 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3674206d1f1sm9116156eec.28.2026.10.21.11.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 11:11:38 -0700 (PDT)
Date: Wed, 21 Oct 2026 11:11:15 -0700
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
Subject: Re: [PATCH v2 15/15] efi/arm64: Implement ARM64 DRTM in the stub
Message-ID: <20261021111115.00004c5c@oss.qualcomm.com>
In-Reply-To: <15-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<15-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
X-Proofpoint-GUID: Fd-QNTPRzcm9CF5mTztx0sBNdKMRaIYO
X-Proofpoint-ORIG-GUID: Fd-QNTPRzcm9CF5mTztx0sBNdKMRaIYO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA3MiBTYWx0ZWRfX962mQ3wZ6tsE
 hUor5i9bKSYQRKoXc0cQAF5jBNjt1fuFog+fgTvUdDxn8JNBzZ+bh7+GajGqT7zeJpFAQNFkANC
 +hPL2MC2cul9y/mbl2u8AZgT4k/EvQQ=
X-Authority-Analysis: v=2.4 cv=KOzPn1Fo c=1 sm=1 tr=0 ts=6ad9005c cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=Ikd4Dj_1AAAA:8 a=Sk9Lk7371zlc0StAK_oA:9 a=CjuIK1q_8ugA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA3MiBTYWx0ZWRfXyVPeRbULzbAX
 mORjW6QP5oShvRhP6wIR1nX+w2Z9pOIRJaouJyJCx1iuJkhVOszN/+95AznSahHCPElQe9tvEmh
 vohQwuXB2I8us/fe8CIGK2yFdjmFQDF91XUyMRpGhV6Wu8coxoB0huUwCUYM8HDIaJdPXJP/pkG
 KSt15i7VSLdeghLZAkdb3xRuYiWb358vlWOmkmFL7nT+krCsJBl+dim6EKBPFkqOtZ/WE50GW8H
 Bqk/wPel+8TW3PPDJESiBEgxN2tBzGToD/KW/HmycjN1ioJVSRQi1KIMkM8QjXVW7gNlpr6R4wO
 RCu3JbDZd5LRFYsl9QalnCJ70zBbTELgXfGBL7kKiHfX4Waoz7Pd6VK84yI9VC2+bCiebcrPqfM
 nQ7wvnYr5d/veox2ZxykwS99Q93ac1mkIYjnXbFCoo5fklU4WBrCL9rXtTWEk/F/jEvRuvZYuor
 5BI7wv82cu62XwmXOXw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210072

On Fri,  2 Oct 2026 20:31:52 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Provide an implementation of the CONFIG_EFI_STUB_DRTM protocol for ARM64
> DEN0113 >= v1.1.
> 
> First, it queries the FW for support and collects all the
> information. This is needed to compute the extra_size, which comes
> from FW reporting how much memory it needs during the launch for the
> DLME Data and DCE-owned data. The generic stub ensures there is
> trailing memory after Image for this.
> 
> Then the DRTM_PARAMETERS launch structure is computed using the
> offsets in the efi_info.
> 
> Finally, the stub does ExitBootServices and calls the actual launch.
> 
> The feature discovery process is deliberately fairly verbose to help
> debug any FW weirdness in the field. Enable it with efi=debug
> 
> It looks something like:
> 
>  EFI stub: DRTM: interface version 1.4
>  EFI stub: DEBUG: DRTM: TPM algorithm 0xc, TPM hashing unavailable, PCR schemas 0x1
>  EFI stub: DEBUG: DRTM: minimum DLME data 73728 bytes, Normal-world DCE 0 bytes
>  EFI stub: Decompressing Linux Kernel...
>  EFI stub: Generating empty DTB
>  EFI stub: Exiting boot services...
>  EFI stub: DEBUG: DRTM: will launch, selected launch features 0x0
>  [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x000f0510]
> 
> Eventually the launch'd kernel is going to require built in crypto
> libraries that match what the FW is using so it can validate some of the
> information left behind during early boot. Refuse to launch if these are
> not built in and build in the most common ones from the ARM64_DRTM
> kconfig.
> 
> One nit, if the platform does not support SMC then using drtm=auto may
> crash on the SMC op. As far as I can tell there is no way to discover SMC
> support through EFI. Learning it from the ACPI FADT is doable and costs
> about 250 lines of code.

Ouch. Sounds like a must have if there is no easier way.

> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

One thing inline that confused me.

Otherwise seems fine to me

> diff --git a/drivers/firmware/efi/libstub/arm64-drtm.c b/drivers/firmware/efi/libstub/arm64-drtm.c
> new file mode 100644
> index 00000000000000..2fc58babc3e7cb
> --- /dev/null
> +++ b/drivers/firmware/efi/libstub/arm64-drtm.c
> @@ -0,0 +1,426 @@

> +
> +/* True if SMCCC 1.0 or later is available. */
> +static bool efi_arm64_psci_smccc_compatible(void)
> +{
> +	struct arm_smccc_res res;
> +	s32 status;
> +
> +	arm_smccc_1_1_smc(PSCI_0_2_FN_PSCI_VERSION, &res);

A function that is meant to check for smccc 1.0 is using the
smccc_1_1 namespaced calls?  Maybe add a comment on why that
is ok to do.  Is anyone actually using SMCCC 1.0 on systems like this?

I a bit surprised we don't have a common helper for this -
I guess the version checks are often explicit in a particular
driver being bound.

> +	if ((s32)res.a0 < 0)
> +		return false;
> +
> +	if (PSCI_VERSION_MAJOR(res.a0) < 1)
> +		return false;
> +
> +	arm_smccc_1_1_smc(PSCI_1_0_FN_PSCI_FEATURES, ARM_SMCCC_VERSION_FUNC_ID,
> +			  &res);
> +	status = (s32)res.a0;
> +	if (status == PSCI_RET_NOT_SUPPORTED) {
> +		/*
> +		 * SMCCC_VERSION was introduced by SMCCC 1.1, so firmware that
> +		 * does not advertise that function through PSCI_FEATURES is
> +		 * using the valid SMCCC 1.0 baseline.
> +		 */
> +		return true;
> +	} else if (status < 0) {
> +		return false;
> +	} else {
> +		u32 version;
> +
> +		arm_smccc_1_1_smc(ARM_SMCCC_VERSION_FUNC_ID, &res);
> +		version = res.a0;
> +		if ((version >> 16) != 1 || version < ARM_SMCCC_VERSION_1_1)
> +			return false;
> +	}
> +	return true;
> +}


