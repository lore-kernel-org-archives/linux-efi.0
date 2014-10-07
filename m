From: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 00/44] kernel: Add support for poweroff handler call chain
Date: Mon,  6 Oct 2014 22:28:02 -0700
Message-ID: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-mips-bounce@linux-mips.org>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: linux-kernel@vger.kernel.org
Cc: adi-buildroot-devel@lists.sourceforge.net, devel@driverdev.osuosl.org, devicetree@vger.kernel.org, lguest@lists.ozlabs.org, linux-acpi@vger.kernel.org, linux-alpha@vger.kernel.org, linux-am33-list@redhat.com, linux-cris-kernel@axis.com, linux-efi@vger.kernel.org, linux-hexagon@vger.kernel.org, linux-m32r-ja@ml.linux-m32r.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org, linux-xtensa@linux-xtensa.org, openipmi-developer@lists.sourceforge.net, user-mode-linux-devel@lists.sourceforge.net, linux-arm-kernel@lists.infradead.org, linux-c6x-dev@linux-c6x.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-metag@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org, linux-sh@v
List-Id: linux-efi@vger.kernel.org

Various drivers implement architecture and/or device specific means to
remove power from the system.  For the most part, those drivers set the
global variable pm_power_off to point to a function within the driver.

This mechanism has a number of drawbacks.  Typically only one means
to remove power is supported (at least if pm_power_off is used).
At least in theory there can be multiple means to remove power, some of
which may be less desirable.  For example, one mechanism might power off the
entire system through an I/O port or gpio pin, while another might power off
a board by disabling its power controller. Other mechanisms may really just
execute a restart sequence or drop into the ROM monitor, or put the CPU into
sleep mode.  Using pm_power_off can also be racy if the function pointer is
set from a driver built as module, as the driver may be in the process of
being unloaded when pm_power_off is called.  If there are multiple poweroff
handlers in the system, removing a module with such a handler may
inadvertently reset the pointer to pm_power_off to NULL, leaving the system
with no means to remove power.

Introduce a system poweroff handler call chain to solve the described
problems.  This call chain is expected to be executed from the architecture
specific machine_power_off() function.  Drivers providing system poweroff
functionality are expected to register with this call chain.  By using the
priority field in the notifier block, callers can control poweroff handler
execution sequence and thus ensure that the poweroff handler with the
optimal capabilities to remove power for a given system is called first.

Patch 01/44 implements the poweroff handler API.

Patches 02/44 to 04/44 are cleanup patches to prepare for the move of
pm_power_off to a common location.

Patches 05/44 to 07/44 remove references to pm_power_off from devicetree
bindings descriptions.

Patch 08/44 moves the pm_power_off variable from architecture code to
kernel/reboot.c. 

Patches 09/44 to 30/44 convert various drivers to register with the kernel
poweroff handler instead of setting pm_power_off directly.

Patches 31/44 to 42/44 do the same for architecture code.

Patch 43/44 replaces a direct call to pm_power_off from a hwmon driver
with a call to kernel_power_off. This patch is part of the series for
completeness, but will find its way upstream through the hwmon subsystem.

Patch 44/44 removes pm_power_off.

For the most part, the individual patches include explanations why specific
priorities were chosen, at least if the selected priority is not the default
priority. Subsystem and architecture maintainers are encouraged to have a look
at the selected priorities and suggest improvements.

I ran the final code through my normal build and qemu tests. Results
are available at http://server.roeck-us.net:8010/builders in the
'poweroff-handler' column. In addition I build several additional
configurations for various architectures.

The series is available in branch poweroff-handler of my repository at
git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git.
It is based on 3.17, with the pending restart handler patches applied.

I got a number of Acks from architecture maintainers as response to the RFC.
I did not add those since the architecture code changed, and I did not think
it was appropriate to retain the Acks.

A note on timing: My original plan was to submit this series after 3.18-rc1
was released.  However, since the commit window will remain open for three
weeks, and the series is, for all practical purposes, ready for review,
I decided to submit it now.  I plan to rebase it to 3.18-rc1 once available
and send another version, hopefully including valuable feedback.

Important changes since RFC:
- Move API to new file kernel/power/poweroff_handler.c.
- Move pm_power_off pointer to kernel/power/poweroff_handler.c. Call
  pm_power_off from do_kernel_poweroff, and only call do_kernel_poweroff
  from architecture code instead of calling both pm_power_off and
  do_kernel_poweroff.
- Provide additional API function register_poweroff_handler_simple
  to simplify conversion of architecture code.
- Provide additional API function have_kernel_poweroff to check if
  a poweroff handler was installed.
- Convert all drivers and architecture code to use the new API.
- Remove pm_power_off as last patch of the series.

Cc: Alexander Graf <agraf@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Corey Minyard <minyard@acm.org>
Cc: David Howells <dhowells@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Jean Delvare <jdelvare@suse.de>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Joshua Thompson <funaho@jurai.org>
Cc: Julian Andres Klode <jak@jak-linux.org>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Marc Dietrich <marvin24@gmx.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Romain Perier <romain.perier@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>

----------------------------------------------------------------
Guenter Roeck (44):
      kernel: Add support for poweroff handler call chain
      memory: emif: Use API function to determine poweroff capability
      hibernate: Call have_kernel_poweroff instead of checking pm_power_off
      m68k: Replace mach_power_off with pm_power_off
      mfd: as3722: Drop reference to pm_power_off from devicetree bindings
      gpio-poweroff: Drop reference to pm_power_off from devicetree bindings
      qnap-poweroff: Drop reference to pm_power_off from devicetree bindings
      kernel: Move pm_power_off to common code
      mfd: palmas: Register with kernel poweroff handler
      mfd: axp20x: Register with kernel poweroff handler
      mfd: retu: Register with kernel poweroff handler
      mfd: ab8500-sysctrl: Register with kernel poweroff handler
      mfd: max8907: Register with kernel poweroff handler
      mfd: tps80031: Register with kernel poweroff handler
      mfd: dm355evm_msp: Register with kernel poweroff handler
      mfd: tps6586x: Register with kernel poweroff handler
      mfd: tps65910: Register with kernel poweroff handler
      mfd: twl4030-power: Register with kernel poweroff handler
      ipmi: Register with kernel poweroff handler
      power/reset: restart-poweroff: Register with kernel poweroff handler
      power/reset: gpio-poweroff: Register with kernel poweroff handler
      power/reset: as3722-poweroff: Register with kernel poweroff handler
      power/reset: qnap-poweroff: Register with kernel poweroff handler
      power/reset: msm-powroff: Register with kernel poweroff handler
      power/reset: vexpress-poweroff: Register with kernel poweroff handler
      x86: iris: Register with kernel poweroff handler
      x86: apm: Register with kernel poweroff handler
      x86: olpc: Register xo1 poweroff handler with kernel poweroff handler
      staging: nvec: Register with kernel poweroff handler
      acpi: Register poweroff handler with kernel poweroff handler
      arm: Register with kernel poweroff handler
      arm64: psci: Register with kernel poweroff handler
      avr32: atngw100: Register with kernel poweroff handler
      ia64: Register with kernel poweroff handler
      m68k: Register with kernel poweroff handler
      mips: Register with kernel poweroff handler
      sh: Register with kernel poweroff handler
      x86: lguest: Register with kernel poweroff handler
      x86: ce4100: Register with kernel poweroff handler
      x86: intel-mid: Drop registration of dummy poweroff handlers
      x86: pmc_atom: Register poweroff handler with kernel poweroff handler
      efi: Register poweroff handler with kernel poweroff handler
      hwmon: (ab8500) Call kernel_power_off instead of pm_power_off
      kernel: Remove pm_power_off

 .../devicetree/bindings/gpio/gpio-poweroff.txt     |  10 +-
 Documentation/devicetree/bindings/mfd/as3722.txt   |   3 +-
 .../bindings/power_supply/qnap-poweroff.txt        |   4 +-
 arch/alpha/kernel/process.c                        |   9 +-
 arch/arc/kernel/reset.c                            |   5 +-
 arch/arm/kernel/process.c                          |   5 +-
 arch/arm/kernel/psci.c                             |   2 +-
 arch/arm/mach-at91/board-gsia18s.c                 |   2 +-
 arch/arm/mach-at91/setup.c                         |   4 +-
 arch/arm/mach-bcm/board_bcm2835.c                  |   2 +-
 arch/arm/mach-cns3xxx/cns3420vb.c                  |   2 +-
 arch/arm/mach-cns3xxx/core.c                       |   2 +-
 arch/arm/mach-highbank/highbank.c                  |   2 +-
 arch/arm/mach-imx/mach-mx31moboard.c               |   2 +-
 arch/arm/mach-iop32x/em7210.c                      |   2 +-
 arch/arm/mach-iop32x/glantank.c                    |   2 +-
 arch/arm/mach-iop32x/iq31244.c                     |   2 +-
 arch/arm/mach-iop32x/n2100.c                       |   2 +-
 arch/arm/mach-ixp4xx/dsmg600-setup.c               |   2 +-
 arch/arm/mach-ixp4xx/nas100d-setup.c               |   2 +-
 arch/arm/mach-ixp4xx/nslu2-setup.c                 |   2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c         |   2 +-
 arch/arm/mach-orion5x/board-mss2.c                 |   2 +-
 arch/arm/mach-orion5x/dns323-setup.c               |   6 +-
 arch/arm/mach-orion5x/kurobox_pro-setup.c          |   2 +-
 arch/arm/mach-orion5x/ls-chl-setup.c               |   2 +-
 arch/arm/mach-orion5x/ls_hgl-setup.c               |   2 +-
 arch/arm/mach-orion5x/lsmini-setup.c               |   2 +-
 arch/arm/mach-orion5x/mv2120-setup.c               |   2 +-
 arch/arm/mach-orion5x/net2big-setup.c              |   2 +-
 arch/arm/mach-orion5x/terastation_pro2-setup.c     |   2 +-
 arch/arm/mach-orion5x/ts209-setup.c                |   2 +-
 arch/arm/mach-orion5x/ts409-setup.c                |   2 +-
 arch/arm/mach-pxa/corgi.c                          |   2 +-
 arch/arm/mach-pxa/mioa701.c                        |   2 +-
 arch/arm/mach-pxa/poodle.c                         |   2 +-
 arch/arm/mach-pxa/spitz.c                          |   2 +-
 arch/arm/mach-pxa/tosa.c                           |   2 +-
 arch/arm/mach-pxa/viper.c                          |   2 +-
 arch/arm/mach-pxa/z2.c                             |   6 +-
 arch/arm/mach-pxa/zeus.c                           |   6 +-
 arch/arm/mach-s3c24xx/mach-gta02.c                 |   2 +-
 arch/arm/mach-s3c24xx/mach-jive.c                  |   2 +-
 arch/arm/mach-s3c24xx/mach-vr1000.c                |   2 +-
 arch/arm/mach-s3c64xx/mach-smartq.c                |   2 +-
 arch/arm/mach-sa1100/generic.c                     |   2 +-
 arch/arm/mach-sa1100/simpad.c                      |   2 +-
 arch/arm/mach-u300/regulator.c                     |   2 +-
 arch/arm/mach-vt8500/vt8500.c                      |   2 +-
 arch/arm/xen/enlighten.c                           |   2 +-
 arch/arm64/kernel/process.c                        |   5 +-
 arch/arm64/kernel/psci.c                           |   2 +-
 arch/avr32/boards/atngw100/mrmt.c                  |   2 +-
 arch/avr32/kernel/process.c                        |   6 +-
 arch/blackfin/kernel/process.c                     |   3 -
 arch/blackfin/kernel/reboot.c                      |   2 +
 arch/c6x/kernel/process.c                          |   9 +-
 arch/cris/kernel/process.c                         |   4 +-
 arch/frv/kernel/process.c                          |   5 +-
 arch/hexagon/kernel/reset.c                        |   5 +-
 arch/ia64/kernel/process.c                         |   5 +-
 arch/ia64/sn/kernel/setup.c                        |   4 +-
 arch/m32r/kernel/process.c                         |   8 +-
 arch/m68k/emu/natfeat.c                            |   3 +-
 arch/m68k/include/asm/machdep.h                    |   1 -
 arch/m68k/kernel/process.c                         |   7 +-
 arch/m68k/kernel/setup_mm.c                        |   1 -
 arch/m68k/kernel/setup_no.c                        |   1 -
 arch/m68k/mac/config.c                             |   3 +-
 arch/metag/kernel/process.c                        |   6 +-
 arch/microblaze/kernel/process.c                   |   3 -
 arch/microblaze/kernel/reset.c                     |   1 +
 arch/mips/alchemy/board-gpr.c                      |   2 +-
 arch/mips/alchemy/board-mtx1.c                     |   2 +-
 arch/mips/alchemy/board-xxs1500.c                  |   2 +-
 arch/mips/alchemy/devboards/platform.c             |  17 +-
 arch/mips/ar7/setup.c                              |   2 +-
 arch/mips/ath79/setup.c                            |   2 +-
 arch/mips/bcm47xx/setup.c                          |   2 +-
 arch/mips/bcm63xx/setup.c                          |   2 +-
 arch/mips/cobalt/setup.c                           |   2 +-
 arch/mips/dec/setup.c                              |   2 +-
 arch/mips/emma/markeins/setup.c                    |   2 +-
 arch/mips/jz4740/reset.c                           |   2 +-
 arch/mips/kernel/reset.c                           |   6 +-
 arch/mips/lantiq/falcon/reset.c                    |   2 +-
 arch/mips/lantiq/xway/reset.c                      |   2 +-
 arch/mips/lasat/reset.c                            |   2 +-
 arch/mips/loongson/common/reset.c                  |   2 +-
 arch/mips/loongson1/common/reset.c                 |   2 +-
 arch/mips/mti-malta/malta-reset.c                  |   2 +-
 arch/mips/mti-sead3/sead3-reset.c                  |   2 +-
 arch/mips/netlogic/xlp/setup.c                     |   2 +-
 arch/mips/netlogic/xlr/setup.c                     |   2 +-
 arch/mips/pmcs-msp71xx/msp_setup.c                 |   2 +-
 arch/mips/pnx833x/common/setup.c                   |   2 +-
 arch/mips/ralink/reset.c                           |   2 +-
 arch/mips/rb532/setup.c                            |   2 +-
 arch/mips/sgi-ip22/ip22-reset.c                    |   2 +-
 arch/mips/sgi-ip27/ip27-reset.c                    |   2 +-
 arch/mips/sgi-ip32/ip32-reset.c                    |   2 +-
 arch/mips/sibyte/common/cfe.c                      |   2 +-
 arch/mips/sni/setup.c                              |   2 +-
 arch/mips/txx9/generic/setup.c                     |   2 +-
 arch/mips/vr41xx/common/pmu.c                      |   2 +-
 arch/mn10300/kernel/process.c                      |   8 +-
 arch/openrisc/kernel/process.c                     |   8 +-
 arch/parisc/kernel/process.c                       |   8 +-
 arch/powerpc/kernel/setup-common.c                 |   6 +-
 arch/s390/kernel/setup.c                           |   8 +-
 arch/score/kernel/process.c                        |   8 +-
 arch/sh/boards/board-sh7785lcr.c                   |   2 +-
 arch/sh/boards/board-urquell.c                     |   2 +-
 arch/sh/boards/mach-highlander/setup.c             |   2 +-
 arch/sh/boards/mach-landisk/setup.c                |   2 +-
 arch/sh/boards/mach-r2d/setup.c                    |   2 +-
 arch/sh/boards/mach-sdk7786/setup.c                |   2 +-
 arch/sh/kernel/reboot.c                            |   6 +-
 arch/sparc/kernel/process_32.c                     |  10 +-
 arch/sparc/kernel/reboot.c                         |   8 +-
 arch/tile/kernel/reboot.c                          |   7 +-
 arch/um/kernel/reboot.c                            |   2 -
 arch/unicore32/kernel/process.c                    |   9 +-
 arch/x86/kernel/apm_32.c                           |  20 ++-
 arch/x86/kernel/pmc_atom.c                         |  20 ++-
 arch/x86/kernel/reboot.c                           |  11 +-
 arch/x86/lguest/boot.c                             |   2 +-
 arch/x86/platform/ce4100/ce4100.c                  |   2 +-
 arch/x86/platform/intel-mid/intel-mid.c            |   5 -
 arch/x86/platform/intel-mid/mfld.c                 |   5 -
 arch/x86/platform/iris/iris.c                      |  25 ++-
 arch/x86/platform/olpc/olpc-xo1-pm.c               |  20 ++-
 arch/x86/xen/enlighten.c                           |   3 +-
 arch/xtensa/kernel/process.c                       |   4 -
 drivers/acpi/sleep.c                               |  15 +-
 drivers/char/ipmi/ipmi_poweroff.c                  |  30 ++--
 drivers/firmware/efi/reboot.c                      |  23 ++-
 drivers/hwmon/ab8500.c                             |   5 +-
 drivers/memory/emif.c                              |   4 +-
 drivers/mfd/ab8500-sysctrl.c                       |  26 ++--
 drivers/mfd/axp20x.c                               |  30 ++--
 drivers/mfd/dm355evm_msp.c                         |  18 ++-
 drivers/mfd/max8907.c                              |  24 ++-
 drivers/mfd/palmas.c                               |  30 ++--
 drivers/mfd/retu-mfd.c                             |  33 ++--
 drivers/mfd/tps6586x.c                             |  31 +++-
 drivers/mfd/tps65910.c                             |  27 ++--
 drivers/mfd/tps80031.c                             |  30 ++--
 drivers/mfd/twl4030-power.c                        |  25 ++-
 drivers/parisc/power.c                             |   3 +-
 drivers/power/reset/as3722-poweroff.c              |  36 +++--
 drivers/power/reset/gpio-poweroff.c                |  36 ++---
 drivers/power/reset/msm-poweroff.c                 |  13 +-
 drivers/power/reset/qnap-poweroff.c                |  28 ++--
 drivers/power/reset/restart-poweroff.c             |  25 ++-
 drivers/power/reset/vexpress-poweroff.c            |  19 ++-
 drivers/staging/nvec/nvec.c                        |  24 +--
 drivers/staging/nvec/nvec.h                        |   2 +
 include/linux/i2c/twl.h                            |   1 -
 include/linux/mfd/axp20x.h                         |   1 +
 include/linux/mfd/max8907.h                        |   2 +
 include/linux/mfd/palmas.h                         |   3 +
 include/linux/mfd/tps65910.h                       |   3 +
 include/linux/mfd/tps80031.h                       |   2 +
 include/linux/pm.h                                 |  14 +-
 kernel/power/Makefile                              |   1 +
 kernel/power/hibernate.c                           |   2 +-
 kernel/power/poweroff_handler.c                    | 173 +++++++++++++++++++++
 kernel/reboot.c                                    |   4 +-
 169 files changed, 794 insertions(+), 475 deletions(-)
 create mode 100644 kernel/power/poweroff_handler.c
