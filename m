Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793007675;
	b=GXE1SCOOtVkDRmLotGJj8sI9VR8AlRacXgzLul6x/LRzQ9cuEbKnuV1XFbbf3lgQOHu+
	 ShccIMVgfMb1lMKsFjUGQcyAZzTVAyNSn+s/FL1+ng1Rhdo+3Bx8htdU/sNC3TkNWsntd
	 t447mJygD1nOLrhbdC+yfAqivltGU+DJKJX6JReULx+rVE6R4YjQ6z6eGpsOwF8ZLUbTd
	 Sah0qAm2cw3nOb5TiARR04mv4aqrdrUjg+/L+dugOJQX2rVrfmfsPw5dawk4tviPA7jGc
	 6Lcwe/Vy2IICoQ3pufLO9zCWhFGyKMAcnZpCyntNAvGFvDpa3huFZSOI9gE+UgSH9UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793007675;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=fmErr11J4yiDe+oqOLxrAHXMe+lgqHj/gW1PNNiv0PY=;
	b=R+RiHAC8GtzZb4e8+UvCbZ7Pa4QpNPXM/tT9OsvYXUbloTqigPDBGEb6e640/O8EwVHL
	 WxAHy5x1v67Mqj4eO822ValNvhCB61K3JswqUyqL5Tm0Is3hOuH5mSrONNJ2uvQO3DiLE
	 lejRDQ8Riav8CnImEjtQsWqeDxCC19ulX9EMwDZXUBTXAuk//dE5uZf5MrFB94q5GYTtZ
	 b0tsp9LYMTetxgGUinbzEeSalalaHAd6KAQH1lMnqDliF5hyS/ygszNh+rQFSSl+/YjyQ
	 aH/gevGmDEEVKmWtWJoa+3AxOQk3apsF3NApCunseh4c4OCA6yukg3CEv5R8U/NnU0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hoY+nVJd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43B9606A330;
	Mon, 26 Oct 2026 09:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hoY+nVJd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56F11F031E2;
	Mon, 26 Oct 2026 09:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007674;
	bh=fmErr11J4yiDe+oqOLxrAHXMe+lgqHj/gW1PNNiv0PY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hoY+nVJdTpF+bOnGRqA60bqEon5wES0uTDgRThXCOwAPT/eYwNotrJ8PurgaBDBH8
	 6RTUTlsQSoBeGbuLzwDPLxO6Tg9aX0DzEGmjJzZhajmJdWtdQFKWaGv+iqM+2uBKpu
	 026t64oG7a4GhVyDaiFRtUzs+QhNWsy1qp4OK/oABUnwArhQHMz6REf23JPiDPpyUt
	 H3PBDpVbqxeuL8lP8i6Dj/GHiIrypsBVaNKkQxsf+1b7KTZ/1TIdboA/vnbPXaRbcE
	 n8p/qSrc52pFTkI67KgPo+ShAyE6zmyE2/FC0JJN0+EVo+8neJxNDYKWgRVYf+Oiv/
	 WBm0YdS18Y/Ng==
Message-ID: <a6cbfb24-efea-41ef-8f1b-dd2bd160cff4@kernel.org>
Date: Sun, 25 Oct 2026 13:43:55 +0100
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
Subject: Re: [PATCH] mm: ppm: add PPM (Page-Plugger Under Memory) to Page
 Fault and Overcommit elimination
To: dev12124 <joaoanandalima@gmail.com>, linux-mm@kvack.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, ardb@kernel.org, keescook@chromium.org
References: <20261024104552.394-1-joaoanandalima@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261024104552.394-1-joaoanandalima@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/24/26 12:45, dev12124 wrote:
> Hi mm subsystem,

Hi,

> 
> This patch implements the Memory Tatic called PPM, Page-Plugger Under Memory.
> The Main Objective is: Page Faults and Overcommit Elimination.
> 
> A few points under additionate:
> 
> 1. Allocation Handshake (ppm_kalloc):
> Using the GFP_PLUG_MEMORY mask, the allocator completely bypasses
> passive overcommit verification. It instantly isolates physical frames
> on the RAM, maps the page table entries síncronamente, and forces the
> Present Bit and Writable Bit to 1 before returning the address block
> register to the CPU.
> 
> 2. Desallocation Cleanup (ppm_kfree):
> Triggered via the GFP_FREE_T parameter, the release phase executes an
> immediate length truncation to 0. It forces a synchronous TLB
> invalidation (via invlpg execution) and flushes the data out of the L3
> cache lines using clflushopt instructions before moving the hot clean
> pages into a dedicated priority recycling pool.
> 
> I additionate a Buffer/Cache with store important objects.

Reading this description I have no idea what this patch does, what it tries to
solve, and why anybody should spend their time to look into it.

> ---
>  include/linux/ppm/gfp_types.h |  74 ++++++++++++++++
>  include/linux/slab.h          |  11 +++
>  mm/memory.c                   | 158 ++++++++++++++++++++++++++++++++++
>  3 files changed, 243 insertions(+)
>  create mode 100644 include/linux/ppm/gfp_types.h
> 
> diff --git a/include/linux/ppm/gfp_types.h b/include/linux/ppm/gfp_types.h
> new file mode 100644
> index 000000000..741122b2d
> --- /dev/null
> +++ b/include/linux/ppm/gfp_types.h
> @@ -0,0 +1,74 @@
> +/* 
> +  Memory Tatic: PPM (Page-Plugger Under Memory).
> +  This File is for PPM Flags/Macros/Functions/Types.
> +  Engineer (brazilian): João Guilherme da Silva Freitas Lima <joanandalima@gmail.com>
> + */
> +
> +/* Types Include Guards */
> +#ifndef __PPM_TYPES_MEMORY 
> +#define __PPM_TYPES_MEMORY 
> +
> +typedef unsigned char uint8_t;
> +typedef unsigned short uint16_t;
> +typedef unsigned int uint32_t;
> +typedef unsigned long long uint64_t;
> +typedef uint64_t gfp_t;
> +/* For errors in Allocation */
> +#define __PPM_ALLOC_ERROR -102
> +/* For errors in Desallocation */
> +#define __PPM_FREE_ERROR 0x04 
> +/* For success */
> +#define __PPM_SUCCESS 0
> +#endif
> +
> +/* Functions Include Guards */
> +#ifndef __PPM_FUNCTIONS_MEMORY
> +#define __PPM_FUNCTIONS_MEMORY 
> +
> +/* Initializer */
> +void __init_ppm_memory();
> +
> +/* Allocator Optimized */
> +int ppm_kalloc(unsigned long address, uint64_t size, gfp_t flags);
> +
> +/* Desallocator Optimized */
> +int ppm_kfree(uint64_t size);
> +
> +#endif
> +
> +/* Flags Include Guards */
> +#ifndef __PPM_FLAGS_MEMORY 
> +#define __PPM_FLAGS_MEMORY
> +
> +/* PPM inits/starts in Bit 54 of a 
> +   64-bit variable 
> + */
> +gfp_t GFP_PLUG_MEMORY = (1ULL << 54); 
> +
> +/* For free memory, the Bit 55 is 
> +   used 
> + */
> +gfp_t GFP_FREE_T = (1ULL << 55);
> +
> +#endif 
> +
> +/* Macros Include Guards */
> +#ifndef __PPM_MACROS_MEMORY
> +#define __PPM_MACROS_MEMORY
> +
> +/* For Kernel Kernel tests 2 Bits (54 and 55) in 
> +  1 Clock Cycle (or in small clocks, example: 5 Clocks), 
> +  is used a mask using | 
> + */
> +gfp_t GFP_MASK = GFP_PLUG_MEMORY | GFP_FREE_T;
> +
> +#endif
> +
> +/* 
> +  Notes:
> +    E-Mail of RFC:
> +        [RFC] mm: page-fault: overcommit: PPM (Page-Plugger Under Memory)
> +    
> +    
> +    Assigned-Off-by: João <joanandalima@gmail.com>

I don't know if I am supposed to laugh or cry ;)

-- 
Cheers,

David
