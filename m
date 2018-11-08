From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/2] efi/arm regression fixes
Date: Thu,  8 Nov 2018 19:45:50 +0100
Message-ID: <20181108184552.14366-1-ard.biesheuvel@linaro.org>
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
Cc: mark.rutland@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, marc.zyngier@arm.com, will.deacon@arm.com, leif.lindholm@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

A couple of fixes for ef/arm issues that were introduced before the
merge window.

Ard Biesheuvel (2):
  efi: arm: revert deferred unmap of early memmap mapping
  efi/arm: libstub: pack FDT after populating it

 drivers/firmware/efi/arm-init.c    | 4 ++++
 drivers/firmware/efi/arm-runtime.c | 2 +-
 drivers/firmware/efi/libstub/fdt.c | 4 ++++
 drivers/firmware/efi/memmap.c      | 3 +++
 4 files changed, 12 insertions(+), 1 deletion(-)

-- 
2.19.1
