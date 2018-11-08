From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 1/6] arm64: memblock: don't permit memblock resizing
 until linear mapping is up
Date: Thu, 8 Nov 2018 17:53:54 +0000
Message-ID: <20181108175354.GF144107@arrakis.emea.arm.com>
References: <20181107141611.12076-1-ard.biesheuvel@linaro.org>
 <20181107141611.12076-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20181107141611.12076-2-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, marc.zyngier@arm.com, bhsharma@redhat.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 07, 2018 at 03:16:06PM +0100, Ard Biesheuvel wrote:
> Bhupesh reports that having numerous memblock reservations at early
> boot may result in the following crash:
> 
>   Unable to handle kernel paging request at virtual address ffff80003ffe0000
>   ...
>   Call trace:
>    __memcpy+0x110/0x180
>    memblock_add_range+0x134/0x2e8
>    memblock_reserve+0x70/0xb8
>    memblock_alloc_base_nid+0x6c/0x88
>    __memblock_alloc_base+0x3c/0x4c
>    memblock_alloc_base+0x28/0x4c
>    memblock_alloc+0x2c/0x38
>    early_pgtable_alloc+0x20/0xb0
>    paging_init+0x28/0x7f8
> 
> This is caused by the fact that we permit memblock resizing before the
> linear mapping is up, and so the memblock_reserved() array is moved
> into memory that is not mapped yet.
> 
> So let's ensure that this crash can no longer occur, by deferring to
> call to memblock_allow_resize() to after the linear mapping has been
> created.
> 
> Reported-by: Bhupesh Sharma <bhsharma@redhat.com>
> Acked-by: Will Deacon <will.deacon@arm.com>
> Tested-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

I missed this patch (wasn't cc'ed) but Will pinged me on IRC, so queued
for 4.20. Thanks.

-- 
Catalin
