Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792598431;
	b=37gmrc3fBNnoCKVtwWnuLj7pYmCN8iBSBIqWP4FGiFm4I4DuoN3/TYRHVJUZdF68ladV
	 bI9eXbTQUm/yeLBONNhonnmo5svIVV1F6SlmC8vmbRsNdYqdCWxWAvmiEy4FMm0oiSf86
	 Mcw3qG8PCfgvGcyAIEU2UgaKypRkKBwDuvglqHzkYSZfxRFRXAihqEnPP+V4dtmgSCjBZ
	 806QpPTvevmRSl8Eh9i6fTU5VI1x3TcBY/3W9AeY1XB+4Co22Th/FYIdjSOp1dxJqHvbp
	 AuQYBsJ82Czwvmbbgz8WTkKGN9WQt4y0PWI2//jCV2WAQp6vd7a8TmHgj6GSTLayQYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792598431;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=ZCSVqnmCg2tgiS2qJzUGfrVmwaXnekD3uvjwV9akWpI=;
	b=fjU5rZan02qTnNp7qjdEZJPRm8ljkIYAU/rCVQk65XphEXnQ98lk5hZG2wRLIKr3Bf6i
	 C9hLhq8swebWipZ1s+D2xrLiImML/bmohIMdjEWGdLSNUsKrVZicDjyP6FtaOnOvonDhl
	 +XGiPdYBIHM1b0WtHQo5j4TicNV2Yeixj+iC9VwuCWuBO/6Vhs883UGE9MaMlvmtm2Go9
	 44kk7NFjyfW3K9m0/yVaTub+Oc5zhP0KKdeIQG+XG/uPFjLVMo3EDfqS6rnKODn9B7iR0
	 kpFscjZ9wKKjuq+j3iUXrVLdK+RyKvLvbCa2J8Ulq0UZl97CfSQNXqm3Jzzqp1VWGAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fwgbev1Y;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=AUSucAZ5;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86B2606A320
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 16:00:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D86B2606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fwgbev1Y;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=AUSucAZ5
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFUAsO1481770
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 16:00:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZCSVqnmCg2tgiS2qJzUGfrVmwaXnekD3uvjwV9akWpI=; b=fwgbev1Y755yo0Wk
	UtrQff0d+SDedqVBkyUwA25GdbsQr1gedtRARzdBI/EmAOe0XsQToYsDxG3dcNo7
	WzxSgYac/ZGOsmY8agUmPRwldZjLtqwf49ThqvX1StCK7jmI7HXPKz+sOHF/9RsX
	d2pytN0NJDGCo1MhMPxlfFPfca6UKvw74dPxLEl0uCzKdYPb+HZyLX3GECv4+38B
	1RGJ0zWdQGHzDf3e0b63brnwjxFoTAwfwuugTBfdk1u7TM1ZeuovSwyIH11w2+ZW
	SdnPxbpBiqOcHpBXKX9x9UDSHSBDxYFiyv72OFxlygXqyI/101YubsytU9S9Gndm
	8d/hEg==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hegs0426a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 16:00:29 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-36803927a49so1320480eec.1
        for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 09:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792598427; x=1793203227; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ZCSVqnmCg2tgiS2qJzUGfrVmwaXnekD3uvjwV9akWpI=;
        b=AUSucAZ5rwrNwA1H8x28mfSSaWtXbiBwUxE5T1IDIqyj7DgtFSzxYZT9LuSvvSTgPB
         j7XaPxNqI6Z4555mK0CsraI/Z5HD4HWGPimtH9S5ExTyWtvKmzXRdYoYmjFEVbrLzd3/
         +UAYmWedV730dIQ8k2cp8yskgRafE8dHvQz8gUDqLTTQ7i8z/sllo84tNui2yBi4IWWa
         eEbjvbEElRuQKudeFCB+Zgh5wkSmQUN+RhLY8oMuO9c65t2M8l95XOJseWBmpSF8QEux
         /6eCpQIQj2C4FgId+q0DLzr1W/5Zlsvbht0Ve+pmKMn4/ek5b1gP74C60NLobkTjohcG
         Ujlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792598427; x=1793203227;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZCSVqnmCg2tgiS2qJzUGfrVmwaXnekD3uvjwV9akWpI=;
        b=NwyJ1Q97tyT97XGBlJ8XD4x7V263RE2jBWDNiVCHJJqOBzV24yyb+Nn3NuW+XgYXeH
         WGtUznMGL3krXApr9+nzL++O/x3D7PEuGRGUQVAys05jyeQU2qnxnozZ1lLr6rEH0UYY
         qXcG1tCHHcXkBU7+o+pTMWUUkNp1qg1lX/LArRgkm0qjVCACeNBazO5iqkrGnvrmYbey
         qRnAw+0fYRGIhfUZoei1TqeKAdI5AXqtdzjiE7RaI0LtSzLST/5/6yOSJpU/QLZrjvrV
         DyBLxRyDfRkT6ibV7apMV2wcoYcOlrqP+0A9oiAjiwu/WxqbF9wC+QGnyA0s7X/ZVQOe
         CZfA==
X-Forwarded-Encrypted: i=1; AKwUvByMK/jTIIiQguuYWIQ6KG2rGi9LcwjcRf5qogA0Uig/toBxv5Tb46g7uwslzDbun4ARgjsO5C4FaYw=@vger.kernel.org
X-Gm-Message-State: AFq9FYLv8VOBF81YfjvFj54WGNNYLVhjU4KdMoqfZo28PJ2p2tvTc6JF
	wshGycOPBRE+1QuvEQVvwLePZe9ztDi8uQ7MfgFM47sIvWpu2OiAcDQvxAuA2/hmISSjRMxX0hY
	ktLAHZgoR+3VuZp5XwKLt1Uo5qXwniJZAEjXwY4rn9kjosFEDB59pqOFx1cuvo64=
X-Gm-Gg: AYBFou23EWqWUqLWPpGbEgpYt2FlhPkRLYOiwUOGhU2JfRlDfcDHeYHErZXSb2FqZUi
	mByPUXo2W0kJQvVHhLLlKEGsbiida+RL0N6jivSG1vn/Y6D5MJGN1OsD6FPA6CrXP/xlb5//mQ2
	0Dhin17xXKUjHIlig7YIp4MVcv9MKNaxiqn5c3BueUyBsJ79RV+ohM2JlL8B9I3Y2WfTy6TUrzi
	/1A7q4zXQY+AcsDLz2NeYVSPAd/ECxq9xiYyklntowU7SnwLya1KuNvVMO9z8J8o1acp/pnMW2+
	Xw9XkHVmgTL/iYvOFo8b9q/9pz3+sNhhWfaUZ0RmllmhIi1j9XgGF4yCt18Vqw48cWWF5HgG+ao
	BKXu3j1+rkwJ4YQL8nyQ2vw4B7jqsBraBfPl47XoN7Q==
X-Received: by 2002:a05:7300:106:b0:35d:d9a9:e455 with SMTP id 5a478bee46e88-3674ef292b9mr4299684eec.21.1792598427220;
        Wed, 21 Oct 2026 09:00:27 -0700 (PDT)
X-Received: by 2002:a05:7300:106:b0:35d:d9a9:e455 with SMTP id 5a478bee46e88-3674ef292b9mr4299533eec.21.1792598425455;
        Wed, 21 Oct 2026 09:00:25 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-367405ed2absm10188327eec.5.2026.10.21.09.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:00:24 -0700 (PDT)
Date: Wed, 21 Oct 2026 09:00:19 -0700
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
Subject: Re: [PATCH v2 02/15] efi/riscv: libstub: Don't set image_size in
 handle_kernel_image()
Message-ID: <20261021090019.000060c4@oss.qualcomm.com>
In-Reply-To: <2-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<2-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
X-Authority-Analysis: v=2.4 cv=S/NMU4sP c=1 sm=1 tr=0 ts=6ad8e19d cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=Ikd4Dj_1AAAA:8 a=xbFV6RGmdEKkzbgyJ_QA:9 a=CjuIK1q_8ugA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2MyBTYWx0ZWRfXxI9GFnhIoqmR
 ghg5kFu3t3qvnCronwuLLlNSaq59cvk2+pRFcUUoCT002PvzFbECFyUIDZMaMARI5zW1juV4TW1
 yHPTBZAqeeReg6unFIRTB1qFV7TxxW/tobMe1fQ7IMvKuEs7CwG4XSno0r11LJoPGcZ0NgbtgSq
 jgnmHWAVE7RS6kU2LHuGxk5D+DJV/CS1t0kBvVHeMy1ZDAsp4b+/Z9GxAjNsvTrirXxjvQqvUDY
 tDwOrgR5X0LnMa7TTYpoZRC/ur/rq+9Pkaih7CMJQZUz87M1t6cLOaDCw+Eu29kqlIe3hMvg8fl
 3CtaG45FrV1f9jURtnsY+K0CqXetRSDTYz74RbNJsIbY41nsSOOFYQ/2SB395xjdM6kxNZVNc8U
 Gtv6QuCZWb+ORzfHDlISpMiFk5piTb5k9l3tja9bQSjcFqMYtgCn0pwaPgZpDHW8xaHI6hBP8dn
 RM/HjTVn9M9duaxsi6g==
X-Proofpoint-ORIG-GUID: TIcFjTdRcmnIp5yuoRdHZidUzUIDulNl
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2MyBTYWx0ZWRfX/e8QphwWwlah
 /kdG64WgFoQKPPvDIs6FDwcFFyUb+DRutmGqZVuwiuEKvqm21nsIW9wOSgsL6RExEVkr1LtxMlj
 W8eHHKWkBoOX4oo9aTIjRXj5BpBY7YI=
X-Proofpoint-GUID: TIcFjTdRcmnIp5yuoRdHZidUzUIDulNl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210063

On Fri,  2 Oct 2026 20:31:39 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Sashiko points out the image_size should only be set if image_addr was
> reassigned to some allocated memory. If image_size is not zero then the
> caller will free the image_addr pointer.
> 
> efi_kaslr_relocate_kernel() never works like that, if it changes
> image_addr to allocated memory the free is done through reserve_size.
> 
> Fixes: b7ac4b8ee73d ("riscv: libstub: Implement KASLR by using generic functions")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Hi Jason,

This made me curious on the differences across architectures...
Looks like there is perhaps some room to make them look more similar at least!
One small step below.

> ---
>  drivers/firmware/efi/libstub/riscv-stub.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
> index e7d9204baee312..725b634c517919 100644
> --- a/drivers/firmware/efi/libstub/riscv-stub.c
> +++ b/drivers/firmware/efi/libstub/riscv-stub.c
> @@ -37,17 +37,14 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
>  	kernel_codesize = __init_text_end - _start;
>  	kernel_memsize = kernel_size + (_end - _edata);
>  	*image_addr = (unsigned long)_start;
> -	*image_size = kernel_memsize;
> -	*reserve_size = *image_size;
> +	*reserve_size = kernel_memsize;
>  
>  	status = efi_kaslr_relocate_kernel(image_addr,
>  					   reserve_addr, reserve_size,
>  					   kernel_size, kernel_codesize, kernel_memsize,
>  					   efi_kaslr_get_phys_seed(image_handle));
> -	if (status != EFI_SUCCESS) {
> +	if (status != EFI_SUCCESS)
>  		efi_err("Failed to relocate kernel\n");

This print is replicated at the caller, so can drop this as well I think.

> -		*image_size = 0;
> -	}
>  
>  	return status;
>  }

