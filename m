Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795793892;
	b=QZcWQTKPivfAszAEKOvzXuwiJBYG3GV3A879GAQ/p8ZuREzNoa6RpzP5yUA5xY9PqiM5
	 CDmfTASR3XSGFxrMKoQOtDK/CQMJ0+h4Z+hXW1Sj86cz0xrtQX5xHKTF+w1ySvHLuprLY
	 xvaJU5fqhITYFP9vwAhphMSaG37bD9Qb9bHJX0R2VccLpDJrNuSw3i1+XvFQjcAVL0qvZ
	 zcXzRNfkYGBUOlM04S9CJ9vY/IIeGHoOpIkdnLdfxsWT0Fkl8FpSGv9Q2qItgyO99PTPJ
	 pmHAXVd7rpyw7XAMDtk/crPDwRWeny17BTc0fdPxxQz+MIxI9isH+is+p8Z5A74jFJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795793892;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:From:Subject:To:Cc:References:Content-Language:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=wSDkFlm4jY6UNA0o3Zt5f5H/V94IK7NSFsorwTBkxTg=;
	b=iW7rg8hfDtm8YbsbLn1VWmIKzBe8MMlXNpbxdaZ7KsTVhaJy+BLyeRPHDtCu7UgrBn3m
	 8+Lc6uDqukgKiEd9B6H5Uvbj0z6G8ui1rE0gRpuEcDeLUyIptiHN+o/Lx+MbhYh/jt/5P
	 gulf0j23LQJCy7cfNfXyC4O2qK0gT1d7ga2Hec/bU7cFdb8120zMfw5EyC6qLCHM0U/wa
	 AHbhCDH3z9P7iXZaUzg9zp34m9mXAr8dYETpG1z3O/i2MqpuEOv6CTnWVBsOZ4towY0th
	 7kvFrH3Iz7SO1MCcdJX7uXf+kGUmMAudjIqFnJxC9VwoVvxPuMJg1kqYA963/SIa8jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b="nn/hj00N";
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DEC606A31C;
	Fri, 27 Nov 2026 15:38:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89DEC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=nn/hj00N
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4sZS3266007;
	Fri, 27 Nov 2026 15:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wSDkFl
	m4jY6UNA0o3Zt5f5H/V94IK7NSFsorwTBkxTg=; b=nn/hj00NgZJYb5SXVZhx2Z
	kNkF85lXdR5x+V+fqdDyxJ5qYh+Gqipxe0MXks2I/k/un6fKwJ3RJaiTxctQaP3z
	nCMk1w00QNknlcaL+IOfEC7OeTi8YZ0MRCNvCUsHFIsIoo2c9niAfPaklcJTFebi
	qkJGjLSH4y4xq/eFyQ1U5fWtVLz7iulTZYM+peO9uvVRKsefY4CRYRSxQc+DaKCn
	lGJi0Jwl+FH3u48VV2G3+qhvTDQk1AnZhUUL+VXF5QXvZEDDGj4oIQwJIvS7hrbY
	5qJpcAuXFjFaWRPge4t52PMZGfS4F+OreQ8l8CHyb2ZpBdA7WTO85cQAzXNB62ag
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g1nns7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:37:14 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4Hec2819251;
	Fri, 27 Nov 2026 15:37:13 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j5kfaarn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:37:13 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFb8ha49676778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:37:11 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 915132004F;
	Fri, 27 Nov 2026 15:37:08 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CC8F2004E;
	Fri, 27 Nov 2026 15:37:05 +0000 (GMT)
Received: from [9.111.162.114] (unknown [9.111.162.114])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:37:04 +0000 (GMT)
Message-ID: <a98fab70-48fa-4640-88d2-a7a08f523128@linux.ibm.com>
Date: Fri, 27 Nov 2026 16:37:04 +0100
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
From: Jens Remus <jremus@linux.ibm.com>
Subject: Re: [RFC PATCH v2 01/30] unwind: Add Minimal DWARF CFI bytecode
 interpreter
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
 <20261125061523.1540234-2-irogers@google.com>
Content-Language: en-US
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20261125061523.1540234-2-irogers@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: brvXg_RJUZTQu5mAUmnatHUtcWzdDrrf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MiBTYWx0ZWRfX+qzyyuyu1B+R
 /ruRXWo/zu5u+2/Z0LaCtY3N+BUb8znffYTTtu+NHKiNIaooKN3ELdx20GOt2uvxx7P5wXL+1+A
 cpcYOaHmrjyz1MF/V7sVGbOPBX+fEdk=
X-Proofpoint-GUID: wK7aymzh3GdSqbeQ85e9O3Dhs5dNAbYJ
X-Authority-Analysis: v=2.4 cv=c8M+0h9l c=1 sm=1 tr=0 ts=6b09a3ab cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=M8zXbRpaHz8_b2Mss2oA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=O8hF6Hzn-FEA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MiBTYWx0ZWRfX4HPNbmoz03PS
 bjSpWwHbVDc6A2l18C+xFCEmA5d1gCfAti1AE4Q1SzAW+XWH1dJfaPQdyS4stAn2G+cg/1aAUvf
 uRdgrMyWaeQO3VhqDkxGUuZ2cKaGcV1OBrcozmGInTBrfeDXb6RQrK4KxWwkAtf42OotKBIWdHe
 BceGetoE/nBLl99++V5H3LEeU1J4HIw9TYbDgVEuk9GuJR2pdZKKa9D/CsYi8ZDqJARO/x5ufyD
 2Jpgbhn/gZMqp0o8TMTsgQaOMNwvalX4PYiAfWhyhXyVAi/esM70kJBhZWD9wMlkR/aiDWPBf4i
 xwqUtmTmLdRda/+RZJvu1W41t85aw+igiTDUK8MpVNp9G1dcUK9mU62x9+jkJKQaVc9srXlgnZB
 Ih3tcpQ1UlqbOBvPf5aIAVXxJ3jGYc131ZTQb9l7oa6JZzH2VjFqr7PCIm5nNDsFOCNVU4nM1HJ
 FsYR8R2QvfZiN/PT/7g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270062

Hello Ian,

great work, I like it!  I am working on adding s390 support on top of
your series.  Some early feedback.

On 11/25/2026 7:14 AM, Ian Rogers wrote:
> Add a strictly bounded DWARF Call Frame Information (.eh_frame /
> .eh_frame_hdr) interpreter (CONFIG_UNWIND_DWARF_CFI) matching SFrame's
> stack-unwinding state model and security properties, without requiring
> new toolchain sections or duplicating user-space unwind metadata.
> 
> Instead of implementing a general DWARF expression virtual machine or
> tracking arbitrary architectural register arrays, struct dwarf_cfi_row
> tracks only:
>  - CFA = (SP | FP | prologue scratch reg) + cfa_off, or fixed-pattern
>    indirect CFA *(FP + off) (DRAP stack realignment) / *(SP + off)
>    (signal trampolines)
>  - Stack pointer save rule (SAME or *(CFA + off)) for signal frames that
>    save SP in sigcontext (such as 32-bit x86 vdso32 __kernel_rt_sigreturn)
>  - Frame pointer save rule (SAME, *(CFA + off), *(FP + off), *(SP + off))
>  - Return address save rule (SAME in link register, *(CFA + off),
>    *(SP + off), or UNDEFINED for bottom-of-stack termination), plus
>    AArch64 PAC-RET signing state (DW_CFA_AARCH64_negate_ra_state)
> 
> Callee-saved general-purpose register spill/restore opcodes are decoded
> and ignored in O(1) space. General DW_OP_* expressions, DW_CFA_set_loc
> backward PC jumps, and DW_CFA_register rules on {SP, FP, RA} are
> rejected with -EINVAL; DW_EH_PE_indirect encodings are rejected whenever
> an encoded address is evaluated (while unused 'P'/'L' CIE augmentation
> fields are skipped by encoded width without dereferencing). CIEs
> (<= 128 B), FDEs (<= 4096 B), LEB128 operands (<= 5 B), and
> DW_CFA_remember_state nesting (<= 4 entries) execute in a single forward
> pass with zero dynamic memory allocations, zero locks, KMSAN output
> unpoisoning, noinstr kernel-memory entry points, and Spectre v1 / v1.1
> nospec hardening (array_index_nospec() and barrier_nospec()).
> 
> Also provide shared RCU-safe loadable-module .eh_frame indexing helpers
> using kvmalloc()/kvfree_rcu_mightsleep() (dwarf_cfi_mod_alloc(),
> dwarf_cfi_mod_free_rcu(), dwarf_cfi_mod_eval()).
> 
> Signed-off-by: Ian Rogers <irogers@google.com>

> diff --git a/include/linux/unwind_dwarf_cfi.h b/include/linux/unwind_dwarf_cfi.h

> +/**
> + * enum dwarf_cfi_rule - Recovery rule for caller's SP, FP, or return address
> + * @DWARF_CFI_RULE_SAME: Register retains its value from the current frame
> + *                       (or defaults to CFA for SP).
> + * @DWARF_CFI_RULE_OFFSET: Saved on the stack at *(CFA + off).
> + * @DWARF_CFI_RULE_FP_OFFSET: Saved relative to FP at *(FP + off) (DRAP frame).
> + * @DWARF_CFI_RULE_SP_OFFSET: Saved relative to SP at *(SP + off) (sigframe).

For s390 support I plan to add the following:

For the implicit DW_CFA_val_offset(SP, -160) rule, as the CFA is defined
as SP at call site + 160:

 * @DWARF_CFI_RULE_VAL_OFFSET: Value is CFA + off; only used for SP.

For DW_CFA_register (mostly used in lead functions to save FP and RA as
well as SP):

 * @DWARF_CFI_RULE_REG[ISTER]: Saved in another register.

> + * @DWARF_CFI_RULE_UNDEFINED: Explicitly undefined (DW_CFA_undefined); marks
> + *                            the bottom of a stack (e.g. _start or clone).
> + */
> +enum dwarf_cfi_rule {
> +	DWARF_CFI_RULE_SAME = 0,
> +	DWARF_CFI_RULE_OFFSET,
> +	DWARF_CFI_RULE_FP_OFFSET,
> +	DWARF_CFI_RULE_SP_OFFSET,
> +	DWARF_CFI_RULE_UNDEFINED,
> +};
> +
> +/**
> + * struct dwarf_cfi_arch - Architecture DWARF register numbers and word size

For s390 support I plan to add:

 * @sp_off: Initial SP offset from the CFA unless a CIE instruction says
 *          otherwise, caller SP = CFA + @sp_off.
 *          0 on most ABIs; -160 on s390, where CFA = caller SP + 160.

That would be used in dwarf_cfi_parse_cie() to initialize the SP rule
and offset.

> + * @ws: Target address/word size in bytes (4 or 8).
> + * @sp_reg: DWARF register number for the stack pointer.
> + * @fp_reg: DWARF register number for the frame pointer.
> + * @ra_reg: Default DWARF return-address column number.
> + */
> +struct dwarf_cfi_arch {
> +	u8 ws;
> +	u8 sp_reg;
> +	u8 fp_reg;
> +	u8 ra_reg;
> +};
> +
> +/**
> + * struct dwarf_cfi_row - Evaluated Minimal DWARF unwind state at a target PC
> + * @cfa_off: Byte offset added to the CFA base register before or as the CFA.

As a non-native speaker I have a hard time to understand that comment.
Wouldn't the following suffice?

 * @cfa_off: Byte offset added to the CFA base register.

> + * @sp_off: Byte offset used to load the saved SP when @sp_rule is an offset.
> + * @fp_off: Byte offset used to load the saved FP when @fp_rule is an offset.
> + * @ra_off: Byte offset used to load the saved RA when @ra_rule is an offset.
> + * @cfa_base: CFA computation mode (&enum dwarf_cfi_base).

What about renaming to cfa_rule?  That would nicely align with the
{sp|fp|ra}_rule and *_reg.

> + * @cfa_reg: DWARF register number when @cfa_base is %DWARF_CFI_BASE_REG.

For s390 support I plan to add the following to support DW_CFA_register:

 * @sp_reg: DWARF register number containing the saved SP when @sp_rule is a register.
 * @fp_reg: DWARF register number containing the saved FP when @fp_rule is a register.
 * @ra_reg: DWARF register number containing the saved RA when @ra_rule is a register.

> + * @sp_rule: Recovery rule for the stack pointer (&enum dwarf_cfi_rule;
> + *           %DWARF_CFI_RULE_SAME indicates caller SP equals CFA).
> + * @fp_rule: Recovery rule for the frame pointer (&enum dwarf_cfi_rule).
> + * @ra_rule: Recovery rule for the return address (&enum dwarf_cfi_rule).
> + * @signal: True if the CIE carries the 'S' signal/interrupt frame augmentation,
> + *          indicating that the saved PC points directly to the interrupted
> + *          instruction rather than after a call instruction.
> + * @ra_signed: True on AArch64 when DW_CFA_AARCH64_negate_ra_state indicates
> + *             that the saved return address carries a PAC signature.
> + */
> +struct dwarf_cfi_row {
> +	s32 cfa_off;
> +	s32 sp_off;
> +	s32 fp_off;
> +	s32 ra_off;
> +	u8 cfa_base;
> +	u8 cfa_reg;
> +	u8 sp_rule;
> +	u8 fp_rule;
> +	u8 ra_rule;
> +	bool signal;
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

