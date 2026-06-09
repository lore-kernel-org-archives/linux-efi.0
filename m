Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEC83DF011
	for <linux-efi@vger.kernel.org>; Tue,  9 Jun 2026 08:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780993038; cv=pass; b=TL2zkO5v80tyvpr7NW1CmF/zlnppjirLIQ4xESR5J8X6Cg7lX7J8AQbwcE7xLjAa9o72Q726t8SfsWY0BGy+C2RJ+eVMARbxeBYPRLqLv7vjTH65wWtzlIAWnSud9M7EeaQ5E0az2Ft4+iwDMIQYKi6jC0iGvGmPQmMdTYhOHFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780993038; c=relaxed/simple;
	bh=dWJx//JOEjj26wHu7ehYPbCtKxGVYW0K8EvQVYpijNA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k7SebFvIXq12R/MVWv4W2jZWTVzzWVOmyBWCovAVamA1jswxG9CrHIjgoLSRRLiBefgNoSVIgsUUuMYtpTPLWj2GeXcf0H0mRfqYzPGp/3D7DFeEuRUUwMtDufUn3BymWh4H4hTBFBDJgZG04jHunSbervFB+oQ5dZiftkq2TAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eQk5Xu9b; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=d9h6AFAo; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eQk5Xu9b";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="d9h6AFAo"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6597rZ0x1923143
	for <linux-efi@vger.kernel.org>; Tue, 9 Jun 2026 08:17:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=jvupPNCldiQKAIDZ/DjgPDJckTZ6qUBUmQZPH8bK9Sg=; b=eQ
	k5Xu9bgZXNXJ4bQsWSdE0Q/hF3srxk9yTe3JRQkdC40uDEowSMrqS7QQqHTqZxVk
	eCGeFEusOg+w5sz7cCmeEO1aHxb2d3NamlhES9kf/HO2CDCbvfCjo2vAo9ww7EUB
	qr/0zdDRAgFFq2ypYQ28gc8ntwbaW+2G8MtoKN3iiteLwr3qDzMPGyi0kXSuOpay
	DrYLUpeGo41/qmgvY5kLPgIM+o7n+zoNoKMpXZUOMwx1w6psgTzgWXpXhSyQi2j/
	kpMrZ82TNStzxJqvdx+xZgnohrv2T+eGo/F5vXVaGUhCqXsDhaUJqx5NkU79XOzW
	kX0G8azJRS4o4VXLdPwQ==
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com [74.125.224.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4epee4g71m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Tue, 09 Jun 2026 08:17:15 +0000 (GMT)
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-6607988ca90so1073315d50.0
        for <linux-efi@vger.kernel.org>; Tue, 09 Jun 2026 01:17:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780993035; cv=none;
        d=google.com; s=arc-20240605;
        b=j9X+K5zyw//Q+PUcEo8Bqe4i0KDpFJEvxnLBsFfx8sHbnu0uNgAeNDb1EnwCI+7gNb
         QlzaE3fWmFMIQA7ztSRJmv0+xZgDXNXwqJr+P5E1pm3mk/7r5mVha5Y9U/r49GJuDmO6
         YHjnHCVub+mV1DaiIZ5c3YP2XWSc733gByEdR33TbnAdknU1MGXgnNM/1QSWtDbGwnUb
         qPXB4eOuv7hIsV3ySWWFvGakkJPFvehvbJp5Q/DgxVfiBcJEpNpZ62tegbOcLi8Zkkm7
         k9aY2t2lOymxm9sLHc5pjwahXOwDPXTrenH1csERcZFlAT1Vr3lo1QoG/7MaINcAfHOe
         U3qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=jvupPNCldiQKAIDZ/DjgPDJckTZ6qUBUmQZPH8bK9Sg=;
        fh=PK/+cBdef3B3bmb9xu4VeAEzgnJgkJo3DLxKDAGpf8M=;
        b=N/Ou1rRdknHCIqTkU3Ln+J0HeImAgJYZ1W8Lrg4L/OTxvEUPLu+0YCFOYEp9tcsb5m
         FB7UHByIXlp9WHAwJmc/JYxLuu/yHuAvp4ayC5NoFXaRSuy51wiwHKTJUVfqxVcxQoY0
         0HpT0y+StHfHx623QU4oGx01wveYkJiJ8N9yekoeCmWxrQ7UZR2vkDNKvPNUur3r8oH4
         eVxeWDEQhmFhDxdi+raUeshoWMxaOtSyGrVC4SqKFs2vCQC11RMnbfVlX80ZnzYdYd5q
         5H6cvfG9HRwdOYi6cyN1iI74Bmle7b14iMmB1aa3/5WSKnHZlUOweER/BSLPrjP3PtVc
         hYPQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780993035; x=1781597835; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jvupPNCldiQKAIDZ/DjgPDJckTZ6qUBUmQZPH8bK9Sg=;
        b=d9h6AFAorcyam0RJ1HuJ8e8jYVJM82lm60dveTKDKSdImXLnTVxnxCqSzpnglo1Z1F
         qmrNuAKvd8dnymOU7WG/ZHOpLDpn3QSt04kOgtFAthJl2oZ9B0xrX2W27peFL54rdU2w
         ciHn4dSkeXPssbW3NlyKXnOC3MON1dy2Mu8L4Nuub+bp3RVvrijWWsUVGGR/rx0nl75l
         X13bLfrLx6ss8HgE69NWZiaYrSA0e8NTlYyLtIkbvx7sl8Qq94/M3tFhdGZWurTozhe0
         nDy+wHcHcobMQ0tFChgBVKgB69/0S007toKZQR9WYTv55NlyeB7madBUZOFUerfqZsld
         femg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780993035; x=1781597835;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jvupPNCldiQKAIDZ/DjgPDJckTZ6qUBUmQZPH8bK9Sg=;
        b=eNKDXP3zD3hXuaFpyJKMTkcPaIrKre98ugfdcDJs7XcoCxPSUBRd4Ewx2FDyWA4hUl
         n0xaYf3uaPp/3qu0/HQaAJNoNhuHSpKq5lHuG9MMd7i0lAmU7Vv64/kF39GKcbsZeEJX
         KB64Ne8jJK0l0KhiqS14Au9rQHSJCp+Id2xP+/gNwzqT2ZBbuafYBQ9eJph6nUD9Z8Bn
         H0oSWPvEOVRwnSKbhukOqQFrY2FRMiUM43GkUQTjCnWqIT+wRT9D8TlWyRaUrIFXCotF
         67HYMpB7nWBhORzqyJR6oWnrcMkQVlW+on8ZYkyebxbCRSAx9QsTTnmSP7d3cqgijA0p
         Tpkg==
X-Forwarded-Encrypted: i=1; AFNElJ+7TSop5WJplWkYF/T8MD7bdkqJ+e3BwzBYKYaaf4tlJpJSYpzM37bo5AUTG3bJyfxIloNnhtdzAxQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1Rm6FRyzmfTK/tcIrv+iN5zYzkx6qa+2NqAI7zq1tiT9akdd9
	qwN5iGjRsAQOU4irf1h5T7isREn3rBN1iA0YqfRprgwbvn6tcgbzArDePU7S/my04QThl08rbAf
	p55Xpl11Fy9aaqQ9fCFD+HNTEHPfqND/LJ7fwto1c3CFGhRxCFab7V/T36L2NisAgjJRdO5uOWc
	Ct9SoG3LGiomLdYP+WQ/8LpNLBJGbIsHw7aagVdw==
X-Gm-Gg: Acq92OH62bul2q77ePaxSS+NcAx6vyWJfAmKGveh4GV33aqiUr3tZOKDfwkQPkrIdPB
	zpekxiksv3gYwAThJcEOBKbpQpV60/WcZUfB4HhOXR9G3mmZCq3gM+L9jEi0JrrxRkcf7lBm9bu
	NaxPifCC3THBnWzbZA5Z0JlMWX6SaKD/5QQtxhU6CdIJdI/UEyPT/Z7t4WYnCvT5DavS2SsMcjv
	uTlaP735kSdSb3L8g==
X-Received: by 2002:a05:690e:4105:b0:660:2f29:9d9c with SMTP id 956f58d0204a3-6614f8195bfmr1177973d50.57.1780993035319;
        Tue, 09 Jun 2026 01:17:15 -0700 (PDT)
X-Received: by 2002:a05:690e:4105:b0:660:2f29:9d9c with SMTP id
 956f58d0204a3-6614f8195bfmr1177943d50.57.1780993034797; Tue, 09 Jun 2026
 01:17:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513084325.2176952-1-himanshu.chauhan@oss.qualcomm.com> <20260513084325.2176952-6-himanshu.chauhan@oss.qualcomm.com>
In-Reply-To: <20260513084325.2176952-6-himanshu.chauhan@oss.qualcomm.com>
Reply-To: sunilvl@oss.qualcomm.com
From: Sunil V L <sunilvl@oss.qualcomm.com>
Date: Tue, 9 Jun 2026 13:47:03 +0530
X-Gm-Features: AVVi8CewdCgb0dSR_aOfcZlf5FZmhKTqxG1BVy6uKMuIOJaJR9mdub3hX1vwY7s
Message-ID: <CAB19ukEWxUTnouJLG9pVBkS9VcfdFP_nVdG9T6V_4dAVLDNKxQ@mail.gmail.com>
Subject: Re: [PATCH v4 05/10] riscv: conditionally compile GHES NMI spool function
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
X-Authority-Analysis: v=2.4 cv=PIs/P/qC c=1 sm=1 tr=0 ts=6a27cc0b cx=c_pps
 a=ngMg22mHWrP7m7pwYf9JkA==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8 a=9L7PnyXcnU1f3mQPG5kA:9
 a=QEXdDO2ut3YA:10 a=yHXA93iunegOHmWoMUFd:22
X-Proofpoint-GUID: GzzwponvDa2omJDv5veedszCNRMRMtTy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDA3NyBTYWx0ZWRfX+tyRffSUsHwZ
 wH7zJMaVshH1neV/AbYkuzEp6bU1HCQY4Jy5NFwZFrvJLyRR5qin5A8I9e6LqbAeg0sUtjRFqWj
 NwyuxaHFnD3NF7ysMUCOSwME7KTEnCXDvveLwWCG6lZXwzkfszmEFTl78O/V9czpdaBHfT3HT2G
 4C+bWwaZHsO+ufvvgv3TD1MZLzKGl5F6tuh8VWoYRHZ/VmrcDdU5INC6ovPy7yg2d4SbyNGgEyC
 uIpmF0XcF+LnJP1D1n6uAmpgF84gB7cQr7jXnkzWn+8UlMc6fnrptg9yDe1EyVxrpj86t+m/yBi
 lHGLDW4uOL6Zo/dYYmACgDE/qv/lhfsWWWQ/41PT8W7OlnUVcr3u41U8wPwZETWKYrGZDjdw4De
 B0RwBJuFugfsHsEokuG58ptbXUdhaV53kudCEBLR8QeVAoeDWRIa6N8mx3CzhRU0pFsczZPmkiw
 YcV6dBC/DLKYuuBNQVw==
X-Proofpoint-ORIG-GUID: GzzwponvDa2omJDv5veedszCNRMRMtTy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0
 clxscore=1011 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606090077

On Wed, May 13, 2026 at 2:14=E2=80=AFPM Himanshu Chauhan
<himanshu.chauhan@oss.qualcomm.com> wrote:
>
> Compile ghes_in_nmi_spool_from_list only when NMI and SEA
> is enabled. Otherwise compilation fails with "defined but
> not used" error.
>
> Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
> ---
>  drivers/acpi/apei/ghes.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 3236a3ce79d6..8edc2c8db1bb 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -1397,6 +1397,7 @@ static int ghes_in_nmi_queue_one_entry(struct ghes =
*ghes,
>         return rc;
>  }
>
> +#if defined(CONFIG_HAVE_ACPI_APEI_NMI) || defined(CONFIG_ACPI_APEI_SEA)
>
>  static int ghes_in_nmi_spool_from_list(struct list_head *rcu_list,
>                                        enum fixed_addresses fixmap_idx)
>  {
> @@ -1415,6 +1416,7 @@ static int ghes_in_nmi_spool_from_list(struct list_=
head *rcu_list,
>
>         return ret;
>  }
> +#endif
>
Reviewed-by: Sunil V L <sunilvl@oss.qualcomm.com>
