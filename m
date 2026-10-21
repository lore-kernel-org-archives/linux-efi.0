Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792600407;
	b=O9fZK0vyskSZUwgqjGMz9X5xSb32KVMg7ePTbkMvAegNuIJG9tILRqiAMhZ7Dbl5TgdH
	 16Y5OcwPiW1WXnH65EavkBgF7f2TLIO/io46BygSkeLyd+4RFGsew66IsIyKAU35Pva23
	 vJSX4PWKJpaKK7vzFMz8lSxtiAK+HOb41H9bcXzUHMKBG0s7j0+JPmHmY7jzkoNkurCsP
	 rUQtfEAs/EPg6UUlMNv6ejHZpEiySmpMVCzK+UFeGvpGOSlE/3WDk9szILDgtP9mgg1G+
	 FGoWQufdWcGFAmsXQFrAc2CXZUe8IhGCM2i5Q/8j1gXVVShldq/btmuY9EzzOHnd1bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792600407;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=5S0gFGL7jUhkinHTL4yVeHOzYpusQ3d8V09xofjMzsw=;
	b=qi7CFq8mCSjaur+THAOqtpz+JF850w5K6S07PEFD9kmtW4R4H1Ro+cnlSgs9jzcPWRaQ
	 cPhXxkbPi3SH/E7YOUEJ/77+SicbAywZ+dvk1Iju9UldeseohGvZu94DnAyfjTY9WeWAV
	 NG6BWBx4WlDSpfMBehDTyKJOAva1Ri8lUAVmcamTtBWDT9NXa+IiZ1Z2eJAwkYkkgKC4n
	 U04ojyE1Kz/a5d+4drbydyZ0xViw09wqaFbRRMP0zDbINtOer3YJIhOveX731tC6XQoYN
	 Ia3s2WNUtg+xq1Dr+AtKlzYZh3/nWEKYG4xnAUGd0bWEJj9cmp4axoyHukjTZU05xfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=GUi+svDU;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=NUmJEvst;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AB8606A321
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 16:33:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33AB8606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=GUi+svDU;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=NUmJEvst
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LG4D2f2149348
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 16:33:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5S0gFGL7jUhkinHTL4yVeHOzYpusQ3d8V09xofjMzsw=; b=GUi+svDU/yyymhsl
	VrHOtB1d73sBGwG7COM52idcWEEDctYMa+eF6Pt4VtlzcUUOeQtAh2n1Vsh/2WQu
	0u2tDuR/jArqfSZjo5WeZDkmKKnq5Cyx8LpPJLaBgJ14HSsFT34pk/oMJnE/QjZP
	wyw5Luv8WVqQT2T3xAGbmx03QPVfE3A+2OotuyjaMF4DqeoByKTYNGCQZF08de+c
	iWVSRHM+0Mr8/oSDoL8AAiVZP7kj7Tx91KaLcsM4HRQSlR0x5UCwgmmD9m+hLCQj
	/j5oJYm/JjLQzfXhoQU6IC244z8l/Pqlkc+kupWm84Z9ZYCfxIBs8ju/HIUwivyK
	DroMWg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf0ke059s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 16:33:24 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ab27eb38d6so948059a91.2
        for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 09:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792600404; x=1793205204; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5S0gFGL7jUhkinHTL4yVeHOzYpusQ3d8V09xofjMzsw=;
        b=NUmJEvstuVXE/tFZM2esXmuv3658YshInDdySPbrRF3yWviKEdk0fOMWFJAkCexFb1
         /zokv5p0CPry3SeWu3Prxvcmv2qZgDT4IK3A2By04GvL6SdhHDW2H2UBzMWbUMVVF9z0
         k53jxv6Qwt/j+0PrPmrxMtlEmqNG9UCMJBM8X9+esboLh6Xs8PRYprzgsS2w67CGcGjS
         oX+f13kUk+taAl/Klgo+b5SDplOcLjj5kOEK6tONmQ+oLIcUrikm30dMmA+Wt1xcPw8I
         AG6LILRXd4RgRW4JLbJN0sddoSipHTJ/bfNJubKWZfcfcfnyUxQCWLuCLb6wYoCJi8R+
         9rqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792600404; x=1793205204;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5S0gFGL7jUhkinHTL4yVeHOzYpusQ3d8V09xofjMzsw=;
        b=0syjJ5Fzwgo76wx6slfUJfaE18x03Gxf/vQhb3WfoOfs1NAVjwAHg6HoxZ2xw9tzTR
         ABOL7+56kAcN4uUGiDEMdrHBjmwYGy3HCqGi6etocjuZemhB9xoPyVWkqUT24XtUZZb0
         9ay+bxpLLMfoN3JQ5C1RluVvks3Gs42ZEi3+7VLsf8PvVRcXwc4JdolMpmWuHu3qgln7
         dgA+Pr9iEs+csY4+xmcbTksf/bag2pQ8pgsvhrXlC/4gTHYHToJk7NZ55wFT3kZhulyZ
         ESuPSM9AWBNVojArzRvkPEc5wHJcU8913D4go9pqTBJoJg8oK1Y6DPpagBqu3H9v98kF
         GlyA==
X-Forwarded-Encrypted: i=1; AKwUvBwPIryGG4PNeB9jxvAGnzIzq3+Bq7aozFVvuBl2V5s46eLsVa8tjS9T7ZYqgBVLCEbOc4J2mYEgn00=@vger.kernel.org
X-Gm-Message-State: AFq9FYJT2ZU+ad6WE1NI952YB6gdwIZXd4Df+SawTtJCO1vZF0Mww4QM
	JheSFztrBV3A89IyRYdLcQxU76hO3X71JfuZwTmbbzP3oONnFhrl4qocbuGh4HIX79fpNSmzbNj
	FFe2iLigkRh3OfIn4XzT5rJwEsnqDvN8xLfRxIvyoc4/9DgKgzhaoB9bj65bkrVE=
X-Gm-Gg: AYBFou0rpOd8ufWNb7IMv/MgMeRfINtyznnD7JOgS3x4PRWqrik8PdIP3lX7jwrmJ8m
	9GG1wgm+jeeoc5SUi2XuPzUK5on2or0vxKzl/CD565WI8xkLEiqQ84hM+IJDdUhE37ebTQ0gw/B
	o72DzzI4G4BfmDncR6/Hp9lI3zXlCZI98mKgFCWPZAcTxkgD55tqwiFMbjaAkaAKIZcue4rPTEM
	qKfuc1rAPoDvIA0zyEv6mBleVfPg8ebLsvYlIU3MV2UOvdq1ZngcSVEzVy8gogyP5ZzIInKOPVa
	4DpF+xmuMy2ogVSoWmbbIkTZsdV/FATv3R6y8F+T9nyA1xpbTf6zMPJIoshwt2IsmBL78giwF/a
	K4+1DbSsO9Em/u6iteoBwUnGz+DC+Kn/TSyho0UxG8A==
X-Received: by 2002:a17:90b:5688:b0:3ac:b185:fa16 with SMTP id 98e67ed59e1d1-3ad86ef57d3mr2257171a91.43.1792600403611;
        Wed, 21 Oct 2026 09:33:23 -0700 (PDT)
X-Received: by 2002:a17:90b:5688:b0:3ac:b185:fa16 with SMTP id 98e67ed59e1d1-3ad86ef57d3mr2257139a91.43.1792600403107;
        Wed, 21 Oct 2026 09:33:23 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea4005a7c1sm11891595ad.71.2026.10.21.09.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:33:22 -0700 (PDT)
Date: Wed, 21 Oct 2026 09:33:16 -0700
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
Subject: Re: [PATCH v2 06/15] efi/zboot: Lift efi_cache_sync_image() from
 efi_zboot_decompress()
Message-ID: <20261021093316.0000594b@oss.qualcomm.com>
In-Reply-To: <6-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<6-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
X-Proofpoint-GUID: yAIBlJS0BlHllVEiQwP7AQOsxmOVPEZY
X-Proofpoint-ORIG-GUID: yAIBlJS0BlHllVEiQwP7AQOsxmOVPEZY
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2NSBTYWx0ZWRfX7tPbrVO4Gy+N
 172P9IkEG7u5eeN7Jg49DDyWM7Qmo4bU2BTvymm/gRNnRmuTHAKuat29JI290NVeGfZGonGPH3j
 A1TA3CJlP7ZttMvW2IBgk2QjI3y6FBQ=
X-Authority-Analysis: v=2.4 cv=KOzPn1Fo c=1 sm=1 tr=0 ts=6ad8e954 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=Ikd4Dj_1AAAA:8 a=EUspDBNiAAAA:8 a=w7afb6Jpyl5axNu8_tQA:9 a=CjuIK1q_8ugA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2NSBTYWx0ZWRfX7nx27XSfq+5z
 ERWbD+soZAW/McCf0CM+kz4kLbyArOhsNH0kFd6WWgwT+wk3PDAuhShvhCu+98KWbfLeozBekh/
 UyPhLlYojDIGJQleeBlUG3NTZ7GCDpmzWeePfqwSLJoCb8/aDijTWxZKxSwCuyH/MW9xMF7zHU8
 IA1Z7QKH1l9UAvMratc2rMIN6MrtqVbWL3PozNng48luC3+SGQbCCClBCTzmkrZj4HgpUEgmBZR
 1wd7FYGCNEGkNu7L0iCqrzRaZ5PKSUz1UDYBFHYFTdzqzsykdsj2ny5Nb5GBvggpgZYvG3XsXFG
 AQ8df+5lD4eUga0uZ7Ohggj2OcnCWx9F+dMj8l4bWc+lMdgBuxfULc+OCUUUDbE8yDWrygLJK9n
 GMWFbhHqpkp2SUTYUOEZYsYld5vqfZm8EaYciOZyMwByoStvkL5LywreI+YOxu08b7L7ZnVQZ0d
 RYT0r5x+bselzZJhx4Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210065

On Fri,  2 Oct 2026 20:31:43 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The two decompressors duplicate this call and the next patch needs to
> change the argument. Hoist it up to remove the duplication.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Some mutterings below, but I couldn't come up with a better code
style, so

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

> diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
> index 4b76f74c56dae0..e3abaa05fc4183 100644
> --- a/drivers/firmware/efi/libstub/zboot.c
> +++ b/drivers/firmware/efi/libstub/zboot.c
> @@ -92,9 +92,11 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
>  	}
>  
>  	// Decompress the payload into the newly allocated buffer
> -	status = efi_zboot_decompress((void *)image_base, alloc_size) ?:
> -	         efi_stub_common(handle, image, image_base, cmdline_ptr);
> -
> +	status = efi_zboot_decompress((void *)image_base, alloc_size);
> +	if (status == EFI_SUCCESS) {
> +		efi_cache_sync_image(image_base, alloc_size);
> +		status = efi_stub_common(handle, image, image_base, cmdline_ptr);

A little ugly though less so than original code with that implicit assumption
of EFI_SUCCCESS == 0 that is avoided in most the rest of this code.
__free magic would be complex given the need to provide the size and hence
we are down to a helper.  Ok. Maybe just not worth the effort given how small
the code is.

> +	}
>  	efi_free(alloc_size, image_base);
>  	return status;
>  }

