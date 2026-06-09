Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBC5264A97
	for <linux-efi@vger.kernel.org>; Tue,  9 Jun 2026 14:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781015450; cv=pass; b=ZAXbsBPUu8TVeETm09E3PLsH23Byk3wq8WUoDX2sMD5prkS9kGk2sosMT9/NI1S6gWSLUjy2Zu01rELIr7suIS1riCls8yCcgX7P7NuNvCT7cqZX48o8HMEpRj0y3eCTgp1nAflQ9M3t6fuFY//0LzvCzoGteNs+OwLErBjR9v0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781015450; c=relaxed/simple;
	bh=qUt22HVRDHTLE/STP9WjivjbEVbcJJjbvLyeAgzpexw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Eu37L455Jg++j3RE4Argrk0c4d0QVtggVzUYxcRn6WgqCXMJyrnht3NDJrb6kCsES+A41Me8RVmvFe/qlwDw/aWNZQR1/IVsXTGgz6P9uIhBFMUhkPKtJ78nIwPkuu+hMyzJ5X6Cc/v4cnNGyl9RYPwZpsC9NZqitXE8zlC7OJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fthfLPGW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=e0PDP77l; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fthfLPGW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="e0PDP77l"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 659ClMJ8652219
	for <linux-efi@vger.kernel.org>; Tue, 9 Jun 2026 14:30:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=n2ZoTe9MZ9DLe7zQEw5ul/Iirw7q5Hetu2UB3w96zKw=; b=ft
	hfLPGWXHW1tH05MGW+QkewmxBy1Qv1V5JZ1bg1jJl3Rmo0OZAHZS1Ti6DGfbnuQq
	Wke6OSRaNbWX2DrJrThCm5nZmCBPypmaW6HFWWeYTaWJtSQ32r8hjLGBM0e4Ma74
	XvLousMzr7VkLfoUz15z1bjMeTNOieUtev0MsrKZ0qfswdGbnYV05JCa6Bym7IHa
	NF/S3WZR1NMkA64Kf/r172K7fuWMmaqpR4zdP3ZC77W6P1TBhLRm/HqFVa9kQFvl
	s+yrnow19Pd/K8omAHQN+8c/cbkR+0Ry6G2B8Ju1rWrJLqtcJTNXXLykt53TNjjM
	gpPW1Xu7r7+I4xexTORw==
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com [74.125.224.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4epf0ssquu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Tue, 09 Jun 2026 14:30:47 +0000 (GMT)
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-66043ac620fso4419421d50.3
        for <linux-efi@vger.kernel.org>; Tue, 09 Jun 2026 07:30:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781015447; cv=none;
        d=google.com; s=arc-20240605;
        b=bvA+pRDo+kiOurcZptUDwexG+kq12C6rlG10aSyGDn528Y7DZ6jX6wfDDY43pIIDLu
         2oVCnuFvwt/ZCtLGANPS/IwZdoRn2hvNx9/KCK9fnTSeQK78L2KBchhtpBwdTb3u1vzI
         s70dGMtUIGA2NaxIXSLOQzEFkSSLERcGmqhrL21QQk/UMMldW9MaC27SLubLHi5AkXhn
         R0sQ4rqZ9/gcxD1bdNnM8rJmQcwXANffu3g1THkNCwazzU1i8oFJL1wudI/Tczeg7I6j
         dsOoXo9TZF0WHn6JEWRf1ICns39tFwQjGbMmgY3pf7kXzOHaZtgfxIRIeixrV+300eV+
         zYnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=n2ZoTe9MZ9DLe7zQEw5ul/Iirw7q5Hetu2UB3w96zKw=;
        fh=sAiBNZdk90bgYnL3742I2E4ANKWfGkOMsZHbjXHkbhM=;
        b=ib5PiJcigStlZbGtZ9Ejd8qJhp6Sapo+CmviP6MAhpLTyeWdFLsZZ+SDCAedA85+dp
         ZTKZHKMym/f93AI0QgbTYaaCbvUF0WD5LDFF4zJNT082eghAYClRsJ3GLfnb7es5qhOW
         KndhE/MlRfB4768hiNL6VDEX16sV7BHp2Y0oYpUgH3Okf2oSY02ETMC9HYmbmpgavgw9
         FmR9+t3FykYGZWnWYfefjKuaurYfKDPUOcq927w8SOZBUFPhLAunNluQ6CBOzsvnCiZU
         khnKGH803yZkS8oetz3MyZHVf1KTGDHGD/Ug3i2ssLXFKYW8UEpE5Vkt1TiALd3KFT7B
         S4kQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781015447; x=1781620247; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n2ZoTe9MZ9DLe7zQEw5ul/Iirw7q5Hetu2UB3w96zKw=;
        b=e0PDP77lR9tEEee1MYxKClvGm2NSEDByKWoQUXDRo9R50HQ9QBE0wkTjJXxS3mqlv9
         F4QIt6HsFwtcP1mqFDetp+S/TFpJ0pDOb6A+hBv6xWdpJIPy8f/YbrEdBc3zHWMX2a4x
         Xbw3DY6kL2heJNH1yTlxPEBlIYzFW9khBL0PD15RT1vHUd4g9An1WqTl9o5GZPrKxBpi
         YssXUwCY97yTXAYK2eZ/1rYyq0urqHi7drOcu+1yz9nawz/NnER4ugyLZauGK/mJhjax
         kMPDOkC5yh6MFQggpB0eblHeXjDselEUF/hGdlzcZ9UuWuCvY6ABV13v6Lty0fTI7ki5
         VLEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781015447; x=1781620247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n2ZoTe9MZ9DLe7zQEw5ul/Iirw7q5Hetu2UB3w96zKw=;
        b=byjnxWvruEw9CsnSnTDFShUuVjwcfrMc75pav+8ObPDnkUxjkgfKz2X7Rww4fjBjzO
         p4JFKRu6Wbd3SOg6/lB/F1YE8429e72Lb+uCEuHUaoAdH/+RJzGBTyHMc9VWk8RiNCps
         AsSp11bF1QVMyTIeuC8Z7YF64TsgflNZ7ECgdBdQKGNpUcepoUSQn3Z70BsH5A4o92yO
         HbKFVx0jraOyrB5PiQLQ8pm2B3DC0gG5g0DCE3XWwCb8qc9SwBbCTPGAuw+WZU6stsQz
         nGCodwrhoptg8P8uPvVlDuSQ7Ot/sW7HTG4POfoaDLsEYxlYHij/xtS1yBkYw53kQXnk
         HhEw==
X-Forwarded-Encrypted: i=1; AFNElJ/42orwN/f1wJncN8DImGo4gSFDjDwQ8lWtt+y//PoIJVYZK0uyh5Kmw4yCe9jEiJGnKkzWyW0L9hU=@vger.kernel.org
X-Gm-Message-State: AOJu0YymDieFVhkWpLag4+6jASRxKIhiGTdxgt/7sA/R7UrOV8IoYR1X
	pa/GCaC8xU1GkXwezp9/lniFKRX2AGiIdHOumudU/TL7ygMf0TGeFvJZ9GxC7xN2MlFgJJbYIVg
	2+KuBw/75yTr7X5ntImYXd3xCmzi3mLL4NJAli6D2DAEfOBtQFdnxc/ij2I4UOXWyqdruKuus7b
	u2ljUe8GxRIjiJ+LqeMsRH+m+rARBZWfQaW70z+w==
X-Gm-Gg: Acq92OE/HRd1lQR0tYNnRU0tGMgbZxpOfeND52S8d2ScCzVK9txufGadko3nrS5nUa2
	V9zn0UWGPhkha5px9cT8fLmq1Y3o9aFOwK+JU+F8KcmJKfOVa6hpdvVlhdQcuEO49+9uisN1XKA
	LuckyaBSL0ThAvuQD44n5h3b2flFDdtFkNqqPS3d1TGk3f809lham1q2q7jZZTfKxyECc/zZpPb
	Mim+0w5P9jk4W7nsQ==
X-Received: by 2002:a05:690e:5cd:b0:657:e42c:ef3f with SMTP id 956f58d0204a3-6610707c453mr14362594d50.47.1781015446801;
        Tue, 09 Jun 2026 07:30:46 -0700 (PDT)
X-Received: by 2002:a05:690e:5cd:b0:657:e42c:ef3f with SMTP id
 956f58d0204a3-6610707c453mr14362545d50.47.1781015446306; Tue, 09 Jun 2026
 07:30:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513084325.2176952-1-himanshu.chauhan@oss.qualcomm.com> <20260513084325.2176952-10-himanshu.chauhan@oss.qualcomm.com>
In-Reply-To: <20260513084325.2176952-10-himanshu.chauhan@oss.qualcomm.com>
Reply-To: sunilvl@oss.qualcomm.com
From: Sunil V L <sunilvl@oss.qualcomm.com>
Date: Tue, 9 Jun 2026 20:00:34 +0530
X-Gm-Features: AVVi8CeCCuwpN-K9EkxyrVCpMYmKH1wrm2WzWm0aWwYK4PiS3mEB9S1-HswUmmQ
Message-ID: <CAB19ukGeM=v=G10r_tX2SC603Tej5Q6nFOCddcPF8BaKwxFxrg@mail.gmail.com>
Subject: Re: [PATCH v4 09/10] riscv: Select HAVE_ACPI_APEI required for RAS
To: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org,
        acpica-devel@lists.linux.dev, paul.walmsley@sifive.com,
        palmer@dabbelt.com, lenb@kernel.org, james.morse@arm.com,
        tony.luck@intel.com, ardb@kernel.org, conor@kernel.org,
        cleger@rivosinc.com, robert.moore@intel.com,
        anup.patel@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDEzOCBTYWx0ZWRfX69JT81TjafkD
 GHp8rmFngDKhe80tegatdNRhpS36tipvC1q8zXq3KaqdYDdlxxk51eWfjkkDkLSjY/isWDvFgYY
 fVRyTfn5QKMYcQKHlRyc/yR1qJJUPewXyjlb7RUJDfHmxMW2sFcqAN2h6Jh7ZlZj+Cw0JfXl8I3
 j/6Kr24HWfZlfo6QmhqPnCfqZa9m9++UfukxKWvbmKpqItLBJdWJWVhzszCZdq6iV+zWoB13HQI
 PwGQDIOq3p3atF+EbMuSeW6ipiUl//AVXIaOkieM0tHJdlKuDmQhwTRhhOs+FFlAN341osmhEhR
 8hKfl4zG/S0ZOO+Cr4AxA9nEwxGAsAKEccpUT0pGage/O68kErYbj631oLimz5JmqvdsqdYCtFd
 PAmnzD6LZrAQmZTHqMHrZvXhE28ZFYSbdT+oDs8KACR0Q4WngaYBReMYVBfq0VyyB0Yul7Laxr+
 mxv8NHxNlamjg3F88hg==
X-Proofpoint-ORIG-GUID: eGOme8jXPL8gxyT0yv2gBZ4US-cHA7Ll
X-Proofpoint-GUID: eGOme8jXPL8gxyT0yv2gBZ4US-cHA7Ll
X-Authority-Analysis: v=2.4 cv=GeonWwXL c=1 sm=1 tr=0 ts=6a282397 cx=c_pps
 a=VEzVgl358Dq0xwHDEbsOzA==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8 a=GsIs01FLSDa8B7WPS-oA:9
 a=QEXdDO2ut3YA:10 a=uujmmnXaIg8lM0-o0HFK:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_03,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606090138

On Wed, May 13, 2026 at 2:14=E2=80=AFPM Himanshu Chauhan
<himanshu.chauhan@oss.qualcomm.com> wrote:
>
> Select the HAVE_ACPI_APEI option so that APEI GHES config options
> are visible.
>
> Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
> ---
>  arch/riscv/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index d235396c4514..b94b19fb4249 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -187,6 +187,7 @@ config RISCV
>         select HAVE_MOVE_PUD
>         select HAVE_PAGE_SIZE_4KB
>         select HAVE_PCI
> +       select HAVE_ACPI_APEI if ACPI
>         select HAVE_PERF_EVENTS
>         select HAVE_PERF_REGS
>         select HAVE_PERF_USER_STACK_DUMP
>
Reviewed-by: Sunil V L <sunilvl@oss.qualcomm.com>
