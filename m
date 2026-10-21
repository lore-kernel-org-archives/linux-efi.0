Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792601529;
	b=L4ekQG9wyEG143UFmNGxEPcKq+/SH+rjs9htyj9Mjll+KtEp7UMdZlWDOSn3eROI4djR
	 AqGP7alNa6KlQVr9OGBaQ+X8ZnY4gFJCt67ZEWYXe2sH/iL653/LD4Tblx+T43vnyB/VJ
	 4c+nPTRdW8/+UxbUki1dSx9Br7otEk+KhjqXVKP1JkSfwqFGEDKVheCtoIO66Jds60gMV
	 57pWpdM8mKhPW7t6wJKZpChlsR69q0Qzdg4MqgrctpsaokxZrkiZGrmENryialE0zQV9m
	 2X38DX3LbTNKWBmAmvT7EjYFptvyt63nJ346RyBetyRE8PHLCmzQfDLmnOShbQ5Od9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792601529;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=3Qwd5IeDpUYoKVbi14CXRmp0vCTcpiIpKFvrCb+PUaQ=;
	b=FvRFCIVei9tXbsawNhnHG8Vu53eGuZ0ivso1fdxiUUGiKHz+lIOEKK4Muj2v2Kg+szbz
	 RL/4zPD9im3f00hPrpAtAjHOlrrbiXzsjEA+JAvCCXOfBD/fLQnYsVzBsbQiYikjtExPf
	 97RT/p0ukNkBvxubyhBquOyV3C2KZNkpYrqU6GE2bf8NWrpU7YGjgoMsRtZ+LyLXJo4ow
	 fJfQBD+tttPIWrmFQDci3LvZ1zkiGhNUTrzVqJqcqgzJ6W8LNp9Y07uW4Jp1ZaS1po6VU
	 1Fnxfo7niIGlXm5RQ8T4SjR8V2Eh4gHPyJwJCWyzRCmAcw0f7mv9ZaFMCFvXM/L7Leg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fGBW0L6P;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QQjpQpmx;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4305A606A31E
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 16:52:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4305A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fGBW0L6P;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QQjpQpmx
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LGjrFo1160902
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 16:52:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3Qwd5IeDpUYoKVbi14CXRmp0vCTcpiIpKFvrCb+PUaQ=; b=fGBW0L6PCB1n3raX
	d/aUhPmemf5kyrJMb2V994vfSQxb8ZW1AUflWoJbMqxkNdQMkyX60NaRpWzwG2ZR
	dyDNPyramva9fABPmwqppOy5x+y3G2Xjpzu+HJAQ8qTdGMQEDtxA5BLJJps0Gfbc
	0RS6PuOx2PIHdwu3bJdDo33JYwkVD1p+N8Eahl+8OsJIsrCWmXNci7Ks5pmN/stb
	gumg0KOS4MOx3tLDNhDJjMnuFbAjLxfI2H6AicbgZ1SvXdgPAikr3eeNDm/5NzI1
	ReUtxdLTy3hBPhb9/wjImsppuSRvPHiJNWyrz7U7vS8e4LyChMQCIA5S5oPDbcDF
	hGURjw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4heh5r457d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 16:52:07 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3510d0baf63so2170755eec.1
        for <linux-efi@vger.kernel.org>; Wed, 21 Oct 2026 09:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792601527; x=1793206327; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=3Qwd5IeDpUYoKVbi14CXRmp0vCTcpiIpKFvrCb+PUaQ=;
        b=QQjpQpmxczgrpr2meAC6qTgPsJ4ZmJ91pnxGxL09Sesa1rfJJ+QmYIiqzX/3ZN2Whc
         PGHUczg9OAvRA0sX9sIDqu77sBzAiBbu7jGYKhjLqjsw2zunSyFSZrk/9dIw43rWgx87
         IVATm2JqsZfxBJA4hz7gvE+ZQkKi5tu3ZcAv3WPj72XLC61Kfbn/vxwFtyI0+LKC4Fg9
         N7c6i0MEQt4EgFAEAjH6SeD6iQGD2AApA1yq+2zxXGXf/7tUfU8F3yLM6Mcr02afFF0F
         fC6EP1lR68xmmprG7i052+aNcNNEAIDBPU11lgff4/LOklidQA8lbZ0lsxRZbkFmV+xj
         424g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792601527; x=1793206327;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Qwd5IeDpUYoKVbi14CXRmp0vCTcpiIpKFvrCb+PUaQ=;
        b=R6xfH90teqzXbV7bkof+BCYUDvWcGTzVPQ3iz1o6aAz8GZ/AbwKLCwN/azEblhLVOZ
         styjcOgt4mix1XcXXaClK8oF2F2v/cBDNGlEpdSHUI4+MkfKpB7dKUf4+fYs1uw7LJGz
         cUqp2rGnEdPS5gp+cdqUrUfsmV0C6heZXI9DWIznCcdaMeJKxHKSazq4RKzTbfcdV/nj
         5F3xco5+q9XN3aO3ajlf2xUz0b29Mk+/sTpo3jCShjIunXKvOkWieka+2ZzvKSiojiNY
         LGgvqcIhr1uybL8H/6Tlr73gq/3mQPjpsbi7kmnXWmRZaMYwM55rnwO1wshCtwkyjkyv
         Ft7Q==
X-Forwarded-Encrypted: i=1; AKwUvBxZDTih8LjG15axwQoMFx0ONSzmf4jd8DWbzCxvOn7SLkKxTRl1+WssYBoncCXajEflcArY17NiDVY=@vger.kernel.org
X-Gm-Message-State: AFq9FYKh1ScE4NIwPNHwNJB4xBUqTuJ4qVNlJ9+q+HWOvF0GRQ1ORoNL
	nOSwboATpR3YKnnmf8mWRFMtB+3y2pKC03aXlvKJ7fL6DevAoTO9Qvo2puWN193JZVqGyuFBMWA
	8IedHniaSOd4ckeB2q89XBliDG29wRIMG2setDvsiLEHfpN0dE4CK1d9AObFNQAA=
X-Gm-Gg: AYBFou2vyrws3hQ1s6lZVOnxqsgNo7wVfj3dY+hFq+jATrFUfhiNnq3niP1ojEHhVPF
	C8oxQd9I344WMjC0RtZZHPfQS5K3RvXu7mDJ6HdLdEKCVV+B6teGaejpGxDBSlzthXAU4uEehkq
	qyO0rEjH8uFuViIu6wOUbfnZFDMRx/r7UlRKe/1H474xnWffuiT/cuEDqxozYNarQVdEXL6R+gJ
	Hun20P3ycJ5Dgfae9yoAzqTITm4A/fgUvh8AuhBpURd+auKDeQLeV4Au14ASmLd+M0P9MPQmMgq
	6q1zhsyrqbIICysG40+rwBAKM4WnNBIeTTp5S/CciJdJ6M1HUk1ms9AU2a/3l4azsOUsECwNHQq
	WnDgBpGM7bAWQahUin0zxMxgS13H4Ww8y9noIe/HldA==
X-Received: by 2002:a05:7300:fb83:b0:359:8492:2107 with SMTP id 5a478bee46e88-3674c43c286mr5506656eec.10.1792601526903;
        Wed, 21 Oct 2026 09:52:06 -0700 (PDT)
X-Received: by 2002:a05:7300:fb83:b0:359:8492:2107 with SMTP id 5a478bee46e88-3674c43c286mr5506599eec.10.1792601526326;
        Wed, 21 Oct 2026 09:52:06 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3674206d1f1sm8700283eec.28.2026.10.21.09.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:52:06 -0700 (PDT)
Date: Wed, 21 Oct 2026 09:51:55 -0700
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
Subject: Re: [PATCH v2 07/15] efi/libstub: Add generic arch callbacks for
 DRTM
Message-ID: <20261021095155.00003fc2@oss.qualcomm.com>
In-Reply-To: <7-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
	<7-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
X-Authority-Analysis: v=2.4 cv=aI5lOr9m c=1 sm=1 tr=0 ts=6ad8edb7 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=Ikd4Dj_1AAAA:8 a=EUspDBNiAAAA:8 a=PZHjKiIRVRR-A8qzlogA:9 a=CjuIK1q_8ugA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: VRQOmHf-MPY3cig7S0m0CBeEDR2Q7gHi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2NyBTYWx0ZWRfXz0Ns6ssVQTL1
 SVzVr28tTber/rltiOmOXV1ulnG7IqmWQ8obMDXw6TuypCpCC7NENwmiq2c1VP2fwSyVvM594ce
 x/hpSfJMdrkZDQz1L/2iGvfgQ+Sds6jvuS5rdIxQ3+Xg1ey0taoiuLrccprOFuOW7ep0EXriEow
 Oa0gAOyDOq6izGS7x0UdYbamXAM3DouX2Dp+Psr3tGhNhvZofJCkgysvS3H85WQttLSHfyuLBLP
 miWpw9dYnkuFKirOa43Z73HQ9TZX3OR/IdptEyP/kXVvczzI0WGLUPW36GJQZO0MoJeYQSj38Ie
 bnI4nkIJAOK2+bcdxkMEdzLjlVALl43/k3bQ51ze/AMhIzHbeaHTN26+Z6JhKO6DAdgNG/RHbMR
 PoWEB4aN+GNBaug2ANwWyeX3VKV2QNE0aU+Tp9awZ2viO5isOcawZMLwJa7ScyvZBzHU0y2xvEY
 1W3ndnnjCet0k/l2pPQ==
X-Proofpoint-GUID: VRQOmHf-MPY3cig7S0m0CBeEDR2Q7gHi
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2NyBTYWx0ZWRfXxE0UZxULUTMQ
 gKhGznMe6rpl4LagyME4yH6zezctiq4Y5CtSylBVcvtDxG86QAshMHYzE5ojQr4l+t6Be0doTfv
 2HSM0vDee2Nt42DYJOPonopUXX6NUow=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210067

On Fri,  2 Oct 2026 20:31:44 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> If the architecture supports an EFI stub launched version of DRTM, it
> can select the kconfig and provide the hooks under its architecture
> build.
> 
> Have the common code parse a drtm=enforce|auto|off kernel command line
> parameter to set the boot behavior. Support commas in the args list since
> there will be more options here down the road.
> 
> efi_drtm_prepare() is called before doing any decompression or image
> relocation. It should figure out if DRTM is supported, policy-permitted,
> and how much memory efi_drtm_get_extra_size() should return.
> 
> The image handling is revised to allocate extra_size at the end of
> the normal image. The architecture can use this to store any
> information needed for the DRTM flow. It is always contiguous with
> Image, which is a requirement of ARM's specification.
> 
> efi_drtm_prepare_launch() is called while still in EFI boot services after
> Image is fully prepared in its final location.
> 
> efi_drtm_launch() is called after exiting boot services and must
> jump into the kernel through the DRTM flow. If it returns, then the
> normal launch is tried (auto mode).
> 
> The extra_size is allocated directly after the Image. Handle the
> trivial zboot flow now, and vmlinux in the following patch.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Seems fine to me.  Some of the functions affected have annoyingly
complex flows already but this isn't obviously making things worse!

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
