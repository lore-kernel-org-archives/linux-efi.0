Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383B6453A54
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 22:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790289763; cv=none; b=hfiW4cHFZ9EcbJ4DHxKNn8poepppJOxq3p1nIhonj8k4j4SzNhw+iow60aocyIjyzUfO8icjwpmrDE44T5j9MyplqVEp/33Q+gYaN+Tfh78/aTZESslE5EfKkksPp1teoHrQ0nG2usL4u4mUJD8axnpBPGMStAJyY/xidqMUD4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790289763; c=relaxed/simple;
	bh=2G1FOvOSJrV6/l8sO+qjbSBFUO9X0CWF5KTVr1JnZkM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q+BoumGHSDs1yVT5Gq7P1zyijzPLaHS9miXln9HzepWACRMx0YjqMahe6JW3IBknNRKgCtx5E0nYcx557I6KCZt7YApohtfCmAaE5fpnJejqyd86uA0mx/ec5/QmyKXkKVtX7xVOlWlpg5h/Kg1Ns9GJwwWoRDVmuO01fCYwppE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eaJiYBco; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gG3maEZM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eaJiYBco";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gG3maEZM"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OMOtCt2766792
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 22:42:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	81QaywXThCj9GvWcrqbFC8hrrggxf6pFQEEvB0A8Stc=; b=eaJiYBcoVJ7qevSl
	dhfq+tXf9Yrht/mLq/jwiRTObIgOPPAp4gq7bt1mDqjTW0V6kXIW+8178jTvvqEY
	/g72Tu5uLFr9TmxDOZ/WTOw4Db3jptMoLUpu03x0RYDq28zhhqtQH8+V6kNLVLAO
	1Ua+MyDrNoK2wgREaJE/EZogzihYwOq1s6HaLVkWSmzeuJh3HKsCfCtwvHP6+Jd8
	ENol9vchyHUhmq3K8SCqt3P2t3zGBv8XLggSyAt3yjEQk8zBoVPz6YK9sKvOoTjx
	qeijDJMaDaBEWWHG3mt12b/Lo717uv1T508Ea2fRW/yjOhQsk+HBOm2Y6914Juvl
	Prcy/g==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw94k8tme-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 22:42:37 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33310847fcaso426106eec.1
        for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 15:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790289756; x=1790894556; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=81QaywXThCj9GvWcrqbFC8hrrggxf6pFQEEvB0A8Stc=;
        b=gG3maEZMC0pbufO8LL5QOq0FfxjoTxszo+qJRi0KYCzyZCnePkWLIQGKfUtcl/KTdQ
         XjIIP4d1fDStjCZtJK9dsFhzYqlQfBj62tM06gZ9fuECG7YBftIZ78IOog6jWcOcuiSo
         /5mMrN9O7ofxmffmpI05i4EMNqB9IWBf1KgF6KIBYQro5JMrRozz7UdnFaUUr3VsbfBW
         kCvnHHspLUSOy0tdNscpUYBF3SKsf958SmJCMRsUDNlDI/GD92uWfL4eXPW4W3XFOfpy
         82xm6J1T77jrZruDN8xxqCS6SIJD47hkJXLXaWxDaaBoyb9FmZtoNxk4esbVzM6dqf3l
         1mQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790289756; x=1790894556;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=81QaywXThCj9GvWcrqbFC8hrrggxf6pFQEEvB0A8Stc=;
        b=CnJcsqP1ynJgDIdqzdXS9aeb27QnJ7ZDk3p4cQxnGr96jRBAqFktRPU6epHiPEckgh
         Kl/cB67lYdO/6SgE3E6bCsUYolpR/b2IBa7nUAcJg8O5yioN4q7AYyTVQMxEg1Q+ilwu
         D4fOtlh28jeD7CEvEK6F9NJW/JSSpv4H7PlFV0HZthySQde/noRj3HAVCLfQJXGK1/ja
         IHu3eAvsoLNTTn0ChaCmY4ReAZcdH5ie2f+x/Cespc5NhADtQvdRoKtlsAKb/460wLv4
         CK84AzTUG0VE7QLuRYhl6ZCzH49UCAiH3sImvT480a4ZjGVoFIfbL6UvffMOpeNzkOQD
         w+PQ==
X-Forwarded-Encrypted: i=1; AKwUvBwMWOqI9wjfxp+mX/RRKJ8wCSMZPjSiVNvYq+a4NcQiPc/gCWcr3juhGYxrBZatA4my0CoVNWddXFc=@vger.kernel.org
X-Gm-Message-State: AFuF++kq2J47w5490zyg5rMbSDuJB3JijWjlG5wD9TBgHecit1ZGZpl3
	rvBL5FafYvERsAV0FrEH/5RoHKEFlqm7J5mxvWAuQOPnCByURBZ5hTu8iy9q2nfpbTR8LCg4UGc
	WsW4OsfcZILajxB07EGRWWsFmvIGFq2aWXsuPS7dlnhArgJR3O/4dx49NUfIPN2Q=
X-Gm-Gg: AYBFou3007E7kTj1MTb+jblYGvtib7KDaCX+kpjcjeG4e02MLEQ2fnpFnWNG8oyyas6
	CsbvrIStm4BMnNIX/WICnsfvpRrH5+6CUcl1jk8uGSBego9/Sd9VPZUabTDOz2PVWsPPa+QjNF9
	HWzUY4XWN2LUmC+MawrBDolVe0AnjcIit7pFQL9We/E8GNuo8KD5YnB3R3Mk2qHnWy2LPo7TK9D
	rIfGZywAtCxWhXqbSnPI+FPD3jJJrKXM5Wc+Rueub8mF+rgaxBD+6lOE5GiruLnKoh2YfJTNK8k
	RAUeDkAZOktUx3kFtg5HlRhFXkkSbckkE6fDtlfgT8jpibkY9LOQaonvyx7tHdfX0M6KY1NqXc6
	jBjJt1BXJrB+QsBwlCN9VT/udYFMGM0OwLZFybRqU/xicj5tBmPCMKA==
X-Received: by 2002:a05:693c:601c:b0:341:4f3:8f84 with SMTP id 5a478bee46e88-341973cf3cfmr120999eec.13.1790289756368;
        Thu, 24 Sep 2026 15:42:36 -0700 (PDT)
X-Received: by 2002:a05:693c:601c:b0:341:4f3:8f84 with SMTP id 5a478bee46e88-341973cf3cfmr120917eec.13.1790289752160;
        Thu, 24 Sep 2026 15:42:32 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34145d0fc9fsm1538764eec.25.2026.09.24.15.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:42:31 -0700 (PDT)
Date: Thu, 24 Sep 2026 15:42:27 -0700
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
Subject: Re: [PATCH 01/16] efi/libstub: Fix error unwind freeing fdt in
 allocate_new_fdt_and_exit_boot()
Message-ID: <20260924154227.00001cbe@oss.qualcomm.com>
In-Reply-To: <1-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
References: <0-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
	<1-v1-27d06b313981+8b-arm64_drtm_jgg@nvidia.com>
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
X-Authority-Analysis: v=2.4 cv=aaj0Dhot c=1 sm=1 tr=0 ts=6ab5a75d cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=Ikd4Dj_1AAAA:8 a=EUspDBNiAAAA:8 a=7U2iMG9xLqzP7ZOKqLsA:9
 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19 a=CjuIK1q_8ugA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: 0TpWhZIZudnbDtJXayd7rmcReCAETWj4
X-Proofpoint-ORIG-GUID: 0TpWhZIZudnbDtJXayd7rmcReCAETWj4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA5MiBTYWx0ZWRfX4QEVkyK599q6
 1KQZ7Qqqadr9mVHlxIf7KQw+HZlHz1i4IfnlShKnvs0VrwWyxoFJ6Y9VIK9xI94c923ukg34H/1
 5dJVRsvlp/vz+c8UDhycZt+n+yyIgQ+uBCGdfI3TZgyAE0phK9XF6poPLJcAQaei0KUvbxp6t04
 153dkNAR5Niydos7X2Zk2mUXWSqTRG3eDBrzaWj5YouM/MQheHADCc91UamXLP3C7bCY5vlfq7n
 noMRB5hYvfWN4K3tykY5XC183RytCzsRoCIUsSEIbX2Dv2OMrpQlNPTOI43sC2xQPmikfo6zr0I
 XmJgKrSsXRfdKWuYh1O0gCAtajtuujKHRjj5IJLujjhDkw93rofYbi9g5w41zTJp78xalwqJt5D
 VEY9KpBovwvpWJc01c+J9UY6YvGPctw/iMsOJUNYBLpH+THlr1OoRfL4e6a/WiaEemzdB4qLc+i
 89z25CrfRMAVOHfDDFQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA5MiBTYWx0ZWRfX9Ui9cLjwAzGX
 AxXjgHHtoisXIknZW8ktjEaG9i/wK/xUv58RAycrP/G4UdTr/5tgz0pKL0KpfvYv6V0lFGc7NBx
 KgP/O8Zbup5acj5kcS4nK2tXiaWU1DM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 priorityscore=1501 spamscore=0 bulkscore=0
 clxscore=1011 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609240092

On Thu, 24 Sep 2026 10:53:04 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Sashiko says fdt_addr can point to either an allocated fdt or the fdt from
> get_fdt() which is memory owned by FW.
> 
> Only the allocated fdt should be freed on the error unwind path. Use a
> dedicated variable for the allocation's size so that the free does not get
> confused.
> 
> Fixes: 4fc8e738ff3e ("efi: libstub: remove DT dependency from generic stub")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/firmware/efi/libstub/fdt.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index 23b3543d3041b0..5b2dd709d7b151 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -229,6 +229,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
>  	u32 desc_ver;
>  	efi_status_t status;
>  	struct exit_boot_struct priv;
> +	unsigned long fdt_size_allocated = 0;
>  	unsigned long fdt_addr = 0;
>  	unsigned long fdt_size = 0;
>  
> @@ -257,6 +258,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
>  			efi_err("Failed to load device tree!\n");
>  			goto fail;
>  		}
> +		fdt_size_allocated = fdt_size;
Hmm. I argued with myself for a while on this.  Which one of fdt_size and fdt_size_allocate
is the appropriate one to pass to the call?  In the end I didn't get a good answer so
oh I guess this is as good as the other way around.

Bug looks real to me and this fixes it I think. Give I know this code very little
take this tag with a pinch of salt.

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

>  	}
>  
>  	if (fdt_addr) {
> @@ -334,7 +336,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(void *handle,
>  	efi_free(MAX_FDT_SIZE, *new_fdt_addr);
>  
>  fail:
> -	efi_free(fdt_size, fdt_addr);
> +	efi_free(fdt_size_allocated, fdt_addr);
>  	if (!efi_novamap)
>  		efi_bs_call(free_pool, priv.runtime_map);
>  

