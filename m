Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792604856;
	b=fCb1fsMVqomLzPSNG0f2UTrXw/J+1Rf9OLctmlweLwW7/2yaa8/a5ccj3Nq9JVK49L+2
	 EgF5fGD+O9H/68YUNFRA+rRZLZ9avsyEm779pqbrDxMhZw/9wdUkl+NjKpWyA5KvSW3RG
	 oxl7wtAAVYh6gw8PMOUmbCw8yJ40Is+U+J0O+IS2dsz54tqt1nXsb+CD5evnzJe4Ekcsl
	 wqBp0CEq++dni/8WxDS6rKvmemYEtSDtrWmcB2dQjETonTg1sbiyDIdoDraUnFeI2NsiL
	 osLLJVeFfII3wIn2u+kV4GrXMRL/oFTOkNPx9hTN2+3TksUal7DcQKPYInJgK5BmFRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792604856;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=kD15e1tCEFZb0oDM+2xTBELmNwYQTz7QW2OQ3oM2K7k=;
	b=c8mrItmTmFqYZLuQghmbZoF7Gx5tkfjv4TgcJfqj5w9BTthkJlCGx9aTaNZukFXKImWK
	 pUS/QkxQocfCIaC8sMehUk7z4/7zt6mRtSn+CtvcKQNL6AnjSFpdRWatdozb6wYyX35we
	 4dJJDKMwciQcvkTtjzlCsXpJ7ZYdETiPSVBbnAgQH0uU+1774nrRpW2i+V349mngbr3dj
	 Qsdv8aeL7tHfVe8cLyg/T8RM+F9k8TS7EqAr0lWlVE7o1Pw0Pp+V6k+Gff9B00VByWWK/
	 D3+PxNwlXAJ69QoCEI52Xa+axTOxzf1ozTsgizwqhFOcVq9Apd7m1o9GL8fsnlDreOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hfpCRj+j;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XY4qXvDR;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB969606A319
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 17:47:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB969606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hfpCRj+j;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XY4qXvDR
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFTogK141134
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 17:47:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kD15e1tCEFZb0oDM+2xTBELmNwYQTz7QW2OQ3oM2K7k=; b=hfpCRj+j2KxWdKAB
	AHRIXbKs8512TkOfMBg7uAuf4pQwBrgHnCXqjXGBqRwBoq/H7P7OrFgZF0Zfi+tR
	vu+VfuJDugBApslvid6veWNBEZZcyRXJAke9i6292jK0t0YZGi9NrNaWSpT8tY+V
	s0gVcVKmPr81HHIdp7X7HflfO6HpD/K1SRGxm3CFbfoBQBPSdCsoYQ7ODmPPoU7T
	R3UtMzJ9hljMDpG1WZQeQQuRgdzWHC+h+yxC/BvbZHBOb3CssvTUbrb7Z5UqBp16
	83IkxTQ0zg67ak7mU7qRBBySHW1fHCbjzIGN0Kp3HDrdNz9pEeOQETK0hUBs98qx
	h9bHVQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hex5898hd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 17:47:34 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-35cbea41088so1777796eec.1
        for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 10:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792604854; x=1793209654; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=kD15e1tCEFZb0oDM+2xTBELmNwYQTz7QW2OQ3oM2K7k=;
        b=XY4qXvDRlemkOXLioiPA/NYaIz5WpoB8rXlMn+FjtpPgYGt7MFoaiskVLfDIRFuta7
         tRacxsEnhhBTkvyjTQ/tkvkWvmkDl1kSId55dkYDblVUUctALRZoKPCbDMxwJlTeS3Lu
         0DeVdXP9YINLRBnJxPK+9fHBNUahU4Ns/BYI4g2iKPwp6YTFnzWmpUM4mUSTdbNKm8bY
         08DYPGt+aUMeNB/tDFBIly+InCK2JIk08tCLMuGLoi7o+6TWNHRquxmtcwQap5UedBZm
         rKLL4YTpOg5Qnwl1aFZFRWQLfOt86QOfW9qNN2cIp7koo16wOHaJ1lY29p9YR1Mjf6/b
         8xPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792604854; x=1793209654;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kD15e1tCEFZb0oDM+2xTBELmNwYQTz7QW2OQ3oM2K7k=;
        b=jl9Pe2I7wUI31EuAch8FSQrfABGpCS/rtEW6XexfKsLXpoVRJJG0OawrksLH63jnLN
         peO/5x7+Dv5iWwabcjSXRVyqLqZuwv/Zr8L9Vh4SsKBk+NY/xvt349cGYECmr5EZK010
         VoJToCjz59uYMf2dWBh8i4hWa0kxVLH3ZYMy5wzSY1va0UTcw11Jejn+1BTIW1KRSJRu
         OfwPGpIocShLfosq++4hcNs9+prAZlOnQ1PC76MKGwFXoOvbrb/XekValxUsYTg5zIZw
         MAcXodSF7Jk7HJqAL/r5mJ7s9CoRVOWSNIzelH6Q8ihaVFiXPZMuf9tEeNDUeGWkNihU
         IUZQ==
X-Forwarded-Encrypted: i=1; AKwUvBzw6qvhbLe6I6+KJxwnKvysoUzX+9GgahQDkZyIf6dlhEVSDf83imu4KMZG/2/iBSJgSNbRwmW4vCI=@vger.kernel.org
X-Gm-Message-State: AFq9FYKfDjS78Ok6ABD9tCCSqLVcFzS8mVLwVXURNmHr7wO9Cr7XHfRJ
	IHW5Fm3GDNQcnCEuvOK0AK+mVLZUKORL7ENoxLIlKKKD+28ffPb5zuShVmYn6mK+QX1K9JZsu8W
	m9k9lfbJmQqma7tc0yhVBT8hGIrQAVmRWoa3mz2jf/fl5T89HY8lOYhUf6gY5pmw=
X-Gm-Gg: AYBFou1FUkwkYQxVxrWTcYFZQdFTBuLo1ppIz+JcCtm1gBBR/hNNk3eypzReEZXZu+A
	/bSWQkBnItsolEvzn70nzqHOEbRjjkQjeby6v8nAcyjMYkTms/OeZbbOlpn4Ww7Zn8K7xc40/0H
	X1yT6+rIzQtWbaRVGWcViX/awWaPeADqLauLxaA3V7oo4FAuTdpbSC+ojoHRnM9oSazcAvLo8w1
	cM3CL/RvG5ODEg98iuVLZVS1Bw+oSMxFo+SFniPOX4D5sHWRjuVGTqZfB1Gm246JUMBPc4MLSCY
	gPxXUABQGHN+WtIGJMC83pmwfVtNcGRDelFrMhw3hhZB9TiH6Jp/Ez/oWGrAqEZUE3j0CJjxm87
	HFoQDQDTddO4ejOrqtuzGq6eLwCkgX5BpkdlcNiSGgQ==
X-Received: by 2002:a05:701b:4214:20b0:143:297c:276c with SMTP id a92af1059eb24-190a5d6f349mr3478101c88.33.1792604854064;
        Wed, 21 Oct 2026 10:47:34 -0700 (PDT)
X-Received: by 2002:a05:701b:4214:20b0:143:297c:276c with SMTP id a92af1059eb24-190a5d6f349mr3477983c88.33.1792604851896;
        Wed, 21 Oct 2026 10:47:31 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36740cc848fsm8915123eec.13.2026.10.21.10.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 10:47:31 -0700 (PDT)
Date: Wed, 21 Oct 2026 10:47:26 -0700
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
Subject: Re: [PATCH v2 14/15] arm64: drtm: Call UNPROTECT_MEMORY
Message-ID: <20261021104726.00002640@oss.qualcomm.com>
In-Reply-To: <14-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<14-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA3MCBTYWx0ZWRfX/2ygSjWtb/jk
 ihWa8y7wrGSxMLUhKPWbx/M1aAmRBJ+1nBkmcRyvTEbv1XRre1u8RAZs9c82CpPh5QlH3m/Snne
 PCNpuvbFxxBH8nexUf2rLJoy1zh/Dcc=
X-Proofpoint-GUID: Xmux41xlJxVfsbJRZuMHX-bHBgla2_Ku
X-Proofpoint-ORIG-GUID: Xmux41xlJxVfsbJRZuMHX-bHBgla2_Ku
X-Authority-Analysis: v=2.4 cv=Ku7YSmWN c=1 sm=1 tr=0 ts=6ad8fab6 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=Ikd4Dj_1AAAA:8 a=4lc54p1sSd76nvOad-kA:9 a=CjuIK1q_8ugA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA3MCBTYWx0ZWRfXycGZDeR8WP44
 sd6QqLvZKZWbO1VA9I07N6roWe8pOAzFT31pO3YEbwpEB49RYX2eBuIEZz7e4Z7qsZnn4kPHUtN
 X0hvim3g6sgohBMp2a47lwE1ojVpsf50TmPTg8kgrefbcuYa0obELx1VtAYwnHtvRZx3AI44Dwm
 LyBSZks+p99qRfW27bhqHOJ1gWVvjL2015b9sxBv/HCVoRA60Kb0xPtmtbfdgQDAeNRciM1tMtC
 66+E8mn6LVutPk48pWQVgM9bTS8J6hLMW/WJAlYSiSWAbGNFLbe9qt0MZvvfIPHuIB8Rct5nDKI
 5g/5fuDlt6WxMtlJADn5+6C2rCsCBRQpJqgxvpvxEY0pFe4n0U4Hy2/xw5Jz28cA/Vshhxa7Jd6
 Nto52Z6jwnf4N5KI12rkb44mUtsp18KtWzclDIv/cVgs31t6pd5rHelgMgu4wORfM3Mx0GL9W8e
 o2l7VWArQnIuDRbGLSA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210070

On Fri,  2 Oct 2026 20:31:51 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The stub always requests ARM_DRTM_LAUNCH_DMA_COMPLETE. On a system
> with an SMMU the COMPLETE option is sanely implemented using the SMMU
> global abort register. DMA_COMPLETE should be mostly a no-op. It
> seems to be designed for the region protection mode that Linux does
> not use.
> 
> However, the FW can still do something interesting under it and we
> should call it. Choose late_initcall as we know the SMMU drivers are
> loaded by then. If some platform does actually block DMA beyond the
> SMMU, then this would result in a noisy failure of built-in driver
> DMA, not a silent security gap.
> 
> The platforms I'm aware of are OK with this placement, and it is a
> reasonable place to start.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  arch/arm64/kernel/drtm.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/arch/arm64/kernel/drtm.c b/arch/arm64/kernel/drtm.c
> index 14493948a27f0d..6062980a5d9e53 100644
> --- a/arch/arm64/kernel/drtm.c
> +++ b/arch/arm64/kernel/drtm.c
> @@ -3,8 +3,47 @@
>   *
>   * Support functions for ARM DEN 0113 "DRTM Architecture for Arm"
>   */
> +#include <linux/bug.h>
>  #include <linux/efi.h>
> +#include <linux/init.h>
> +#include <linux/printk.h>
>  
>  #include <asm/drtm.h>
>  
>  struct arm64_drtm_handoff arm64_drtm_handoff __efi_data_handoff;
> +
> +static int __init arm64_drtm_unprotect_memory(void)
> +{
> +	s64 status;
> +
> +	if (!arm64_drtm_handoff.drtm_enabled)
> +		return 0;
> +
> +	/*
> +	 * Currently Linux can only fully support a DRTM implementation that
> +	 * relies only the SMMU.

That sentence doesn't parse.  relies on maybe?

> This should be called directly after attaching
> +	 * a driver to every SMMU but before binding any drivers that want to
> +	 * use devices attached to the SMMU. Our boot flow does not have a way
> +	 * to do that, so for now call it here.
> +	 *
> +	 * For SMMU based implementations their UNPROTECT_MEMORY is probably a
> +	 * NOP since touching the SMMU here is forbidden, but they may still do
> +	 * something interesting so be sure to call it at least.
> +	 *
> +	 * The stub excludes the most likely case of non-SMMU by only using
> +	 * ARM_DRTM_DMA_PROTECTION_COMPLETE, which is defined as:
> +	 *    Complete DMA protection is hardware-based enforcement at the SMMU
> +	 *    that blocks all DMA from Non- secure devices."
> +	 *
> +	 * For now if people have such systems they cannot include built-in
> +	 * drivers for any DMA devices, those have to be modules to be ordered
> +	 * after this.
> +	 */
> +	status = arm_drtm_unprotect_memory();
> +	WARN(status != ARM_DRTM_SUCCESS,
> +	     "DRTM: failed to unprotect memory (x0=%lld)", status);
> +	if (status == ARM_DRTM_SUCCESS)
> +		pr_info("DRTM: launch completed\n");
> +	return 0;
> +}
> +late_initcall_sync(arm64_drtm_unprotect_memory);

