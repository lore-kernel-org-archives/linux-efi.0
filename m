From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 156/156] x86/efi: Clarify that reset attack mitigation needs appropriate userspace
Date: Fri,  2 Feb 2018 17:58:57 +0100
Message-ID: <20180202140847.458165935@linuxfoundation.org>
References: <20180202140840.242829545@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180202140840.242829545@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Matthew Garrett <mjg59@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <mjg59@google.com>

commit a5c03c31af2291f13689d11760c0b59fb70c9a5a upstream.

Some distributions have turned on the reset attack mitigation feature,
which is designed to force the platform to clear the contents of RAM if
the machine is shut down uncleanly. However, in order for the platform
to be able to determine whether the shutdown was clean or not, userspace
has to be configured to clear the MemoryOverwriteRequest flag on
shutdown - otherwise the firmware will end up clearing RAM on every
reboot, which is unnecessarily time consuming. Add some additional
clarity to the kconfig text to reduce the risk of systems being
configured this way.

Signed-off-by: Matthew Garrett <mjg59@google.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/Kconfig |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -159,7 +159,10 @@ config RESET_ATTACK_MITIGATION
 	  using the TCG Platform Reset Attack Mitigation specification. This
 	  protects against an attacker forcibly rebooting the system while it
 	  still contains secrets in RAM, booting another OS and extracting the
-	  secrets.
+	  secrets. This should only be enabled when userland is configured to
+	  clear the MemoryOverwriteRequest flag on clean shutdown after secrets
+	  have been evicted, since otherwise it will trigger even on clean
+	  reboots.
 
 endmenu
 
