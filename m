Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFF0380FEC
	for <linux-efi@vger.kernel.org>; Tue,  9 Jun 2026 08:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780993659; cv=pass; b=ZwDhX44CT3jTmkJdX/AZqsOLbJHBBDnO1xqZTrM6LUDyiMOezJfVruVr3DkhE/AwF//szSycmo6rWaw+3VAWu7pcAMefLdhKsGiYj7eE5esI47XeeI3aze4+vkl+PHdzB2B9+7gMFXS9pM1t+O+tej5DrEoXzQ1lRar0UcrpIi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780993659; c=relaxed/simple;
	bh=1yq6NLeTXKn2qxQnfkuIZx97MltL8Uj5Dvhjzl5v+/Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D/1x+VzpVAKk6apjTkHvgisoEr1qrXPiDsH9V1T/iNYJMNJlNNGpu7MBMLJOhNAvzgD4oiYq03gpVar+EPZIbRYEe6cmKs+L58gO7jZMGQOmxnZCh1M+OjAHSxZMNdpIhFbRzkB5ZNp9Lx5NaiHJTEOScZvxXvGHG+QWwnm+Zww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=a9+ay0tN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Pom7KRDd; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="a9+ay0tN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Pom7KRDd"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6597rbHP2034662
	for <linux-efi@vger.kernel.org>; Tue, 9 Jun 2026 08:27:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=TFkSAnnuzu4vpgPtCevU9biue3ziTEZcQbHKJrTFV8s=; b=a9
	+ay0tNlJqbfko3akJd6ZxVnaymemUIb0U4vMaEBJicsXy3mKJoGs4l9LMFjwToas
	Ojj+KBqwFXM0pWv2Z/iXLzdwRNb1/8tZv1AzHBofi5WkV0a9WQWg9u6oc5yAvspm
	S3Ie84Q1u7WKdC7oRtNE4tTvTabbfG3i3Kdxv1IH/KxuRbJSqQ5PPfOFmISACeVt
	Ro//6yjwkHHPgyWNQcJKzVSqGuX1CorJ82ERYhwgBJZtuycC7QT4QAPAJ5tiqjQY
	/BAW39z9JHJ8s+kZOnEy3P+UypuFrtR3/ZP/k5EDax/A4OXikUiXhFgI66oZJ4kb
	8pBNoBGn22Lb+NeK2OpA==
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com [74.125.224.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4epeear7vh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Tue, 09 Jun 2026 08:27:35 +0000 (GMT)
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-66043ac620fso3845226d50.3
        for <linux-efi@vger.kernel.org>; Tue, 09 Jun 2026 01:27:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780993655; cv=none;
        d=google.com; s=arc-20240605;
        b=DnZjCNtC3qtB8z5gzSawViBnSasASxcEuk696s84yq2Prgtjy2NjVchfiS/xNVmR8a
         +o8oPDVI+8QEq/IsgYaIxzhtsrG05xx4+LEivA3YlxNmlZc6beZWZ8y2DyY33tXQma32
         Q/R23r2roVwx+NqlMDAQZ8oSRMDhRKszPdEjaBmMzILAIFQASq6IqZCC7CzUZl2cl4mc
         RJyFLDIt16+ztplrBzQHb2OJRVwaQp76rKKBhLXJIqQs3fKhj84bmOqBD127jeQbypnb
         H0u8A684kDEe99E/0ME5F0uQst4kAqm8k6CMPBadwuOOvrkH1wzLDr59gVwJd1QR8EZD
         SnNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=TFkSAnnuzu4vpgPtCevU9biue3ziTEZcQbHKJrTFV8s=;
        fh=VXl2zIdWbsOae9iqF7Rit/RtYf+3+vxH/FA3tq+jvZY=;
        b=QoDWPkMGcBkqf1s9Ftt42HkSaLNq5ze/VuIfnfAbujPiuAr5AwAMNErDlx5hCOlt8i
         Od3QP4N5eRaLhSlKoIH0ifSVhV9rgRJDU9pytJ7LlKtVW1BpKQZVuQWfaP2/0tdm6kGE
         v/7ytRj4GjzmWzXXxFSvquSZPTjVsVGQYos1nk8NItIJRzCtsp6NlhaCW3c9wK67dYH7
         8XDN+ansST9F0xHPPSbTH8wJ3G/qQXkWVYjhXj6Z9KoItgHKKHh0pgDx1iPHZeh9KuT8
         mlTqeXUXM+Ok4HWC2o2vTA2W8HGfKFNhlleORCJxAfpvNK9m51EVBJ723Rp1NbMQGdB8
         FYlg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780993655; x=1781598455; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TFkSAnnuzu4vpgPtCevU9biue3ziTEZcQbHKJrTFV8s=;
        b=Pom7KRDd5vPCamRtzxCwYb9y/ZLjnwxhcxOIDkdVjJ+OLadZ5ptbTUiN05a0rOYctu
         nIqzmujZHCX40Tgh6IfnXToRGJIPgKNF2Cjx8wKt1mCmyHoh3WaG76uCE/qHK/73gL3S
         iONgwVr7RZiT2z6ROsuFeAZXoLM1CSeWqRU6mWwiKESAjJz/EIItuei/ryZA94T4IDZw
         Lh8WOfR/vH7EklnXMi+4zLKPwip3rW5Cp5Vs8+qzr6MeduyYQMaIwgQBnZ3u9LcmT5TW
         gz4kjiV8CW6s43NvfxvCYvTF+3CzZjiKH2bE/nDcTXkEbx7ML2LDeOAX6WIkXvWkOMQB
         1Y8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780993655; x=1781598455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TFkSAnnuzu4vpgPtCevU9biue3ziTEZcQbHKJrTFV8s=;
        b=TYPhOIKG+5R8yWNkCkum7Otn4mulaiULj2D2uQeOi7qnwoikdi77Mv/aNm+3Eb6cVA
         jjha7cHQnRGz6D1lExouWChg+/9LVnfM52ZGPY98fiOSfdEpMnUJlaIQ676iwSKEZXrr
         NZctN060DKugymsAraVLv2yZ7cr3+lDS9nbPwkxDHPlVB9K7j6stvPT5sh44CgQJ3qvj
         l6LBxK8Uc3PRa5Q9fQzuz19lEvo6FDHE501kqBBh5Ulc0FCrE6IwVJZJYb0vFwmQUNUO
         XJKBvxnAUhRbvsS0x7Rmx7KJ9BVwOLiBJFl2M2ORbwrNka840tP9Ub52XXUk0Cv1eNQf
         AnIw==
X-Forwarded-Encrypted: i=1; AFNElJ/RlBh+Lv1jlIrYr0b4uHhieiv1wbZusvEdkQlFNiWhG6ROCKYejT52vSNXem6vbDdDKzUu3ZQefAE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6al0LsF4GrF5BQCzB9UfTY6fI2yLCNYy8nY+Wl7Zqd1lItbVw
	hTlUWTI4Y9OzMXG38b1Xe417QFPG5XOnD+bR7Q7yinQhxrTIUvA+O2C2zCzBDGsgN9Pb+YrGXWv
	tpxDwQtvRA+dzIx7b0aCR/1yZ8MeYnSU7EhyuBJ3AMFx4ooXTSQtA5nJOub5YhbJNfU8sAEm5tK
	JYo/BEdq1+ipUez9eXaoeBWD7blrRWukjO6NGAwQ==
X-Gm-Gg: Acq92OGczrZLZaju0lRhN8z9iVqFLeY5tmWUsSMJKZ4WCn93b8Ml+rvpZXvmq2NFL8m
	OAx3iHeO0Saxar87bnQYYgd41Dfng1Q9rSoQsIfyyg2fvGE4BjD40JDEumUe3ECbOXwf3zcf9Av
	bZ6Tsa9EX+hC2J2QCjYdDsq7DHM+67XZo3igojnhP6SswMM9KUwLMKT5lMzfjy7o96mWhZv4j91
	RYzW6AuPUE0jjE2/g==
X-Received: by 2002:a05:690e:168f:b0:660:ea4a:153a with SMTP id 956f58d0204a3-66106f4d882mr16311104d50.22.1780993654668;
        Tue, 09 Jun 2026 01:27:34 -0700 (PDT)
X-Received: by 2002:a05:690e:168f:b0:660:ea4a:153a with SMTP id
 956f58d0204a3-66106f4d882mr16311086d50.22.1780993654159; Tue, 09 Jun 2026
 01:27:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513084325.2176952-1-himanshu.chauhan@oss.qualcomm.com> <20260513084325.2176952-8-himanshu.chauhan@oss.qualcomm.com>
In-Reply-To: <20260513084325.2176952-8-himanshu.chauhan@oss.qualcomm.com>
Reply-To: sunilvl@oss.qualcomm.com
From: Sunil V L <sunilvl@oss.qualcomm.com>
Date: Tue, 9 Jun 2026 13:57:23 +0530
X-Gm-Features: AVVi8CfQL2ndPqpNPolnsL7-JCyoUBHFD0_-DueGPSQTd6Hneha3xqLb-1My64o
Message-ID: <CAB19ukHDB6viGCM7FURuqsR_4E=bb8nd-z-Y32+mgrdBT7JB-A@mail.gmail.com>
Subject: Re: [PATCH v4 07/10] riscv: Add RISC-V entries in processor type and
 ISA strings
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
X-Proofpoint-ORIG-GUID: xzpV6NfEwbs7pxZEJQupKnqqz9I2oHVc
X-Authority-Analysis: v=2.4 cv=Iey3n2qa c=1 sm=1 tr=0 ts=6a27ce77 cx=c_pps
 a=J+5FMm3BkXb42VdG8aMU9w==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8 a=_3BUxsq8Yho0MmvbAbQA:9
 a=QEXdDO2ut3YA:10 a=Epx66wHExT0cjJnnR-oj:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDA3OCBTYWx0ZWRfX2h2bXvZI3Tsc
 6Ym2cXbjlb+cCZtf3P6SokmqFyexDNSsj+GtFsIJGHVulmYSVQi9F5ciD4B2Y9DgHC+UsFfEsVA
 KJyQsrNgQvwf/1w5Xcb8E5PZRlxQMGgmYMvAQDyAe9tPNuFO73A3IBCbYCyJGNrnfwj1Qhx9p+O
 fBz4JVbJ2I48xLysoK6V62QHXLfDLauKj5I9ogC94ev08YkomCyP+MeOxckj8MMVKz6soweKzH/
 0M3HeUq4WS0Z5pG+hrgxUrSARnxMpUzpk4tl5o6S/RJ8R7P0hlJgXmnAJWCYDIT4HfZdQ0xtmwd
 CduyXFPuP6Mt/lnnjodHkocciY6lh8w8MJJ7Vb0onDIcHXpls5KiNe7pcAm3O+E66qDUPaIwYdd
 /4VfyqNQ3hQ/NoAfmT44YNPkeWRXgaK2dC15PXZ024SZo2gX4Z+11tuqIAYz3H+KFuLeLJdVrN9
 O1S1fVM8NHbNfDnixRw==
X-Proofpoint-GUID: xzpV6NfEwbs7pxZEJQupKnqqz9I2oHVc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606090078

On Wed, May 13, 2026 at 2:14=E2=80=AFPM Himanshu Chauhan
<himanshu.chauhan@oss.qualcomm.com> wrote:
>
> Add RISCV and RISCV32/64 strings in the in processor type and ISA strings
> respectively. These are defined for cper records.
>
> Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
> ---
>  drivers/firmware/efi/cper.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index 06b4fdb59917..1b1ab2f1355b 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -170,6 +170,7 @@ static const char * const proc_type_strs[] =3D {
>         "IA32/X64",
>         "IA64",
>         "ARM",
> +       "RISC-V",
>  };
>
>  static const char * const proc_isa_strs[] =3D {
> @@ -178,6 +179,8 @@ static const char * const proc_isa_strs[] =3D {
>         "X64",
>         "ARM A32/T32",
>         "ARM A64",
> +       "RV32/RV32E",
> +       "RV64",
>  };
>
Reviewed-by: Sunil V L <sunilvl@oss.qualcomm.com>
