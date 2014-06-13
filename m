From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v5 0/7] xen: Add EFI support
Date: Fri, 13 Jun 2014 19:00:16 +0200
Message-ID: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
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
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org
Cc: mjg59@srcf.ucam.org, jeremy@goop.org, matt.fleming@intel.com, ian.campbell@citrix.com, andrew.cooper3@citrix.com, stefano.stabellini@eu.citrix.com, mingo@redhat.com, david.vrabel@citrix.com, jbeulich@suse.com, hpa@zytor.com, boris.ostrovsky@oracle.com, tglx@linutronix.de, eshelton@pobox.com
List-Id: linux-efi@vger.kernel.org

Hey,

This patch series adds EFI support for Xen dom0 guests.
It is based on Jan Beulich and Tang Liang work. I was
trying to take into account all previous comments,
however, if I missed something sorry for that.

Daniel

 arch/x86/kernel/setup.c          |    4 +-
 arch/x86/platform/efi/efi.c      |   77 ++++++++++-------
 arch/x86/xen/enlighten.c         |   24 ++++++
 drivers/firmware/efi/efi.c       |   26 +++---
 drivers/xen/Kconfig              |    4 +
 drivers/xen/Makefile             |    3 +
 drivers/xen/efi.c                |  374 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h              |    3 +-
 include/xen/interface/platform.h |  123 +++++++++++++++++++++++++++
 9 files changed, 595 insertions(+), 43 deletions(-)

Daniel Kiper (7):
      efi: Use early_mem*() instead of early_io*()
      efi: Introduce EFI_NO_DIRECT flag
      xen: Define EFI related stuff
      xen: Put EFI machinery in place
      arch/x86: Replace plain strings with constants
      arch/x86: Remove redundant set_bit() call
      arch/x86: Comment out efi_set_rtc_mmss()
