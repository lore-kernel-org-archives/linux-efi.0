Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51412F12AE
	for <linux-efi@vger.kernel.org>; Tue, 16 Jun 2026 04:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781584188; cv=pass; b=jOZOKOX9WvJEMYCbrpZ3yoKdoh3FPJhpsAZMFZS6w19tVIU9ZF1hwxS98NHQwxd6AaGLMWqrj6DOo0LYDAzLFvGpttJbCZJFubIkzbrDPLXBVJaYRxR9XSN7cmwrZC8vIeyhCZyKWtnJmhZCSI0l2zFn9hoP9vC5H8Yq7X2YteY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781584188; c=relaxed/simple;
	bh=G/Z1inyDCMAl7p2lEjznxt2Xge/0eiWaPfYQIShw7uY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ckiazRe8x74yKKcw0RhkD/9RZU/Rm5uz0lj4KA4CpqpFyeNnT0uuRT/ueLb6//3Zg8+HKqcDsSuIfnkLiBOOTE+SgzFPbPOwZ6SNtgZ92X1ZqbqScLrCmVxfmaPHITPNSXXJOUL3IAldp1UTu+7pLPd6Ztvzsn3/HDC3nkcHPpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CHXtK9dr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=B6+drhKn; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CHXtK9dr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="B6+drhKn"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65G1xh5G1790430
	for <linux-efi@vger.kernel.org>; Tue, 16 Jun 2026 04:29:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=uiSbxUJEm3aTACH1EONHBj8VwUud/W9+7fe3ejBUM84=; b=CH
	XtK9dremQVIChyCZsSd0DouORbk7d6dzThY/OxKgbxVEdEt2RPO2S/bbdTnd05+p
	oE4KTXvlpjfKr2cEbKffSpAUXmwNB3U2hw9Sg823cO0+0luq6ObHu2M+4+6E2b04
	2VThF4LeFvbl/MzpGrQ958bcOR03g0ZoZHtQb8OQn79BE5fTLqnHNf2sEQh9EAXT
	ocnh2jmCps8yxHbzccOxU6xgvaW1qDbC7Q0qf9PmETlEi/1slCjD5Zw3BsjzmjNY
	+fnhn4xQiVoooRGcr5ru5FXM9proradETUjFzMho/UUZjEA7riW/zNWtxv0/MQci
	HSjwDJJFxfCdu9TnjByg==
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4etew0mr8t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Tue, 16 Jun 2026 04:29:46 +0000 (GMT)
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7efd3991826so44099717b3.0
        for <linux-efi@vger.kernel.org>; Mon, 15 Jun 2026 21:29:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781584185; cv=none;
        d=google.com; s=arc-20240605;
        b=BFe1q4480R2ld4xUAPb1UlXtoSjj3w9Nw78VwvYOnhhJhGN+3aPDWUVSsShN2ONuk6
         eRw8sOVIA32lXOrfv75lniMRdLmcz2wag7sBTDQIXeaQgZXLhXf+uod3vVcBU7gMPBLa
         lHct5UbcKEPZcm0iAumf8spfekgGIvuCXShNwA5pzoyyIbGmmhriKrgcJQC4p8Nb35MX
         K1MQpEbYXb2vnTsNNrHQa5mHHYvVbyNLjA7wG3fuyutBkANfQvRSn9t53k04Lku0qWhM
         f9KmbAUGrg6HoSxYsUH/cp6K+Krz6F8+FpDdrCMG2xW0rW9jAY8JQIFHmoL6WWnmHGaM
         zHCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=uiSbxUJEm3aTACH1EONHBj8VwUud/W9+7fe3ejBUM84=;
        fh=hF/k2EGznLEROcApfE+u08G8EcLNBGu5y+ZQhJgx7G8=;
        b=GwW+z5lKyQgq1S4a2yIfRBfxLVhJkldorYDPle5GZt0cBrrj93RZG50cfbhUOBOteg
         33Og/cvT01qjCds8I6/o1LQ+UqSG00exyNsg4F/PSST5BtyFWaq8nOkq6EcSa+nWXRzs
         dTqIjb5QMp2XRnaJlU8kRpK1BjceW8e4pKmcJz/lTSXBd9XqVRrcfTAqh80xnf2/9M7r
         9DoXSbF415Wz1+rEXz8kVxxq+XvNyY0wAvu8Q7AStvlO83F1QCuhL2pbVzcyad7xGHuV
         j7vetlgTgikpyW/99+x4DmFzzxuBCYXu/lMmPGY6z+l6OWsbUx2djDW4Og3s5j2Q8Jk6
         wQdQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781584185; x=1782188985; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uiSbxUJEm3aTACH1EONHBj8VwUud/W9+7fe3ejBUM84=;
        b=B6+drhKnjxBC0IE0nbAdTPV5zOsIQGAKO2o1vBNZqD1/T19D2aAUA9ZdcnU0CLBeF/
         FFfifOQ/H0pltckvXklGLZ52zao8kXXhELACTnxyY7Xxbea6y8CUksl6kcCC4RwZHNXu
         eAb5MtZxVyd3gmHQ0XNuPIYuoO0duliRJItzwe2sYbmkUPqgEuHDV0f4oiNzmw+okf8h
         7NVNimh14y3beGsZwLbE2p5JY7VzhyZGM68U7/3W8RxxYJzP8w8vIUuNfyBROoBFFf7U
         6k1Oj4RIddEth6oTGMII7irBptTcHqCngm9SbGV3KPpk3TrWZiIl0vV+OEulET5LDQ3k
         dZbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781584185; x=1782188985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uiSbxUJEm3aTACH1EONHBj8VwUud/W9+7fe3ejBUM84=;
        b=YauOwdyjZfQWR2pAzJEt6kbFDzGHd50a2S+n0SALV42FBlwSHuDfQ9lDp1mqmcWDg4
         jmkUZkY/RimoL3q9LBVwHG8f/oqJVE2AKWA3NOL1VX4np2kN12VDPOVSFd4WUWQyKPPj
         wNEGx3EbQjPgLAIEt/dCQn5y6WsXePT31X5O4WVnoZjv17xGEUWYFa1Pwj75nBLRN5CT
         FN6X01J0oEIsO+GwRkEHPu1+AadM4pq4xl+8QFEguRov0Wm7+a1zbLl5I5K7D7rA1u9W
         kd+EvKzXRtZo+danYvkiMCGolotVnaO2VyK6YvcVAAePbu6VRRVlE5ejEAsqBSaqmL11
         fX5w==
X-Forwarded-Encrypted: i=1; AFNElJ80fEk50CoxOV7gxdPXe4nQmlbbGC7/flyKq3VKX0PXXrH3+xf0FmHBxFmBOqrXm7AC5+qneqLUXeU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNQPk9QSLFFrpMsxML4jJ17j/vVrVn3kmh5e3TDZ3TPqOYxquK
	yjnQylUgDFrw2i2XHunSZH2+aBvoyaUC1OZRRwoEbQry7fqKYroWR+SQa9h9J8y6dXPiFGRABAu
	hwhCzLEwqKB9A03D/N7gpvezKjWMYFbMZ2odtaHZwIgI+3NkOgxppVS3zv7dVNZAY7JXvnl3qva
	GINPJ7+rZ7LdF1KOTyvlve3t7iJ+4kYSnLF8XWVQ==
X-Gm-Gg: Acq92OGTJ+HGms9E/Tfm6lUKNytsZiDpQRMAUfE7FsOE8qBDR/7kA9pQFdprT4M00CK
	Ic1mkNh5miCwLghenzb7hGTGAHbfNyYdRQsxnvYbNGFd11dCr7p+JVqL9d+xGIOoYHhvnikfS+z
	30Qabxi7E+GbTzh/KFNBUsJCkim1VLm71cyXjR+mpE6xK7I3VgV/0HfnuCHVP9G0x8J1rpsPsMC
	rwR2g+0
X-Received: by 2002:a05:690c:6f0f:b0:7dc:61c7:5919 with SMTP id 00721157ae682-7f7b85260c8mr159907287b3.37.1781584185113;
        Mon, 15 Jun 2026 21:29:45 -0700 (PDT)
X-Received: by 2002:a05:690c:6f0f:b0:7dc:61c7:5919 with SMTP id
 00721157ae682-7f7b85260c8mr159907127b3.37.1781584184746; Mon, 15 Jun 2026
 21:29:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260615-efi_reset_shutdown-v1-0-9414edcbbab0@meta.com> <20260615-efi_reset_shutdown-v1-2-9414edcbbab0@meta.com>
In-Reply-To: <20260615-efi_reset_shutdown-v1-2-9414edcbbab0@meta.com>
Reply-To: sunilvl@oss.qualcomm.com
From: Sunil V L <sunilvl@oss.qualcomm.com>
Date: Tue, 16 Jun 2026 09:59:33 +0530
X-Gm-Features: AVVi8CcNRoHNlbuFDJquTotPLHdD45hKeD4LKVXtIQwwoO7UFjJZNufPU49TWgw
Message-ID: <CAB19ukEZhGc=4mi2D1e3FxZdJ_yENGt_=B+2R+3WDkxtT+xmYw@mail.gmail.com>
Subject: Re: [PATCH 2/2] riscv: Restart via EFI runtime services when available
To: Atish Patra <atish.patra@linux.dev>
Cc: Ard Biesheuvel <ardb@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
        linux-efi@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Atish Patra <atishp@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDA0MSBTYWx0ZWRfX9hzT/je94KRh
 MdR6vcpp/VYwyOSRyOVjHtI/37RE4+ZC2zhUxg90bl7q17HzVnsa+TmfNsctCm0eObhQ1dDcDZ5
 gfW0oBUQjILz0E7OGafbW84fcnJu+7Y=
X-Authority-Analysis: v=2.4 cv=QLlYgALL c=1 sm=1 tr=0 ts=6a30d13a cx=c_pps
 a=72HoHk1woDtn7btP4rdmlg==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=YMgV9FUhrdKAYTUUvYB2:22 a=VabnemYjAAAA:8 a=EUspDBNiAAAA:8
 a=Vwtfa9UIybZDa4ZHMzYA:9 a=QEXdDO2ut3YA:10 a=kA6IBgd4cpdPkAWqgNAz:22
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDA0MSBTYWx0ZWRfX7lM+tyYEuNIP
 zP+Ki8BuGYY3NICffCgMF0jzhOJ9l7RL2qX4FIlC3M96d3flSJ1UbcGlXPeC0Yx/DSp5CMwpOAQ
 xIfs+vlghgcLYTnJlbYt+kMfpxLsU6pkc5jJmCF4VifaL53+Qkx9ZXC4l/IY69YPwlW/bn6X2iU
 I08DsqAtH3N1KBOdh6NLCAglTFV5DXEebHugZwNu0BIgCpMTbTZ8O2IF7suHg53vVB0e+r6VfcR
 3sQSgQKMH7/tjBpZUgywVlkQlVAwWpPLeTYYnNq7vxP/tcIEUydPZfqTh3dosR9e7zPyuQwMF2b
 UTak7zvOyljKY27VaqR+z8N7p9U45mAXK8ZVXuOBZz02PJEM6TLttO6JlOuxrq8poKWWr7m3Ia/
 8XOg9gE4Nf2mJFLRK3VrUghETHK20UXHdEi2DsDErm+NrpkosYJ4eAyO7nn+ptvamwuQF+tCCKS
 ZcmLlEVMN9cCEc373vg==
X-Proofpoint-GUID: u-BW5Wh16tOZccogfUWZN_snPYH4MMug
X-Proofpoint-ORIG-GUID: u-BW5Wh16tOZccogfUWZN_snPYH4MMug
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_01,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606160041

On Tue, Jun 16, 2026 at 4:59=E2=80=AFAM Atish Patra <atish.patra@linux.dev>=
 wrote:
>
> From: Atish Patra <atishp@meta.com>
>
> Firmware-preferred reset and EFI capsule update support requires reset
> via EFI runtime services rather than direction M-mode firmware invocation
> via SBI. Unlike poweroff, restart mechanism is directly controlled from
> machine_restart function though.
>
> Prefer the EFI runtime ResetSystem() service for restart when UEFI
> runtime services are available.
>
> Signed-off-by: Atish Patra <atishp@meta.com>
> ---
>  arch/riscv/kernel/reset.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/riscv/kernel/reset.c b/arch/riscv/kernel/reset.c
> index 912288572226..541e2162c85a 100644
> --- a/arch/riscv/kernel/reset.c
> +++ b/arch/riscv/kernel/reset.c
> @@ -3,6 +3,7 @@
>   * Copyright (C) 2012 Regents of the University of California
>   */
>
> +#include <linux/efi.h>
>  #include <linux/reboot.h>
>  #include <linux/pm.h>
>
> @@ -17,6 +18,12 @@ EXPORT_SYMBOL(pm_power_off);
>
>  void machine_restart(char *cmd)
>  {
> +       /*
> +        * UpdateCapsule() depends on the system being reset via ResetSys=
tem().
> +        */
> +       if (efi_enabled(EFI_RUNTIME_SERVICES))
> +               efi_reboot(reboot_mode, NULL);
> +
>         do_kernel_restart(cmd);
>         while (1);
>  }
>
LGTM.
Reviewed-by: Sunil V L <sunilvl@oss.qualcomm.com>
