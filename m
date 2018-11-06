From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [PATCH 0/4] Enable deadcode elimination at link time
Date: Tue, 6 Nov 2018 13:39:35 +0000
Message-ID: <20181106133935.GB30658@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
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
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

This series enables elimination of dead code from the kernel at link
time.  The changes are mostly ARM specific, except for one change in
EFI as the EFI stub must not be compiled with -fdata-sections.

 arch/arm/Kconfig                       |  1 +
 arch/arm/boot/compressed/vmlinux.lds.S |  2 +-
 arch/arm/kernel/vmlinux.lds.S          | 10 +++++-----
 arch/arm/kernel/vmlinux.lds.h          | 18 +++++++++---------
 drivers/firmware/efi/libstub/Makefile  |  2 +-
 5 files changed, 17 insertions(+), 16 deletions(-)

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
