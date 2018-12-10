From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/4] ARM: re-enable EFI persistent memory reservations
Date: Mon, 10 Dec 2018 17:29:45 +0100
Message-ID: <20181210162949.8597-1-ard.biesheuvel@linaro.org>
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
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-efi@vger.kernel.org, Russell King <linux@armlinux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

The EFI persistent memory reservations introduced during the v4.20
merge window had some teething issue, and we ended up disabling it
temporarily for 32-bit ARM due to the fact that the needed changes
were not as straightforward as on arm64.

So this series fixes the issues, and re-enables the feature for
32-bit ARM.

Cc: Russell King <linux@armlinux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>

Ard Biesheuvel (4):
  ARM: mm: permit memblock resizing right after mapping the linear
    region
  ARM: mm: permit early_memremap() to be used in paging_init()
  efi/arm: apply persistent memory reservations during paging_init()
  efi/arm: re-enable the memreserve table for 32-bit ARM

 arch/arm/kernel/setup.c                 | 2 --
 arch/arm/mm/init.c                      | 1 -
 arch/arm/mm/mmu.c                       | 5 +++++
 drivers/firmware/efi/libstub/arm-stub.c | 3 ---
 4 files changed, 5 insertions(+), 6 deletions(-)

-- 
2.19.2
