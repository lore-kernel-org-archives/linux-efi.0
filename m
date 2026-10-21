Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792602392;
	b=RCIvoLE+cPnyzPJBd3TDdwcbnyfLekRzzbWsRO261kJ7IG2vv1SNBAbpX7wQokcRjl4d
	 TRSyw24zah0jW+RBr//v74SGwJwVg9MNq0oykYLeEh5y+hqlBBWFFkaVDFyyU1s4OhHqq
	 k/AJNxBA2DHUyB+es6m65zUIF1vW1c7QeaboNKqAX3VzyyGVOgKeHBfRokBmCWLh4iO1R
	 PWVVTFORPZuiAN1y1zCIUKV5EbIy4bwpBsS/QLd1nOGDURsApG+mLK3ydvBMGJtRM7Z9B
	 Tmx29/aZT7S+C4CxdmRQ1dE47mCuePjIqhlSzVPFh7F3xfGZfhZpt2dwd7gdjliXbyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602392;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=4KgtddslSOEOaN73E6Xh0kX0j9JGBALLWlHj4vZIcu8=;
	b=ColfoWoZWjzQM3y8Ujd1hnMszqJ8Z+vfszS9gttO2x8YS0zpYHBB9sq5rDPXGtMH6U5K
	 jV7RHD40iIJ0ci0gJjcOhhLdjgDLCD8U8UglAzDJyZEf5uR4itZ7yzdSvgu+opE/HP6Ig
	 HgY0Dfx9jEVDK1bp2bL2yskfo277LLSNJ9s3XCIxCtAm6xRCw51EZMb7t9hcwZ6Yg7ik2
	 Nv8hOiBGsWiATNIU4n+ye80NykHsxHaQeDLz1ufHlZ4qqSmtXwoTBzTXOStviYyee0JhD
	 fqKwyqWc2LQ2TWWifuMI9DkVQPlW2CPnm2MWecd+kQ6MsjjNfhsSi6LyF3h//S4BS7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OSlcL8cO;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=S0lM1fWI;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54E9606A32A
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 17:06:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B54E9606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OSlcL8cO;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=S0lM1fWI
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFU6JM141642
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 17:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4KgtddslSOEOaN73E6Xh0kX0j9JGBALLWlHj4vZIcu8=; b=OSlcL8cOU5zXbryB
	8fphfV9zo1XreQA4OpWxV/h7tO89Sx+6X2Zl5p6+0ULsUn90taN9eGxYH16jm+qk
	L0XZJ7Dn3v8XGxu9eL4AUwpW89Q08hqaGYjoQLd+s7IfocWo3yT9caDh8KNWlz5H
	s2wvu8IN32qEW3e4b+swbEmyIx4Sb7Bfs53jhsZpFAhMxFVFGH/lhgrGUhOIl9na
	ZHCzsoC6k5dyzggh321+7NzEQC0sx6z0Q589PxqQBdkJCqG9N/vTM/t84N6WLpwZ
	XNzQ4yeKMJxtggMzRJOTsDyC0PwIrehi/AU/krpfAg39mwEvzewP39PNMVc/Bg+a
	pxwNPQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hex58924r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 17:06:30 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36696c9f55bso54386eec.1
        for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 10:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792602390; x=1793207190; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=4KgtddslSOEOaN73E6Xh0kX0j9JGBALLWlHj4vZIcu8=;
        b=S0lM1fWIw6Y5hJNpLN3G50Ucns5COX1CrBE5hbyjPvJoSWfaUU74zEBfK5Y9LOfw2o
         3qJuezojUa7Gwuxzpuy/sRiQzyLvOc9/wbbwX7fNFq1fLWNTYoqZf2H0HrpG76BxzJkd
         j4NEOGLlwqNWTzlkJzpYzISQUweCoK4ctrM0+yYr/nhRkxxHwelCf8Yr47GhsPdS/Gh/
         VebX6ND7e/SueIFT8iifQkT50U24TtcvbyCvGuKBnDq3FtCLV80e+kGT9AWueohj3ns1
         ZLNryXgd9nc5t4EbUsKv7TiPfGLjKNrhfFHKWolwtgbwMqQR6ThArwPN1LlmwKKUPgZc
         Ru6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792602390; x=1793207190;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4KgtddslSOEOaN73E6Xh0kX0j9JGBALLWlHj4vZIcu8=;
        b=jCpXd+dMeD56z8MW4hvowHgtkFM7/3y8scU+h0noGTrzn6WjLGRtwIp+8HaEND8XKH
         2JsQoET2TjNGT/DzewZC9e1hc0gJU8TPO5Dha1BSvfhtScSOv4LIkbvlHDd9XHfH2FM1
         Nq6f1m4wdI8UVuE+K+bJb//gSoHzLk36qlKCFMC/x43OkTPd43jixGLor6ho3pXFRWoa
         7kecmWqDWxVM7iDSalllz1pmsmo03RMGrYb8HF2i8cyRMDGCk/lMCtNBF+ReTf4Ro36T
         4TQ5U4T197FTQu7m8HcOemnMs2q4CFuhvVpSmY7nVVXIl+6TsFMDYDaOnKkjhY9jTHom
         UiiA==
X-Forwarded-Encrypted: i=1; AKwUvBw2cYkftl28VGJeMyHTk9ZLEeUIKu4M2V/xxpUeoUp9FmvzUK+p0Bm5KsV3pE9zsnrU8qY9A3cdCo8=@vger.kernel.org
X-Gm-Message-State: AFq9FYIL/XPmClt/GfMEHlknSzh9V6xryz59oUjJs5CTAGOYa3rSn4aa
	zzAr1kAerrudpyI912Octi9wMLKc0h8AylFVC3N0F6Q030gwPr9+9N3jORh1W/ZZEk2CNIr+OPq
	1Bbooo1Vtq7Rl+Adn8SbQNXUkXA0tSIA6+WrNVxHdMZJf7zpFvpXtVAGaTjuUnnU=
X-Gm-Gg: AYBFou3SctnbIs+cOSo7ABzrJyaTT7CFODqjQGuO2r+fjiJhyaVnkuJ8+SuS/Dwp668
	oOTzDw3WeVw/+w0n678xG9/w/6M7UMKBMMQKxXpted89+wCAEAXAbSCwmwe3bOCaCnBdExj+/p3
	TSnaVN7p7kfcHW7hrXE0eFFXP0u8w3Ku/t8eetHlyDep5rsGL587cOAH+HNF05moGgs00hqrhP+
	LqdtlJk/xqMKiWJGHdT92Fwc6jAhd+q8ufgPSpr+h45ro6lW6J+XHHL7zmYTzWwG2qnjC/f7Kw2
	9q8v8+mwGtdxJzh4FgxL3lZhB1pzILE8y6TNlhaX6ekaZ4SRZ479Ndc7C04xK9wc/kE6fUM1cF+
	LH4AkVvPARHOjf1qjfbDwl+zHAxoZ7eA3R7Uk7QMEAQ==
X-Received: by 2002:a05:693c:20cf:20b0:363:a45d:10b1 with SMTP id 5a478bee46e88-365fa49061dmr6847134eec.5.1792602390066;
        Wed, 21 Oct 2026 10:06:30 -0700 (PDT)
X-Received: by 2002:a05:693c:20cf:20b0:363:a45d:10b1 with SMTP id 5a478bee46e88-365fa49061dmr6847104eec.5.1792602389510;
        Wed, 21 Oct 2026 10:06:29 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-367f52ce166sm5334511eec.29.2026.10.21.10.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 10:06:29 -0700 (PDT)
Date: Wed, 21 Oct 2026 10:06:22 -0700
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
Subject: Re: [PATCH v2 08/15] efi/libstub: Have efi_kaslr_relocate_kernel()
 handle extra_size
Message-ID: <20261021100622.00007ae5@oss.qualcomm.com>
In-Reply-To: <8-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<8-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2OCBTYWx0ZWRfX5iuyfnI6OiRg
 XllgEU+Yu+ZPimJ148B3ovIlUxzYyZXA75kILv79uOoZdI61Y+issQSGXo8DmE7JKZuT0O02jE5
 ynBkx2gv0gW1WvpE3Q1JxFdGK9FTTQM=
X-Proofpoint-GUID: L8uXR5tBvkezWb8Ap4DvVrvPg2tsz0Ve
X-Proofpoint-ORIG-GUID: L8uXR5tBvkezWb8Ap4DvVrvPg2tsz0Ve
X-Authority-Analysis: v=2.4 cv=Ku7YSmWN c=1 sm=1 tr=0 ts=6ad8f116 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=Ikd4Dj_1AAAA:8 a=EUspDBNiAAAA:8 a=z1Vexnt6jiiBlSUV7TIA:9 a=CjuIK1q_8ugA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2OCBTYWx0ZWRfX8n6gPhPcOnh3
 gG524lrF+ipxQo52SzBpVybs9cj5O8rwxd04sFpFIKq2Jr2JUiBdfeSWE8d/zOmfJLOq0rCACRi
 e9zX7fGJxwpwkdW60i4AwTlBJDVX63aeneuMn+E6cXoGPySFg+t//Erd4L2zhomVYTc5MzuHzbb
 nkSVkRkUWIbP8KY3RT/TWq9OfpXyGRJtQapxPLwy+yzjhMBKC6qOuDWZ+U519A5sllXf8IRPJNm
 PdYxC7fTPqz0V4ocuMHEaNGuO+5NM8aYUnTCGgI4uSQuIetPftj+3VkBXKaTm1ViXTfFCFDUFqO
 Z+H4AxRmZyJwa1nBO32i5vgHV/idanNigkroowr5DKv3k3TwdqdMOD3YBZ3yUk0az4zYLHsOJAJ
 eaI3AE9nqiM+PW2E6McIr4SlA3yeBiou+dr6YSzu8OXzYFNoKJeK444ON3Yxk5wMmTdf9rtGnXf
 vgRd9k5f/Q0pqfoZY9Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210068

On Fri,  2 Oct 2026 20:31:45 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> There are three possibilities here, each a little different:
> - relocating for kaslr, just request extra_size like the zboot flow does
>   when allocating from EFI
> - in place, attempt to allocate from EFI precisely after Image to
>   confirm nothing weird is there, failing that
> - like any other error with the in place EFI location allocate
>   non-randomly with extra_size included
> 
> Remove the callers' assignments of reserve_size since
> efi_kaslr_relocate_kernel() now does it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
A couple of trivial comments.  Otherwise looks good to me.

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

> diff --git a/drivers/firmware/efi/libstub/kaslr.c b/drivers/firmware/efi/libstub/kaslr.c
> index 4bc963e999eb97..e419f3800af517 100644
> --- a/drivers/firmware/efi/libstub/kaslr.c
> +++ b/drivers/firmware/efi/libstub/kaslr.c

> @@ -125,16 +164,29 @@ efi_status_t efi_kaslr_relocate_kernel(unsigned long *image_addr,
>  	}
>  
>  	if (status != EFI_SUCCESS) {
> -		if (!check_image_region(*image_addr, kernel_memsize)) {
> +		bool image_region_ok =
> +			check_image_region(*image_addr, kernel_memsize);
> +
> +		if (!image_region_ok) {

Why this change?  I don't particularly mind but seems to be churn that isn't
necessarily needed.

>  			efi_err("FIRMWARE BUG: Image BSS overlaps adjacent EFI memory region\n");
>  		} else if (IS_ALIGNED(*image_addr, min_kimg_align) &&
> -			   (unsigned long)_end < EFI_ALLOC_LIMIT) {
> -			/*
> -			 * Just execute from wherever we were loaded by the
> -			 * UEFI PE/COFF loader if the placement is suitable.
> -			 */
> -			*reserve_size = 0;
> -			return EFI_SUCCESS;
> +			   (unsigned long)_end + extra_size < EFI_ALLOC_LIMIT) {
> +			if (!extra_size) {
> +				/*
> +				 * Just execute from wherever we were loaded by
> +				 * the UEFI PE/COFF loader if the placement is
> +				 * suitable.
> +				 */
> +				*reserve_size = 0;
> +				return EFI_SUCCESS;
> +			}
> +
> +			status = allocate_image_tail(*image_addr,
> +						     kernel_memsize, extra_size,
> +						     reserve_addr,
> +						     reserve_size);

I'd move reserve_size up a line to group it with reserve_addr.


> +			if (status == EFI_SUCCESS)
> +				return EFI_SUCCESS;
>  		}
>  
>  		status = efi_allocate_pages_aligned(*reserve_size, reserve_addr,
> diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
> index 725b634c517919..a88b2d275e5bb0 100644
> --- a/drivers/firmware/efi/libstub/riscv-stub.c
> +++ b/drivers/firmware/efi/libstub/riscv-stub.c
> @@ -37,7 +37,6 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
>  	kernel_codesize = __init_text_end - _start;
>  	kernel_memsize = kernel_size + (_end - _edata);
>  	*image_addr = (unsigned long)_start;
> -	*reserve_size = kernel_memsize;
>  
>  	status = efi_kaslr_relocate_kernel(image_addr,
>  					   reserve_addr, reserve_size,

