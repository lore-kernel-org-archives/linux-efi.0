Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795794384;
	b=5WYgmUVPxB1uGEmHsHoetAAwjQaCV2ACsln82Fjgmr/MYM+XRDrTDTgiCkS2i6iytnDg
	 w8VUnzXLwgIvrRKtQImWHRJEwKcfewOw+nlqLQr3HLgomUoaKRskbgrWAqdc7aM4Ur1mF
	 s+R71t9yfnAwY8Gu8fY70UgtXjup7UpqSAvqz/q7cMALS7IlODgvV4xi31J+4suGI65a8
	 3K09T33cYT0srd0OE4hMAZCAckXgjSm+b0EnrHh8qXRUGHv9GdieMJa8ylWl8e+eq947C
	 oBJ/lmHO/v5hrFt48iFLLEsIwew9YLn6HvxGtRrgu6BPuwBmWzr+u9F7ITBgGCRFzfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795794384;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Ef79Sm+tXuuwj3ufmXm7GJ7x61OFnxYLGpboMdf9IBI=;
	b=C/a+2C4ySS/wUkQifHDfC7NBIoZs06MMuL9CxIwo6IpCTHGql/BivVqDktb0lq5K3Z6O
	 cLd79Bw+GpRaOGVcWBQwVfUeT+2Y/JVkOMDgBFhZegQJnJ02hgNGljcNH1uZzdTRYbHPP
	 Fem7zxFPS2mra7h84AVlkh5lFYaKfvhjOkvQQovKqVrhZqepe/XzT4oU1umYZn6LBbnIl
	 sZnnrmASLZpCb3xst4Doo9ZgPrerAjzCYiS0GxENVjgE7ACrPi8cfOhjY00MZXGKICM+V
	 5x2HqMARPQf3YbKUT4bT8HTs1/UrUS/ROboh96I7Z6r1KNcIRYXcymmyPm0DQr4qYYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=sdEQ0NsA;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A08606A31C;
	Fri, 27 Nov 2026 15:46:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54A08606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=sdEQ0NsA
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4xWq1650913;
	Fri, 27 Nov 2026 15:45:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Ef79Sm
	+tXuuwj3ufmXm7GJ7x61OFnxYLGpboMdf9IBI=; b=sdEQ0NsA1Rp5M9ki4aIM4f
	7cZlgbBScopeC6p1ATCCEH+WXpatpRevj3IPaed0EcBpANh42lq2uuIXWlyy1qU7
	AkeFHkXLSpPKXcnkFJDFdSLOtI/VyBJfwHC7ZMtZTsNYDZ/brU3myrmKhfiUjWPy
	0fI8n1roGMw2d2nWhp0xrHWd4Pqao3FqfDG8U6CAbdzPwA3tXYpeymgXa8Q9aXTI
	/BAS04+efAngyb4Ciq8AIUvwu3Loung1K6tCkLRINQO28gp3wVNH5YxoVv8t+jDY
	eWi+1fVPMLICcXI0S937RiF/RVzMcibVDsTH60heWnzWLNRZxFvwet0mBj0ZpjfA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g3pgxr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:45:18 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4HlC3245420;
	Fri, 27 Nov 2026 15:45:17 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j5uxx9cpw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:45:17 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFjFm540763836
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:45:15 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 08B6B2004E;
	Fri, 27 Nov 2026 15:45:15 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C3D1120040;
	Fri, 27 Nov 2026 15:45:12 +0000 (GMT)
Received: from [9.111.162.114] (unknown [9.111.162.114])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:45:12 +0000 (GMT)
Message-ID: <b3e99b3a-7dd6-4e3a-97a8-3011a5f52569@linux.ibm.com>
Date: Fri, 27 Nov 2026 16:45:12 +0100
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 03/30] unwind_user: Support Minimal DWARF CFI
 user-space unwinding
To: Ian Rogers <irogers@google.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org,
        mingo@redhat.com, tglx@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, mark.rutland@arm.com,
        linux-arm-kernel@lists.infradead.org, pjw@kernel.org,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
        linux-riscv@lists.infradead.org, acme@kernel.org, namhyung@kernel.org,
        linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org,
        nathan@kernel.org, llvm@lists.linux.dev, nsc@kernel.org,
        linux-kbuild@vger.kernel.org, ojeda@kernel.org,
        rust-for-linux@vger.kernel.org, ardb@kernel.org,
        linux-efi@vger.kernel.org, maz@kernel.org, oupton@kernel.org,
        kvmarm@lists.linux.dev, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, indu.bhagat@oracle.com,
        wnliu@google.com, dylanbhatch@google.com
References: <20261125061523.1540234-1-irogers@google.com>
 <20261125061523.1540234-4-irogers@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20261125061523.1540234-4-irogers@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=SoQFe/O0 c=1 sm=1 tr=0 ts=6b09a58f cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=SydnlHaeet_-pvNvn0IA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MiBTYWx0ZWRfX//27zJLiQVYf
 xNjLa9qa44AULBZTtm4EESxzfRForMWNqSTmBaImA7YWQRwKK193TC19ItTlLVgilaXwZcnzcHe
 QICuhIDhMKp+bHoMoSt/uaiJRuECQxw=
X-Proofpoint-ORIG-GUID: cZ0MGuDQofjwbSOIcLLHaDoI3HDF3ZM6
X-Proofpoint-GUID: qPE-_zE0roniklQP5kQm896Xq2TUdaEX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MiBTYWx0ZWRfX4zkwEbYrR0Ub
 t0vOYaJYi0U5fCUQEvK7YRpLsUhXmMQXuiM36maaVxnFZXU1rrQUthFEbLYJHfQ8mCgalEmUz9e
 B7Mif8gfIPXAX3kO+XyYclvI0cKi9WMZ/7JlebSj2IAYBHr/ka7KsyN89Cdhrx4wT4PbAfWQBAT
 vaAk2DkMcgC44nO7KjdUz6R5rjsODltvTuqXXm5ALXPLp0H/ZO8Ct1digR3BRypj4Uc1sUtuPzF
 ZH5ChZOtmSI6NzV3W/BZjmJ0Q7pdKguTBaz/OmLbUQKxiK6RMKntlafD4sSPwuDe3SlxeWhjXJO
 Vqj6sUGeFx60W2WrESFJ1gQtM74EOPI8YX9qEdKmzlI+AznCNZl6L3cVAyBCU2FLCWaOPTohD6h
 8lDI6YxQCvH59CpgKFzbug+kiskWWh+Pqw1qEnxi9LnGRL4Ikg2RHebJTdd7adhpf3ze38WyP0K
 aXhNs6vkU6Uy4I0JVFA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270062

Hello Ian,

some early feedback.

On 11/25/2026 7:14 AM, Ian Rogers wrote:
> Extend the generic user-space unwinder (kernel/unwind/user.c) with
> UNWIND_USER_TYPE_CFI (CONFIG_HAVE_UNWIND_USER_CFI), resolving ELF
> PT_GNU_EH_FRAME headers across executable VMAs in kernel/unwind/user_cfi.c.
> 
> Key design details:
>  - Find the executable VMA and its base ELF mapping (vm_pgoff == 0)
>    under mmap_read_lock_killable(), then drop mmap_read_lock() before
>    issuing any faultable copy_from_user() reads.
>  - Cache VMA -> PT_GNU_EH_FRAME lookups (including negative lookups for
>    anonymous/JIT VMAs so unwind_user_next() falls back per frame to FP)
>    in a 4-slot per-walk cache on struct unwind_user_state.
>  - Track stack-pointer validity (state->sp_valid and
>    unwind_user_fp_sets_sp()) across mixed CFI -> FP -> CFI walks so
>    architectures whose FP step does not recover exact caller SP reject
>    SP-based rules until an outer FP-based FDE or sigreturn restores SP,
>    and support signal-frame SP recovery from *(CFA + sp_off).
>  - Provide overridable unwind_user_frame_pointer() (guarded by
>    CONFIG_HAVE_UNWIND_USER_FP), unwind_user_fp_sets_sp(), and
>    unwind_user_sigreturn() hooks alongside unwind_user_link_register()
>    and unwind_user_strip_pac(), and allow up to UNWIND_USER_MAX_SIGNALS
>    signal frames per walk to switch stacks (SA_ONSTACK).
>  - Support link-register leaf frames, DRAP/sigframe indirect CFA rules,
>    and clean bottom-of-stack termination on DW_CFA_undefined or zero RA.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>

> diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h

> +/**
> + * struct unwind_user_frame - Evaluated unwind rule for stepping one user frame
> + * @cfa_off: Byte offset added to FP (when @use_fp is true) or SP to form CFA.

 * @cfa_off: Byte offset added to CFA base register (SP or FP) to form CFA.

> + * @sp_off: Byte offset from CFA to saved caller SP when @sp_from_cfa is true.
> + * @ra_off: Byte offset from CFA (or SP when @ra_from_sp is true) to saved RA.
> + * @fp_off: Byte offset from CFA, FP, or SP to saved caller FP (0 if unchanged,
> + *          unless @fp_from_fp or @fp_from_sp is set).
> + * @use_fp: True if the CFA base register is FP rather than SP.
> + * @cfa_indirect: True if the computed CFA address must be dereferenced once in
> + *                user memory (DRAP or signal trampoline frame).
> + * @sp_from_cfa: True if saved SP is located at *(cfa + @sp_off) (e.g. vdso32
> + *               sigreturn frame where CFA points at sigcontext).
> + * @fp_from_fp: True if saved FP is located at *(state->fp + @fp_off).
> + * @fp_from_sp: True if saved FP is located at *(old_sp + @fp_off).
> + * @ra_from_sp: True if saved RA is located at *(old_sp + @ra_off).
> + * @ra_from_reg: True if RA is still in @state->ra rather than on the stack.

This flag soup is confusing.  For s390 support I would need to add the
following to support DW_CFA_register, which would make it even worse:

 * @sp_reg: DWARF register number containing the saved SP when if @sp_from_reg
            is true.
 * @fp_reg: DWARF register number containing the saved FP when if @fp_from_reg
            is true.
 * @ra_reg: DWARF register number containing the saved RA when if @ra_from_reg
            is true.
 * @sp_from_reg: True if saved SP is located in @sp_reg.
 * @fp_from_reg: True if saved FP is located in @fp_reg.
 * @ra_from_reg: True if saved RA is located in @ra_reg.

Wouldn't it be preferable to use something more similar to struct
dwarf_cfi_row?

  cfa_rule: UNDEFINED, SP, FP, SP_INDIRECT, FP_INDIRECT, REGISTER
  cfa_reg
  cfa_off

  {sp|fp|ra}_rule: SAME, OFFSET, SP_OFFSET, FP_OFFSET, VAL_OFFSET,
                   REGISTER, UNDEFINED
  {sp|fp|ra}_reg
  {sp|fp|ra}_off

> + * @ra_signed: True if the recovered RA carries an AArch64 PAC signature.
> + */
>  struct unwind_user_frame {
>  	s32 cfa_off;
> +	s32 sp_off;
>  	s32 ra_off;
>  	s32 fp_off;
>  	bool use_fp;
> +	bool cfa_indirect;
> +	bool sp_from_cfa;
> +	bool fp_from_fp;
> +	bool fp_from_sp;
> +	bool ra_from_sp;
> +	bool ra_from_reg;
> +	bool ra_signed;
> +};
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/

