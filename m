Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795264967;
	b=fQ6cd4rVAFwu7gSXBwZxDmBLWswmgKJcqNx9FrAmxRB8tPSfV3qv2OHqE48gNcPzFrWE
	 ByCImukPSB2RFi2Q04zf4xSMq2dBOxw8NnEO+v1EnmcDsP9Pfk8EBJC9vUvQ/cGuVw5on
	 1E4hNRxuwK3HKY9+VM5R/rgxrDO2TqGCUuv+lCKLuH3Q+0/OVSRbyu3SNPAryot9DZEpy
	 fpJWZ8BYD4FyOoKDZ0I8yBUqlk8t8at1d0OZMy3oPcivSY5JblDqTIPbsZxVUvCD844Pl
	 28XmxvXMfUuUtvXpU49cnvgzr+oSuRmwvOetCCz/PdqJl8hDoftILF/Uwrg8yjxYugg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795264967;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=RuNf+pePjIWf7fpgOl6kHLwN5HRwrqk6Ttj5H6K8/Jo=;
	b=2dRhoAapGGkOYN71pNt+r23qfWfE6dNiaTzWOXbWV4yOyepQIRdta7haaKdJEHamEDMy
	 2weTZjMr3GLOLlqRkNS47CsuugA6xQc8FTPP3h0rC0q9x+36KGsPKseuRCZHXHhRMFN2h
	 f45uSguyq65Xkeiyzch8BbITmpIu2Ed9W6ovl3ZfO3rHZuImaZLRPRogStk7JRpR3Ts9y
	 V9jHVtA8xh5hCIsAVKq8XrKsltszoPYr/XilyUEjQNIdCZYrAlcPknyw2CTF25ipZWPIJ
	 NvB4OfVrSIjw85NRHeTK7wvjkVTKeBPx8RCzRm9z0GDiWVnYGF/mdgCk+rkkUgcet8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Edkrk0u9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54F7606A320
	for <linux-efi@vger.kernel.org>; Sat, 21 Nov 2026 12:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Edkrk0u9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467F51F000C4;
	Sat, 21 Nov 2026 12:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795264967;
	bh=RuNf+pePjIWf7fpgOl6kHLwN5HRwrqk6Ttj5H6K8/Jo=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Edkrk0u9ZBtn+sfvtyuaB/62cjo0kHZXc7JqL1+Jp4ysmhyM/WQWc+zX5yq5ntE+k
	 PL91l3Ay41tESI8Ugjuvp2aENCO0yodQ5+tfIZLAi13ySYtAfEaVGuxx1E57xfWmis
	 rEjsgGfnti4RQFMyOPd3QkzDs7JG5bd3LCiGn1+JSoIMwFGbjkMTaJam9jZPEqhKs9
	 OQyjCnUOo+vaApoK20oxvbEZpoqIssyd7YG2tavubLveNtDjejhWiRSqVmCOp1ucF2
	 q3YhaEZbxEysEJktsEXJmYai7zYBPzNQdPoOqVpcfVvZGgxERveq0jA9pmSyw/uW2I
	 ilbvM8oWL2z4A==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8364D198003A;
	Sat, 21 Nov 2026 07:42:44 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Sat, 21 Nov 2026 07:42:44 -0500
X-ME-Sender: <xms:wJEBa-ZtDfskQiFzaQkxwVZMjq6DINcp4B6Qz1M2SaA5wwiI4_tiUw>
    <xme:wJEBa8NCC5VQmS8G261kZ6ip0-tk_XJZFGroObPFb8iocwZNqWdOahCNPdXDHSQlM
    HyN0W4dPkuG1m2gUPabxWiFTmCzFbJDkMhklxB0rrNmH-Y-fdyedhr5>
X-ME-Proxy-Cause: dmFkZTE9e/DNRSP39ywX8YGfN8UoAyYP0CkDVl1avqiAO6xwU1q4JAb9xbXdWO/PpICXkX
    zSe7F6+aKSXIivBTl4vZebp345mjcvLiZD9TrcN4QHwBOm4LthXKqGLtvIk6OB86Itx5kS
    d/UV1jGeDDUTrmqovg7yftxuaJvfmdlHv1cqtQRmHAiOgfntYjw8a9G5ML3j1HE+rNqrVv
    sJFYZ4GZgtsNvuRQjxcJtW6yVD0Woj3jL7EuAHCN2PhP3rLmluqpBpD3npZIKTrh/eJwu+
    Lw3q/JjeWsgRzz3r5esxoF6oGSF9wTLqWumVmdUFgjUGa9Tpovw5aSjfTMwfCS592JTuoV
    OcXXV3oeikv72LVep537lddmHM1Iut790jkACgOjIl+lEFO4p3xtlcZddXdPlBYFtphFDP
    jV32RIJDx4tRZ2V5R/L0EsrklNVJbzl7ijr/T3nZVrJa82J4FoSmDH/wqpWF6Q/DzLC7UO
    0GqxSPyYwOx8njcf0bDlwbbQQrKhDvHIkwvEcARRI/kQBu4gR7VcNwPUgpi5Vo+mq2sbbX
    JsQXlL0ca+cqLynAiw8kIttg+OZmMDY42RhkY/ihzW1I+bJk+G9+JyYVViCb3eNHh6SNs7
    Nga9lB9eHPZJC2iV/xvblxvv98by0fJIDxf0P1vn//Dnp0e2VImQzs8lz2wA
X-ME-Proxy: <xmx:xJEBawZT-KsmJZzuUSa4Uls47l6wsD-ci_BoSZ8jlZQATSPlTA8QYQ>
    <xmx:xJEBa6r1kDXzUi7QTo6cAoEOem3srPLfrattqzVlNKoAHexfPEQZJQ>
    <xmx:xJEBa9xJhgpCROoCvfEgXfgfFrtmU2GSpQ2U0d49dLNbWRUuCUW-Zg>
    <xmx:xJEBayLyKn1Qzc1vCBGkv0JyamZh9rl3O9Ev_HOOuNk6vN1DQ_UqaA>
    <xmx:xJEBa_7sd8dXEJRNAg92aZYpU2HoUJd-Va-8yw61X00ejPrsRHaXKaZB>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id B33E7F8008E; Sat, 21 Nov 2026 07:42:40 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: Afc6hXNcC8eV
Date: Sat, 21 Nov 2026 13:42:20 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: gaohan@iscas.ac.cn, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre Ghiti" <alex@ghiti.fr>,
 "Atish Patra" <atish.patra@linux.dev>, "Stephen Boyd" <sboyd@kernel.org>,
 "Brian Masney" <bmasney+clk@redhat.com>,
 "Jerome Brunet" <jbrunet+clk@baylibre.com>,
 "Chen Wang" <chen.wang@linux.dev>, "Inochi Amaoto" <inochiama@gmail.com>
Cc: "Han Gao" <rabenda.cn@gmail.com>, linux-efi@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-clk@vger.kernel.org, sophgo@lists.linux.dev
Message-Id: <bb39f961-0589-4a3e-b649-888cf5edd3a1@app.fastmail.com>
In-Reply-To: <20261121-b4-sg2042-efi-rtc-v1-1-19898b8ad497@iscas.ac.cn>
References: <20261121-b4-sg2042-efi-rtc-v1-0-19898b8ad497@iscas.ac.cn>
 <20261121-b4-sg2042-efi-rtc-v1-1-19898b8ad497@iscas.ac.cn>
Subject: Re: [PATCH 1/2] riscv: efi: Map runtime MMIO with device attributes
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 21 Nov 2026, at 11:38, Han Gao via B4 Relay wrote:
> From: Han Gao <gaohan@iscas.ac.cn>
>
> EFI_MEMORY_MAPPED_IO regions are mapped with PAGE_KERNEL, so device
> registers end up mapped as normal memory.
>
> On Milk-V Pioneer, GetTime() reads the clock controller registers and
> faults:
>
>   Oops - load access fault [#1]
>   Workqueue: efi_runtime efi_call_rts
>   status: 0000000200000120 badaddr: 0000007030012000 cause: 0000000000000005
>
> Use PAGE_KERNEL_IO for these regions.
>
> Fixes: b91540d52a08 ("RISC-V: Add EFI runtime services")
> Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
> ---
>  arch/riscv/kernel/efi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

I can take this as a fix via the EFI tree if you like.


> diff --git a/arch/riscv/kernel/efi.c b/arch/riscv/kernel/efi.c
> index 2d3cc57b4535..11e85d0ebc91 100644
> --- a/arch/riscv/kernel/efi.c
> +++ b/arch/riscv/kernel/efi.c
> @@ -22,7 +22,7 @@ static __init pgprot_t 
> efimem_to_pgprot_map(efi_memory_desc_t *md)
>  	u32 type = md->type;
> 
>  	if (type == EFI_MEMORY_MAPPED_IO)
> -		return PAGE_KERNEL;
> +		return PAGE_KERNEL_IO;
> 
>  	/* R-- */
>  	if ((attr & (EFI_MEMORY_XP | EFI_MEMORY_RO)) ==
>
> -- 
> 2.55.0
