Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792598916;
	b=kZWL707JsasHCFd6bN0pcHjFh3su+6niUFexHEH2PLchou8k5RPsmz1tlfe3mYShbJdF
	 j1xVRMPacOP8Y86q5Q/2Ss+cq0kGPd2nvXsGIfrqRGeR5MTFlUtHBujy0KhnxtaOkO14U
	 +LvV3DIxnlsEf/eyRxGCzJVq3pkwkQKuYmEuZ+ZP0QIHIOkgol/MuClyOYd42kufomydL
	 4NC32rq/dEQReZus2jWHuAolzBcNhKAG0BRYcJgjAdtOb/Y00kkF9KvYXgDskLK7TSdpr
	 doCWZaSvs5bAkZTodXDpyP083Uzf40eHpL4/KA6pNo6ZIyRHvIhxeg+/4J8hwenbzyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792598916;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=xpcFx5Tgg5MtNBAEwITPf99dESr1dNj5mhlvVGEZ9HE=;
	b=DsRbib3PIS25N5nDkFDbe91Lvibu3aKXh56Mb7ywXuwygu+L7GUVkljR5FKWrZQVTlE0
	 /6vFOJVqVPsfT+QpzzdYpC/lf+FLSa1/RiY5v7r8Ctdscwka1EFBtUc7btaaHr92uiQ6w
	 OoRSZ1EtE84LGw7Fgkngk7VFunYgjdEzgy14eIUm05pIbaGJcc2c0b1ggtwn9z6hbg2yL
	 k2M9jFEO+4/XhuSvTMLDeojTlYLCHV3sukzZsC0t8P5yjzdSiqs/ogdYhgNyQskZG32Xj
	 t/M/FvbS2KVtKg+bI3/zzUksyO+Ikn2VHfYw6IS4i3mAlOFelQi26U6aa2H136B94vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ppsqazaf;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=AlgG2yKd;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F283606A31B
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 16:08:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F283606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ppsqazaf;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=AlgG2yKd
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFoAXK524161
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 16:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xpcFx5Tgg5MtNBAEwITPf99dESr1dNj5mhlvVGEZ9HE=; b=ppsqazaf3z/Ovnn1
	SzWOwFC6FBH4fWPIj1FFpw1+MfbxoKTpq3L+dL3Z+e3w7356YZ6RysSOxUSlT+jE
	QJ63VeLe4fC9YoZU8/wWjZGfXODKSBwllcZGiYbUnENdNs5V4JoZtOO0xT0uHd/I
	xWphiIy5SHHmhNox7zwzrK2Vqs+UWLy3gU0nXuyduCWSyhwAtJrrWHEuN+VRgTMm
	hlzoca2KU2LPeFWWVXhGFOSPOe97rBtnG8yGmM71Gq6BNVbN2C1Iwmwrje5lGBva
	VCVasiUkD3EzsCgdmldMxwRAjdIFHG23zVG5vKxeMRaRrlso7XF2npL2q3GBF2Sc
	GdYlJQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf0cv02q4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 16:08:35 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cca35cf9f77so449528a12.2
        for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 09:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792598915; x=1793203715; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=xpcFx5Tgg5MtNBAEwITPf99dESr1dNj5mhlvVGEZ9HE=;
        b=AlgG2yKd9rezGDoVAK8tHC1EbYhTk2vdFncR/cM32rw1R4Kg3pGEJ0vzzMUUx7am2N
         86uFG8yz6c1dkLP+e0mlLOW74Aii11LwnHh6fizV8MJzmvSB9foYSYt7B6+SfKXOmlOU
         Y6Cd4lU5EU+M/yf9x4qe2bkTw4WDOkMAUJHSr6XLAbH8+Y8BH17FStqqZhf/2q8FscJw
         cB+wBWGPasCxLlurN9xiTMFpKGvWaFBONYji6K3D+LV/lFZp1gWdKI7v38J83C01YMr0
         gyz0RChxfsYPVwnpEgXAWOU5LDy9m3J/wYoFEU1tDek9N9ZCBN27nPim2GM+ANVs7qIi
         W2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792598915; x=1793203715;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xpcFx5Tgg5MtNBAEwITPf99dESr1dNj5mhlvVGEZ9HE=;
        b=YJZMGuZVHJQeTckpP1Jxv1mDl6ikOOlqzJtM5KYVH4swQm/sv1udEOyo2Ztd7nxz7S
         AyiXY6QEjQhAE4Rw3VI4M/ARW2sCs04FVKTBWLeuBteQ2u0f9YKuBH/GkNz1cEKmLhlr
         K1Jep+Tl+B00hQpBP0/eKhgzKE0jG8wXfrQs0749wfrqz5sWJOSdDy2MWPl7XiDv0qXz
         eTHktwIBNc7y24S/QIGPcwSe7mh7K6s0hKNk4aFnS2xlQU6Tao88xx0XK4Eme4VuVAft
         lebTSSAKaIDQj8jAsJtFkIs2Q5pLdvUt46sY2FiuqmPhEiK/ZjSXHupAqB8wW6UnnmNp
         YmlQ==
X-Forwarded-Encrypted: i=1; AKwUvBy/Aelb8eVMEGzFaFoMgB49XVBpzU7tOkzx10IGGRGJajc7TKd+GH3hkH2XWX9P7+R2BzqO1v8D5Ks=@vger.kernel.org
X-Gm-Message-State: AFq9FYJJ+sE95Qm8nxD2r6XH/zS28BKUPpiAKmDL3TddhEDi6/L2Ar7K
	WTo5JOIzS2AwOXBo1r8d8a6OUwBBx6cHiz5bcQj9QHcXGcioxfgSXnmzo4gHCBeBooEgC1obniF
	lvu6F2z9ZBM1yoTJyZXQEARXTQjhHAVBv1HviBKpg6vy+H+7Jsu7toOIzxLr4GqE=
X-Gm-Gg: AYBFou0+CjBJkmmozzGYP6SJlcFMqpi37L6DyIga4Q536N+LGPCkGylI7OZGpketgJh
	1aqP9tJ1rUcdZF4Sztuy1kXW8PZCxAL28M8ACH8bcoJ9X0Ysysne3cAJmsWsNxFTXCfktTaC9E5
	qi9d9/4eBj5QDQPuwYdnTD5TvlyHIhzBZ303i2fWxVJZH6b+BtBIns919TDzcoS1/+kGeYF16oq
	hJxk9tNPs+WXITc+CWSCZj90FmDlt2KYMeD3mYi1bRLQn2qIY3EoRHvOHlDPT0T5kzv0guU7rs2
	4A9YfuKfZtOMi2jmtYo7edleqPKue8MHAm1eO8f21ysHgCSgqQnDAVpbzgh40J6d86dByryYJsT
	vcPL5JXw0xhIJ465JD6yfe16LljDwUGCUkcoQVXE0Vg==
X-Received: by 2002:a05:6a21:3288:b0:3e2:2b76:bf23 with SMTP id adf61e73a8af0-3e287eda189mr2084253637.68.1792598914751;
        Wed, 21 Oct 2026 09:08:34 -0700 (PDT)
X-Received: by 2002:a05:6a21:3288:b0:3e2:2b76:bf23 with SMTP id adf61e73a8af0-3e287eda189mr2084221637.68.1792598914240;
        Wed, 21 Oct 2026 09:08:34 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd6b861c7dfsm188964a12.25.2026.10.21.09.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:08:33 -0700 (PDT)
Date: Wed, 21 Oct 2026 09:08:27 -0700
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
Subject: Re: [PATCH v2 03/15] efi/libstub: Free cmdline_ptr in efi_pe_entry
Message-ID: <20261021090827.000078b8@oss.qualcomm.com>
In-Reply-To: <3-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<3-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
X-Authority-Analysis: v=2.4 cv=NrRE4MdJ c=1 sm=1 tr=0 ts=6ad8e383 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=Ikd4Dj_1AAAA:8 a=EUspDBNiAAAA:8 a=gCM90IwNaqpJe8xd-nwA:9 a=CjuIK1q_8ugA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-ORIG-GUID: R0FWaq4yCbh73IPzlxzAHZC7NCQ7xdF2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2NCBTYWx0ZWRfX5qd4rLTtAv+a
 8pBlKZN+QFh/YjOxP3dde4uDJNs3rBnpzixEE8ZLzXQ9fd6unuHn5nHgwV7FyTM/8DltPfKZSgx
 GTTDRCuuvN+VLTn4PV0zQIfbA3ghYX8=
X-Proofpoint-GUID: R0FWaq4yCbh73IPzlxzAHZC7NCQ7xdF2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2NCBTYWx0ZWRfX3tBYxyJY+g8s
 UaIeXwSNcOqm4U/U4D8B0krNdtVnIpxweONrdzPIu+Q82bIi0/SnFUjZH1pwULSGsn6Gdj5TOeh
 jECr4Vs/LneTnCWYyyMh3tvh7U+TzgzRSWGXKaHK672DYLv5/2tXC2HEhXnVOTxCbeEL9toy7F4
 2Go75+e+9BGir577wcqw/NEv2IBq26wDoW/URjjgcaqZt3TYJQevfua7jCuhCtj9GF5QkGyqpuk
 TwskHvLR54l89EXJdb97NmEsUJ5BGt7CUlwLiuzBaVlzrnJB/c/deD/NUZYukZnDVAC+rDU4bB6
 HkIaHIgt4P3eyo8H4J3/Piz233zYuSfSz9WCfI42AAiBeI1BpIwy4ih1gpBwUHxI0Imt7RqyYsX
 SY5CTEv27C+qaB+G3IQTgSo41gy1bKXCuaRm5DtQWTnUvcOQ1TRru+tuU+ykvvUISQejQtacBnk
 4yP2upufQ+tyMxL5AAg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210064

On Fri,  2 Oct 2026 20:31:40 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Sashiko points out that efi_handle_cmdline() allocates this memory and
> hands it over to the caller. If efi_pe_entry() ever returns it should be
> freed. Add a __free annotation.
> 
> Fixes: 42c8ea3dca09 ("efi: libstub: Factor out EFI stub entrypoint into separate file")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Seems sensible. 

If anyone has more time than either of us, I note the efi_handle_cmdline()
use of __free() should move down to the point of allocation.
It's only a couple of lines, but none the less...

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

> ---
>  drivers/firmware/efi/libstub/efi-stub-entry.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
> index aa85e910fe595e..fc1282fb442e71 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-entry.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
> @@ -40,7 +40,6 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
>  	unsigned long image_addr;
>  	unsigned long image_size = 0;
>  	/* addr/point and size pairs for memory management*/
> -	char *cmdline_ptr = NULL;
>  	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
>  	unsigned long reserve_addr = 0;
>  	unsigned long reserve_size = 0;
> @@ -63,6 +62,7 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
>  		return status;
>  	}
>  
> +	char *cmdline_ptr __free(efi_pool) = NULL;
>  	status = efi_handle_cmdline(image, &cmdline_ptr);
>  	if (status != EFI_SUCCESS)
>  		return status;

