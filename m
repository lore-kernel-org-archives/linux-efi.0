Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888FA3E1208
	for <linux-efi@vger.kernel.org>; Tue,  9 Jun 2026 08:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780992128; cv=pass; b=mFctr1Ur4u2ReZdI9qo4KZ9NUabhCncChum+KShpI0nYfl0HcsEqYz6rSlWgfzM3GnFPAirXlCW0TX+S8ZaYonNhVUZBjLNQCakcppAtEsSSImBPOpwXmifEHiw1RINoh94sOujoKZ3brzXEaj2XxMcgPt42yugwNFKIa+1dTSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780992128; c=relaxed/simple;
	bh=+1EOZR2wB1otcZ/6xEuFv8g9neuOi9MSaHh/ECdDfgI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TDe+BhJta8QGIMk9Ow0sOQziWNnga0sL5ghAKrNZiBSJzAsn9/9Hl7JOYWB7PDWavbQUyK5KJ9CNMmOIct0XX5GJCHvCQv/eJD61E1+maZt64+db7W36nnrUagBmhXyuFtewHO6VayoRUAtBALeIWw8O+lRtd9aWsCYpuPZP1PQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=L46jW91n; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FQEeiAKN; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="L46jW91n";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FQEeiAKN"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6597raSh1923149
	for <linux-efi@vger.kernel.org>; Tue, 9 Jun 2026 08:02:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=ppbxYWmUe+n14dBjJKXE7EunGdgOizVvORmJjhi9sIQ=; b=L4
	6jW91n3danqpMZpLno/pXbgGWSanIfmO9hon068Tpnm9qha7YtcdgtUzxQJoyeYg
	RWTBu5aL53Flz1LEpv5Rygv6Q2Ra30dpOwmmC2GHNZ1pb/hVJCVKGKbhKYN0RNra
	CUenh4IG4t2Fe+PdEeZ1oZZ3R1Ve2CtA/UVCtAYCrbsuuoI2FmP/S+7rdgETGz/j
	7KksS3/qVrZX8vSzYARaeFDUe3TgFThzKaUGNMWM2DJOCJUOD6PyC3W+h0x6cgPj
	hE9I05HmCv/r0kpqpEb9uvq81wreomdAmQZhnkgVanDQ3qc4qw6tGaLprPO7dZXB
	U6X/A5CsUnA3KoCQID7g==
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4epee4g50a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Tue, 09 Jun 2026 08:02:06 +0000 (GMT)
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7ebbaaf1679so102779767b3.0
        for <linux-efi@vger.kernel.org>; Tue, 09 Jun 2026 01:02:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780992126; cv=none;
        d=google.com; s=arc-20240605;
        b=gZ3jAx/KtxY42WSyJ7U3mliuG6Ve1zKfdUFCTtI7nWj5GAWs9zKbg/KPhH2aJQZOQj
         VjvRmDVIpvOL1Vkd87I5crNu5Kuqk/+wP9H6Af+BrR7tgLkh/ofhztjEMeB/JQTAlD08
         z0ogHRsnPpYPfNv4W8bcgtUtaysEERZwPFqQS5vPqHzCdaZN1seIpTDsk57NeV2xqnr/
         1QNGE8FuzTMUWLHns1kXDBpiyBZ2D6a2bPo94gERKOCqa2nZ/vCYd37Isl65NYX5h9BA
         2QZ6bD4a7pszi1Y35MXe/+ep8vAWX2/rKilmFJfohTKj3tqkMdpTi8mG93GS1DttF1DL
         swbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=ppbxYWmUe+n14dBjJKXE7EunGdgOizVvORmJjhi9sIQ=;
        fh=6+vqWtx57LJvoBEk3rF3cJ6yo5eEve/eXiIzXZqe2lE=;
        b=DYbGvtgvg+G1xxdbPa+hpjOSTUoKCLOQZYsdycxwULbB1uRyG8qxBIXfEFPllwt9SH
         s7y91j5MWOrbHg5UWJiNU7PmMFkPQTMhoYVE6fR1lS2jEJScjWk9KV4rZNXs2y62eOum
         WSc/g0TFrfBu/Y5rg+FCyNzT+Mu8eiMN4oURznKzFs8iapO8uu6D/xQ5l6gQFa7MkCbj
         Vn7yhclV6SzU9AKY0s0dxBkHAtkGdIAaoEH+/pbH8GYBO66frZmMQOzsym15rtjRNvvz
         N+BdONcxMpqslVlyIJVkuOanfdTlr9gm2/bE6s306/n4xbfLHF5yr1ejs2t+d3QiWg7V
         Ejsg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780992126; x=1781596926; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ppbxYWmUe+n14dBjJKXE7EunGdgOizVvORmJjhi9sIQ=;
        b=FQEeiAKNui0UwrJgGnMiUfl21t/I0wYLJ8jNW3v7/Tg4m4n7ZmXw4YG0/gMltvPTYn
         t4AeMdeVRwjxD850aA7MEI6XgzSxJaU8qvs1o+Tvz0u3XPP5iHJbIIttJOyzOZ7XkBy+
         RWK32vFimOJA0uiYqmc7z/XQ5pHZayTstKZgRyrE0M1pY2ZrET5iGF6se754rpE23cAE
         qckt5+ypAne3VKytbz9TWBQoV+lD60hjFRDT5Uj5USFrNWV9mWPUSeXWslt0xQH+3Atq
         DIemziy75jj2YH254fyxqf4yZytyJXK7K/7zJYO2VubhTQEVSEXjffcZlFRGJ0ann9I7
         JMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780992126; x=1781596926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ppbxYWmUe+n14dBjJKXE7EunGdgOizVvORmJjhi9sIQ=;
        b=U1hYCHJqQpaWpmHBKuNwYRQfJcNH0DapBj0rGj4gRATkgSlGl6RbgKofDLpNd0aj4Y
         plFFantxIi4A1f0aACHpNyXMOvYJKngDxjHtudBpZfK1/iQtiN8kWSAsTqJEB3P0u8fC
         kdsNZKabcWWmSvBAW6zTuarN5kBo9OzIF/V5C/r0sZ8AMHEdHW7NKSNPxwlU/aD6zCUv
         /NNn8G28GJZ3hAXl8q+0mukxO7SNfId4FCJPCb04/jc3btQHDVeB/NoXt0tjLU4n0XlZ
         MlXL22TvkDf6wBysqMjMv4TCWfYwxLF0E0WqAqO/XcIuAYt1ApMvrIIjGOrKzRhvpXft
         yRSQ==
X-Forwarded-Encrypted: i=1; AFNElJ9oynmliffdjTasFRHV3VejwrwsCKtq/+izXQIsCCoMMXM70FUaRAY/BhYKDeZ0XOuBleM6gbClYWg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ+QtFCU7Jz68JIk8JUFT6JxpAexRHTevs6uPHga6/jNYGALjY
	4HStCAPor3XC1zfrRX7MUzY6RPERAsN3mlu7zTIyLd7QelDwEe42kYDbyQ4dF7Z7ITOx7zFTLsQ
	Zt+lyK1SQvrU6GsZwNcG+ymMfn1kZWE/+RUfng3fbo2Ud6nNpqw9qtUpqd5jWyyWYs14nACdIbu
	pXsLvRo54wJs1SvmyTLOEe9TED9ujF8J7MjvXWeA==
X-Gm-Gg: Acq92OE+/SDTEcpowS5uqxmfsjOASAbZlBEaE1lh4b7uqKGJv/JUgyVv9iZjKzMERJx
	7LzShVCJLI6IVDyAJsfh5kWV88cCQgiFUDiI1Ak9i61PpBdohsQ7ZU01qhiVZqIf2SLEyaXpcdN
	bDOaID6xar/NeHb74c1gKCr45lMnPQ2AJUFDCAvVr70qeJUc7/lvyyXuP7a060CNfL/Lt2aTic6
	DMjfTblI1YyVI35yQ==
X-Received: by 2002:a05:690e:4144:b0:660:a653:4495 with SMTP id 956f58d0204a3-66106e01386mr16440738d50.4.1780992126059;
        Tue, 09 Jun 2026 01:02:06 -0700 (PDT)
X-Received: by 2002:a05:690e:4144:b0:660:a653:4495 with SMTP id
 956f58d0204a3-66106e01386mr16440721d50.4.1780992125662; Tue, 09 Jun 2026
 01:02:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513084325.2176952-1-himanshu.chauhan@oss.qualcomm.com> <20260513084325.2176952-3-himanshu.chauhan@oss.qualcomm.com>
In-Reply-To: <20260513084325.2176952-3-himanshu.chauhan@oss.qualcomm.com>
Reply-To: sunilvl@oss.qualcomm.com
From: Sunil V L <sunilvl@oss.qualcomm.com>
Date: Tue, 9 Jun 2026 13:31:54 +0530
X-Gm-Features: AVVi8Cdab09nLFiWsiig7vANHBJNBVR0v6HSRzUvHph-SxzBxVhm2UenvmNafPY
Message-ID: <CAB19ukExADA6W1pXDqVdA13BGLrtbG1nkfNKVwKyCd4yrNtdMg@mail.gmail.com>
Subject: Re: [PATCH v4 02/10] riscv: Define arch_apei_get_mem_attribute for RISC-V
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
X-Authority-Analysis: v=2.4 cv=PIs/P/qC c=1 sm=1 tr=0 ts=6a27c87e cx=c_pps
 a=g1v0Z557R90hA0UpD/5Yag==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8 a=lDU5pCILgqd7k7drH44A:9
 a=QEXdDO2ut3YA:10 a=MFSWADHSvvjO3QEy5MdX:22
X-Proofpoint-GUID: wzMgBC6aYNo1GzN54xEozfQtxFpk93r1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDA3NSBTYWx0ZWRfX+cqNi6+by/YE
 BP/j34+TmWASszpxnrL2OCF0JN6QeV4SHxMwid87+o7WyIXLhXfaq1k630ZnoFiKLrUYApB1iaQ
 dUdT4cx0z3nG24djJx+GUOlZ/llUWrgfDiiiqO1xShedvJKCogiEJOchVMh/VnuSyNKzVKOhyK9
 PdLylZuezGD4WRYkuH/uRNLf+vfOX7sRo1Bggm/o/LcAz1K+lZb9/jCVqJAYQGayMFI2st8EA/g
 MZUX85ZM/JH6k404kTaEdv6OWWmTZII6M1ehbYoFE5ovtFBPFioREo4YsQmqpoV9OkLSERgIey5
 fDb1AEClP65UbxiL0vxNLtOP1v9iLyTA6et1o/AIyanMAssAEHnfcKmDkFmJMnXYoIjEtxYzwze
 FmA3Ru5TFYHD3p/KIHdqRgjfiLq4OA6zc3Q8Gy+e2+1hxRwmXysMHJADqxNFAcBKqtCvY3mkC7s
 HYQOcTgh4Pp2d2udnvw==
X-Proofpoint-ORIG-GUID: wzMgBC6aYNo1GzN54xEozfQtxFpk93r1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0
 clxscore=1011 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606090075

On Wed, May 13, 2026 at 2:13=E2=80=AFPM Himanshu Chauhan
<himanshu.chauhan@oss.qualcomm.com> wrote:
>
> ghes_map function uses arch_apei_get_mem_attribute to get the
> protection bits for a given physical address. These protection
> bits are then used to map the physical address.
>
> Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
> ---
>  arch/riscv/include/asm/acpi.h | 16 ++++++++++++++++
>  arch/riscv/kernel/acpi.c      | 12 ++++++++++++
>  2 files changed, 28 insertions(+)
>
> diff --git a/arch/riscv/include/asm/acpi.h b/arch/riscv/include/asm/acpi.=
h
> index 26ab37c171bc..c142db9f81a7 100644
> --- a/arch/riscv/include/asm/acpi.h
> +++ b/arch/riscv/include/asm/acpi.h
> @@ -14,6 +14,7 @@
>
>  /* Basic configuration for ACPI */
>  #ifdef CONFIG_ACPI
> +pgprot_t __acpi_get_mem_attribute(phys_addr_t addr);
>
>  typedef u64 phys_cpuid_t;
>  #define PHYS_CPUID_INVALID INVALID_HARTID
> @@ -27,6 +28,21 @@ extern int acpi_disabled;
>  extern int acpi_noirq;
>  extern int acpi_pci_disabled;
>
> +#ifdef CONFIG_ACPI_APEI
> +/*
> + * acpi_disable_cmcff to disable IA-32 Corrected Machine Check (CMC)
> + * Firmware-First mode. It is not required in RISC-V architecture
> + * and is present for compatibility
> + */
> +#define acpi_disable_cmcff 1
> +static inline pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr)
> +{
> +       return  __acpi_get_mem_attribute(addr);
> +}
> +#else /* CONFIG_ACPI_APEI */
> +#define acpi_disable_cmcff 0
> +#endif /* !CONFIG_ACPI_APEI */
> +
>  static inline void disable_acpi(void)
>  {
>         acpi_disabled =3D 1;
> diff --git a/arch/riscv/kernel/acpi.c b/arch/riscv/kernel/acpi.c
> index 068e0b404b6f..7a6770697999 100644
> --- a/arch/riscv/kernel/acpi.c
> +++ b/arch/riscv/kernel/acpi.c
> @@ -204,6 +204,18 @@ struct acpi_madt_rintc *acpi_cpu_get_madt_rintc(int =
cpu)
>         return &cpu_madt_rintc[cpu];
>  }
>
> +pgprot_t __acpi_get_mem_attribute(phys_addr_t addr)
> +{
> +       u64 attr;
> +
> +       attr =3D efi_mem_attributes(addr);
> +       if (attr & EFI_MEMORY_WB)
> +               return PAGE_KERNEL;
> +       if ((attr & EFI_MEMORY_WC) || (attr & EFI_MEMORY_WT))
> +               return pgprot_writecombine(PAGE_KERNEL);
> +       return PAGE_KERNEL;
> +}
> +
>  /*
>   * __acpi_map_table() will be called before paging_init(), so early_iore=
map()
>   * or early_memremap() should be called here to for ACPI table mapping.
>
Reviewed-by: Sunil V L <sunilvl@oss.qualcomm.com>
