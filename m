Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795277484;
	b=y6UG93kWFkZoxQZ0HTfLVOWkEQaVq7a+hKl3xO9uLv9gfClzhY6OTDdnLqt59PaKDsgg
	 cw3cdT52sbjoMAKVYe/DQMLpMM6P7NqIxjpoE3OkcFoSXAHt2ZBNFwuB/cJkqgqEQaT/C
	 jdCZzA4BRgOCl+0wi59Z0WiwpgVTqjFipfVU2LsqPMS9Zix/tBrAiYaeF5RUdE0eegcph
	 43+eWCUr+PDTirb3sZ8R87eYKNpsgahwXMu3YyRiB4k8gjwxIZCeakNhVfF0ft664dVk2
	 VwMtAGAdk3yqqYNIMqglNCo5UZPeqs5PKljBhn/qloA5JkbI20BVTW7jfeaWRudK4KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795277484;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=W1j+QhMZh7cgcvgfATIzWEl16YVX0rVq0ndiSNVz1qQ=;
	b=WgPclbkZWOOlyowV4L9RFOhf4dN0WFiGOnNZKTrmev1t3KjpBdC2Yr40MEeCNUlkIBjd
	 4pyJEs3b/ZYtUlIdhUCt+u26hAwRS8AH+FZoWVWic4ewTJmnDQ0lD5vXO9bNMTvBB1oD9
	 xWTGCS5sPuYXEblZj3Egvkq16FQRdMTJB1FQVhAIoEamqJVCKhPlUoYBIaL6ROy3SZCLR
	 xqtFFYryofP9k/tgknKMJcrp5VQIAvmhfjjSvIdVvNBjhuaUM+Jz53IpEDh+ktklNoG87
	 RfRuSahAtbGB/NpND4aO6vra0DB2OFd8EFSAWwfFFm8fPcFhAWz3bewxY92gX2IBF9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NzYmgpvu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8B3606A32A;
	Sat, 21 Nov 2026 16:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NzYmgpvu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8CE1F000C0;
	Sat, 21 Nov 2026 16:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795277484;
	bh=W1j+QhMZh7cgcvgfATIzWEl16YVX0rVq0ndiSNVz1qQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NzYmgpvuJIFpPtdd8tq6/HIa7robc9D/bIOhT2avJpe9XsZ6qHCrISlXgK8/FvGh/
	 X0wzFu07O7Bad2wBXUms7a8LkKwPT/Eu9TaW4283DaOs68wshJmLT8sR1EOsAIgcrP
	 fJ28Nz2Eg2FQ+XPtbvPO0JpEQJhgF1sr5tr9cTyRlXTzXQ0l/TpEq6rdSzHMuFv1Xi
	 mLqLKk68m6oqZW//bZ5jEkOlHZtVPc/ZjXidDPi0XUOt5jlnQSRT1K8Nb6J1JV/P+v
	 pRHJRQz13IY/6G+1iWO7qhh5yT0O5epbn11ShX/aNvvt7kk9upAw3DUxP47zcelqhP
	 Zqw8JANXcUQ+A==
Message-ID: <b64cf863-e50d-455f-826c-13cd9ec66c6b@kernel.org>
Date: Sat, 21 Nov 2026 17:11:15 +0100
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
Subject: Re: [PATCH 2/2] clk: sophgo: sg2042-clkgen: Keep gates of reserved
 devices enabled
To: gaohan@iscas.ac.cn, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Atish Patra <atish.patra@linux.dev>, Stephen Boyd <sboyd@kernel.org>,
 Brian Masney <bmasney+clk@redhat.com>,
 Jerome Brunet <jbrunet+clk@baylibre.com>, Chen Wang <chen.wang@linux.dev>,
 Inochi Amaoto <inochiama@gmail.com>
Cc: Han Gao <rabenda.cn@gmail.com>, linux-efi@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-clk@vger.kernel.org, sophgo@lists.linux.dev
References: <20261121-b4-sg2042-efi-rtc-v1-0-19898b8ad497@iscas.ac.cn>
 <20261121-b4-sg2042-efi-rtc-v1-2-19898b8ad497@iscas.ac.cn>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <20261121-b4-sg2042-efi-rtc-v1-2-19898b8ad497@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/11/2026 11:38, Han Gao via B4 Relay wrote:
> From: Han Gao <gaohan@iscas.ac.cn>
> 
> On Milk-V Pioneer, firmware can own I2C0 to back the EFI RTC, with the
> node marked status = "reserved". I2C0 shares GATE_CLK_APB_I2C with the
> I2C controllers Linux uses. When those runtime-suspend, the gate is
> switched off under the firmware and GetTime() returns EFI_NOT_READY.
> 
> Walk the reserved children of /soc and match their clock references,
> as done in commit 6aa175476490 ("clk: renesas: cpg-mssr: Ignore all
> clocks assigned to non-Linux system"). Unlike that driver, use
> CLK_IS_CRITICAL rather than CLK_IGNORE_UNUSED: the gate is shared with
> devices Linux drives, and their runtime PM would still turn it off.
> 
> Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
> ---
>  drivers/clk/sophgo/clk-sg2042-clkgen.c | 38 +++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/sophgo/clk-sg2042-clkgen.c b/drivers/clk/sophgo/clk-sg2042-clkgen.c
> index 6abc2c973c49..414904965edf 100644
> --- a/drivers/clk/sophgo/clk-sg2042-clkgen.c
> +++ b/drivers/clk/sophgo/clk-sg2042-clkgen.c
> @@ -11,6 +11,8 @@
>  #include <linux/clk.h>
>  #include <linux/clk-provider.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_clk.h>
>  #include <linux/platform_device.h>
>  #include <asm/div64.h>
>  
> @@ -840,6 +842,35 @@ static int sg2042_clk_register_divs(struct device *dev,
>  	return ret;
>  }
>  
> +static bool sg2042_clk_is_reserved(struct device_node *clkgen, unsigned int id)
> +{
> +	struct device_node *soc __free(device_node) = of_find_node_by_path("/soc");

Where did you document the ABI? Soc is implied but not enforced. commit
6aa175476490 makes the same mistake.

Reserved nodes might not even appear in DTB passed to Linux, because
they are not the hardware exposed to the OS, so this entire approach is
fragile. IMO, the list of clocks which are not controller by Linux
should be static in the driver, but if you insist on using some ABI then
you must document it.

Best regards,
Krzysztof
