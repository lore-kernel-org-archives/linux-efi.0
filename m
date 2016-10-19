From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 0/2] efi/arm64: add vmlinux link to PE/COFF debug table
Date: Wed, 19 Oct 2016 12:40:30 +0100
Message-ID: <1476877232-24308-1-git-send-email-ard.biesheuvel@linaro.org>
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
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: mark.rutland@arm.com, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>, leif.lindholm@linaro.org, eugene@hp.com
List-Id: linux-efi@vger.kernel.org

Much like GNU debug links, PE/COFF binaries can carry the patch to the binary
containing the debugging symbols. Since the kernel binary is loaded by UEFI
at an a priori unknown offset in the 1:1 mapping of physical memory, having
this information is useful for the debugger automation to find the file and
the offset, and load the symbols automatically.

So if we have debugging symbols to begin with (CONFIG_DEBUG_INFO=y), add the
absolute path to vmlinux to the PE/COFF debug table.

Ard Biesheuvel (2):
  efi: libstub: preserve .debug sections after absolute relocation check
  efi: arm64: add vmlinux debug link to the Image binary

 arch/arm64/kernel/Makefile            |  4 +++
 arch/arm64/kernel/head.S              | 34 +++++++++++++++++++-
 arch/arm64/kernel/image.h             |  3 ++
 drivers/firmware/efi/libstub/Makefile | 19 ++++++++---
 4 files changed, 54 insertions(+), 6 deletions(-)

-- 
2.7.4
