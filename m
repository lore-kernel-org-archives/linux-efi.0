Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E582B3ECBE3
	for <linux-efi@vger.kernel.org>; Fri, 10 Jul 2026 08:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783670772; cv=pass; b=oRd4rVXQpxJ6bq36ifWPcAsujo098tAKCAtpe+9e7e+sLRfTcW7gF+qAfomHpclny3IZD+b4T61doVI7NBoJMzbeuT9UK7jNG6q4/vTJzxES7R54h3DehhMKVRZKl1BmUf6jcGIa1O9wjUDH3iQijRbTW+mcyz47AzVj10aDcw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783670772; c=relaxed/simple;
	bh=rYdv04oG7QSSqQZeIDnFcGqjfR8SCbXpzGryBIgOyyw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WCkUViNf6FlZ+/4vQCSVBWDN7v/I2yq1C7qMO8oRlTKOlTlc83y7bqmbCQb26DOepKfmNsuFuGKtT943OWCA2L/uWTbgiZgd0II4BFvvwzvTnfAp09KCEcNlGEv1xKfbUs7QOS6/V8Avntore2O+a2pNV1B2rG5mJOBqaA7wwm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YeKF3eBY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=idRpkeMj; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YeKF3eBY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="idRpkeMj"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66A7dWsW056455
	for <linux-efi@vger.kernel.org>; Fri, 10 Jul 2026 08:06:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rYdv04oG7QSSqQZeIDnFcGqjfR8SCbXpzGryBIgOyyw=; b=YeKF3eBY7YssdI5B
	/CNfbsjB3WeZZD+/j0hsm7M+BolNZGpNt8sFiZ1fxzS07wNM0fQsrgxCw5ozLsqP
	4nV0wSnGGjCvNTew1rYYpYpei9CkONTrO4qUP19uW6IF0ga0jOStVAigRgefukaE
	hmZGqAcJuwMQnRm2B4wwuNE3bPZfloEvISlHxEyVjQ8xUjvRkJd2MWf5nunb6432
	Q/FWQpqMKbVkHZkoHqmkv/fA0kw1GYQpZQxBd87vi7V8+yvDS3pBoX6h8uLCPjsv
	2CTY8BfzoycHKevmZLFdL5p17fa9U846DR28eHJNfu/dbJyesvdnHP9zFR3x4TGt
	nsdMbw==
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com [74.125.224.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fajwta1k7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Fri, 10 Jul 2026 08:06:04 +0000 (GMT)
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-667bb944299so1021748d50.0
        for <linux-efi@vger.kernel.org>; Fri, 10 Jul 2026 01:06:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783670764; cv=none;
        d=google.com; s=arc-20260327;
        b=bkqVYxXV3GrGiYPKwPJSDguDPY9FAVRInpMA/VknNjVNEBVzlIfxRfpCDbBEg5dg1E
         TBO7ZOcaRvdph5e80W+zRnvt2di4ZJLGJsmes3pbLrVI5IA7p0lCx91KQN1kpnawDAL4
         fuHNUJxQtsysE0qsqa8yQK8k3XiAtbbNQ5SPt6mrx4nFDDEJ+xR/eYlbc3i4XvSaegOr
         1pGwdxTvEM+3Ur6N5gcGvVZW084XrhDUCM1mTeeY9gA1Mahp/Su8vgokV8j5fVbJUzs/
         oqMMKLZQl1dkGW9vVyfEM8OWDs2O8KC08e4HbAlz64YV0QeW7ngBitFdGPgQ/KgdmRY3
         Ny8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rYdv04oG7QSSqQZeIDnFcGqjfR8SCbXpzGryBIgOyyw=;
        fh=kt94AcLFjxVmyWomy4yqdxC9RrhmoCZ5ff/XdSKm6qU=;
        b=OTxjrzGW7QRn9vVtTQtfnSR/bpu7y08YFUwxyM8nKsZMsepw9I0PJShqgxbZicON7Y
         x+TwLe88Kz0LhXuV2C+FzjRe14b+pYUtAgN8fa7OLbtlHdk18kurl8ASFHW8vlEAF7ff
         WHcUJIkV7r0/LXgRE13jHAQecYG66QbHN+Lgjbwd80ZvT+csQMFWMMRaQTmoYT5XyDmy
         /KHn39RXDRKEasNBwybUlzKygTdPMbsvK8QXq6dOzmdwBkh0bt3vzRySzZs+3lQCp+1q
         t3Blua4RU5VGqsfxI342YzVV+62kzar77V2ca7UNWXL6uLZR+oc0aqpXoi7W3XdEjM72
         Z9Cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783670764; x=1784275564; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rYdv04oG7QSSqQZeIDnFcGqjfR8SCbXpzGryBIgOyyw=;
        b=idRpkeMjXJyCvIu8/gt2YRAzyWDLcm+9VUkWEUqL3ZmAWLturyq5G1KSZEIpIvsBMO
         L7xFCiYJ4ycXhevahVjn98zdb/vPVry2doAfw8hVmd82PG5XJDhBRE2VvibK7M19LeFR
         L7aPcs/8e8OcEq2d/yY3PvQmINstoz2IKoFU0lW9PhjfCjYVvvnoYM/Jc1FYzuutPFZD
         cBKNxXV4jop0t7VBYGxgjI+5qHmjm9JMLikwv2pTs9Zpn2pLVc6qGhBaGaxpNSwgQxB1
         7WIbbHmqZpNm6QOYxQyW9BsvgoWyQU2fPYM1boP6hQy06fdX1cGsrOxQW6SBWSqavsU7
         QADg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783670764; x=1784275564;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rYdv04oG7QSSqQZeIDnFcGqjfR8SCbXpzGryBIgOyyw=;
        b=HUrYd0Zdty0BxOJ0i3jFnwrgzcY7Nn4DRZn46AEM1rB05VnWmGhlRR576/dreS4WVi
         wK3Pnh1c7naNiW6K2Mt3gndsHSSfL6ulB0qmH50UFnvEXQ+rjYpSH4uoqzOs8+MWqy1W
         BXmbkz19gwV3bFt9AWLKPEQBVgK8K9/oIpWrZGrmmuR9CNHMZkKQJFDLiwwOi5sf3WAM
         vL3VHa0ii1EwxZ/G3SG/VxOT/UCMFEtp84QiX8xIoH3fUwhofPoa1wYtEd9+HHTNIHZu
         VRVRlv65l/n83oXn07j7RnLsqFQ91Zq40WkNGI+XKo/ewosSbQLTrI7e0MFENMB8w9Sh
         kq7w==
X-Forwarded-Encrypted: i=1; AHgh+RoDWHNnzrI4E1huQ8dxgwbCOCyxYpwGRUdIGwM1cgWx0/ORJVqS7m0/pN50b1vgn9QcBUA78s1r5EQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsONZ4pXtHTTKwH5Q0iRERTe9SdGaGmvi3/5u8MdMId8h7dZ8m
	1IeS8eEE0HpOabYmhxyGPN4aJQHqCqx30x9xbpcDCHwAHHCDxxCLjZ1wWiKctuPIsSGPzbbc3SK
	Y56NWk+QE3KKCj0DaWi9iy+Awnt2B2rAwXUsoBvhdfrce3sT+M0/tqS5roiNE7+wLCWj/H/61Pk
	XR6jGZtnAxxKfwGZAq0txKhidXnSFKyQwA1aEHrg==
X-Gm-Gg: AfdE7ckry2BBgD20Jr1nAdqohgNNq6XZgOiQ36G9W6The/sSUGI9m+wO3olOLxoCfF/
	t6gwZLlwU51EEIXmwBGLHlc1XnH85xBtgTTZrOrMqv/kToz7/amIvWsTJs0UHG5VTzbPWPj4iTk
	nL90gNQtrpPlblZS1zuwkmAOkwYClqovVJM5AGXnBvahtdBI/kohPvRzyI6K6bBZDRbg==
X-Received: by 2002:a05:690c:7:b0:81d:5b4c:f8ba with SMTP id 00721157ae682-81dc11f3df5mr81106767b3.61.1783670763740;
        Fri, 10 Jul 2026 01:06:03 -0700 (PDT)
X-Received: by 2002:a05:690c:7:b0:81d:5b4c:f8ba with SMTP id
 00721157ae682-81dc11f3df5mr81106587b3.61.1783670763343; Fri, 10 Jul 2026
 01:06:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701091226.7SWW4TrT@linutronix.de> <CAC_iWj+xDErhPeKGtsLK=nvPB7P8cQE3g9XCkaWf-d_j85FxCQ@mail.gmail.com>
 <20260710073147.XJAJbIwc@linutronix.de> <CAC_iWjLO3CAAFXE3s15Xcy3pWFK3ge5sWYmHHRBtcccKM2e1hw@mail.gmail.com>
In-Reply-To: <CAC_iWjLO3CAAFXE3s15Xcy3pWFK3ge5sWYmHHRBtcccKM2e1hw@mail.gmail.com>
From: Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Date: Fri, 10 Jul 2026 10:05:52 +0200
X-Gm-Features: AUfX_mwICOJc44DowSC3LE5i066PLHBu7IpKzk3cTcYCH17D6Iz-aAH1CV8bv30
Message-ID: <CAGgiveXyOGFY=gyn3ok0p7wtjP_1oY6Q9Jqa6fCYXrwRoNQ=tg@mail.gmail.com>
Subject: Re: [PATCH] Documentation: Extend the real-time hardware bits with
 some firmware bits
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "jenswi@kernel.org" <jenswi@kernel.org>,
        linux-rt-devel@lists.linux.dev, linux-doc@vger.kernel.org,
        linux-efi@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Clark Williams <clrkwllms@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Ogness <john.ogness@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=XOYAjwhE c=1 sm=1 tr=0 ts=6a50a7ec cx=c_pps
 a=ngMg22mHWrP7m7pwYf9JkA==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_K5XuSEh1TEqbUxoQ0s3:22 a=NEAV23lmAAAA:8 a=UXIAUNObAAAA:8 a=7CQSdrXTAAAA:8
 a=KKAkSRfTAAAA:8 a=bCoxK1dQaO2rIu0SeVsA:9 a=QEXdDO2ut3YA:10
 a=yHXA93iunegOHmWoMUFd:22 a=a1s67YnXd6TbAZZNj1wK:22 a=a-qgeE7W1pNrGK8U0ZQC:22
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: YuNeXNN8BqXlKSg_JW0rK-zQBVz03Efy
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEwMDA3NyBTYWx0ZWRfX/oJeJnjYH3WJ
 gYb/zoL11N46hNceHNgL0LFyU22/DQqUlx4HRxKqHcO6W89AzZmSJTmEepKXcej0SFuDCmHVqxe
 Pf0n2y8wyrEtVsifN/MVOCcuKvtdQJU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEwMDA3NyBTYWx0ZWRfX7wz/Xl5Edglw
 JUwhLiBr5lgFQNDxv0+gYic7+SpmZEPIMtrrQvWYA1xwV7CYgKynDQa5Vu/ICuCBccDliuXDEam
 8RupoTHYlajiDcOsxHej4Dj1bJ3CBpKLyPrS+jQ06zSvSZ2PW1udugfDaOYsFvM7JDdN2OMBss+
 DWfgcNz+W5ou52kWVEejt1vR+xJ6QZXeHNNsFY/aQLdU4Y5IGFItGtz6FChNma9ECh9JjpJDMky
 xv7OVS2FobX5Hwt2ec6gZPqMgL3qQFfdzPIEQgzeql4H/QayOKlH17lSy4xWdQ3Bw55J3p3Ky/r
 r8KOTM/CvVabSdWzElWE4RckxaYLd2CtUlkdEypvoX5GTmnaYLg3L37292/emJRjADDo5Wd+Ja+
 A1tUivEDn+3erg8M1zb/7udT2me4flBhw7XNevX539Oh3poTXWyI/R2I50uPeFHUnu+m/9WjIDh
 3/l97TCSLBQ02cBzPqA==
X-Proofpoint-ORIG-GUID: YuNeXNN8BqXlKSg_JW0rK-zQBVz03Efy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-10_02,2026-07-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 clxscore=1011 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607100077

Hi,

On Fri, Jul 10, 2026 at 9:53=E2=80=AFAM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> On Fri, 10 Jul 2026 at 10:31, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> >
> > On 2026-07-10 09:29:55 [+0300], Ilias Apalodimas wrote:
> > > Hi Sebastian!
> > Hi Ilias,
> >
> > > > +++ b/Documentation/core-api/real-time/hardware.rst
> > > > @@ -130,3 +130,95 @@ https://github.com/Linutronix/RTC-Testbench.
> > >
> > > [...]
> > >
> > > > +
> > > > +OP-TEE (ARM)
> > > > +~~~~~~~~~~~~
> > >
> > > That's RISC-V as well nowadays
> >
> > I did not find much here. Their architecture isn't the same as on ARM i=
s
> > it? But the overall concept is the same, right?
>
> I haven't checked the IRQ vectors on risc-v, but I assume they have a
> similar logic since that's an OP-TEE design decision not a per
> architecture one.
>
> >
> > > > +
> > > > +OP=E2=80=91TEE uses a global serialization mechanism (the "big loc=
k"), ensuring that on
> > > > +each core only one OP=E2=80=91TEE thread executes secure=E2=80=91w=
orld code at a time.
> > > > +
> > > > +Execution flows from the normal world (Linux) into the secure worl=
d (OP=E2=80=91TEE)
> > > > +through the secure monitor at EL3. Linux and OP=E2=80=91TEE cannot=
 disable or mask each
> > > > +other=E2=80=99s interrupts because both run at EL1 in different se=
curity states.
> > >
> > > That's not always true. It depends on a combination of OP-TEE and TF-=
A
> > > configs iirc.
> > > The most common though is that IRQs and FIQs are directly delivered t=
o
> > > S-EL1, in which case OP-TEE can mask IRQs.
> > > There's also a difference between GICv2 and GICv3 in the way
> > > interrupts are delivered.
> >
> > You are saying that OP-TEE can mask Linux' interrupts or if OP-TEE
> > instructs TF-A to do so (via config)?
>
> OP-TEE can mask Linux IRQs

You can find more about interrupts in OP-TEE here
https://optee.readthedocs.io/en/latest/architecture/core.html#interrupt-han=
dling

>
> >
> > > > +
> > > > +Architecturally, the secure monitor can mask or reroute normal=E2=
=80=91world interrupts
> > > > +before entering the secure world. In a correct OP=E2=80=91TEE/ TF=
=E2=80=91A implementation, it
> > > > +does not do this for the duration of secure calls. Normal=E2=80=91=
world interrupts
> > > > +remain deliverable, and a normal=E2=80=91world IRQ will preempt OP=
=E2=80=91TEE via EL3 and
> > > > +return control to Linux.
> > >
> > > The 'sane' case is indeed where IRQs are delivered to OP-TEE which
> > > exits back to Linux immediately.
> > >
> > > > +
> > > > +Secure=E2=80=91world interrupts (FIQs) are possible if the SoC rou=
tes a device's
> > > > +interrupt as secure. Such a secure FIQ will preempt Linux immediat=
ely, trap
> > > > +into EL3, and transfer control to OP=E2=80=91TEE's secure interrup=
t handler. Linux
> > > > +cannot mask or preempt this. Secure FIQ handlers must therefore be=
 extremely
> > > > +short to avoid introducing noticeable latency.
> > >
> > > There are also 'fast SMCs', which run with IRQs disabled for their
> > > entire duration.
> >
> > can their be distinguished somehow from normal SMC invocations or is
> > just a consequence that the secure monitor does not enable interrupts
> > during transition for some of the "functions"?
>
> They can be identified. There's a function identifier defined in the
> SMC calling conventions doc [0].
> Bit 31 is always 1 for fast calls and 0 for yielding.

This is a calling convention and is not controlled by hardware. There
are exceptions for the FF-A SMCs, for instance.

Cheers,
Jens

>
> >
> > > > +
> > > > +The transition from normal world -> secure monitor -> OP=E2=80=91T=
EE and back introduces
> > > > +additional latency due to world switching and context save/ restor=
e. This
> > > > +overhead is typically a few microseconds and usually remains in th=
e noise
> > > > +floor.
> > >
> > > That's correct.
> > >
> > > > +
> > > > +If the secure monitor masks normal=E2=80=91world interrupts during=
 OP=E2=80=91TEE invocations,
> > > > +or if OP=E2=80=91TEE uses long=E2=80=91running secure FIQ handlers=
, then OP=E2=80=91TEE can introduce
> > > > +measurable latency spikes.
> > > > --
> > > > 2.53.0
> > > >
> > >
> > > Overall I think this is worth documenting, but infortunately there's =
a
> > > wider range of configs and corner cases we have to describe.
> >
> > Okay.
>
> [0] https://developer.arm.com/documentation/den0028/h/?lang=3Den
>
> Cheers
> /Ilias
> >
> > > Cheers
> > > /Ilias
> >
> > Sebastian
