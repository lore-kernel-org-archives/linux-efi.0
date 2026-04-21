Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FB73BE642;
	Tue, 21 Apr 2026 11:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776770897; cv=none; b=dB+HageF7HSa/W4tBdVdKUZCry8/fqeQ1ArspGMQRj9U1HM55lu/A0UG/441WBpnhVp/beSFr3QlmI7pYcy0lL7xE9/Kf/Ujb3cnWjOp7V0RMD+Ze02Ex9YKJyrINadx867Nvuz+4zJ2ZA/OXLk0ZKYzx8+4ak1t1uUpSQGmSNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776770897; c=relaxed/simple;
	bh=P++Yyn1JP/4b/huOi9i6Zb2cbr0smKxdMdTr8Xy6wss=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ezzHZcwuX+cpq5eMw1Y2+eYDy2BdXAM9xx3a0nq4Tyqeaixq0Lk+svwdexAdchUejwwddO1HPlIjZrQSJd1/WKkqeHS97IO1Ipy34P2xH1eqCBRGlMFMMpbduAXPEO22yaJxzU+2+MyGlMqC3WDq3foEiJwJuLek2ZKfdhc3BmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MkHF6pjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MkHF6pjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4D7C2BCB0;
	Tue, 21 Apr 2026 11:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776770897;
	bh=P++Yyn1JP/4b/huOi9i6Zb2cbr0smKxdMdTr8Xy6wss=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=MkHF6pjJ3Z2MOSn6pQjQ8C0UJL1o3JdWCUsMuV4cwVyYgySCuMyRw+WsS50l9zXge
	 WHWWh6KcnSUcpjubpmDzfM/CVreYdbRm/BF1uM01NQc7QJCpMRBJSYR9pS3Tyyg1Br
	 S9YeZOZXRhPHP0UnJZMNJ6fv+em6MqeTyx3oYCqUIkBcLeR+osJG2jhkdNwgWr4kJL
	 R1uI0tS82llARgyNsrpVtFHDhJKTK6IfrKm4M0zBDAUqX/QsYjdnPOaBcLAiRtCekS
	 gBNKjr3toK6mms4Xbm3lGfhD0MN3PYVe8mWKbeGDElZ2yu+UzPhw+rICgghvHFUvfx
	 OiTSUr893AfdQ==
Message-ID: <62c418bc-082b-4ae2-a889-f63dd2b7f503@kernel.org>
Date: Tue, 21 Apr 2026 13:28:03 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/7] riscv: add Svnapot-based contiguous PTE support
To: Yunhui Cui <cuiyunhui@bytedance.com>, akpm@linux-foundation.org,
 alex@ghiti.fr, andrew+kernel@donnellan.id.au, andreyknvl@gmail.com,
 anup@brainfault.org, aou@eecs.berkeley.edu, apopple@nvidia.com,
 ardb@kernel.org, atish.patra@linux.dev, baolin.wang@linux.alibaba.com,
 debug@rivosinc.com, djordje.todorovic@htecgroup.com, dvyukov@google.com,
 elver@google.com, glider@google.com, ilias.apalodimas@linaro.org,
 junhui.liu@pigmoral.tech, kasan-dev@googlegroups.com, kees@kernel.org,
 kevin.brodsky@arm.com, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, liu.xuemei1@zte.com.cn, ljs@kernel.org,
 namcao@linutronix.de, osalvador@suse.de, palmer@dabbelt.com, pjw@kernel.org,
 rmclure@linux.ibm.com, rostedt@goodmis.org, rppt@kernel.org,
 ryabinin.a.a@gmail.com, surenb@google.com, vincenzo.frascino@arm.com,
 vishal.moola@gmail.com, wangruikang@iscas.ac.cn, zhangchunyan@iscas.ac.cn
References: <20260421092457.37649-1-cuiyunhui@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260421092457.37649-1-cuiyunhui@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/21/26 11:24, Yunhui Cui wrote:
> Hi,
> 
> First of all, thanks to Ryan Roberts for the work on mTHP and
> Contiguous PTE support on arm64. That work provides a very useful
> reference for reducing page fault overhead and TLB pressure for
> large but still PTE-mapped memory ranges.
> 
> This series adds Svnapot-based contiguous PTE support for RISC-V.
> 
> To achieve similar benefits on RISC-V, this series introduces a
> Contiguous-PTE-like mechanism built on top of the Svnapot extension.
> The intent is to preserve the core-MM PTE semantics while allowing
> RISC-V to transparently fold eligible base-page mappings into
> Svnapot-encoded contiguous mappings when possible.
> 
> The series splits the low-level raw PTE helpers from the public
> core-MM-facing PTE helpers, so that:
> 
> -the __xxx helpers expose the raw hardware PTE encoding,
> -the xxx helpers provide the semantic view expected by core MM,
> -and Svnapot-aware handling is centralized in the public wrapper layer.


Just curious, is there opportunity to share some of the code with arm64,
factoring out helpers that handle something like
CONFIG_ARCH_HAS_CONTIG_PTES ?


-- 
Cheers,

David
