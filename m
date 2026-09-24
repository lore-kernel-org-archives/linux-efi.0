Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EF5371D1F
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 22:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290651; cv=none; b=Yqk1uhKjX4694TfuUOmssnt+9zu8OOzHu4A6Lxu//1M3gGEqabfuAL71JSQ+6hAvGUaIR/XHYIcjaNoUVeCFNB8H2Vaf9fLwgR1rZE//uZMoQNqyQdHaoAKwx7BFu6jOQSUD/GZBYDvSqzCq2T97nA9SpPpVFs+oLijiYsYX5D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290651; c=relaxed/simple;
	bh=fpfPQgsOtOc9WLlVwD3MxGuJHzdHkV63pmZ7ZwBuyzg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZXJyQJ7cyuEJmuTTnSLU7DaABCm2Wgtt9YQ6VLXilRWkWDueVeqmQu+ZkhfMD9ghOfs8o0fC79i2Ou3gsISqtKYqfwmbWAqrnwcm+WhIX6EMgNSYDVTInkcdOYKQAFSeAF0RoszFAoLhQD8ggWjkNFB9VFdQVlqbtHfJwIQHbMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BI2Gayz/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JFg2BY/l; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BI2Gayz/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JFg2BY/l"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OMPgpg3340697
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 22:57:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WdAcd3jJW9o4oT6W8Pd28WqwPKx89e7FKJveLvjxmTM=; b=BI2Gayz/LjxSc6mE
	Kg+MLNOusLPeYnOxYOG9xy/G6ynTgm5i8HXcMPcVaie12keAjyA2Oz1Cf0fyIkw2
	1iPHcxBnFcP9qOOkZ07f07f5aQw1qPFKV8ApXthFNkR53KsFmNN+apNakWPmF9KB
	GZ4On06jpyBc5aTWoomkmhaScQbrjk2k5yn95Es0ViLT4dyJ6vNbt0gJYJ4jce1c
	XIv1evwdRyzJbK4ev5ygZd0QRpNzogYF0Tn6LwzUygOtjjPo7wa0hzGZ8ulMQwj8
	1Dwm44i8PH1iR4SnWFtv/Stn36RWYL43Nv8n7mH5JL14F6v+yiIOppzxFkJgDYi0
	2R3TpQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw5q8sygf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 22:57:28 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33baaba6371so967082eec.1
        for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 15:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790290648; x=1790895448; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=WdAcd3jJW9o4oT6W8Pd28WqwPKx89e7FKJveLvjxmTM=;
        b=JFg2BY/lxuAu5jy1YajhRoDl2AglObRJGzaW5Q4zGg0qujD/P6pBhA5nuf35UMYjMh
         HSeTj1SDLOso48DVdhcy5CXFBUeICzX22Bk4KaKt29KNnHS5nT2m2Xhhj1drWAxleTcW
         RZzK4hH9EcIHpNph73V8H+w6F9DyDowEYlK8SfRlqEYrypJu/142rSxWTgd9/xBtzrtc
         MWwF1v31xrM4hHUbb9Q5fR/ssZVCvEsqxHBHV+KfkE7R/vNep7jxC7XHe0czZ52BVeUs
         hR9bOy6k4GdC94M6id/e3dm2ywoa8Qq7+biKmc5+IAck3Ve4vKW2eN3oV/29RO3UGJWh
         eoeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790290648; x=1790895448;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WdAcd3jJW9o4oT6W8Pd28WqwPKx89e7FKJveLvjxmTM=;
        b=jtanckZnEFRp0vzDaXs7SoQDpBPLcmtrhzF+QEXR8zlcja9r/BBTwcIUlefjxhjLlP
         kaHxyerLqKWYq7vjp+U9SfMjyFGUlIfPfZimmrqGTdq52Hy0RDLy5VBWOfGrefWQHfWD
         ZmRZ9ScuwuqdzRW3+WLqPPAosAx8IiN5x7sP0x2kE2JnWhC50RYzRe0EnmzfTAcv3Kqi
         tNVenCvmQX3mzIXe4WuRmQj/uETDiTl0i145QdfB4XHzwkuJfmorggjA6/UkOWbsQ7LL
         3N5YJ3KjxCF9INItcD0ZomCwzdcm8dE/W4EVNOgq9Igg21tOS5jfS59izoMDbowKQhhA
         OOGw==
X-Forwarded-Encrypted: i=1; AKwUvBwpMWsCnFBtE/E97kFm/bGIgHzokJgXkfPc1/DGm9j1DJ/r14F4PS7j5mlpvGuUWAmva2ogbAIssO0=@vger.kernel.org
X-Gm-Message-State: AFuF++nnNYNeg7BcMVT8ppXfgkGcGc5l1r345UDf1N8qSr4J8d67atik
	gX20h7YCUzl4UcQSXWE/yho5x0mesdZrGvgT7ibS8ZuLLsrxjYSvSP4DLrTlJlWwH1xNq3mM+gG
	hpGVj77X3V5xWs0g6ezonP4UYXpJsiC82NJfGIdWMAmWYcppgHplxYOcnbzzdcbw=
X-Gm-Gg: AYBFou3vVCqv7JLBZ4ozj0GfINENGUxhMkFJg1R2RdZVyjOFYeiUaE2QOoQuQH6OwQt
	IQAQzZ+xurfIaF8FOrla8xO/upVfVJ/qZbUW7PTHYuPhYWaXSEYV8KGpSebAWruvUJShUHwR8lK
	/gr0m5XYNuGclkDpW+KDtAJ23x1MYRD+UOtor3O2FUANoFcDvGGabGGK+DaY8Wb+MvVtF+PT9XN
	6VhNQlqgKpPpsmFPg1o8NIx0BMm06ZakKBSlsv7U+Yr/9fk91GWQZ8mA7K+pL9cXNpianBfSxE5
	KaXkzuhd6PSgIXT2Wzl9yQ1P5xeQlPLerahg1qqBBSdDsWmDrdk6jtVK6LPc7AeZE/hgh7XxmzX
	608H5P9a2eSaHLbstshvXvqh9ATnlIOLL4m+wiWvZYWobrkRONxRjOQ==
X-Received: by 2002:a05:693c:621a:b0:33c:e61:e201 with SMTP id 5a478bee46e88-34002edee42mr4033410eec.22.1790290647509;
        Thu, 24 Sep 2026 15:57:27 -0700 (PDT)
X-Received: by 2002:a05:693c:621a:b0:33c:e61:e201 with SMTP id 5a478bee46e88-34002edee42mr4033386eec.22.1790290646954;
        Thu, 24 Sep 2026 15:57:26 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34144757f31sm2046484eec.14.2026.09.24.15.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:57:26 -0700 (PDT)
Date: Thu, 24 Sep 2026 15:57:21 -0700
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
        patches@lists.linux.dev, Ross Philipson
 <ross.philipson@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Song
 Shuai <songshuaishuai@tinylab.org>
Subject: Re: [PATCH 07/16] efi/zboot: Lift efi_cache_sync_image() from
 efi_zboot_decompress()
Message-ID: <20260924155721.000016a9@oss.qualcomm.com>
In-Reply-To: <7-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
	<7-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
Organization: Qualcomm
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA5MyBTYWx0ZWRfXy0C15r9k+jzK
 Zvc810/ysS3DN/+3QnsL59eTdiNFWK7n8mI8qP97mTHpUDUgLoZ9ksEfh+klOtG6x6Ug8UEKXdK
 w//n4yy7dGQOEHuN77sC+uVCUqE0ZaE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA5MyBTYWx0ZWRfX5FN8WmH7PQSl
 QnJhUMUHbhmeSERVG2unqwakLErphMfbUSeUj399CdQ9utNQTyKJospGT6NCFvd5geH0j/20wrW
 QrLMFioayaiWHvl2AX1bi1VzLAAxMXp/fgolVFwf/5n0eYYxlW9pKAhBOK+NnLaRkPAO8XdVQxF
 2YulXPifITJuzkMbSKm/MUdFgBK9c967NofwdACfgIDFH9XU4Mser9rwJ4/fliK/enolb8Z/ntI
 spvZLQDBiTih1lmny/IUM1qBBrLrB774DF3B0G7DtxlZekj9rxEDmFM6qfW2t7HpYEphmVxX8Rw
 J93qsyHEwunFe2lp4OGO7N7x62NvCf6QznwwheenRH4IQ0A0a2Qf2+tFiVzy9mTK8jY2eQpTj0e
 s/nG/lWWx5uh7ybkho1uNNtAZ1ZYGg55EihqIWxaYsbEjuy/BF04PfKS/8JG4gRP63ABLWHv6/3
 0yiS6xWw3ofNez63nRA==
X-Authority-Analysis: v=2.4 cv=SYRi5fRu c=1 sm=1 tr=0 ts=6ab5aad8 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=Ikd4Dj_1AAAA:8 a=gav0J8kFgDfseqtY68YA:9 a=CjuIK1q_8ugA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: 4OL3MlooUvx5TAPYvTZi9LPgZtctneke
X-Proofpoint-ORIG-GUID: 4OL3MlooUvx5TAPYvTZi9LPgZtctneke
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240093

On Thu, 24 Sep 2026 10:53:10 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The two decompressors duplicate this call and the next patch needs to
> change the argument. Hoist it up to remove the duplication.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

> diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
> index 4b76f74c56dae0..960a542881d875 100644
> --- a/drivers/firmware/efi/libstub/zboot.c
> +++ b/drivers/firmware/efi/libstub/zboot.c
> @@ -92,9 +92,12 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
>  	}
>  
>  	// Decompress the payload into the newly allocated buffer
> -	status = efi_zboot_decompress((void *)image_base, alloc_size) ?:
> -	         efi_stub_common(handle, image, image_base, cmdline_ptr);
> -
> +	status = efi_zboot_decompress((void *)image_base, alloc_size);
> +	if (status == EFI_SUCCESS) {
> +		efi_cache_sync_image(image_base, alloc_size);
> +		status =
> +			efi_stub_common(handle, image, image_base, cmdline_ptr);

Just go one character longer!

> +	}
>  	efi_free(alloc_size, image_base);
>  	return status;
>  }

