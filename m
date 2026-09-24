Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2E03BCD21
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 22:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290149; cv=none; b=pe5j7ZdF9runWWa5q1Ayq9x6ALPgUl0/FFup4cAb2agcrBjhIKjPuJdyYLKmPpvjEIn6dVHYk+/cPeHx3gUNJ9GqQzVicISInqLwiXB9NpOpxbqoqkAf/2KME7AH3wjuuF2R9qoPOdOlIUQA27FQGkXRSIU4xHLfXqwQizOtCeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290149; c=relaxed/simple;
	bh=EsE+bP4ImbF198tRF/p/BEO5nlCx3+LrGeUaFu0gIWU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m6M73dLVNpAcZs1Fa+CrPRKhS6f/wjom3rXt21+YXf0LUmF5egU4Ui9OfdUtFB1OEhMLEume7vZagxJc/MjEYe5eWg3695Rdzz3tGTyT3U7EilG85UrYTwJaFwhxewzLbh8Zy1yTDJlpjjOOQsWITUOcqbO2zXIATCk2cXsuCQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UnwyqbzY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TE/W4E2Y; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UnwyqbzY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TE/W4E2Y"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OMOo8j2766698
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 22:49:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oo8YGRfyp+kAVxf53tgrQWeKF/gkFQ1vpq3RnEKr7OY=; b=UnwyqbzYYs+KvHQI
	pdaCx1jtw5ZY0g35b3TDHY1cZfUiyOOybRzb2dGrJpMmxlONRNVSQrHCIK6+AoC7
	QnvuyVkfsbutTtg/yDMfBQUkcTg+g9F3yaain8P0Plp1XMrZxMEFtivmZwU0CQSe
	ofHBo1aKp2Fj7gieTJXChc0guhXjz78g5/YQm8yV6jdF4DVlAjn/ZKGezuK1U1zf
	EgGFGjtO6diq8oxU1+jfEQZtkOeEUAA1QQjM+IUboDFRrPF9yqUpJATk3M3VjNOY
	A8FRKURil3a5aaVAiLtj8asDhAlxSaEDtDqf0iqQI5xndVjM8Dveu39DfcoA+QTX
	4xyL3w==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw94k8u4u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 22:49:07 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30c0d568830so506408eec.1
        for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 15:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790290147; x=1790894947; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=oo8YGRfyp+kAVxf53tgrQWeKF/gkFQ1vpq3RnEKr7OY=;
        b=TE/W4E2YA7DdQDjtoKa9Ohy5kUi+xAKvSnseMcMtfdSdbuoPntoIv73orzyxWN4IuC
         2oePRdpPasRiq6vVsCfUbvmsX2alW+qlKKX0UKAX89xkaWkb0KhGwesg2bQuV15mUiZV
         U2KpG4683JUoUkaXslkWhxiLu2r2Lh1CUKo+LPzK756B6CRK28mQsWOX4r5+PV3v73zw
         sI25zXrD+7mkZw05ruaX+DWfies/8zF5Pgr72KoohmGqNLICIVEvNz0tLj85efg6EmvC
         CiYpSFon1t0TmqgQxUDzlKxZ/q/X30MN8Zgc5bl05DNJYB2dvA8lm0jlnRGzcFXobNGl
         XvaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790290147; x=1790894947;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oo8YGRfyp+kAVxf53tgrQWeKF/gkFQ1vpq3RnEKr7OY=;
        b=Avua/goBs/lFu4CC/czcw40krlt35tfsKTIcc8gtCb8w5C/4NzSg3dFvgaoc7FSr3C
         P6LgqrHvNntXfW+ANLsCt/KTIjYCa+XCWg1wt1fB4G9rtvFmvsWDi5sGnUv1ZaP51fvt
         Y1uLtVK+Usca7OyhnWVkPGlIo5/xza+skD0tG7oJ612T10YkhpRyQm6+3bQptHgaOmEg
         BwWGvJgZDAxKfjb1PQJX6QFZtJp+UEKh2KdkYpSsYPi3o1u6L1afRuby63ORi4u6ecAW
         a7mPTFQpqcsG7zKrZtUlx5PxfFxdHC2Fs6f8O/ozS+mwS8mVY+zAse1OZGTN/nnYwgE2
         p0Wg==
X-Forwarded-Encrypted: i=1; AKwUvBzSXz4bbmgaSlc3BOeFjWTtA6hDdqi5Buji/Xh1rFErHWQ6Z1DeKSQrxw1PZ8S/i2yaEyZuDmUn09U=@vger.kernel.org
X-Gm-Message-State: AFuF++ksFVSCEKljew+oblnixQ1qjDrf0Ud0BuhVhcJG9SaSSbXWHLlq
	SFef8gwCkZAXOUT2XsYiWDeUvNfG4B7yTalsQiVOWKi86AysvZgorSCsYESMf1f5oBxCO7a4rzv
	FDAUoF7wYjZFNS/xQ7dP/Itczz7bHaddrfyZ2dufLY0l5q15HSmCZmS+8SUOlKWo=
X-Gm-Gg: AYBFou0kGkenKS0gZeh51L8AzbukpHse/Ddw0AvlY/dj7j5H5diyIVVUs2VRS8tsK4v
	NFuZ1kkpPaNa4lT79AAcDHKB1+3aEjwp4goNIuk8cN306tCwPv67JaJRxS8gQ1/2vUIQx/aFJi0
	mY6Z0a7FVi1s10I721XJpUKD3yujKyfK18fkxNhZqV5pLB/lAFu8G1Uvxj57tkTwWmBkNkS5Ryy
	t8QyHA9L4p5obzh+8Joy1zoHYI+Ynid5CrVV9epKpolP8szljhiox7B8Dq9OfRIJQrohN8eurXQ
	c0aEBUb0DYek65oJCdV3dlYOEl3UmJQs5yliRpeJQ70EaoqIFC0zHT/BgK7wDzgomkF1LPX0Gst
	12pXIGIsDWdAzlniGSayCobXkPWJvzldbeH9Qis1VnwwtZGPZ0d3S2g==
X-Received: by 2002:a05:7301:8614:b0:33b:dcbc:6046 with SMTP id 5a478bee46e88-33ffe341a5fmr3054545eec.7.1790290146789;
        Thu, 24 Sep 2026 15:49:06 -0700 (PDT)
X-Received: by 2002:a05:7301:8614:b0:33b:dcbc:6046 with SMTP id 5a478bee46e88-33ffe341a5fmr3054509eec.7.1790290146115;
        Thu, 24 Sep 2026 15:49:06 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3414407d18fsm1417100eec.10.2026.09.24.15.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:49:05 -0700 (PDT)
Date: Thu, 24 Sep 2026 15:49:02 -0700
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
Subject: Re: [PATCH 03/16] efi/libstub: Free cmdline_ptr in efi_pe_entry
Message-ID: <20260924154902.0000528b@oss.qualcomm.com>
In-Reply-To: <3-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
	<3-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
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
X-Authority-Analysis: v=2.4 cv=aaj0Dhot c=1 sm=1 tr=0 ts=6ab5a8e3 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=Ikd4Dj_1AAAA:8 a=xhtQj0KKqAk-GveBB2QA:9 a=CjuIK1q_8ugA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: FZeI_MqpijieHedkWzmES3TeZ95ry4yx
X-Proofpoint-ORIG-GUID: FZeI_MqpijieHedkWzmES3TeZ95ry4yx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA5MyBTYWx0ZWRfX91PUL/0jHa3C
 JgLuhinW0FeuW8Cjpaxfk9wKS/SC40W0iQ3mdMhgVZSLoGvRN1UybCQ+OF10H0FoKTZ5ciT/Rt3
 Oz9ZHJ4I0dCYxsGw88cg6wzeoAv+PvKAqAOkvPkdYpdqv45HyzjqGWctpAZQDbDAXfQgcmfAnhd
 5FC8ZjLjrVvrpBrd+C8VvGHIPiHnMbd3aqntzjSqSvqUzF7BpflCCNvnLXXnXeFpocRdeHdiUdT
 /6YM0zZyvLFDe3bTep47aZ/5abV8HfGI0VxyVKbTKySlvbQcxFPu9tyqAucd6nEemIlaHs/vJRs
 YdyGnLGqv9Viy95VSZl+Ndvk21zBUlo2o119ruUluFq8kluSByFoHQ0Av45L7bTqtXmONkdNI3j
 hBHTVcRRlIbFswAHNBw6mxfVJlieCbIB0JW6+WmTel7/mDyvScw/fp5Ht4TpADq9CRUdOgkB56d
 f2fcMRWriDpLp8gh/3w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA5MyBTYWx0ZWRfX4PSo8Lwo3RCn
 eeXRihbJaoQk22W2CFzKVS/r2AQvCPJpM6UNReivEEjNSqSXaEZuS5Z6krsFZ6B0jaODLtXQn2E
 ryf8cREAxEWaQPNOzxdFr+3g6zROKnw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 priorityscore=1501 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240093

On Thu, 24 Sep 2026 10:53:06 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Sashiko points out that efi_handle_cmdline() allocates this memory and
> hands it over to the caller. If efi_pe_entry() ever returns it should be
> freed. Add a __free annotation.
> 
> Fixes: 42c8ea3dca09 ("efi: libstub: Factor out EFI stub entrypoint into separate file")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/firmware/efi/libstub/efi-stub-entry.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
> index aa85e910fe595e..83fade2b0d3b84 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-entry.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
> @@ -40,7 +40,7 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
>  	unsigned long image_addr;
>  	unsigned long image_size = 0;
>  	/* addr/point and size pairs for memory management*/
> -	char *cmdline_ptr = NULL;
> +	char *cmdline_ptr __free(efi_pool) = NULL;

Can we move this down to just above the call to efi_handle_cmdline that
does the constructor side of this?

I see none of the efi stuff follow those guidance note that went in cleanup.h.

Ah well, not my problem :)

J

>  	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
>  	unsigned long reserve_addr = 0;
>  	unsigned long reserve_size = 0;

