From: David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire
 section
Date: Mon, 10 Oct 2016 08:33:50 -0700
Message-ID: <57FBB4DE.2090502@gmail.com>
References: <1475747527-32387-1-git-send-email-rrichter@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475747527-32387-1-git-send-email-rrichter@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Richter <rrichter@cavium.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, linux-efi@vger.kernel.org, David Daney <david.daney@cavium.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Hanjun Guo <hanjun.guo@linaro.org>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On 10/06/2016 02:52 AM, Robert Richter wrote:
> There is a memory setup problem on ThunderX systems with certain
> memory configurations. The symptom is
>
>   kernel BUG at mm/page_alloc.c:1848!
>
> This happens for some configs with 64k page size enabled. The bug
> triggers for page zones with some pages in the zone not assigned to
> this particular zone. In my case some pages that are marked as nomap
> were not reassigned to the new zone of node 1, so those are still
> assigned to node 0.
>
> The reason for the mis-configuration is a change in pfn_valid() which
> reports pages marked nomap as invalid:
>
>   68709f45385a arm64: only consider memblocks with NOMAP cleared for linear mapping
>
> This causes pages marked as nomap being no long reassigned to the new
> zone in memmap_init_zone() by calling __init_single_pfn().
>
> Fixing this by restoring the old behavior of pfn_valid() to use
> memblock_is_memory(). Also changing users of pfn_valid() in arm64 code
> to use memblock_is_map_memory() where necessary. This only affects
> code in ioremap.c. The code in mmu.c still can use the new version of
> pfn_valid().
>
> Should be marked stable v4.5..

In that case you should add:

Cc: <stable@vger.kernel.org> # 4.5.x-

here.


>
> Signed-off-by: Robert Richter <rrichter@cavium.com>
[...]
