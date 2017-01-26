From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 0/2] efi/arm64: add vmlinux link to PE/COFF debug table
Date: Thu, 26 Jan 2017 19:24:44 +0000
Message-ID: <1485458686-32544-1-git-send-email-ard.biesheuvel@linaro.org>
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
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt@codeblueprint.co.uk, mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com
Cc: leif.lindholm@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Much like GNU debug links, PE/COFF binaries can carry the path on the build
host to the binary containing the debugging symbols. Since the kernel binary
is loaded by UEFI at an a priori unknown offset in the 1:1 mapping of physical
memory, having this information is useful for the debugger automation to find
the file and the offset, and load the symbols automatically.

So if we have debugging symbols to begin with (CONFIG_DEBUG_INFO=y), add the
absolute path to vmlinux to the PE/COFF debug table.

v3: move the EFI debug table itself into the EFI header, which removes the
    need for externally visible symbols or changes to the linker script (#2)
    update commit log to explain that the debug support table is defined
    in the UEFI spec, and is thus not EDK2/PI specific

v2: rebase onto v4.10-rc
    use strip rather than objcopy for first pass (#1)
    move debug table inside #ifdef CONFIG_EFI region in head.S (#2)

Note that these patches can be merged independently, although they are
both required to get the functionality.

Ard Biesheuvel (2):
  efi: libstub: Preserve .debug sections after absolute relocation check
  efi: arm64: Add vmlinux debug link to the Image binary

 arch/arm64/kernel/Makefile            |  4 ++
 arch/arm64/kernel/head.S              | 46 +++++++++++++++++++-
 drivers/firmware/efi/libstub/Makefile | 24 ++++++----
 3 files changed, 65 insertions(+), 9 deletions(-)

-- 
2.7.4
