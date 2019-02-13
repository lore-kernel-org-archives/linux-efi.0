From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/2] efi/arm/gicv3: implement fix for memory reservation issue
Date: Wed, 13 Feb 2019 14:27:36 +0100
Message-ID: <20190213132738.10294-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-mm@kvack.org, James Morse <james.morse@arm.com>, Andrew Morton <akpm@linux-foundation.org>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Another attempt at fixing the chicked-and-egg issue where the number of
memblock reservations for GICv3 LPI tables overflow the statically
allocated table, and reallocating it involves allocating memory pages
that may turn out to be the ones we were attempting to reserve in the
first place.

If this is accepted as an appropriate fix, something similar should be
backported to v4.19 as well, although there, we'll need to increase the
memblock reservation table size even more, given that it lacks a later
optimization to the EFI memreserve code to merge the linked list entries.

Cc: Catalin Marinas <catalin.marinas@arm.com> 
Cc: Will Deacon <will.deacon@arm.com> 
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Marc Zyngier <marc.zyngier@arm.com> 
Cc: James Morse <james.morse@arm.com>
Cc: linux-mm@kvack.org 

Ard Biesheuvel (2):
  arm64: account for GICv3 LPI tables in static memblock reserve table
  efi/arm: Revert "Defer persistent reservations until after
    paging_init()"

 arch/arm64/include/asm/memory.h         | 11 +++++++++++
 arch/arm64/kernel/setup.c               |  1 -
 drivers/firmware/efi/efi.c              |  4 ----
 drivers/firmware/efi/libstub/arm-stub.c |  3 ---
 include/linux/efi.h                     |  7 -------
 include/linux/memblock.h                |  3 ---
 mm/memblock.c                           | 10 ++++++++--
 7 files changed, 19 insertions(+), 20 deletions(-)

-- 
2.20.1
