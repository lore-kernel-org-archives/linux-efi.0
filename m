From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/2] compiler-gcc.h: add gnu_inline to all inline
 declarations
Date: Thu, 07 Jun 2018 11:31:43 -0700
Message-ID: <28c288fd3e87b6c839697519043cf642518e0262.camel@perches.com>
References: <20180605170532.170361-1-ndesaulniers@google.com>
         <20180605170532.170361-2-ndesaulniers@google.com>
         <202492204c2d5bd5ca27307cbca5e44673b739ed.camel@perches.com>
         <CAKwvOdkUk7ZL8tXgBs0Y+0Y5NVebgAYne_qgdSWWDOvQaWFPhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKwvOdkUk7ZL8tXgBs0Y+0Y5NVebgAYne_qgdSWWDOvQaWFPhw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, akataria@vmware.com, boris.ostrovsky@oracle.com, brijesh.singh@amd.com, Cao jin <caoj.fnst@cn.fujitsu.com>, Greg KH <gregkh@linuxfoundation.org>, hpa@zytor.com, "J. Kiszka" <jan.kiszka@siemens.com>, jarkko.sakkinen@linux.intel.com, jgross@suse.com, Josh Poimboeuf <jpoimboe@redhat.com>, kirill.shutemov@linux.intel.com, mingo@redhat.com, mjg59@google.com, Matthias Kaehlcke <mka@chromium.org>, Philippe Ombredanne <pombredanne@nexb.com>, rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>, thomas.lendacky@amd.com, Thiebaud Weksteen <tweek@google.com>, linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, virtua
List-Id: linux-efi@vger.kernel.org

On Thu, 2018-06-07 at 10:26 -0700, Nick Desaulniers wrote:
> I get the feeling that the use of __inline__ or __inline (vs inline)
> in the kernel may be wrong and their use should be eradicated in the
> follow up patch set, but it would be cool if others have additional
> insight.

__inline is easy and useful to remove as it's used in
just a few files.

But __inline__ is used in a lot of files and locations:

$ git grep -w --name-only __inline__ | wc -l
154
$ git grep -w __inline__ | wc -l
503

Some of these files are used in asm includes as
well where __inline__ may be preferred by gcc

https://gcc.gnu.org/onlinedocs/gcc/Alternate-Keywords.html#Alternate-Keywords

so perhaps asm exclusions would be necessary.

A similar script to sed them is certainly possible
but perhaps could cause some conflicts later in
a merge cycle.  Realistically, this sort of script
can only be applied by Linus.  Separating out the
individual patches by maintainer effectively means
the series will never be wholly applied.

Maybe excluding all /asm/ directories:

$ git grep -w --name-only __inline__ | \
  grep -vP '(?:/uapi/|/asm/|^scripts/|compiler)' | \
  xargs sed -r -i -e 's/\b__inline__\b/inline/g'

This script today results are (-U0 to minimize output):
---
$ git diff -U0 --stat -p
 Documentation/translations/ja_JP/SubmittingPatches |  4 +--
 Documentation/translations/zh_CN/SubmittingPatches |  4 +--
 arch/arm/mach-iop32x/include/mach/uncompress.h     |  2 +-
 arch/arm/mach-iop33x/include/mach/uncompress.h     |  2 +-
 arch/arm/mach-ixp4xx/include/mach/uncompress.h     |  2 +-
 arch/ia64/hp/common/sba_iommu.c                    |  2 +-
 arch/ia64/hp/sim/simeth.c                          |  2 +-
 arch/ia64/oprofile/backtrace.c                     |  4 +--
 arch/m68k/mac/iop.c                                | 14 +++++-----
 arch/mips/kernel/binfmt_elfn32.c                   |  2 +-
 arch/sh/include/cpu-sh3/cpu/dac.h                  |  6 ++---
 block/partitions/amiga.c                           |  2 +-
 drivers/atm/he.c                                   |  6 ++---
 drivers/atm/idt77252.c                             |  6 ++---
 drivers/gpu/drm/mga/mga_drv.h                      |  2 +-
 drivers/gpu/drm/mga/mga_state.c                    | 14 +++++-----
 drivers/gpu/drm/r128/r128_drv.h                    |  2 +-
 drivers/gpu/drm/r128/r128_state.c                  | 14 +++++-----
 drivers/gpu/drm/via/via_irq.c                      |  2 +-
 drivers/gpu/drm/via/via_verifier.c                 | 30 +++++++++++-----------
 drivers/isdn/hardware/eicon/platform.h             | 14 +++++-----
 drivers/isdn/i4l/isdn_net.c                        | 14 +++++-----
 drivers/isdn/i4l/isdn_net.h                        |  8 +++---
 drivers/media/pci/ivtv/ivtv-ioctl.c                |  2 +-
 drivers/net/ethernet/sun/sungem.c                  |  8 +++---
 drivers/net/ethernet/sun/sunhme.c                  |  6 ++---
 drivers/net/hamradio/baycom_ser_fdx.c              |  2 +-
 drivers/net/wan/lapbether.c                        |  2 +-
 drivers/net/wan/n2.c                               |  4 +--
 drivers/parisc/led.c                               |  4 +--
 drivers/parisc/sba_iommu.c                         |  2 +-
 drivers/parport/parport_gsc.c                      |  2 +-
 drivers/parport/parport_gsc.h                      |  4 +--
 drivers/parport/parport_pc.c                       |  2 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  2 +-
 drivers/scsi/pcmcia/sym53c500_cs.c                 |  4 +--
 drivers/scsi/qla2xxx/qla_inline.h                  |  2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  4 +--
 drivers/staging/ipx/ipx_proc.c                     |  2 +-
 drivers/tty/amiserial.c                            |  2 +-
 drivers/tty/serial/ip22zilog.c                     |  2 +-
 drivers/tty/serial/sunsab.c                        |  4 +--
 drivers/tty/serial/sunzilog.c                      |  2 +-
 drivers/video/fbdev/core/fbcon.c                   | 20 +++++++--------
 drivers/video/fbdev/ffb.c                          |  2 +-
 drivers/video/fbdev/intelfb/intelfbdrv.c           | 10 ++++----
 drivers/video/fbdev/intelfb/intelfbhw.c            |  2 +-
 drivers/w1/masters/matrox_w1.c                     |  4 +--
 fs/coda/coda_linux.h                               |  6 ++---
 fs/freevxfs/vxfs_inode.c                           |  2 +-
 fs/nfsd/nfsfh.h                                    |  4 +--
 include/acpi/platform/acgcc.h                      |  2 +-
 include/asm-generic/ide_iops.h                     |  8 +++---
 include/drm/drmP.h                                 |  4 +--
 include/drm/drm_legacy.h                           |  2 +-
 include/linux/atalk.h                              |  4 +--
 include/linux/ceph/messenger.h                     |  2 +-
 include/linux/hdlc.h                               |  4 +--
 include/linux/inetdevice.h                         |  8 +++---
 include/linux/parport.h                            |  4 +--
 include/linux/parport_pc.h                         | 22 ++++++++--------
 include/net/ax25.h                                 |  2 +-
 include/net/checksum.h                             |  2 +-
 include/net/dn_nsp.h                               | 16 ++++++------
 include/net/ip.h                                   |  2 +-
 include/net/ip6_checksum.h                         |  2 +-
 include/net/ipx.h                                  | 10 ++++----
 include/net/llc_c_ev.h                             |  4 +--
 include/net/llc_conn.h                             |  4 +--
 include/net/llc_s_ev.h                             |  2 +-
 include/net/netrom.h                               |  8 +++---
 include/net/scm.h                                  | 14 +++++-----
 include/net/udplite.h                              |  2 +-
 include/net/x25.h                                  |  8 +++---
 include/net/xfrm.h                                 | 18 ++++++-------
 include/video/newport.h                            | 12 ++++-----
 net/appletalk/atalk_proc.c                         |  4 +--
 net/appletalk/ddp.c                                |  2 +-
 net/core/neighbour.c                               |  2 +-
 net/core/scm.c                                     |  2 +-
 net/decnet/dn_nsp_in.c                             |  2 +-
 net/decnet/dn_nsp_out.c                            |  2 +-
 net/decnet/dn_route.c                              |  2 +-
 net/decnet/dn_table.c                              |  4 +--
 net/ipv4/igmp.c                                    |  2 +-
 net/ipv6/af_inet6.c                                |  2 +-
 net/ipv6/icmp.c                                    |  4 +--
 net/ipv6/udp.c                                     |  4 +--
 net/lapb/lapb_iface.c                              |  4 +--
 net/llc/llc_input.c                                |  2 +-
 sound/sparc/amd7930.c                              |  6 ++---
 91 files changed, 240 insertions(+), 240 deletions(-)

diff --git a/Documentation/translations/ja_JP/SubmittingPatches b/Documentation/translations/ja_JP/SubmittingPatches
index 02139656463e..188846f1184b 100644
--- a/Documentation/translations/ja_JP/SubmittingPatches
+++ b/Documentation/translations/ja_JP/SubmittingPatches
@@ -679,2 +679,2 @@ gcc においては、マクロと同じくらい軽いです。
-「 static inline 」は「 static __inline__ 」や「 extern inline 」や
-「 extern __inline__ 」よりも適切です。
+「 static inline 」は「 static inline 」や「 extern inline 」や
+「 extern inline 」よりも適切です。
diff --git a/Documentation/translations/zh_CN/SubmittingPatches b/Documentation/translations/zh_CN/SubmittingPatches
index e9098da8f1a4..5c39b6c487b5 100644
--- a/Documentation/translations/zh_CN/SubmittingPatches
+++ b/Documentation/translations/zh_CN/SubmittingPatches
@@ -380,2 +380,2 @@ Static inline 函数相比宏来说，是好得多的选择。Static inline 函
-应该用 'static inline' 而不是 'static __inline__', 'extern inline' 和
-'extern __inline__' 。
+应该用 'static inline' 而不是 'static inline', 'extern inline' 和
+'extern inline' 。
diff --git a/arch/arm/mach-iop32x/include/mach/uncompress.h b/arch/arm/mach-iop32x/include/mach/uncompress.h
index ed4ac3e28fa1..24d1dd4ea27f 100644
--- a/arch/arm/mach-iop32x/include/mach/uncompress.h
+++ b/arch/arm/mach-iop32x/include/mach/uncompress.h
@@ -26 +26 @@ static inline void flush(void)
-static __inline__ void __arch_decomp_setup(unsigned long arch_id)
+static inline void __arch_decomp_setup(unsigned long arch_id)
diff --git a/arch/arm/mach-iop33x/include/mach/uncompress.h b/arch/arm/mach-iop33x/include/mach/uncompress.h
index 62b71cde1f79..9fc5a2aae8de 100644
--- a/arch/arm/mach-iop33x/include/mach/uncompress.h
+++ b/arch/arm/mach-iop33x/include/mach/uncompress.h
@@ -26 +26 @@ static inline void flush(void)
-static __inline__ void __arch_decomp_setup(unsigned long arch_id)
+static inline void __arch_decomp_setup(unsigned long arch_id)
diff --git a/arch/arm/mach-ixp4xx/include/mach/uncompress.h b/arch/arm/mach-ixp4xx/include/mach/uncompress.h
index 7b25c0225e46..d9e698f7d7e1 100644
--- a/arch/arm/mach-ixp4xx/include/mach/uncompress.h
+++ b/arch/arm/mach-ixp4xx/include/mach/uncompress.h
@@ -38 +38 @@ static void flush(void)
-static __inline__ void __arch_decomp_setup(unsigned long arch_id)
+static inline void __arch_decomp_setup(unsigned long arch_id)
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index ee5b652d320a..795a1924a796 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -110 +110 @@ extern int swiotlb_late_init_with_default_size (size_t size);
-#define SBA_INLINE	__inline__
+#define SBA_INLINE	inline
diff --git a/arch/ia64/hp/sim/simeth.c b/arch/ia64/hp/sim/simeth.c
index f39ef2b4ed72..e0620283dfc6 100644
--- a/arch/ia64/hp/sim/simeth.c
+++ b/arch/ia64/hp/sim/simeth.c
@@ -249 +249 @@ simeth_open(struct net_device *dev)
-static __inline__ int dev_is_ethdev(struct net_device *dev)
+static inline int dev_is_ethdev(struct net_device *dev)
diff --git a/arch/ia64/oprofile/backtrace.c b/arch/ia64/oprofile/backtrace.c
index 6a219a946050..c9c8282f7a73 100644
--- a/arch/ia64/oprofile/backtrace.c
+++ b/arch/ia64/oprofile/backtrace.c
@@ -35 +35 @@ typedef struct
-static __inline__ int in_ivt_code(unsigned long pc)
+static inline int in_ivt_code(unsigned long pc)
@@ -44 +44 @@ static __inline__ int in_ivt_code(unsigned long pc)
-static __inline__ int next_frame(ia64_backtrace_t *bt)
+static inline int next_frame(ia64_backtrace_t *bt)
diff --git a/arch/m68k/mac/iop.c b/arch/m68k/mac/iop.c
index 9bfa17015768..288b07530802 100644
--- a/arch/m68k/mac/iop.c
+++ b/arch/m68k/mac/iop.c
@@ -164 +164 @@ irqreturn_t iop_ism_irq(int, void *);
-static __inline__ void iop_loadaddr(volatile struct mac_iop *iop, __u16 addr)
+static inline void iop_loadaddr(volatile struct mac_iop *iop, __u16 addr)
@@ -170 +170 @@ static __inline__ void iop_loadaddr(volatile struct mac_iop *iop, __u16 addr)
-static __inline__ __u8 iop_readb(volatile struct mac_iop *iop, __u16 addr)
+static inline __u8 iop_readb(volatile struct mac_iop *iop, __u16 addr)
@@ -177 +177 @@ static __inline__ __u8 iop_readb(volatile struct mac_iop *iop, __u16 addr)
-static __inline__ void iop_writeb(volatile struct mac_iop *iop, __u16 addr, __u8 data)
+static inline void iop_writeb(volatile struct mac_iop *iop, __u16 addr, __u8 data)
@@ -184 +184 @@ static __inline__ void iop_writeb(volatile struct mac_iop *iop, __u16 addr, __u8
-static __inline__ void iop_stop(volatile struct mac_iop *iop)
+static inline void iop_stop(volatile struct mac_iop *iop)
@@ -189 +189 @@ static __inline__ void iop_stop(volatile struct mac_iop *iop)
-static __inline__ void iop_start(volatile struct mac_iop *iop)
+static inline void iop_start(volatile struct mac_iop *iop)
@@ -194 +194 @@ static __inline__ void iop_start(volatile struct mac_iop *iop)
-static __inline__ void iop_bypass(volatile struct mac_iop *iop)
+static inline void iop_bypass(volatile struct mac_iop *iop)
@@ -199 +199 @@ static __inline__ void iop_bypass(volatile struct mac_iop *iop)
-static __inline__ void iop_interrupt(volatile struct mac_iop *iop)
+static inline void iop_interrupt(volatile struct mac_iop *iop)
diff --git a/arch/mips/kernel/binfmt_elfn32.c b/arch/mips/kernel/binfmt_elfn32.c
index 89b234844534..3fc459d8a84a 100644
--- a/arch/mips/kernel/binfmt_elfn32.c
+++ b/arch/mips/kernel/binfmt_elfn32.c
@@ -85 +85 @@ struct elf_prpsinfo32
-static __inline__ void
+static inline void
diff --git a/arch/sh/include/cpu-sh3/cpu/dac.h b/arch/sh/include/cpu-sh3/cpu/dac.h
index fd02331608a8..67ae1ae03c47 100644
--- a/arch/sh/include/cpu-sh3/cpu/dac.h
+++ b/arch/sh/include/cpu-sh3/cpu/dac.h
@@ -18 +18 @@
-static __inline__ void sh_dac_enable(int channel)
+static inline void sh_dac_enable(int channel)
@@ -27 +27 @@ static __inline__ void sh_dac_enable(int channel)
-static __inline__ void sh_dac_disable(int channel)
+static inline void sh_dac_disable(int channel)
@@ -36 +36 @@ static __inline__ void sh_dac_disable(int channel)
-static __inline__ void sh_dac_output(u8 value, int channel)
+static inline void sh_dac_output(u8 value, int channel)
diff --git a/block/partitions/amiga.c b/block/partitions/amiga.c
index 560936617d9c..7434b0a0f86c 100644
--- a/block/partitions/amiga.c
+++ b/block/partitions/amiga.c
@@ -19 +19 @@
-static __inline__ u32
+static inline u32
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index 29f102dcfec4..abb6415f9565 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -181 +181 @@ static const struct atmdev_ops he_ops =
-static __inline__ void
+static inline void
@@ -327 +327 @@ he_readl_internal(struct he_dev *he_dev, unsigned addr, unsigned flags)
-static __inline__ struct atm_vcc*
+static inline struct atm_vcc*
@@ -2053 +2053 @@ he_irq_handler(int irq, void *dev_id)
-static __inline__ void
+static inline void
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 6e737142ceaa..226a65a03b70 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -1786 +1786 @@ set_tct(struct idt77252_dev *card, struct vc_map *vc)
-static __inline__ int
+static inline int
@@ -1792 +1792 @@ idt77252_fbq_level(struct idt77252_dev *card, int queue)
-static __inline__ int
+static inline int
@@ -2019 +2019 @@ idt77252_send_oam(struct atm_vcc *vcc, void *cell, int flags)
-static __inline__ unsigned int
+static inline unsigned int
diff --git a/drivers/gpu/drm/mga/mga_drv.h b/drivers/gpu/drm/mga/mga_drv.h
index a45bb22275a7..a4bb4ead677f 100644
--- a/drivers/gpu/drm/mga/mga_drv.h
+++ b/drivers/gpu/drm/mga/mga_drv.h
@@ -664 +664 @@ do {									\
-static __inline__ int mga_is_idle(drm_mga_private_t *dev_priv)
+static inline int mga_is_idle(drm_mga_private_t *dev_priv)
diff --git a/drivers/gpu/drm/mga/mga_state.c b/drivers/gpu/drm/mga/mga_state.c
index e5f6b735f575..67f261c59111 100644
--- a/drivers/gpu/drm/mga/mga_state.c
+++ b/drivers/gpu/drm/mga/mga_state.c
@@ -68 +68 @@ static void mga_emit_clip_rect(drm_mga_private_t *dev_priv,
-static __inline__ void mga_g200_emit_context(drm_mga_private_t *dev_priv)
+static inline void mga_g200_emit_context(drm_mga_private_t *dev_priv)
@@ -91 +91 @@ static __inline__ void mga_g200_emit_context(drm_mga_private_t *dev_priv)
-static __inline__ void mga_g400_emit_context(drm_mga_private_t *dev_priv)
+static inline void mga_g400_emit_context(drm_mga_private_t *dev_priv)
@@ -118 +118 @@ static __inline__ void mga_g400_emit_context(drm_mga_private_t *dev_priv)
-static __inline__ void mga_g200_emit_tex0(drm_mga_private_t *dev_priv)
+static inline void mga_g200_emit_tex0(drm_mga_private_t *dev_priv)
@@ -146 +146 @@ static __inline__ void mga_g200_emit_tex0(drm_mga_private_t *dev_priv)
-static __inline__ void mga_g400_emit_tex0(drm_mga_private_t *dev_priv)
+static inline void mga_g400_emit_tex0(drm_mga_private_t *dev_priv)
@@ -186 +186 @@ static __inline__ void mga_g400_emit_tex0(drm_mga_private_t *dev_priv)
-static __inline__ void mga_g400_emit_tex1(drm_mga_private_t *dev_priv)
+static inline void mga_g400_emit_tex1(drm_mga_private_t *dev_priv)
@@ -225 +225 @@ static __inline__ void mga_g400_emit_tex1(drm_mga_private_t *dev_priv)
-static __inline__ void mga_g200_emit_pipe(drm_mga_private_t *dev_priv)
+static inline void mga_g200_emit_pipe(drm_mga_private_t *dev_priv)
@@ -252 +252 @@ static __inline__ void mga_g200_emit_pipe(drm_mga_private_t *dev_priv)
-static __inline__ void mga_g400_emit_pipe(drm_mga_private_t *dev_priv)
+static inline void mga_g400_emit_pipe(drm_mga_private_t *dev_priv)
diff --git a/drivers/gpu/drm/r128/r128_drv.h b/drivers/gpu/drm/r128/r128_drv.h
index 2de40d276116..ae32a67dec16 100644
--- a/drivers/gpu/drm/r128/r128_drv.h
+++ b/drivers/gpu/drm/r128/r128_drv.h
@@ -420 +420 @@ do {									\
-static __inline__ void r128_update_ring_snapshot(drm_r128_private_t *dev_priv)
+static inline void r128_update_ring_snapshot(drm_r128_private_t *dev_priv)
diff --git a/drivers/gpu/drm/r128/r128_state.c b/drivers/gpu/drm/r128/r128_state.c
index b9bfa806d346..36a6642f485d 100644
--- a/drivers/gpu/drm/r128/r128_state.c
+++ b/drivers/gpu/drm/r128/r128_state.c
@@ -82 +82 @@ static void r128_emit_clip_rects(drm_r128_private_t *dev_priv,
-static __inline__ void r128_emit_core(drm_r128_private_t *dev_priv)
+static inline void r128_emit_core(drm_r128_private_t *dev_priv)
@@ -97 +97 @@ static __inline__ void r128_emit_core(drm_r128_private_t *dev_priv)
-static __inline__ void r128_emit_context(drm_r128_private_t *dev_priv)
+static inline void r128_emit_context(drm_r128_private_t *dev_priv)
@@ -123 +123 @@ static __inline__ void r128_emit_context(drm_r128_private_t *dev_priv)
-static __inline__ void r128_emit_setup(drm_r128_private_t *dev_priv)
+static inline void r128_emit_setup(drm_r128_private_t *dev_priv)
@@ -139 +139 @@ static __inline__ void r128_emit_setup(drm_r128_private_t *dev_priv)
-static __inline__ void r128_emit_masks(drm_r128_private_t *dev_priv)
+static inline void r128_emit_masks(drm_r128_private_t *dev_priv)
@@ -158 +158 @@ static __inline__ void r128_emit_masks(drm_r128_private_t *dev_priv)
-static __inline__ void r128_emit_window(drm_r128_private_t *dev_priv)
+static inline void r128_emit_window(drm_r128_private_t *dev_priv)
@@ -173 +173 @@ static __inline__ void r128_emit_window(drm_r128_private_t *dev_priv)
-static __inline__ void r128_emit_tex0(drm_r128_private_t *dev_priv)
+static inline void r128_emit_tex0(drm_r128_private_t *dev_priv)
@@ -199 +199 @@ static __inline__ void r128_emit_tex0(drm_r128_private_t *dev_priv)
-static __inline__ void r128_emit_tex1(drm_r128_private_t *dev_priv)
+static inline void r128_emit_tex1(drm_r128_private_t *dev_priv)
diff --git a/drivers/gpu/drm/via/via_irq.c b/drivers/gpu/drm/via/via_irq.c
index c96830ccc0ec..02f2a309ea8d 100644
--- a/drivers/gpu/drm/via/via_irq.c
+++ b/drivers/gpu/drm/via/via_irq.c
@@ -155 +155 @@ irqreturn_t via_driver_irq_handler(int irq, void *arg)
-static __inline__ void viadrv_acknowledge_irqs(drm_via_private_t *dev_priv)
+static inline void viadrv_acknowledge_irqs(drm_via_private_t *dev_priv)
diff --git a/drivers/gpu/drm/via/via_verifier.c b/drivers/gpu/drm/via/via_verifier.c
index fb2609434df7..400fe11b128d 100644
--- a/drivers/gpu/drm/via/via_verifier.c
+++ b/drivers/gpu/drm/via/via_verifier.c
@@ -238 +238 @@ static hazard_t table3[256];
-static __inline__ int
+static inline int
@@ -253 +253 @@ eat_words(const uint32_t **buf, const uint32_t *buf_end, unsigned num_words)
-static __inline__ drm_local_map_t *via_drm_lookup_agp_map(drm_via_state_t *seq,
+static inline drm_local_map_t *via_drm_lookup_agp_map(drm_via_state_t *seq,
@@ -290 +290 @@ static __inline__ drm_local_map_t *via_drm_lookup_agp_map(drm_via_state_t *seq,
-static __inline__ int finish_current_sequence(drm_via_state_t * cur_seq)
+static inline int finish_current_sequence(drm_via_state_t * cur_seq)
@@ -347 +347 @@ static __inline__ int finish_current_sequence(drm_via_state_t * cur_seq)
-static __inline__ int
+static inline int
@@ -520 +520 @@ investigate_hazard(uint32_t cmd, hazard_t hz, drm_via_state_t *cur_seq)
-static __inline__ int
+static inline int
@@ -624 +624 @@ via_check_prim_list(uint32_t const **buffer, const uint32_t * buf_end,
-static __inline__ verifier_state_t
+static inline verifier_state_t
@@ -716 +716 @@ via_check_header2(uint32_t const **buffer, const uint32_t *buf_end,
-static __inline__ verifier_state_t
+static inline verifier_state_t
@@ -765 +765 @@ via_parse_header2(drm_via_private_t *dev_priv, uint32_t const **buffer,
-static __inline__ int verify_mmio_address(uint32_t address)
+static inline int verify_mmio_address(uint32_t address)
@@ -783 +783 @@ static __inline__ int verify_mmio_address(uint32_t address)
-static __inline__ int
+static inline int
@@ -803 +803 @@ verify_video_tail(uint32_t const **buffer, const uint32_t * buf_end,
-static __inline__ verifier_state_t
+static inline verifier_state_t
@@ -835 +835 @@ via_check_header1(uint32_t const **buffer, const uint32_t * buf_end)
-static __inline__ verifier_state_t
+static inline verifier_state_t
@@ -853 +853 @@ via_parse_header1(drm_via_private_t *dev_priv, uint32_t const **buffer,
-static __inline__ verifier_state_t
+static inline verifier_state_t
@@ -886 +886 @@ via_check_vheader5(uint32_t const **buffer, const uint32_t *buf_end)
-static __inline__ verifier_state_t
+static inline verifier_state_t
@@ -904 +904 @@ via_parse_vheader5(drm_via_private_t *dev_priv, uint32_t const **buffer,
-static __inline__ verifier_state_t
+static inline verifier_state_t
@@ -941 +941 @@ via_check_vheader6(uint32_t const **buffer, const uint32_t * buf_end)
-static __inline__ verifier_state_t
+static inline verifier_state_t
diff --git a/drivers/isdn/hardware/eicon/platform.h b/drivers/isdn/hardware/eicon/platform.h
index 62e2073c3690..ea861c904cd2 100644
--- a/drivers/isdn/hardware/eicon/platform.h
+++ b/drivers/isdn/hardware/eicon/platform.h
@@ -162 +162 @@ void diva_xdi_didd_remove_adapter(int card);
-static __inline__ void *diva_os_malloc(unsigned long flags, unsigned long size)
+static inline void *diva_os_malloc(unsigned long flags, unsigned long size)
@@ -171 +171 @@ static __inline__ void *diva_os_malloc(unsigned long flags, unsigned long size)
-static __inline__ void diva_os_free(unsigned long flags, void *ptr)
+static inline void diva_os_free(unsigned long flags, void *ptr)
@@ -188 +188 @@ void diva_os_free_message_buffer(diva_os_message_buffer_s *dmb);
-static __inline__ void diva_os_sleep(dword mSec)
+static inline void diva_os_sleep(dword mSec)
@@ -192 +192 @@ static __inline__ void diva_os_sleep(dword mSec)
-static __inline__ void diva_os_wait(dword mSec)
+static inline void diva_os_wait(dword mSec)
@@ -236 +236 @@ typedef spinlock_t diva_os_spin_lock_t;
-static __inline__ int diva_os_initialize_spin_lock(spinlock_t *lock, void *unused) { \
+static inline int diva_os_initialize_spin_lock(spinlock_t *lock, void *unused) { \
@@ -238 +238 @@ static __inline__ int diva_os_initialize_spin_lock(spinlock_t *lock, void *unuse
-static __inline__ void diva_os_enter_spin_lock(diva_os_spin_lock_t *a, \
+static inline void diva_os_enter_spin_lock(diva_os_spin_lock_t *a, \
@@ -241 +241 @@ static __inline__ void diva_os_enter_spin_lock(diva_os_spin_lock_t *a, \
-static __inline__ void diva_os_leave_spin_lock(diva_os_spin_lock_t *a, \
+static inline void diva_os_leave_spin_lock(diva_os_spin_lock_t *a, \
diff --git a/drivers/isdn/i4l/isdn_net.c b/drivers/isdn/i4l/isdn_net.c
index c138f66f2659..09d4cb136382 100644
--- a/drivers/isdn/i4l/isdn_net.c
+++ b/drivers/isdn/i4l/isdn_net.c
@@ -73 +73 @@
-static __inline__ int isdn_net_device_started(isdn_net_dev *n)
+static inline int isdn_net_device_started(isdn_net_dev *n)
@@ -89 +89 @@ static __inline__ int isdn_net_device_started(isdn_net_dev *n)
-static __inline__ void isdn_net_device_wake_queue(isdn_net_local *lp)
+static inline void isdn_net_device_wake_queue(isdn_net_local *lp)
@@ -101 +101 @@ static __inline__ void isdn_net_device_wake_queue(isdn_net_local *lp)
-static __inline__ void isdn_net_device_stop_queue(isdn_net_local *lp)
+static inline void isdn_net_device_stop_queue(isdn_net_local *lp)
@@ -114 +114 @@ static __inline__ void isdn_net_device_stop_queue(isdn_net_local *lp)
-static __inline__ int isdn_net_device_busy(isdn_net_local *lp)
+static inline int isdn_net_device_busy(isdn_net_local *lp)
@@ -141 +141 @@ static __inline__ int isdn_net_device_busy(isdn_net_local *lp)
-static __inline__ void isdn_net_inc_frame_cnt(isdn_net_local *lp)
+static inline void isdn_net_inc_frame_cnt(isdn_net_local *lp)
@@ -148 +148 @@ static __inline__ void isdn_net_inc_frame_cnt(isdn_net_local *lp)
-static __inline__ void isdn_net_dec_frame_cnt(isdn_net_local *lp)
+static inline void isdn_net_dec_frame_cnt(isdn_net_local *lp)
@@ -161 +161 @@ static __inline__ void isdn_net_dec_frame_cnt(isdn_net_local *lp)
-static __inline__ void isdn_net_zero_frame_cnt(isdn_net_local *lp)
+static inline void isdn_net_zero_frame_cnt(isdn_net_local *lp)
diff --git a/drivers/isdn/i4l/isdn_net.h b/drivers/isdn/i4l/isdn_net.h
index cca6d68da171..5fdff8a0ac8d 100644
--- a/drivers/isdn/i4l/isdn_net.h
+++ b/drivers/isdn/i4l/isdn_net.h
@@ -67 +67 @@ extern void isdn_net_write_super(isdn_net_local *lp, struct sk_buff *skb);
-static __inline__ int isdn_net_lp_busy(isdn_net_local *lp)
+static inline int isdn_net_lp_busy(isdn_net_local *lp)
@@ -79 +79 @@ static __inline__ int isdn_net_lp_busy(isdn_net_local *lp)
-static __inline__ isdn_net_local *isdn_net_get_locked_lp(isdn_net_dev *nd)
+static inline isdn_net_local *isdn_net_get_locked_lp(isdn_net_dev *nd)
@@ -107 +107 @@ static __inline__ isdn_net_local *isdn_net_get_locked_lp(isdn_net_dev *nd)
-static __inline__ void isdn_net_add_to_bundle(isdn_net_dev *nd, isdn_net_local *nlp)
+static inline void isdn_net_add_to_bundle(isdn_net_dev *nd, isdn_net_local *nlp)
@@ -128 +128 @@ static __inline__ void isdn_net_add_to_bundle(isdn_net_dev *nd, isdn_net_local *
-static __inline__ void isdn_net_rm_from_bundle(isdn_net_local *lp)
+static inline void isdn_net_rm_from_bundle(isdn_net_local *lp)
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 4cdc6d2be85d..e4e8b38387ec 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -1625 +1625 @@ static int ivtv_try_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder
-static __inline__ void warn_deprecated_ioctl(const char *name)
+static inline void warn_deprecated_ioctl(const char *name)
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 7a16d40a72d1..63868368da4f 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -644 +644 @@ static int gem_abnormal_irq(struct net_device *dev, struct gem *gp, u32 gem_stat
-static __inline__ void gem_tx(struct net_device *dev, struct gem *gp, u32 gem_status)
+static inline void gem_tx(struct net_device *dev, struct gem *gp, u32 gem_status)
@@ -714 +714 @@ static __inline__ void gem_tx(struct net_device *dev, struct gem *gp, u32 gem_st
-static __inline__ void gem_post_rxds(struct gem *gp, int limit)
+static inline void gem_post_rxds(struct gem *gp, int limit)
@@ -746 +746 @@ static __inline__ void gem_post_rxds(struct gem *gp, int limit)
-static __inline__ struct sk_buff *gem_alloc_skb(struct net_device *dev, int size,
+static inline struct sk_buff *gem_alloc_skb(struct net_device *dev, int size,
@@ -989 +989 @@ static void gem_tx_timeout(struct net_device *dev)
-static __inline__ int gem_intme(int entry)
+static inline int gem_intme(int entry)
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 06da2f59fcbf..1b7c95d17e46 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -111 +111 @@ static int txlog_cur_entry;
-static __inline__ void tx_add_log(struct happy_meal *hp, unsigned int a, unsigned int s)
+static inline void tx_add_log(struct happy_meal *hp, unsigned int a, unsigned int s)
@@ -126 +126 @@ static __inline__ void tx_add_log(struct happy_meal *hp, unsigned int a, unsigne
-static __inline__ void tx_dump_log(void)
+static inline void tx_dump_log(void)
@@ -139 +139 @@ static __inline__ void tx_dump_log(void)
-static __inline__ void tx_dump_ring(struct happy_meal *hp)
+static inline void tx_dump_ring(struct happy_meal *hp)
diff --git a/drivers/net/hamradio/baycom_ser_fdx.c b/drivers/net/hamradio/baycom_ser_fdx.c
index 190f66c88479..bd91fb571927 100644
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -232 +232 @@ static inline unsigned int hweight8(unsigned int w)
-static __inline__ void ser12_rx(struct net_device *dev, struct baycom_state *bc, struct timespec64 *ts, unsigned char curs)
+static inline void ser12_rx(struct net_device *dev, struct baycom_state *bc, struct timespec64 *ts, unsigned char curs)
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 0e3f8ed84660..84145ec82a36 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -79 +79 @@ static struct lapbethdev *lapbeth_get_x25_dev(struct net_device *dev)
-static __inline__ int dev_is_ethdev(struct net_device *dev)
+static inline int dev_is_ethdev(struct net_device *dev)
diff --git a/drivers/net/wan/n2.c b/drivers/net/wan/n2.c
index c8f4517db3a0..45ea8da79fa5 100644
--- a/drivers/net/wan/n2.c
+++ b/drivers/net/wan/n2.c
@@ -151 +151 @@ static card_t **new_card = &first_card;
-static __inline__ u8 sca_get_page(card_t *card)
+static inline u8 sca_get_page(card_t *card)
@@ -157 +157 @@ static __inline__ u8 sca_get_page(card_t *card)
-static __inline__ void openwin(card_t *card, u8 page)
+static inline void openwin(card_t *card, u8 page)
diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index 0c6e8b44b4ed..65baa86dbae7 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -352 +352 @@ static void led_LCD_driver(unsigned char leds)
-static __inline__ int led_get_net_activity(void)
+static inline int led_get_net_activity(void)
@@ -404 +404 @@ static __inline__ int led_get_net_activity(void)
-static __inline__ int led_get_diskio_activity(void)
+static inline int led_get_diskio_activity(void)
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 11de0eccf968..a7a79aebae17 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -92 +92 @@
-#define SBA_INLINE	__inline__
+#define SBA_INLINE	inline
diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index 190c0a7a1c52..20dab463e40d 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -79 +79 @@ static int clear_epp_timeout(struct parport *pb)
- * parport_xxx_yyy macros.  extern __inline__ versions of several
+ * parport_xxx_yyy macros.  extern inline versions of several
diff --git a/drivers/parport/parport_gsc.h b/drivers/parport/parport_gsc.h
index 812214768d27..21a3f96806f9 100644
--- a/drivers/parport/parport_gsc.h
+++ b/drivers/parport/parport_gsc.h
@@ -44 +44 @@
-static __inline__ unsigned char parport_readb( unsigned long port )
+static inline unsigned char parport_readb( unsigned long port )
@@ -50 +50 @@ static __inline__ unsigned char parport_readb( unsigned long port )
-static __inline__ void parport_writeb( unsigned char value, unsigned long port )
+static inline void parport_writeb( unsigned char value, unsigned long port )
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 380916bff9e0..c5d3a1053dff 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -228 +228 @@ static int clear_epp_timeout(struct parport *pb)
- * parport_xxx_yyy macros.  extern __inline__ versions of several
+ * parport_xxx_yyy macros.  extern inline versions of several
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 050f04418f5f..a6bf8caec5fd 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4476 +4476 @@ lpfc_info(struct Scsi_Host *host)
-static __inline__ void lpfc_poll_rearm_timer(struct lpfc_hba * phba)
+static inline void lpfc_poll_rearm_timer(struct lpfc_hba * phba)
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 20011c8afbb5..299963f8d0ac 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -244 +244 @@ SYM53C500_int_host_reset(int io_port)
-static __inline__ int
+static inline int
@@ -299 +299 @@ SYM53C500_pio_read(int fast_pio, int base, unsigned char *request, unsigned int
-static __inline__ int
+static inline int
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 37ae0f6d8ae5..92ba43f58314 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -42 +42 @@ qla24xx_calc_iocbs(scsi_qla_host_t *vha, uint16_t dsds)
-static __inline__ uint16_t
+static inline uint16_t
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 15eaa6dded04..2d08240facff 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -346 +346 @@ struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
-__inline__ void
+inline void
@@ -368 +368 @@ qla2x00_restart_timer(scsi_qla_host_t *vha, unsigned long interval)
-static __inline__ void
+static inline void
diff --git a/drivers/staging/ipx/ipx_proc.c b/drivers/staging/ipx/ipx_proc.c
index 360f0ad970de..930af2a09d62 100644
--- a/drivers/staging/ipx/ipx_proc.c
+++ b/drivers/staging/ipx/ipx_proc.c
@@ -104 +104 @@ static int ipx_seq_route_show(struct seq_file *seq, void *v)
-static __inline__ struct sock *ipx_get_socket_idx(loff_t pos)
+static inline struct sock *ipx_get_socket_idx(loff_t pos)
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 34dead614149..c1bd9b74f4d5 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -174 +174 @@ static inline int serial_paranoia_check(struct serial_state *info,
-static __inline__ void rtsdtr_ctrl(int bits)
+static inline void rtsdtr_ctrl(int bits)
diff --git a/drivers/tty/serial/ip22zilog.c b/drivers/tty/serial/ip22zilog.c
index 8c810733df3d..8ccf8b7ee8bb 100644
--- a/drivers/tty/serial/ip22zilog.c
+++ b/drivers/tty/serial/ip22zilog.c
@@ -493 +493 @@ static irqreturn_t ip22zilog_interrupt(int irq, void *dev_id)
-static __inline__ unsigned char ip22zilog_read_channel_status(struct uart_port *port)
+static inline unsigned char ip22zilog_read_channel_status(struct uart_port *port)
diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index b93d0225f8c9..c586d0a67e3b 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -95 +95 @@ static char *sab82532_version[16] = {
-static __inline__ void sunsab_tec_wait(struct uart_sunsab_port *up)
+static inline void sunsab_tec_wait(struct uart_sunsab_port *up)
@@ -103 +103 @@ static __inline__ void sunsab_tec_wait(struct uart_sunsab_port *up)
-static __inline__ void sunsab_cec_wait(struct uart_sunsab_port *up)
+static inline void sunsab_cec_wait(struct uart_sunsab_port *up)
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index bc7af8b08a72..5c7f1648f54d 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -593 +593 @@ static irqreturn_t sunzilog_interrupt(int irq, void *dev_id)
-static __inline__ unsigned char sunzilog_read_channel_status(struct uart_port *port)
+static inline unsigned char sunzilog_read_channel_status(struct uart_port *port)
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 3e330e0f56ed..54c011cf1f5c 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -178,4 +178,4 @@ static void fbcon_set_palette(struct vc_data *vc, const unsigned char *table);
-static __inline__ void ywrap_up(struct vc_data *vc, int count);
-static __inline__ void ywrap_down(struct vc_data *vc, int count);
-static __inline__ void ypan_up(struct vc_data *vc, int count);
-static __inline__ void ypan_down(struct vc_data *vc, int count);
+static inline void ywrap_up(struct vc_data *vc, int count);
+static inline void ywrap_down(struct vc_data *vc, int count);
+static inline void ypan_up(struct vc_data *vc, int count);
+static inline void ypan_down(struct vc_data *vc, int count);
@@ -1430 +1430 @@ static void fbcon_set_disp(struct fb_info *info, struct fb_var_screeninfo *var,
-static __inline__ void ywrap_up(struct vc_data *vc, int count)
+static inline void ywrap_up(struct vc_data *vc, int count)
@@ -1449 +1449 @@ static __inline__ void ywrap_up(struct vc_data *vc, int count)
-static __inline__ void ywrap_down(struct vc_data *vc, int count)
+static inline void ywrap_down(struct vc_data *vc, int count)
@@ -1468 +1468 @@ static __inline__ void ywrap_down(struct vc_data *vc, int count)
-static __inline__ void ypan_up(struct vc_data *vc, int count)
+static inline void ypan_up(struct vc_data *vc, int count)
@@ -1492 +1492 @@ static __inline__ void ypan_up(struct vc_data *vc, int count)
-static __inline__ void ypan_up_redraw(struct vc_data *vc, int t, int count)
+static inline void ypan_up_redraw(struct vc_data *vc, int t, int count)
@@ -1516 +1516 @@ static __inline__ void ypan_up_redraw(struct vc_data *vc, int t, int count)
-static __inline__ void ypan_down(struct vc_data *vc, int count)
+static inline void ypan_down(struct vc_data *vc, int count)
@@ -1540 +1540 @@ static __inline__ void ypan_down(struct vc_data *vc, int count)
-static __inline__ void ypan_down_redraw(struct vc_data *vc, int t, int count)
+static inline void ypan_down_redraw(struct vc_data *vc, int t, int count)
diff --git a/drivers/video/fbdev/ffb.c b/drivers/video/fbdev/ffb.c
index 6b1915872af1..d86911707e54 100644
--- a/drivers/video/fbdev/ffb.c
+++ b/drivers/video/fbdev/ffb.c
@@ -414 +414 @@ static int ffb_sync(struct fb_info *p)
-static __inline__ void ffb_rop(struct ffb_par *par, u32 rop)
+static inline void ffb_rop(struct ffb_par *par, u32 rop)
diff --git a/drivers/video/fbdev/intelfb/intelfbdrv.c b/drivers/video/fbdev/intelfb/intelfbdrv.c
index d7463a2a5d83..de1ee0f5406a 100644
--- a/drivers/video/fbdev/intelfb/intelfbdrv.c
+++ b/drivers/video/fbdev/intelfb/intelfbdrv.c
@@ -273 +273 @@ MODULE_PARM_DESC(mode,
-static __inline__ char * get_opt_string(const char *this_opt, const char *name)
+static inline char * get_opt_string(const char *this_opt, const char *name)
@@ -291 +291 @@ static __inline__ char * get_opt_string(const char *this_opt, const char *name)
-static __inline__ int get_opt_int(const char *this_opt, const char *name,
+static inline int get_opt_int(const char *this_opt, const char *name,
@@ -304 +304 @@ static __inline__ int get_opt_int(const char *this_opt, const char *name,
-static __inline__ int get_opt_bool(const char *this_opt, const char *name,
+static inline int get_opt_bool(const char *this_opt, const char *name,
@@ -910 +910 @@ static void intelfb_pci_unregister(struct pci_dev *pdev)
-__inline__ int intelfb_var_to_depth(const struct fb_var_screeninfo *var)
+inline int intelfb_var_to_depth(const struct fb_var_screeninfo *var)
@@ -926 +926 @@ __inline__ int intelfb_var_to_depth(const struct fb_var_screeninfo *var)
-static __inline__ int var_to_refresh(const struct fb_var_screeninfo *var)
+static inline int var_to_refresh(const struct fb_var_screeninfo *var)
diff --git a/drivers/video/fbdev/intelfb/intelfbhw.c b/drivers/video/fbdev/intelfb/intelfbhw.c
index 57aff7450bce..bbd258330f21 100644
--- a/drivers/video/fbdev/intelfb/intelfbhw.c
+++ b/drivers/video/fbdev/intelfb/intelfbhw.c
@@ -1028 +1028 @@ static int calc_pll_params(int index, int clock, u32 *retm1, u32 *retm2,
-static __inline__ int check_overflow(u32 value, u32 limit,
+static inline int check_overflow(u32 value, u32 limit,
diff --git a/drivers/w1/masters/matrox_w1.c b/drivers/w1/masters/matrox_w1.c
index d83d7c99d81d..8bdee261770f 100644
--- a/drivers/w1/masters/matrox_w1.c
+++ b/drivers/w1/masters/matrox_w1.c
@@ -81 +81 @@ struct matrox_device
-static __inline__ u8 matrox_w1_read_reg(struct matrox_device *dev, u8 reg)
+static inline u8 matrox_w1_read_reg(struct matrox_device *dev, u8 reg)
@@ -92 +92 @@ static __inline__ u8 matrox_w1_read_reg(struct matrox_device *dev, u8 reg)
-static __inline__ void matrox_w1_write_reg(struct matrox_device *dev, u8 reg, u8 val)
+static inline void matrox_w1_write_reg(struct matrox_device *dev, u8 reg, u8 val)
diff --git a/fs/coda/coda_linux.h b/fs/coda/coda_linux.h
index 126155cadfa9..5f324bb0bd13 100644
--- a/fs/coda/coda_linux.h
+++ b/fs/coda/coda_linux.h
@@ -85 +85 @@ static inline struct coda_inode_info *ITOC(struct inode *inode)
-static __inline__ struct CodaFid *coda_i2f(struct inode *inode)
+static inline struct CodaFid *coda_i2f(struct inode *inode)
@@ -90 +90 @@ static __inline__ struct CodaFid *coda_i2f(struct inode *inode)
-static __inline__ char *coda_i2s(struct inode *inode)
+static inline char *coda_i2s(struct inode *inode)
@@ -96 +96 @@ static __inline__ char *coda_i2s(struct inode *inode)
-static __inline__ void coda_flag_inode(struct inode *inode, int flag)
+static inline void coda_flag_inode(struct inode *inode, int flag)
diff --git a/fs/freevxfs/vxfs_inode.c b/fs/freevxfs/vxfs_inode.c
index 1f41b25ef38b..a0b32934b1e4 100644
--- a/fs/freevxfs/vxfs_inode.c
+++ b/fs/freevxfs/vxfs_inode.c
@@ -77 +77 @@ vxfs_dumpi(struct vxfs_inode_info *vip, ino_t ino)
-static __inline__ umode_t
+static inline umode_t
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index 755e256a9103..f399f4a16fc9 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -169 +169 @@ void	fh_put(struct svc_fh *);
-static __inline__ struct svc_fh *
+static inline struct svc_fh *
@@ -185 +185 @@ fh_copy_shallow(struct knfsd_fh *dst, struct knfsd_fh *src)
-static __inline__ struct svc_fh *
+static inline struct svc_fh *
diff --git a/include/acpi/platform/acgcc.h b/include/acpi/platform/acgcc.h
index 085db95a3dae..32abaa61ef96 100644
--- a/include/acpi/platform/acgcc.h
+++ b/include/acpi/platform/acgcc.h
@@ -29 +29 @@ typedef __builtin_va_list va_list;
-#define ACPI_INLINE             __inline__
+#define ACPI_INLINE             inline
diff --git a/include/asm-generic/ide_iops.h b/include/asm-generic/ide_iops.h
index 81dfa3ee5e06..c7028674a03d 100644
--- a/include/asm-generic/ide_iops.h
+++ b/include/asm-generic/ide_iops.h
@@ -9 +9 @@
-static __inline__ void __ide_mm_insw(void __iomem *port, void *addr, u32 count)
+static inline void __ide_mm_insw(void __iomem *port, void *addr, u32 count)
@@ -17 +17 @@ static __inline__ void __ide_mm_insw(void __iomem *port, void *addr, u32 count)
-static __inline__ void __ide_mm_insl(void __iomem *port, void *addr, u32 count)
+static inline void __ide_mm_insl(void __iomem *port, void *addr, u32 count)
@@ -25 +25 @@ static __inline__ void __ide_mm_insl(void __iomem *port, void *addr, u32 count)
-static __inline__ void __ide_mm_outsw(void __iomem *port, void *addr, u32 count)
+static inline void __ide_mm_outsw(void __iomem *port, void *addr, u32 count)
@@ -33 +33 @@ static __inline__ void __ide_mm_outsw(void __iomem *port, void *addr, u32 count)
-static __inline__ void __ide_mm_outsl(void __iomem * port, void *addr, u32 count)
+static inline void __ide_mm_outsl(void __iomem * port, void *addr, u32 count)
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index c6666cd09347..bbdb27d6af63 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -126 +126 @@ static inline bool drm_drv_uses_atomic_modeset(struct drm_device *dev)
-static __inline__ int drm_core_check_feature(struct drm_device *dev,
+static inline int drm_core_check_feature(struct drm_device *dev,
@@ -146 +146 @@ static __inline__ int drm_core_check_feature(struct drm_device *dev,
-static __inline__ bool drm_can_sleep(void)
+static inline bool drm_can_sleep(void)
diff --git a/include/drm/drm_legacy.h b/include/drm/drm_legacy.h
index cf0e7d89bcdf..47d75920ace9 100644
--- a/include/drm/drm_legacy.h
+++ b/include/drm/drm_legacy.h
@@ -197 +197 @@ void drm_legacy_ioremapfree(struct drm_local_map *map, struct drm_device *dev);
-static __inline__ struct drm_local_map *drm_legacy_findmap(struct drm_device *dev,
+static inline struct drm_local_map *drm_legacy_findmap(struct drm_device *dev,
diff --git a/include/linux/atalk.h b/include/linux/atalk.h
index 23f805562f4e..257c986f7f40 100644
--- a/include/linux/atalk.h
+++ b/include/linux/atalk.h
@@ -63 +63 @@ struct ddpehdr {
-static __inline__ struct ddpehdr *ddp_hdr(struct sk_buff *skb)
+static inline struct ddpehdr *ddp_hdr(struct sk_buff *skb)
@@ -91 +91 @@ struct elapaarp {
-static __inline__ struct elapaarp *aarp_hdr(struct sk_buff *skb)
+static inline struct elapaarp *aarp_hdr(struct sk_buff *skb)
diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index c7dfcb8a1fb2..91828f8242a2 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -82 +82 @@ enum ceph_msg_data_type {
-static __inline__ bool ceph_msg_data_type_valid(enum ceph_msg_data_type type)
+static inline bool ceph_msg_data_type_valid(enum ceph_msg_data_type type)
diff --git a/include/linux/hdlc.h b/include/linux/hdlc.h
index 97585d9679f3..c9e58c889548 100644
--- a/include/linux/hdlc.h
+++ b/include/linux/hdlc.h
@@ -77 +77 @@ static inline struct hdlc_device* dev_to_hdlc(struct net_device *dev)
-static __inline__ void debug_frame(const struct sk_buff *skb)
+static inline void debug_frame(const struct sk_buff *skb)
@@ -104 +104 @@ int detach_hdlc_protocol(struct net_device *dev);
-static __inline__ __be16 hdlc_type_trans(struct sk_buff *skb,
+static inline __be16 hdlc_type_trans(struct sk_buff *skb,
diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index e16fe7d44a71..6c381934b335 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -185 +185 @@ struct in_ifaddr *inet_lookup_ifaddr_rcu(struct net *net, __be32 addr);
-static __inline__ bool inet_ifa_match(__be32 addr, struct in_ifaddr *ifa)
+static inline bool inet_ifa_match(__be32 addr, struct in_ifaddr *ifa)
@@ -194 +194 @@ static __inline__ bool inet_ifa_match(__be32 addr, struct in_ifaddr *ifa)
-static __inline__ bool bad_mask(__be32 mask, __be32 addr)
+static inline bool bad_mask(__be32 mask, __be32 addr)
@@ -256 +256 @@ static inline void in_dev_put(struct in_device *idev)
-static __inline__ __be32 inet_make_mask(int logmask)
+static inline __be32 inet_make_mask(int logmask)
@@ -263 +263 @@ static __inline__ __be32 inet_make_mask(int logmask)
-static __inline__ int inet_mask_len(__be32 mask)
+static inline int inet_mask_len(__be32 mask)
diff --git a/include/linux/parport.h b/include/linux/parport.h
index 397607a0c0eb..a28dc3e22074 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -388 +388 @@ extern void parport_release(struct pardevice *dev);
-static __inline__ int parport_yield(struct pardevice *dev)
+static inline int parport_yield(struct pardevice *dev)
@@ -406 +406 @@ static __inline__ int parport_yield(struct pardevice *dev)
-static __inline__ int parport_yield_blocking(struct pardevice *dev)
+static inline int parport_yield_blocking(struct pardevice *dev)
diff --git a/include/linux/parport_pc.h b/include/linux/parport_pc.h
index 3d6fc576d6a1..ea368c35a5e7 100644
--- a/include/linux/parport_pc.h
+++ b/include/linux/parport_pc.h
@@ -63 +63 @@ struct parport_pc_via_data
-static __inline__ void parport_pc_write_data(struct parport *p, unsigned char d)
+static inline void parport_pc_write_data(struct parport *p, unsigned char d)
@@ -71 +71 @@ static __inline__ void parport_pc_write_data(struct parport *p, unsigned char d)
-static __inline__ unsigned char parport_pc_read_data(struct parport *p)
+static inline unsigned char parport_pc_read_data(struct parport *p)
@@ -128 +128 @@ static inline void dump_parport_state (char *str, struct parport *p)
-static __inline__ unsigned char __parport_pc_frob_control (struct parport *p,
+static inline unsigned char __parport_pc_frob_control (struct parport *p,
@@ -146 +146 @@ static __inline__ unsigned char __parport_pc_frob_control (struct parport *p,
-static __inline__ void parport_pc_data_reverse (struct parport *p)
+static inline void parport_pc_data_reverse (struct parport *p)
@@ -151 +151 @@ static __inline__ void parport_pc_data_reverse (struct parport *p)
-static __inline__ void parport_pc_data_forward (struct parport *p)
+static inline void parport_pc_data_forward (struct parport *p)
@@ -156 +156 @@ static __inline__ void parport_pc_data_forward (struct parport *p)
-static __inline__ void parport_pc_write_control (struct parport *p,
+static inline void parport_pc_write_control (struct parport *p,
@@ -174 +174 @@ static __inline__ void parport_pc_write_control (struct parport *p,
-static __inline__ unsigned char parport_pc_read_control(struct parport *p)
+static inline unsigned char parport_pc_read_control(struct parport *p)
@@ -184 +184 @@ static __inline__ unsigned char parport_pc_read_control(struct parport *p)
-static __inline__ unsigned char parport_pc_frob_control (struct parport *p,
+static inline unsigned char parport_pc_frob_control (struct parport *p,
@@ -211 +211 @@ static __inline__ unsigned char parport_pc_frob_control (struct parport *p,
-static __inline__ unsigned char parport_pc_read_status(struct parport *p)
+static inline unsigned char parport_pc_read_status(struct parport *p)
@@ -217 +217 @@ static __inline__ unsigned char parport_pc_read_status(struct parport *p)
-static __inline__ void parport_pc_disable_irq(struct parport *p)
+static inline void parport_pc_disable_irq(struct parport *p)
@@ -222 +222 @@ static __inline__ void parport_pc_disable_irq(struct parport *p)
-static __inline__ void parport_pc_enable_irq(struct parport *p)
+static inline void parport_pc_enable_irq(struct parport *p)
diff --git a/include/net/ax25.h b/include/net/ax25.h
index 3f9aea8087e3..cd0bec7a6d4d 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -273 +273 @@ static inline struct ax25_cb *sk_to_ax25(const struct sock *sk)
-static __inline__ void ax25_cb_put(ax25_cb *ax25)
+static inline void ax25_cb_put(ax25_cb *ax25)
diff --git a/include/net/checksum.h b/include/net/checksum.h
index aef2b2bb6603..e03914ab9197 100644
--- a/include/net/checksum.h
+++ b/include/net/checksum.h
@@ -44 +44 @@ __wsum csum_and_copy_from_user (const void __user *src, void *dst,
-static __inline__ __wsum csum_and_copy_to_user
+static inline __wsum csum_and_copy_to_user
diff --git a/include/net/dn_nsp.h b/include/net/dn_nsp.h
index 413a15e5339c..771d3943a8f9 100644
--- a/include/net/dn_nsp.h
+++ b/include/net/dn_nsp.h
@@ -147 +147 @@ struct  srcobj_fmt {
-static __inline__ int dn_before(__u16 seq1, __u16 seq2)
+static inline int dn_before(__u16 seq1, __u16 seq2)
@@ -156 +156 @@ static __inline__ int dn_before(__u16 seq1, __u16 seq2)
-static __inline__ int dn_after(__u16 seq1, __u16 seq2)
+static inline int dn_after(__u16 seq1, __u16 seq2)
@@ -164 +164 @@ static __inline__ int dn_after(__u16 seq1, __u16 seq2)
-static __inline__ int dn_equal(__u16 seq1, __u16 seq2)
+static inline int dn_equal(__u16 seq1, __u16 seq2)
@@ -169 +169 @@ static __inline__ int dn_equal(__u16 seq1, __u16 seq2)
-static __inline__ int dn_before_or_equal(__u16 seq1, __u16 seq2)
+static inline int dn_before_or_equal(__u16 seq1, __u16 seq2)
@@ -174 +174 @@ static __inline__ int dn_before_or_equal(__u16 seq1, __u16 seq2)
-static __inline__ void seq_add(__u16 *seq, __u16 off)
+static inline void seq_add(__u16 *seq, __u16 off)
@@ -180 +180 @@ static __inline__ void seq_add(__u16 *seq, __u16 off)
-static __inline__ int seq_next(__u16 seq1, __u16 seq2)
+static inline int seq_next(__u16 seq1, __u16 seq2)
@@ -188 +188 @@ static __inline__ int seq_next(__u16 seq1, __u16 seq2)
-static __inline__ int sendack(__u16 seq)
+static inline int sendack(__u16 seq)
@@ -196 +196 @@ static __inline__ int sendack(__u16 seq)
-static __inline__ int dn_congested(struct sock *sk)
+static inline int dn_congested(struct sock *sk)
diff --git a/include/net/ip.h b/include/net/ip.h
index ecffd843e7b8..41a4a6597d96 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -523 +523 @@ static inline void ip_ipgre_mc_map(__be32 naddr, const unsigned char *broadcast,
-static __inline__ void inet_reset_saddr(struct sock *sk)
+static inline void inet_reset_saddr(struct sock *sk)
diff --git a/include/net/ip6_checksum.h b/include/net/ip6_checksum.h
index cca840584c88..27567477dcc6 100644
--- a/include/net/ip6_checksum.h
+++ b/include/net/ip6_checksum.h
@@ -58 +58 @@ static inline __wsum ip6_gro_compute_pseudo(struct sk_buff *skb, int proto)
-static __inline__ __sum16 tcp_v6_check(int len,
+static inline __sum16 tcp_v6_check(int len,
diff --git a/include/net/ipx.h b/include/net/ipx.h
index baf090390998..cf89ef92a5f7 100644
--- a/include/net/ipx.h
+++ b/include/net/ipx.h
@@ -50 +50 @@ extern int sysctl_ipx_pprop_broadcasting;
-static __inline__ struct ipxhdr *ipx_hdr(struct sk_buff *skb)
+static inline struct ipxhdr *ipx_hdr(struct sk_buff *skb)
@@ -142 +142 @@ const char *ipx_device_name(struct ipx_interface *intrfc);
-static __inline__ void ipxitf_hold(struct ipx_interface *intrfc)
+static inline void ipxitf_hold(struct ipx_interface *intrfc)
@@ -160 +160 @@ int ipxrtr_ioctl(unsigned int cmd, void __user *arg);
-static __inline__ void ipxitf_put(struct ipx_interface *intrfc)
+static inline void ipxitf_put(struct ipx_interface *intrfc)
@@ -166 +166 @@ static __inline__ void ipxitf_put(struct ipx_interface *intrfc)
-static __inline__ void ipxrtr_hold(struct ipx_route *rt)
+static inline void ipxrtr_hold(struct ipx_route *rt)
@@ -171 +171 @@ static __inline__ void ipxrtr_hold(struct ipx_route *rt)
-static __inline__ void ipxrtr_put(struct ipx_route *rt)
+static inline void ipxrtr_put(struct ipx_route *rt)
diff --git a/include/net/llc_c_ev.h b/include/net/llc_c_ev.h
index 3948cf111dd0..266275a945b4 100644
--- a/include/net/llc_c_ev.h
+++ b/include/net/llc_c_ev.h
@@ -123 +123 @@ struct llc_conn_state_ev {
-static __inline__ struct llc_conn_state_ev *llc_conn_ev(struct sk_buff *skb)
+static inline struct llc_conn_state_ev *llc_conn_ev(struct sk_buff *skb)
@@ -219 +219 @@ int llc_conn_ev_qlfy_set_status_rst_done(struct sock *sk, struct sk_buff *skb);
-static __inline__ int llc_conn_space(struct sock *sk, struct sk_buff *skb)
+static inline int llc_conn_space(struct sock *sk, struct sk_buff *skb)
diff --git a/include/net/llc_conn.h b/include/net/llc_conn.h
index df528a623548..27880d1bfd99 100644
--- a/include/net/llc_conn.h
+++ b/include/net/llc_conn.h
@@ -88 +88 @@ static inline struct llc_sock *llc_sk(const struct sock *sk)
-static __inline__ void llc_set_backlog_type(struct sk_buff *skb, char type)
+static inline void llc_set_backlog_type(struct sk_buff *skb, char type)
@@ -93 +93 @@ static __inline__ void llc_set_backlog_type(struct sk_buff *skb, char type)
-static __inline__ char llc_backlog_type(struct sk_buff *skb)
+static inline char llc_backlog_type(struct sk_buff *skb)
diff --git a/include/net/llc_s_ev.h b/include/net/llc_s_ev.h
index 84db3a59ed28..00439d3e9f5d 100644
--- a/include/net/llc_s_ev.h
+++ b/include/net/llc_s_ev.h
@@ -47 +47 @@ struct llc_sap_state_ev {
-static __inline__ struct llc_sap_state_ev *llc_sap_ev(struct sk_buff *skb)
+static inline struct llc_sap_state_ev *llc_sap_ev(struct sk_buff *skb)
diff --git a/include/net/netrom.h b/include/net/netrom.h
index 5a0714ff500f..1741b7cc8962 100644
--- a/include/net/netrom.h
+++ b/include/net/netrom.h
@@ -126 +126 @@ struct nr_node {
-static __inline__ void nr_node_put(struct nr_node *nr_node)
+static inline void nr_node_put(struct nr_node *nr_node)
@@ -136 +136 @@ static __inline__ void nr_node_put(struct nr_node *nr_node)
-static __inline__ void nr_neigh_put(struct nr_neigh *nr_neigh)
+static inline void nr_neigh_put(struct nr_neigh *nr_neigh)
@@ -148 +148 @@ static __inline__ void nr_neigh_put(struct nr_neigh *nr_neigh)
-static __inline__ void nr_node_lock(struct nr_node *nr_node)
+static inline void nr_node_lock(struct nr_node *nr_node)
@@ -154 +154 @@ static __inline__ void nr_node_lock(struct nr_node *nr_node)
-static __inline__ void nr_node_unlock(struct nr_node *nr_node)
+static inline void nr_node_unlock(struct nr_node *nr_node)
diff --git a/include/net/scm.h b/include/net/scm.h
index 903771c8d4e3..ae6a707f2dee 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -46 +46 @@ struct scm_fp_list *scm_fp_dup(struct scm_fp_list *fpl);
-static __inline__ void unix_get_peersec_dgram(struct socket *sock, struct scm_cookie *scm)
+static inline void unix_get_peersec_dgram(struct socket *sock, struct scm_cookie *scm)
@@ -51 +51 @@ static __inline__ void unix_get_peersec_dgram(struct socket *sock, struct scm_co
-static __inline__ void unix_get_peersec_dgram(struct socket *sock, struct scm_cookie *scm)
+static inline void unix_get_peersec_dgram(struct socket *sock, struct scm_cookie *scm)
@@ -55 +55 @@ static __inline__ void unix_get_peersec_dgram(struct socket *sock, struct scm_co
-static __inline__ void scm_set_cred(struct scm_cookie *scm,
+static inline void scm_set_cred(struct scm_cookie *scm,
@@ -64 +64 @@ static __inline__ void scm_set_cred(struct scm_cookie *scm,
-static __inline__ void scm_destroy_cred(struct scm_cookie *scm)
+static inline void scm_destroy_cred(struct scm_cookie *scm)
@@ -70 +70 @@ static __inline__ void scm_destroy_cred(struct scm_cookie *scm)
-static __inline__ void scm_destroy(struct scm_cookie *scm)
+static inline void scm_destroy(struct scm_cookie *scm)
@@ -77 +77 @@ static __inline__ void scm_destroy(struct scm_cookie *scm)
-static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
+static inline int scm_send(struct socket *sock, struct msghdr *msg,
@@ -112 +112 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
-static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
+static inline void scm_recv(struct socket *sock, struct msghdr *msg,
diff --git a/include/net/udplite.h b/include/net/udplite.h
index 9185e45b997f..747859a3a00f 100644
--- a/include/net/udplite.h
+++ b/include/net/udplite.h
@@ -20 +20 @@ extern struct udp_table		udplite_table;
-static __inline__ int udplite_getfrag(void *from, char *to, int  offset,
+static inline int udplite_getfrag(void *from, char *to, int  offset,
diff --git a/include/net/x25.h b/include/net/x25.h
index ed1acc3044ac..4cb533479d61 100644
--- a/include/net/x25.h
+++ b/include/net/x25.h
@@ -245 +245 @@ void x25_link_free(void);
-static __inline__ void x25_neigh_hold(struct x25_neigh *nb)
+static inline void x25_neigh_hold(struct x25_neigh *nb)
@@ -250 +250 @@ static __inline__ void x25_neigh_hold(struct x25_neigh *nb)
-static __inline__ void x25_neigh_put(struct x25_neigh *nb)
+static inline void x25_neigh_put(struct x25_neigh *nb)
@@ -268 +268 @@ void x25_route_free(void);
-static __inline__ void x25_route_hold(struct x25_route *rt)
+static inline void x25_route_hold(struct x25_route *rt)
@@ -273 +273 @@ static __inline__ void x25_route_hold(struct x25_route *rt)
-static __inline__ void x25_route_put(struct x25_route *rt)
+static inline void x25_route_put(struct x25_route *rt)
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 45e75c36b738..bdb796d1a7b3 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -897 +897 @@ static inline bool addr4_match(__be32 a1, __be32 a2, u8 prefixlen)
-static __inline__
+static inline
@@ -924 +924 @@ __be16 xfrm_flowi_sport(const struct flowi *fl, const union flowi_uli *uli)
-static __inline__
+static inline
@@ -1303 +1303 @@ static inline int xfrm6_policy_check_reverse(struct sock *sk, int dir,
-static __inline__
+static inline
@@ -1315 +1315 @@ xfrm_address_t *xfrm_flowi_daddr(const struct flowi *fl, unsigned short family)
-static __inline__
+static inline
@@ -1327 +1327 @@ xfrm_address_t *xfrm_flowi_saddr(const struct flowi *fl, unsigned short family)
-static __inline__
+static inline
@@ -1344 +1344 @@ void xfrm_flowi_addr_get(const struct flowi *fl,
-static __inline__ int
+static inline int
@@ -1354 +1354 @@ __xfrm4_state_addr_check(const struct xfrm_state *x,
-static __inline__ int
+static inline int
@@ -1366 +1366 @@ __xfrm6_state_addr_check(const struct xfrm_state *x,
-static __inline__ int
+static inline int
@@ -1380 +1380 @@ xfrm_state_addr_check(const struct xfrm_state *x,
-static __inline__ int
+static inline int
diff --git a/include/video/newport.h b/include/video/newport.h
index bcbb3d1b6bf9..108bc554c4b8 100644
--- a/include/video/newport.h
+++ b/include/video/newport.h
@@ -429 +429 @@ static inline unsigned short newport_vc2_get(struct newport_regs *regs,
-static __inline__ void newport_cmap_setaddr(struct newport_regs *regs,
+static inline void newport_cmap_setaddr(struct newport_regs *regs,
@@ -440 +440 @@ static __inline__ void newport_cmap_setaddr(struct newport_regs *regs,
-static __inline__ void newport_cmap_setrgb(struct newport_regs *regs,
+static inline void newport_cmap_setrgb(struct newport_regs *regs,
@@ -453 +453 @@ static __inline__ void newport_cmap_setrgb(struct newport_regs *regs,
-static __inline__ int newport_wait(struct newport_regs *regs)
+static inline int newport_wait(struct newport_regs *regs)
@@ -463 +463 @@ static __inline__ int newport_wait(struct newport_regs *regs)
-static __inline__ int newport_bfwait(struct newport_regs *regs)
+static inline int newport_bfwait(struct newport_regs *regs)
@@ -550 +550 @@ static __inline__ int newport_bfwait(struct newport_regs *regs)
-static __inline__ void
+static inline void
@@ -561 +561 @@ xmap9FIFOWait (struct newport_regs *rex)
-static __inline__ void
+static inline void
diff --git a/net/appletalk/atalk_proc.c b/net/appletalk/atalk_proc.c
index 8006295f8bd7..6bc7c80a44de 100644
--- a/net/appletalk/atalk_proc.c
+++ b/net/appletalk/atalk_proc.c
@@ -20 +20 @@
-static __inline__ struct atalk_iface *atalk_get_interface_idx(loff_t pos)
+static inline struct atalk_iface *atalk_get_interface_idx(loff_t pos)
@@ -81 +81 @@ static int atalk_seq_interface_show(struct seq_file *seq, void *v)
-static __inline__ struct atalk_route *atalk_get_route_idx(loff_t pos)
+static inline struct atalk_route *atalk_get_route_idx(loff_t pos)
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 55fdba05d7d9..2ea6293ab718 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1280 +1280 @@ static int atalk_getname(struct socket *sock, struct sockaddr *uaddr,
-static __inline__ int is_ip_over_ddp(struct sk_buff *skb)
+static inline int is_ip_over_ddp(struct sk_buff *skb)
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 1fb43bff417d..268f4096e421 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -865 +865 @@ static void neigh_periodic_work(struct work_struct *work)
-static __inline__ int neigh_max_probes(struct neighbour *n)
+static inline int neigh_max_probes(struct neighbour *n)
diff --git a/net/core/scm.c b/net/core/scm.c
index b1ff8a441748..d508a27f8552 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -48 +48 @@
-static __inline__ int scm_check_creds(struct ucred *creds)
+static inline int scm_check_creds(struct ucred *creds)
diff --git a/net/decnet/dn_nsp_in.c b/net/decnet/dn_nsp_in.c
index 1b2120645730..e3ad1f89781a 100644
--- a/net/decnet/dn_nsp_in.c
+++ b/net/decnet/dn_nsp_in.c
@@ -585 +585 @@ static void dn_nsp_linkservice(struct sock *sk, struct sk_buff *skb)
-static __inline__ int dn_queue_skb(struct sock *sk, struct sk_buff *skb, int sig, struct sk_buff_head *queue)
+static inline int dn_queue_skb(struct sock *sk, struct sk_buff *skb, int sig, struct sk_buff_head *queue)
diff --git a/net/decnet/dn_nsp_out.c b/net/decnet/dn_nsp_out.c
index 56a52a004c56..afa3d33190b2 100644
--- a/net/decnet/dn_nsp_out.c
+++ b/net/decnet/dn_nsp_out.c
@@ -532 +532 @@ void dn_send_conn_conf(struct sock *sk, gfp_t gfp)
-static __inline__ void dn_nsp_do_disc(struct sock *sk, unsigned char msgflg,
+static inline void dn_nsp_do_disc(struct sock *sk, unsigned char msgflg,
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index e74765024d88..67cc6b7b11c1 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -177 +177 @@ static void dn_dst_ifdown(struct dst_entry *dst, struct net_device *dev, int how
-static __inline__ unsigned int dn_hash(__le16 src, __le16 dst)
+static inline unsigned int dn_hash(__le16 src, __le16 dst)
diff --git a/net/decnet/dn_table.c b/net/decnet/dn_table.c
index f0710b5d037d..90b5144c20bf 100644
--- a/net/decnet/dn_table.c
+++ b/net/decnet/dn_table.c
@@ -408 +408 @@ static void dn_rtmsg_fib(int event, struct dn_fib_node *f, int z, u32 tb_id,
-static __inline__ int dn_hash_dump_bucket(struct sk_buff *skb,
+static inline int dn_hash_dump_bucket(struct sk_buff *skb,
@@ -437 +437 @@ static __inline__ int dn_hash_dump_bucket(struct sk_buff *skb,
-static __inline__ int dn_hash_dump_zone(struct sk_buff *skb,
+static inline int dn_hash_dump_zone(struct sk_buff *skb,
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 85b617b655bc..68ee4a2ae8b2 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -21 +21 @@
- *		Alan Cox	:	Added lots of __inline__ to optimise
+ *		Alan Cox	:	Added lots of inline to optimise
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index d443c18b45fe..3b7b260125b3 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -103 +103 @@ EXPORT_SYMBOL_GPL(ipv6_mod_enabled);
-static __inline__ struct ipv6_pinfo *inet6_sk_generic(struct sock *sk)
+static inline struct ipv6_pinfo *inet6_sk_generic(struct sock *sk)
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index d8c4b6374377..1f22146a09f8 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -114 +114 @@ static const struct inet6_protocol icmpv6_protocol = {
-static __inline__ struct sock *icmpv6_xmit_lock(struct net *net)
+static inline struct sock *icmpv6_xmit_lock(struct net *net)
@@ -129 +129 @@ static __inline__ struct sock *icmpv6_xmit_lock(struct net *net)
-static __inline__ void icmpv6_xmit_unlock(struct sock *sk)
+static inline void icmpv6_xmit_unlock(struct sock *sk)
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 00e2112da26d..6a3b249634e7 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -542 +542 @@ static int __udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
-static __inline__ void udpv6_err(struct sk_buff *skb,
+static inline void udpv6_err(struct sk_buff *skb,
@@ -939 +939 @@ static void udp_v6_early_demux(struct sk_buff *skb)
-static __inline__ int udpv6_rcv(struct sk_buff *skb)
+static inline int udpv6_rcv(struct sk_buff *skb)
diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index db6e0afe3a20..b797138fec8c 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -55 +55 @@ static void lapb_free_cb(struct lapb_cb *lapb)
-static __inline__ void lapb_hold(struct lapb_cb *lapb)
+static inline void lapb_hold(struct lapb_cb *lapb)
@@ -60 +60 @@ static __inline__ void lapb_hold(struct lapb_cb *lapb)
-static __inline__ void lapb_put(struct lapb_cb *lapb)
+static inline void lapb_put(struct lapb_cb *lapb)
diff --git a/net/llc/llc_input.c b/net/llc/llc_input.c
index 82cb93f66b9b..6d467c8b1d70 100644
--- a/net/llc/llc_input.c
+++ b/net/llc/llc_input.c
@@ -75 +75 @@ void llc_set_station_handler(void (*handler)(struct sk_buff *skb))
-static __inline__ int llc_pdu_type(struct sk_buff *skb)
+static inline int llc_pdu_type(struct sk_buff *skb)
diff --git a/sound/sparc/amd7930.c b/sound/sparc/amd7930.c
index 56f17410fcea..3d1e603fdcfe 100644
--- a/sound/sparc/amd7930.c
+++ b/sound/sparc/amd7930.c
@@ -347 +347 @@ static struct snd_amd7930 *amd7930_list;
-static __inline__ void amd7930_idle(struct snd_amd7930 *amd)
+static inline void amd7930_idle(struct snd_amd7930 *amd)
@@ -358 +358 @@ static __inline__ void amd7930_idle(struct snd_amd7930 *amd)
-static __inline__ void amd7930_enable_ints(struct snd_amd7930 *amd)
+static inline void amd7930_enable_ints(struct snd_amd7930 *amd)
@@ -369 +369 @@ static __inline__ void amd7930_enable_ints(struct snd_amd7930 *amd)
-static __inline__ void amd7930_disable_ints(struct snd_amd7930 *amd)
+static inline void amd7930_disable_ints(struct snd_amd7930 *amd)
