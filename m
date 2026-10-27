Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793079141;
	b=fB6ZThRzVVKIVaGtSCbWdYv7sspxtxetDJe0LGxbC853zGViwLYWRVDKJXPaq57S8wUL
	 pwOhDwKZy32L4R+P4jp+gcbmknNqpdwTM4vScdZTQGmE1LDdC4J1fT0Zwlo2nF5UCpeDh
	 MfiELQw31Rte1ttYwd17lKbezCB07FOVkyGis2skB2vD5nlZBhUP1HrEyRz+lfFRRFov/
	 vcBdMiW4QsEDrRdY1McxM5K1AkhgvulSKCOaNFpf1+xq3FxXvvofXI1ynwnQzqKWfwW/Y
	 tC9zR/Gn3ZNmxMMB3m8rbx80ZsyI4eKMaS+ktz4FjtkalP8Qv233vuKjedwmhHdrhRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793079141;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=VpHSucyNN1LDa5ApCaatg77B1Q+sqWuq080vIR/b0Fs=;
	b=dx6VTkdkE4XHMKQo7+E4jEpLl8CJGIEsQyk8da568Y8xa2wmL2v8K0aAlofSJfcPf5dl
	 rp9/rwrXs8oagh3TIyEaQlkCzkwrgDB3gr/BgGhNnHw+fZn28smMMi3LXHIwx+LCD2bUZ
	 SaXbN306+/e6ewrYF+sDQ8c94Ru+9T9zKxuEjKa/mSzZtQTzMVhl/SSkevUacMpGtzj3/
	 QdjvikAKgiAb8dthImlbh3ZCH4bcfIHsxBcHAKfNgIRiIGLqbISd9WKO/hDVbV7Yt72oc
	 eXUInuFOO+Fc0Ohje1jVV/dhiP6rCUisK9SElqqs8VSv283VO4BGiUB7xOlLBKFefXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=S5u+X6ID;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=B9UMs+0B;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC55C606A31F
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 05:32:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC55C606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=S5u+X6ID;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=B9UMs+0B
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69R2F3rF831794
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 05:32:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=VpHSucyNN1LDa5ApCaatg77B
	1Q+sqWuq080vIR/b0Fs=; b=S5u+X6IDdAqSFMJ/sWFXego0TywOvH3i2WaDBwXL
	mfDX8VulUGbMrrfYuEcCZ1izjFgzaIrtWd9yxtNA0qeqD7VOsM4ia5hN2HGXcOml
	uTQb9ugVR7xpwkYbLrCl6fiksvHkkO3Dd5ubaWPUyuxgkBtpIiw/h/Di7Lbko6as
	j/UPCPe3ww0utvfbRS54B5/lukNbt4BfwSkRCc6Yr4gmm9g2ggWG1idnUE+APZtG
	OHifiAhrl9MpdF6EFICaQa9Ufp7aMytkMHUCmcpLhjgnZvisX5hrbi6HSsSRWE25
	AksywJxYyO7jNCA0Y1dQSI6nbsRFx2rf/pb1AFANpAhyqQ==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hjfavs7y5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Tue, 27 Oct 2026 05:32:19 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-147be78cd56so2087380c88.1
        for <linux-efi@vger.kernel.org>; Mon, 26 Oct 2026 22:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793079138; x=1793683938; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VpHSucyNN1LDa5ApCaatg77B1Q+sqWuq080vIR/b0Fs=;
        b=B9UMs+0B8D78gQ0EP5zw1u1E7FVMWKillt4uKMDqQRz7gO0OUl6xWcNVMLf5kpmIWx
         STCUj9slKUYmgsmnnea/NcWnf7bsh5aF8J/jnBdZ8agD5V2JLHc9EVs70qnHXqtqD+FJ
         Ok8oAFh5h5DaQiFGXZs668+omhwGyXXzG2mhZM2fOqepBJFHoz6N5DNFoTDPDLKeAuvh
         IudcrLScDtaLD1vObg3Pedj13ptsDrALh7tDqmSNmORcyqZ2xSj7TiddhjorXEdc9L0g
         27jZZ8w5JhkLsXO5XKq3gHGlJ6t6tDCpMd7gWVuHuQ7ieY+JtJ6ogip+/8Q4oVI8vwuW
         T67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793079138; x=1793683938;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VpHSucyNN1LDa5ApCaatg77B1Q+sqWuq080vIR/b0Fs=;
        b=sINR/FEEJ5zZeFy2GdnRQjNJ0CxbbhPTFmb5jMvPE4V/XvFQ9rrPW+Nr/lc725Qxza
         RBbyW3slYF+Dqsd3kPNisgVYJ51/ffw581Z4kbw3kIP5RsfZqDs2fZh54AvmiyCkGBnL
         aCuTQmeZLhkNPGgQdUwEpa6u62PYDEBv3IXdPiZXAvStt3g6C4tnnXx8aeiu3c+68DSO
         SWZdGy3YH+TpytA8w+OSOaYZ08q1NU5Y2H+bLeZW3P9sCjLR4wK5cfvzyhAhMjUgOU3J
         Ife3YD8YTQAyxZRq5NdvbQNhyHkXpxn7mXiP4VNVWPQ4X+RoG8Or/NNIwcGKzHJpzEPE
         q8iA==
X-Forwarded-Encrypted: i=1; AKwUvBzJvp9vqVakg2a7loQHlYtvSJtvJ2KpSMsJ8V0Bqw7QFoerJg3IfFoVYKItDVSiiQxABFun4HlQ4q4=@vger.kernel.org
X-Gm-Message-State: AFq9FYKSdWVcpopSThBoha4/SvV9j0lQnIpTVjQIYiPiL2L2hQrJulOv
	m7iwkRrlTn1QO3nrkSIxLVNnjBj7NQKll7hR4VW0x6yTu0kZMvsC3jEOuFIYPgyxE1sAbPjL1E0
	7+B/9jjoYUzqoXQSRrcp8Rrzy52V9DbpTuERj2aaNZXZ7ZQoTvfVck34+yxRLl2g=
X-Gm-Gg: AYBFou2gBOOuqzRqWma6T5hoCqlfm1I0dZOO073MkCBls8uAqPko2F5TOCk18d03esh
	bXcQWG5nB7trNOrL40zk3SwMeL8PMVTsDV3Zh/BbFhyshQCjuDZVoEQbwysLwN+5OQSOfoggD5b
	cymdq91CJMJQfx0y3spLai3vW8Y71gwY9HfOKDQl7rGFcwO0QFJ8b0CbB2t1/iBw4HRD9JBkFGt
	VcLX8w6Ys+nCrq2MYh/7etyrEK+Hjw2bQ1WIpLfvQnR4rNFlMGy6/5zVz6G1PIZr+9riczNyykL
	YhYj2X8pDq/evnW4lJl8Ero/rcneB5psQyA/Rqxi6m5m5XXmEzxRIZoH6kaTZyHb4499QygWTTs
	YJgsTd0Ow8FuBsCKlQjacjgDBx9fiZgKrlwJf1JBD0fggU/rKM/Xjbwp0OLqNOoUG1lV14Xy7Qh
	glAXbdW3m0qVEWRtElYLvNeQI=
X-Received: by 2002:a05:7022:68f:b0:1a4:c892:b130 with SMTP id a92af1059eb24-1a4c892b30emr987466c88.15.1793079138480;
        Mon, 26 Oct 2026 22:32:18 -0700 (PDT)
X-Received: by 2002:a05:7022:68f:b0:1a4:c892:b130 with SMTP id a92af1059eb24-1a4c892b30emr987444c88.15.1793079137877;
        Mon, 26 Oct 2026 22:32:17 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a37c88aasm27316225c88.23.2026.10.26.22.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 22:32:17 -0700 (PDT)
Date: Tue, 27 Oct 2026 11:02:09 +0530
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org,
        rafael@kernel.org
Cc: acpica-devel@lists.linux.dev, anup.patel@oss.qualcomm.com, ardb@kernel.org,
        conor@kernel.org, james.morse@arm.com, lenb@kernel.org,
        palmer@dabbelt.com, paul.walmsley@sifive.com, robert.moore@intel.com,
        sunilvl@oss.qualcomm.com, tony.luck@intel.com,
        zhangzhanpeng.jasper@bytedance.com
Subject: Re: [PATCH v5 3/9] Introduce a new HEST notification type for RISC-V
 SSE events.
Message-ID: <auA3WZf5rLlx4Lve@hu-himchau-blr.qualcomm.com>
References: <20260924073714.1650588-1-himanshu.chauhan@oss.qualcomm.com>
 <20260924073714.1650588-4-himanshu.chauhan@oss.qualcomm.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924073714.1650588-4-himanshu.chauhan@oss.qualcomm.com>
X-Proofpoint-GUID: lknfuy9CKOUJfQZF23JT4A3hjJ7WjN6y
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDAyMSBTYWx0ZWRfX++7qlTPhD+mc
 mUq6RoK4P77dus5FTCMcOgFU7coccQzUYhEBZcUCP+7zL9oQKmW6pDx6LZX9CMZolHJMJIDTcEj
 5S1sfQmG8KgURBqyaDrr1kCu4PU9p6k=
X-Authority-Analysis: v=2.4 cv=EIeTQFZC c=1 sm=1 tr=0 ts=6ae03763 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=NEAV23lmAAAA:8 a=EUspDBNiAAAA:8 a=wNwvQHF-ByPSNzcBtQ4A:9 a=CjuIK1q_8ugA:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-ORIG-GUID: lknfuy9CKOUJfQZF23JT4A3hjJ7WjN6y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDAyMSBTYWx0ZWRfX1Np1WqBCv/Lu
 qa/60F3FzN08jdi1ah0oPlAD+8BZIxGvzlCG4JFDMpWPpAObi0r059qD8YYAqgAmvw0KoGLTsxB
 1IBgTv9Lp/M5wZdv6F9S69BDZyfwopKW0KMDRoBWeRkpLThOUWd50gotMIRzV9cF2IlcU0KSJh0
 5sw11P+sH2yokn5fRb5yb4zLaY/e+7SPv9bthxFQBLxObLGRALhpr2mGRz1LttjlopEP5DNhSsQ
 EXtDvfLSNYKXux8z5x5CwDgYsBa0mP/yhNBPgLzfhMprB5WLPrEH6Kb3h+byYbfwwY73JMDT5n0
 M90sXsEDD6JIVKeMpfMZg0ijNF2OF6DQrhcPiZx0BL8OTVn2BJ7k+ow11QJMRORODemQayCZmh2
 bL5IqyXa6c8JjVvrtggsOqF+caNgN7OjPZjBiyL5ekK3F+rEWzPE9ZiY82LwiXcL7OC9lpsM+IR
 SM/TWZuFWdQJ7LnL3qg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610270021

On Thu, Sep 24, 2026 at 01:07:08PM +0530, Himanshu Chauhan wrote:
> The GHES entry's notification structure contains the notification
> to be used for a given error source. For error sources delivering
> events over SSE, it should contain the new SSE notification type.
> acpi: Introduce SSE in HEST notification types
> 
> ACPICA commit f73f39352c1170464afe812cc96b20cc9db1d822

Hi Rafael,

This is merged in ACPICA. Could you please pick it up for Linux kernel?
Once you do that I will drop this patch from here.

Regards
Himanshu

> 
> Link: https://github.com/open-acpica/acpica/commit/f73f3935
> Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
> ---
>  include/acpi/actbl1.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
> index d824838cb7af..105fd51f83ec 100644
> --- a/include/acpi/actbl1.h
> +++ b/include/acpi/actbl1.h
> @@ -1798,7 +1798,8 @@ enum acpi_hest_notify_types {
>  	ACPI_HEST_NOTIFY_SEI = 9,	/* ACPI 6.1 */
>  	ACPI_HEST_NOTIFY_GSIV = 10,	/* ACPI 6.1 */
>  	ACPI_HEST_NOTIFY_SOFTWARE_DELEGATED = 11,	/* ACPI 6.2 */
> -	ACPI_HEST_NOTIFY_RESERVED = 12	/* 12 and greater are reserved */
> +	ACPI_HEST_NOTIFY_SSE = 12, /* RISCV SSE */
> +	ACPI_HEST_NOTIFY_RESERVED = 13	/* 13 and greater are reserved */
>  };
>  
>  /* Values for config_write_enable bitfield above */
> -- 
> 2.43.0
> 
