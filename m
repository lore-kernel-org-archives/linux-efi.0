From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC Part1 PATCH v3 13/17] x86/io: Unroll string I/O when SEV is active
Date: Wed, 26 Jul 2017 12:45:17 +0200
Message-ID: <CAK8P3a3h7JpmkW7W=HwqAuWWmro=ngj6HSeiiML_=T82x-FtZQ@mail.gmail.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com> <20170724190757.11278-14-brijesh.singh@amd.com>
 <063D6719AE5E284EB5DD2968C1650D6DD003FB85@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD003FB85@AcuExch.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Laight <David.Laight@aculab.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Fenghua Yu <fenghua.yu@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Paul Mackerras <paulus@samba.org>, "H . Peter Anvin" <hpa@zytor.com>, Christoph Lameter <cl@linux.com>, Jonathan Corbet <corbet@lwn.net>, =?UTF-8?Q?Radim_Krcm=C3=A1r?= <rkrcmar@redhat.com>, Piotr Luc <piotr.luc@intel.com>, Ingo Molnar <mingo@redhat.com>, Dave Airlie <airlied@redhat.com>, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.len>
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 25, 2017 at 11:51 AM, David Laight <David.Laight@aculab.com> wrote:
> From: Brijesh Singh
>> Sent: 24 July 2017 20:08
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Secure Encrypted Virtualization (SEV) does not support string I/O, so
>> unroll the string I/O operation into a loop operating on one element at
>> a time.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/include/asm/io.h | 26 ++++++++++++++++++++++----
>>  1 file changed, 22 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
>> index e080a39..2f3c002 100644
>> --- a/arch/x86/include/asm/io.h
>> +++ b/arch/x86/include/asm/io.h
>> @@ -327,14 +327,32 @@ static inline unsigned type in##bwl##_p(int port)                       \
>>                                                                       \
>>  static inline void outs##bwl(int port, const void *addr, unsigned long count) \
>>  {

This will clash with a fix I did to add a "memory" clobber
for the traditional implementation, see
https://patchwork.kernel.org/patch/9854573/

> Is it even worth leaving these as inline functions?
> Given the speed of IO cycles it is unlikely that the cost of calling a real
> function will be significant.
> The code bloat reduction will be significant.

I think the smallest code would be the original "rep insb" etc, which
should be smaller than a function call, unlike the loop. Then again,
there is a rather small number of affected device drivers, almost all
of them for ancient hardware that you won't even build in a 64-bit
x86 kernel, see the list below. The only user I found that is actually
still relevant is drivers/tty/hvc/hvc_xen.c, which uses it for the early
console.

       Arnd

---
Full list for reference

$ git grep -wl '\(__ide_\|\)\(in\|out\)s\(b\|w\|l\)' drivers sound/
drivers/atm/horizon.c
drivers/cdrom/gdrom.c
drivers/gpu/drm/vmwgfx/vmwgfx_msg.h
drivers/ide/ide-io-std.c
drivers/isdn/hardware/avm/avmcard.h
drivers/isdn/hardware/eicon/divasmain.c
drivers/isdn/hardware/mISDN/avmfritz.c
drivers/isdn/hardware/mISDN/iohelper.h
drivers/isdn/hardware/mISDN/netjet.c
drivers/isdn/hardware/mISDN/w6692.c
drivers/isdn/hisax/asuscom.c
drivers/isdn/hisax/avm_a1.c
drivers/isdn/hisax/avm_a1p.c
drivers/isdn/hisax/avm_pci.c
drivers/isdn/hisax/diva.c
drivers/isdn/hisax/elsa.c
drivers/isdn/hisax/gazel.c
drivers/isdn/hisax/hisax_fcpcipnp.c
drivers/isdn/hisax/ix1_micro.c
drivers/isdn/hisax/mic.c
drivers/isdn/hisax/netjet.c
drivers/isdn/hisax/niccy.c
drivers/isdn/hisax/saphir.c
drivers/isdn/hisax/sedlbauer.c
drivers/isdn/hisax/sportster.c
drivers/isdn/hisax/teles3.c
drivers/isdn/hisax/w6692.c
drivers/isdn/hisax/w6692.h
drivers/media/rc/winbond-cir.c
drivers/mtd/spi-nor/aspeed-smc.c
drivers/net/appletalk/cops.c
drivers/net/arcnet/arcdevice.h
drivers/net/arcnet/com20020.c
drivers/net/ethernet/3com/3c509.c
drivers/net/ethernet/3com/3c515.c
drivers/net/ethernet/3com/3c574_cs.c
drivers/net/ethernet/3com/3c589_cs.c
drivers/net/ethernet/8390/axnet_cs.c
drivers/net/ethernet/8390/mcf8390.c
drivers/net/ethernet/8390/ne.c
drivers/net/ethernet/8390/ne2k-pci.c
drivers/net/ethernet/8390/pcnet_cs.c
drivers/net/ethernet/8390/smc-ultra.c
drivers/net/ethernet/amd/nmclan_cs.c
drivers/net/ethernet/fujitsu/fmvj18x_cs.c
drivers/net/ethernet/hp/hp100.c
drivers/net/ethernet/smsc/smc9194.c
drivers/net/ethernet/smsc/smc91c92_cs.c
drivers/net/ethernet/smsc/smc91x.h
drivers/net/ethernet/xircom/xirc2ps_cs.c
drivers/net/sb1000.c
drivers/net/wan/sbni.c
drivers/net/wireless/cisco/airo.c
drivers/net/wireless/intersil/hostap/hostap_cs.c
drivers/net/wireless/intersil/hostap/hostap_plx.c
drivers/net/wireless/marvell/libertas/if_cs.c
drivers/net/wireless/wl3501_cs.c
drivers/parport/parport_pc.c
drivers/pcmcia/m32r_cfc.c
drivers/scsi/NCR53c406a.c
drivers/scsi/aha152x.c
drivers/scsi/eata_pio.c
drivers/scsi/fdomain.c
drivers/scsi/g_NCR5380.c
drivers/scsi/imm.c
drivers/scsi/nsp32_io.h
drivers/scsi/pcmcia/nsp_io.h
drivers/scsi/pcmcia/sym53c500_cs.c
drivers/scsi/ppa.c
drivers/scsi/qlogicfas408.c
drivers/scsi/sym53c416.c
drivers/staging/comedi/drivers/adl_pci9111.c
drivers/staging/comedi/drivers/cb_pcidas.c
drivers/staging/comedi/drivers/das16m1.c
drivers/staging/comedi/drivers/das1800.c
drivers/staging/iio/adc/ad7606_par.c
drivers/tty/hvc/hvc_xen.c
drivers/tty/isicom.c
drivers/tty/rocket_int.h
drivers/usb/host/isp1362.h
drivers/usb/musb/blackfin.c
sound/drivers/opl4/opl4_lib.c
sound/isa/gus/gus_dram.c
sound/isa/gus/gus_pcm.c
