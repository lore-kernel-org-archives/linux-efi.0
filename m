Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795794282;
	b=FPDAmdS5/WX0DUOJK0JL8QuaeQsPhY3SLb0AGEDY9dB+EZUxLpkWi1L50thihGFSx+E2
	 e1mI8p93Lq+j7uDv7WMSqIuF5OO+AIosmEnNBO522/muWVoUvpKrGP/DzYak6XvbwyKTL
	 m+nDWQxH9enRXO0ObYQFjltaCSPx6AeuU+lYmTe8PWtXWphgbW63uF81QcfrOKePA5Yr2
	 SMfznHw7sezpyyA9ZjuEQ2oxClBdGo2ayCujRbBaxBJZp0GSrSgVBj+Hglw+xuduxu2JQ
	 R0cujOFnV3SLvLDrA5QHLhwxPDsXAI4O5fwTGqvRIGH9QtFEdmD2FEgDQ1SYbzmlLCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795794282;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ZUudbvDd7MPyN1ktju7yYOYQ2x2QokIUznwDazPg6Tw=;
	b=qrVCXOAnWAy4vP705NthZRuKLuRQJU7ijsdmb/US7LNVLOYbtzo9ZQZv5qC45zNtkXT7
	 JPm3eA1H8kcmWAHugGE0p4WXYuD3ZKMY7IFC7oy9WiffNVPlmMFlmDtO5DP9SqFtdH800
	 0pVhXhIxbA1Gs87Il5XUMBgsFO4Hz/KQLjEpCGrXATVPDKom67hX+HC2Tn2v9XN/eA6Yv
	 xbVJ45uebKX7TsPVlzeFEfiGQiGxhzq5J4sVd/hT1gA+eiY2WBEJczEiaEj2bkqaiB2o0
	 sm5Xz0GRldl/x4bRVcXIqcMBZAabUsGrJA5wBr6IaPdHV3HdylKLMrrOLWzHgZw5gGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ouxCdVIP;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA67606A326;
	Fri, 27 Nov 2026 15:44:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DA67606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ouxCdVIP
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE51UZ3266281;
	Fri, 27 Nov 2026 15:43:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ZUudbv
	Dd7MPyN1ktju7yYOYQ2x2QokIUznwDazPg6Tw=; b=ouxCdVIPDTnoqzsJUQXtST
	SW++jnDmlSChVN7g7jjSSr2GEdqI+8pYUzeH9o9p++NAQ3/sVjZkebO5YpmRU+XZ
	Rs/pa96kU3ljTUuOjyojPDxFAbTVOqHFbFZwqZuXknf9srEXiKRTFwAh2eECKbJ5
	Bx0/Mg6BeU9yHjZ9z1yULD+PVzlTl5qIRdX9PpPN3pAu57283gjeW7fQ0y5GaNGX
	lKqVJQxugAEJj4Kh5bsGGI26I4wUQBDyMGpJL9kEPYLJXb10rK99tN7ND/qcvg2n
	RDDq0tlSnZ7qaIVPtFsRydTEdeoGMk3/KAoPC6T+IEtzDhbHw5AOT7UZFoQyMt5g
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g1npam-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:43:47 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4ETH3998991;
	Fri, 27 Nov 2026 15:43:46 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j6x3h2p98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:43:44 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFhcV947186264
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:43:38 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 535392005A;
	Fri, 27 Nov 2026 15:43:38 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A04F22004B;
	Fri, 27 Nov 2026 15:43:34 +0000 (GMT)
Received: from [9.111.162.114] (unknown [9.111.162.114])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:43:34 +0000 (GMT)
Message-ID: <a07554af-f6df-4a7f-a656-d01b8bc6ab6a@linux.ibm.com>
Date: Fri, 27 Nov 2026 16:43:34 +0100
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
Subject: Re: [RFC PATCH v2 12/30] x86/unwind: Add Minimal DWARF CFI kernel
 unwinder
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
 <20261125061523.1540234-13-irogers@google.com>
Content-Language: en-US
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20261125061523.1540234-13-irogers@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 5ZJeZ4dRYLWKasNlVNFN_HgzbYFJrPH2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MiBTYWx0ZWRfX3ppIf7DvuI0B
 vCLEIduUtrcdh1ifjCJ30YvokvPQxXSoffMeR6OCQbDbZZlYU+s04lE4FKdQSzPHvl5DeT/nsPk
 HYln2faN13fSVAO423AD3Vi7w0XWYeI=
X-Proofpoint-GUID: kfW7DRO-7vrKBDiqgdjT-kZh031cAVz2
X-Authority-Analysis: v=2.4 cv=c8M+0h9l c=1 sm=1 tr=0 ts=6b09a534 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=1XWaLZrsAAAA:8 a=w5RBXh3AvzieJi7Cyr8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MiBTYWx0ZWRfX3qAzkgNtC0R4
 HUyG6CTQOWPyYas2a2ejLw5Sj5SkgS+QrLoDYBCI/EAzMCTtw9O3tNX/G5nGF98UhevvaMdJVtJ
 pr1KvXtTIF+qBHW6b5LH97yXYLtnzMmuu8kPoL+zW1Cv8i3Aj4z8LcGwX3K4YypRtAv4zNndM9i
 wfHgY2arEijRcZkQ4ZIXMrNjIeyx6iM/1NcRaSBz18OqH8naX/KUse5ovf9oVT9hsZw36H3UW3L
 /e/Qn2JUTNuhsH6F4/oF7RHIEIekrRKJTTS7u5t9jpDXdFjCVQpR5zovcNKKfcWsIhIKKW8NslY
 HzQ7pcW2dMfkFomCCT7lH+LeybRe/MSuQ11Z4ZN0qinIYMAIENvpk1/7/eM+4RJYhijppy7nuAP
 cJDGtQcsa+zjcbRtV6WV18OsJEe0qjzbBkI1JX1Ozc8T29bBR34fOPSiPudo98JgaSuCi6Lzkt3
 g8rf7PJ+1CZxrm8hZqg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270062

Hello Ian,

some early feedback.

On 11/25/2026 7:15 AM, Ian Rogers wrote:
> Add CONFIG_UNWINDER_DWARF_CFI as a selectable x86-64 kernel stack
> unwinder in arch/x86/kernel/unwind_dwarf.c, implementing the asm/unwind.h
> and HAVE_RELIABLE_STACKTRACE interfaces over compiler-generated
> .eh_frame and linker-generated --eh-frame-hdr tables:
>  - Build kernel C and Rust objects with asynchronous unwind tables and
>    -fomit-frame-pointer while suppressing unwind tables in boot/startup
>    and purgatory objects.
>  - Place .eh_frame_hdr and .eh_frame inside RO_DATA via
>    ARCH_RODATA_SECTIONS, index loadable module .eh_frame sections via
>    dwarf_cfi_mod_alloc()/dwarf_cfi_mod_free_rcu(), and enable BPF
>    exception stack walks in arch/x86/net/bpf_jit_comp.c.
>  - Unwind across task, IRQ, exception, ftrace, fgraph, rethook, BPF, and
>    call_on_stack() frames, while rejecting in-kernel pt_regs exception
>    boundaries in arch_stack_walk_reliable().
> 
> Signed-off-by: Ian Rogers <irogers@google.com>

> diff --git a/arch/x86/kernel/unwind_dwarf.c b/arch/x86/kernel/unwind_dwarf.c

> +/**
> + * unwind_next_frame() - Advance @state to the next outer x86-64 kernel frame
> + * @state: Current x86 unwind state.
> + *
> + * Evaluates Minimal DWARF CFI for @state->ip, handles top-of-stack task
> + * pt_regs, arch_rethook_trampoline entry, %rsp-verified ENCODE_FRAME_POINTER
> + * entry/exception pt_regs transitions, and call_on_stack() IRQ stack pivots.
> + *
> + * Return: true if a valid outer frame was unwound, or false when the bottom of
> + * the stack is reached or an error terminates the walk.
> + */
> +bool unwind_next_frame(struct unwind_state *state)
> +{
...

> +		/*
> +		 * Unencoded entry assembly (pre-ENCODE_FRAME_POINTER or
> +		 * post-POP_REGS) or an unaligned/encoded %rbp cannot be
> +		 * unwound via a frame-pointer guess.
> +		 */
> +		if (in_entry_text(state->ip) || (state->bp & (sizeof(long) - 1)))
> +			goto err;
> +
> +		/* Fallback to frame-pointer guess and mark unreliable */
> +		row = bpf_fp_row;
> +		state->error = true;
> +	}
> +
Maybe add a comment that the UNDEFINED rule indicates that the outermost
frame has been reached?

	/* RA undefined indicates outermost frame reached */

> +	if (row.ra_rule == DWARF_CFI_RULE_UNDEFINED)
> +		goto the_end;
> +
> +	if (row.ra_rule != DWARF_CFI_RULE_OFFSET)
> +		goto err;

Good: For RA rule only OFFSET is supported.  SP and FP rules may need
checking (see below).

> +
> +	switch (row.cfa_base) {
> +	case DWARF_CFI_BASE_SP: {
> +		unsigned long sp_base = state->sp;
> +
> +		/*
> +		 * call_on_stack() stores the pre-switch task-stack %rsp at the
> +		 * top slot of the per-CPU IRQ stack (info.end - 1) and pivots
> +		 * %rsp there before invoking the IRQ/softirq handler.
> +		 */
> +		if (state->stack_info.type == STACK_TYPE_IRQ &&
> +		    state->sp == (unsigned long)(state->stack_info.end - 1)) {
> +			if (!deref_stack_reg(state, state->sp, &sp_base))
> +				goto err;
> +		}
> +		cfa = sp_base + row.cfa_off;
> +		break;
> +	}
> +	case DWARF_CFI_BASE_FP:
> +		cfa = state->bp + row.cfa_off;
> +		break;
> +	case DWARF_CFI_BASE_FP_INDIRECT:
> +		if (!deref_stack_reg(state, state->bp + row.cfa_off, &cfa))
> +			goto err;
> +		break;
> +	case DWARF_CFI_BASE_REG:
> +		if (!get_scratch_reg(state, row.cfa_reg, &cfa))
> +			goto err;
> +		cfa += row.cfa_off;
> +		break;
> +	default:
> +		goto err;
> +	}
> +
> +	ip_p = cfa + row.ra_off;
> +	if (!deref_stack_reg(state, ip_p, &state->ip))
> +		goto err;
> +
> +	state->ip = dwarf_recover_ret_addr(state, state->ip,
> +					   (unsigned long *)ip_p);
> +	if (!state->ip || dwarf_is_rethook_trampoline(state->ip))
> +		goto err;
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	if (state->ip == (unsigned long)return_to_handler)
> +		goto err;
> +#endif
> +
> +	if (row.fp_rule == DWARF_CFI_RULE_OFFSET) {
> +		if (!deref_stack_reg(state, cfa + row.fp_off, &state->bp))
> +			goto err;
> +	} else if (row.fp_rule == DWARF_CFI_RULE_FP_OFFSET) {
> +		if (!deref_stack_reg(state, state->bp + row.fp_off, &state->bp))
> +			goto err;
> +	}

IIUC any other FP rule falls through and is implicitly handled as SAME.
Furthermore row.sp_rule is not checked anywhere, so that any SP rule is
explicitly handled as SP = CFA.  The implementations for the other archs
are similar.  Maybe I am missing something.

> +
> +	state->sp = cfa;
> +	state->regs = NULL;
> +	state->prev_regs = NULL;
> +	state->full_regs = false;
> +	state->signal = row.signal;
> +
Regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/

