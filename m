Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFF437C932
	for <linux-efi@vger.kernel.org>; Mon, 18 May 2026 03:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779073616; cv=pass; b=WxTxyuu0gVh6zUOQIbgLB5h1ClH2cV2XGHa/pHgXRVcExX10qRLjiG3rSU9xq+Fr34zHLfiEs7ZS1zs6WqMi5WUJIsdxw8g0NnlWQ1nolko9SEv0t6g5OA1++RjjPVgywAsAenoS8EAVskqrFCDafWpkeDxR2V65nC0XKTxhq0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779073616; c=relaxed/simple;
	bh=fO0syQPa6DgAL6Biu5LOpvUimHkt27lXFQ4HIpa68wE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T1nyyfI03sR9Wrs7L6XpqGKu01Yk+C11b4FimGGm0SaVRp2ArqASu7pN9AUPqXVkERipmtlUMb9+jnAuZ8lWyz59/Xk6Nwl1j0EHmSG4Sb+zAtrFntKpH58+/WNTGQN0RbgF9kdN3rVBOCB9TBgRJHpRAx4KkBgoVTeyT90gvPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mAEEYiqL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CP/GLikw; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mAEEYiqL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CP/GLikw"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64HLtNFR753087
	for <linux-efi@vger.kernel.org>; Mon, 18 May 2026 03:06:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	X708K6u8SzSx52/GxLg4ntRNIqhO0X/cHHFOcijQWfw=; b=mAEEYiqLjDj3ISSj
	U5DTIyGChBAQ/hDH6mDWkV6zMwT8BOQuX2+8nzAyS9aaOYA0uF35nWjqMAnPO9CO
	kDURFnlI2SvtZVFtL2PMfoSaJwmZkWBzsUTC0cnUSVkhA6e+rZcH8vMNrK/YHxrv
	NjyQV02h7yktq+80nCCu2aPwj3jeGUzsnYijL010Z5NCWM+E7/iezZiQ9ZVkGZxV
	ha8zvgvtHH05doMuKKYrYfQ1p2puHZypDxlp6iANSMc14+Muu/dft+LVBA/Wk8wG
	yqDsVg+F2SCwMf70CJ/xSX5we1QXkH4hbl5d3oaco9SCSGaPGCmTXgUiPaYuclDx
	2WjEtQ==
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e6tvck4fh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Mon, 18 May 2026 03:06:54 +0000 (GMT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7dcd9061254so4646991a34.0
        for <linux-efi@vger.kernel.org>; Sun, 17 May 2026 20:06:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779073613; cv=none;
        d=google.com; s=arc-20240605;
        b=Bt6AkTUMvWYEhpCiEneali1esBqwY4v2rh5XAbYYgG4lP2H2x3nHTN2+lcQdT30clT
         qC9HwtZYSrftEBymkH+by0R1q1Ip0f1+UDvIxWAlgbFC/9HsKzMv1UYL0FRXuj+YC/xm
         0Y3fGuxhWv3x5c0npK0bNTciX3v0xOFZBRmR+1wSJk9oLlIu23s8RpbxwEbeYWpubKGg
         HMotBGZk14JeNiJdD6ljghGkn/A3Q8lRMlxCIGLEngTumD2DDwx/DD4gdS8UYPx6W4Q6
         82U50m0QhrraEuaMDoO2RmkmaQY7oKYE4GqHYdxOGE3FtGwnFMiDTY6b28drmHAK9AVR
         2zWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X708K6u8SzSx52/GxLg4ntRNIqhO0X/cHHFOcijQWfw=;
        fh=M650ou1f8zaAVVMy0lFF8BWt300KNNciHBsZF11IztM=;
        b=JR7gVDsJbV38AQeWsKlLovfRMqfuGv1RYBGo/XR+3A9gEaN5iOx34jSwnWURgrZkwP
         DM4EAkTIbb5nCSueoCDpHx4fdwosjmxje4gIfwAOLnw01/gQaagiYEY64Nr1u6BqxEQs
         q9IH4TDYHVaq0McpsBF0XfnBraDufP+W5FgP9V9XkQx1zW9UZabIar6tYPGMS4Uil8Zy
         NNNq/WmlQkhdpKP3v9ZT2brBoyxaMVaigyRZ0ggsMCXJwqDB6C8Go1OkQP8W2j0ZuaN2
         1e2w+esriO8Fvqm0/a4W6bGXg7lpbPEIwDZGIYNxrMz6Qtp3DayD1Ey2JuB0s1VSVXGO
         Xe/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779073613; x=1779678413; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X708K6u8SzSx52/GxLg4ntRNIqhO0X/cHHFOcijQWfw=;
        b=CP/GLikwWG/D6yQjX4M90UGvKrFcZEb1KeRC5TkHsgiEwDzPblUhCi+zhI/3sS51Rq
         abuUEiW2mPCJGV/IywzrTK+wLyKXS9f0LzzXFzI+u7ipFU/9Nir0W1d1cGkex64JHpjw
         8Cq7RpipGKAPdCB0e+d0qwbK0edFOP8b6XKUr/Thhs6DdYWSLysD36WwSTJYbuAlhS29
         1YXuhFIGBsardU8rzhoCWLaSUOeHbHWq5z/9TS6/YLmG1v4DaTIuONRfN482homVrJT7
         duP1pvYHoHj6pFOPfQEO1hfdwwfD/Dm56AEwG9OKujwAO8KEy4cZ5K4+gJH81sMVyMR7
         DQ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779073613; x=1779678413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X708K6u8SzSx52/GxLg4ntRNIqhO0X/cHHFOcijQWfw=;
        b=NWaR+/NVnFXQ7CD5UrPjByCMrcI7XAgDGmqzf3kwnSzwMuNEaMZe2f6UAM2f9HOFzU
         6yxPvgnO9Xg5RIHgJSAqBq1hv1p1CdU9P51XJdoedb14xJZfVV5bN/YkIeaLaxC8PQsV
         MJQdO1tsp7slxVQ/Svh8wkQnf6CQVYC5v5NeEcHaxvV11vbIayv93/kgiKGgMAhJss8b
         CWycHk/BxEx4R/PkDBR/bvYVb/uclExUdmsmf75PpB48p+R1aaJb1i4lG2RleISDPtKI
         J2C30I8wjaGYXZ3nBsI2Gl/OEpS3qUkf8l+8h8h4Oq3epR2N/8yXXJ/XOdyPJsiqueLW
         G8dQ==
X-Forwarded-Encrypted: i=1; AFNElJ/XMhIIAwLtUKHqf8bJzQViryC2cNPkwREG2Z1uZ4/ZEhmAuNdvOxTcUMGgrz0FdFw8EBvCiFgRG50=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9s3gg7uVMoq+jj8sHEcMPJE94c+PM+l1ZY9UPWz3c2EJ8clrI
	l9CpdoGKmMi3sVZO7BBtS6fna4FSuEuT4tKcQVB051ro5xKGIeTpxbQa+vytMkb2ita7CNBblLc
	Dm4+mnzZlT4eQI//7mIOlmSqhbx2GoJVYzMkVQaiiqFUZdnohTxFRiFYhJzVMWraWvMr/U/rnHo
	yAJ/svQHHWi7cbQVmpIt/ONNVDr+Fx6hsQ0MjCDqAxLxeuye6K
X-Gm-Gg: Acq92OGP/toL7B0o9/Eul2vwtdYYywOClgIYpxLlG4+jHhd74jq5NmLpZWTrmOco6fy
	0qzL4XpKD1q/AEtOaGXZAbeACjumFyYy2ttHsSrU/PJC+7E8zp2Pc6Y/v0vlo8jyVIW9Gxc4guo
	FGjE2ZCEODkZrA9/xdUQ8Mff03RFJmI/yoaGYIapsfzmWA2SeLa6wMVnX4JLrcVzIpf1E26mWH2
	BzLU+FEBOrCZeh0kg==
X-Received: by 2002:a05:6830:828b:b0:7e3:7697:9b5a with SMTP id 46e09a7af769-7e4f2b9bfd7mr9164815a34.18.1779073613221;
        Sun, 17 May 2026 20:06:53 -0700 (PDT)
X-Received: by 2002:a05:6830:828b:b0:7e3:7697:9b5a with SMTP id
 46e09a7af769-7e4f2b9bfd7mr9164792a34.18.1779073612814; Sun, 17 May 2026
 20:06:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513084325.2176952-1-himanshu.chauhan@oss.qualcomm.com>
 <20260513084325.2176952-4-himanshu.chauhan@oss.qualcomm.com> <CAJZ5v0g2kjfAvcTzp8898A8HdMymU1SQ-rHW_DFhZP49c9=s5Q@mail.gmail.com>
In-Reply-To: <CAJZ5v0g2kjfAvcTzp8898A8HdMymU1SQ-rHW_DFhZP49c9=s5Q@mail.gmail.com>
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Date: Mon, 18 May 2026 08:36:40 +0530
X-Gm-Features: AVHnY4IXHSTvGb4jHkiTrfKvQSC_eyAqKXiBE4l4KpJ5S_P8fZyP7mnKGJ0aI8I
Message-ID: <CA+Ht8=YbMLXnCFtoyVosrjS56ye_bUp16awgxnXkEmHB4_5_Dw@mail.gmail.com>
Subject: Re: [PATCH v4 03/10] acpi: Introduce SSE in HEST notification types
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org,
        acpica-devel@lists.linux.dev, paul.walmsley@sifive.com,
        palmer@dabbelt.com, lenb@kernel.org, james.morse@arm.com,
        tony.luck@intel.com, ardb@kernel.org, conor@kernel.org,
        cleger@rivosinc.com, robert.moore@intel.com, sunilvl@oss.qualcomm.com,
        anup.patel@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: iNzCjUEMPa8r517Ii3UrGIIyeathjIyd
X-Authority-Analysis: v=2.4 cv=UIDt2ify c=1 sm=1 tr=0 ts=6a0a824e cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=DJpcGTmdVt4CTyJn9g5Z:22 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=h0uksLzaAAAA:8 a=sBTH58jHExCepGOTGfcA:9 a=QEXdDO2ut3YA:10
 a=Z1Yy7GAxqfX1iEi80vsk:22 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-GUID: iNzCjUEMPa8r517Ii3UrGIIyeathjIyd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDAyNyBTYWx0ZWRfX72NxkCLZ8KZ8
 q2FKTkRfGqXBMtTEqnFCZqEoVBFMO+fFHtmsGnhjNNKYKFmhNpUgkoW6VT5XRZUAuNEVfzmc0H3
 uClYGKqpYwwlgLvkxs16il+Q3PskBIivrCD0bEEyHLAKHNFl4Sk3DA7mh3sw0gUWG1LrC3BpxxX
 sgkLmetgCd38pc53kLWOeUOcHbappYdy+MMTUPFQHrnCHpS/EJ4tqXtjW4WrQ2HDA+ZLttwBs2t
 X1ISPTOpnbYPK5tsh2aPKxjgpaIIXlW72DamlKNfnv8kmQQne1dAEnzN7OsFfmPEPJGJJnc5tZC
 /JAWbZyunkoZBsHRlEcjRKeUMWj4tRL2rYvgTWlsgqOjOXs+cOL/0gO1muIWFKZaLavZLFF1C/K
 bztgUwsv6rfPYm4nHNRrtZe46cEM65YLXQjuuVYUYhu/dhBuoGIoQxXv9vpT8bKV0NXSzjn3GIx
 E0ZKWFqv44p1Li3zcuQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-18_01,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1015
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605180027

Hi Rafael,

On Thu, May 14, 2026 at 12:56=E2=80=AFAM Rafael J. Wysocki <rafael@kernel.o=
rg> wrote:
>
> On Wed, May 13, 2026 at 10:44=E2=80=AFAM Himanshu Chauhan
> <himanshu.chauhan@oss.qualcomm.com> wrote:
> >
> > Introduce a new HEST notification type for RISC-V SSE events.
> > The GHES entry's notification structure contains the notification
> > to be used for a given error source. For error sources delivering
> > events over SSE, it should contain the new SSE notification type.
> >
> > Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
> > Reviewed-by: Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>
> > ---
> >  include/acpi/actbl1.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
> > index f72e00517eb3..2a8167979458 100644
> > --- a/include/acpi/actbl1.h
> > +++ b/include/acpi/actbl1.h
>
> This is an ACPICA change, so it should go through the upstream ACPICA
> project on GitHub.  See
>
> Documentation/driver-api/acpi/linuxized-acpica.rst
>
> for more information.
>
> If there is already an upstream ACPICA commit making this change,
> please add a Link: tag pointing to that commit to the $subject patch.

I have already provided the pull request in ACPICA on github in the
cover letter.
Below is the part of the cover letter.

 - Raised a review request for patch "Introduce SSE in HEST
notification types" in ACPICA
   https://github.com/acpica/acpica/pull/1170
   Keeping the patch here for complete functionality

Thanks
Regards
Himanshu
>
> > @@ -1798,7 +1798,8 @@ enum acpi_hest_notify_types {
> >         ACPI_HEST_NOTIFY_SEI =3D 9,       /* ACPI 6.1 */
> >         ACPI_HEST_NOTIFY_GSIV =3D 10,     /* ACPI 6.1 */
> >         ACPI_HEST_NOTIFY_SOFTWARE_DELEGATED =3D 11,       /* ACPI 6.2 *=
/
> > -       ACPI_HEST_NOTIFY_RESERVED =3D 12  /* 12 and greater are reserve=
d */
> > +       ACPI_HEST_NOTIFY_SSE =3D 12, /* RISCV SSE */
> > +       ACPI_HEST_NOTIFY_RESERVED =3D 13  /* 13 and greater are reserve=
d */
> >  };
> >
> >  /* Values for config_write_enable bitfield above */
> > --
> > 2.43.0
> >
> >
