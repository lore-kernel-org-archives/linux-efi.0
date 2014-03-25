From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v3 0/5] xen: Add EFI support
Date: Tue, 25 Mar 2014 21:57:51 +0100
Message-ID: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org
Cc: fenghua.yu@intel.com, jeremy@goop.org, matt.fleming@intel.com, ian.campbell@citrix.com, stefano.stabellini@eu.citrix.com, tony.luck@intel.com, mingo@redhat.com, david.vrabel@citrix.com, jbeulich@suse.com, hpa@zytor.com, boris.ostrovsky@oracle.com, tglx@linutronix.de, eshelton@pobox.com
List-Id: linux-efi@vger.kernel.org

Hey,

This patch series adds EFI support for Xen dom0 guests.
It is based on Jan Beulich and Tang Liang work. I was
trying to take into account all previous comments,
however, if I missed something sorry for that.

Additionally, I attempted to leave all credits as is and
put SOB in relevant places. If I made any mistake drop me
a line and I will fix it in next version.

Feel free to play with it. I am looking forward for your comments.

Daniel

 arch/ia64/kernel/efi.c           |   30 ++++--
 arch/x86/kernel/setup.c          |    2 +-
 arch/x86/platform/efi/efi.c      |   20 ++--
 arch/x86/xen/enlighten.c         |   10 ++
 drivers/firmware/efi/efi.c       |   26 ++++++
 drivers/xen/Kconfig              |    3 +
 drivers/xen/Makefile             |    1 +
 drivers/xen/efi.c                |  425 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h              |   10 ++
 include/xen/interface/platform.h |  123 +++++++++++++++++++++++-
 10 files changed, 633 insertions(+), 17 deletions(-)

Daniel Kiper (5):
      efi: Add efi_init_ops variable
      efi: Export arch_tables variable
      x86: Call efi_memblock_x86_reserve_range() on native EFI platform only
      xen: Define EFI related stuff
      xen: Put EFI machinery in place
