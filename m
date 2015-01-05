From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 0/2] arm64: don't call early_*map() post paging_init()
Date: Mon,  5 Jan 2015 18:33:53 +0000
Message-ID: <1420482835-6444-1-git-send-email-leif.lindholm@linaro.org>
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
To: msalter@redhat.com, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, will.deacon@arm.com, catalin.marinas@arm.com
Cc: ard.biesheuvel@linaro.org
List-Id: linux-efi@vger.kernel.org

This (tiny) series resolves a fairly serious problem with
early_ioremap/iounmap/memremap/memunmap on arm64. These functions
cannot safely be called after paging_init(), but the sanity check
was not triggering.

As a result, a fixmap entry was incorrectly cleared during
early_initcalls on arm64 UEFI systems.

1/2 reworks the arm64 UEFI support code to not attempt these calls
and
2/2 enables the sanity check

Leif Lindholm (2):
  arm64: don't make early_*map() calls post paging_init()
  arm64: call early_ioremap_reset() in paging_init()

 arch/arm64/kernel/efi.c   | 12 +++---------
 arch/arm64/kernel/setup.c |  2 --
 arch/arm64/mm/mmu.c       |  1 +
 3 files changed, 4 insertions(+), 11 deletions(-)

-- 
2.1.3
