Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795793900;
	b=dg71j/5llY4skX6l+GP6dcJWJxJ5hrDSqXdyZ+LRk5RLLanatfPd3NCu18Orpxl/LbW0
	 L9ZULWNcOlJILJK12jLI8UwXr7LwQgt21Mr+FPbOBHNA0llXevCBjbn7Qd2a1uk40FZTC
	 MvKwmSVeu+qbZg1aZaPmDfYJeDiQVfb9QYcyired7tH+e6q2BiT2KlSHXTw+BM+QYF5c6
	 1KGr1J2QwNMcCO11qsuNT/3E3USBx2UNpb3Cjy5W435aH6kKgP69jJMCvgRZhuxonwxvX
	 q+/ad9Ya4cZWxRQbq7cpBm6H2f2dG/KeAPOau7wPljS38soorWwcRY4mmt2GVFf0OQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795793900;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Stat-Signature:
	 X-Spam-Status:X-Rspamd-Server:X-Session-Marker:X-Session-ID:
	 DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=gxUrschx7iu+16DWxWUw1U2XUCMCjzUqsWH6d1cDnhw=;
	b=VEl28XnJ+e8+i4gFfcKQphu+5cw0xpdMpVIs8J36xAD713PGuFC8Q1hd08Cx9CFmfT8I
	 V2v+hEWZz+f+Vi2ZvCfq51FrUw/Ttx7/dp0gycFYPpz4rc1qi7Bw90DfzrNP6A1uMaFMR
	 2SPpAjG8sBtWSSbP0Z0fZr7M+n7fkW427ze0Jh272We9IfgzsOCt02Lz+ph8fW8SDXcwP
	 fw04MKfHNtdpc/J2GLeR6G+/jfb3uO5UiZ7XpwGvM/aA/wdztZ4qnNob+CnHDpE11tlOe
	 pqoenMBjYdCymRpkSoJ0p+AJfgX4BOnn+JuNw7fPga8i/WKwkpVIErGhsLlkmrhn9Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b="Xg/3Scjl";
	arc=none smtp.remote-ip=216.40.44.12
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB40B606A31F;
	Fri, 27 Nov 2026 15:38:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB40B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=Xg/3Scjl
Received: from omf07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6FD05A041A;
	Fri, 27 Nov 2026 15:38:09 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id BB51F20030;
	Fri, 27 Nov 2026 15:37:57 +0000 (UTC)
Date: Fri, 27 Nov 2026 10:37:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ian Rogers <irogers@google.com>
Cc: Gary Guo <gary@garyguo.net>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 jpoimboe@kernel.org, peterz@infradead.org, mingo@redhat.com,
 tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, linux-riscv@lists.infradead.org,
 acme@kernel.org, namhyung@kernel.org, linux-perf-users@vger.kernel.org,
 mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, bpf@vger.kernel.org, nathan@kernel.org,
 llvm@lists.linux.dev, nsc@kernel.org, linux-kbuild@vger.kernel.org,
 ojeda@kernel.org, rust-for-linux@vger.kernel.org, ardb@kernel.org,
 linux-efi@vger.kernel.org, maz@kernel.org, oupton@kernel.org,
 kvmarm@lists.linux.dev, shuah@kernel.org, linux-kselftest@vger.kernel.org,
 indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com,
 dylanbhatch@google.com
Subject: Re: [RFC PATCH v2 00/30] unwind: Minimal DWARF CFI unwinding for
 user and kernel space
Message-ID: <20261127103756.4ce1989b@gandalf.local.home>
In-Reply-To: <CAP-5=fWkUW787c4dGx9rccucqD67dfRgwBB_SoCxFnfZXtXP-w@mail.gmail.com>
References: <20261125061523.1540234-1-irogers@google.com>
	<DN4FM3TBOJ9T.2QOOL77P5HETO@garyguo.net>
	<20261125132225.00254c37@gandalf.local.home>
	<CAP-5=fWkUW787c4dGx9rccucqD67dfRgwBB_SoCxFnfZXtXP-w@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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
X-Rspamd-Queue-Id: BB51F20030
X-Stat-Signature: wrsqnz8uj45at8ncwo3okdibrged3eg3
X-Rspamd-Server: rspamout02
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/dy2vpicCHk2iAQD+WW3qcRkxd14MkZ4s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=gxUrschx7iu+16DWxWUw1U2XUCMCjzUqsWH6d1cDnhw=; b=Xg/3ScjlKHzBVPraoOdvRylx/Tn9nPAYZ/C1gW38+Nx2ATB28UjFuCVf5e98y+tLOcG6TFzHy67F9QBjmX8aC9pHdqg0pHBMtg5eILTMjducJZa4IENErBHjNLmW5OFDQEgQHLPC5xBqYrd/UrOdze/mJmaiqA2w5Z3MTGbMPS4=
X-HE-Tag: 1795793877-61331
X-HE-Meta: U2FsdGVkX1/j7/71rCLaiFjDADFZc74Yp0prnXfCQBF4enA4f8rdECVF0ISe3Ly50emRXOf2HdrZLBLkoiuEGR+oJRbQMf1/i+XDUMlfnGYQLe0qCt97O5CoaW4hoC/F91l99iY/PiDqO+8+vTXQ/AqPP2NBByNBDH6ZeqAMh2ENM4PHzXqgryIcX89x6oAGO21F8xOdO8sPkf0hilILgoDsi/WPMta7T9oIZop3OuyFMZuh3Xa03sko/cmK1iz7ICGKr8JAtH6AwvAW+3SZ/GaNkx1chFRpRs88093QP1TiqPh96gshIMWlNhgBxJ8YToqfmwL7/M92MqAiLAblOPtD1GS54wKUZbI+XxSG0KneN+QExrohcDopEQ3txjhSmzlE8y/PHhCMFRNW5B4exSNDaEa0lMV25DdZfKhiKZWSY0+oQ1O26svscCbJSE0O+34Xusfmkes=

On Wed, 25 Nov 2026 20:52:56 -0800
Ian Rogers <irogers@google.com> wrote:

> There has been recent work on both MIPS and Alpha for perf events, so
> supporting ARM32 EHABI doesn't seem unreasonable. Devices like the
> Raspberry Pi Zero W/WH, which use a 32-bit CPU are end-of-life in 2030
> (according to https://endoflife.date/raspberry-pi ). It is
> out-of-scope here, but extending the kernel and verification
> infrastructure shouldn't be hard.

If it's not too much of a burden then sure. I've stopped supporting new
features in ftrace for x86 32bit a long time ago ;-)

-- Steve
