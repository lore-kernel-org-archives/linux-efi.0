From: "Brian J. Johnson" <bjohnson@sgi.com>
Subject: Re: [edk2] Corrupted EFI region
Date: Thu, 08 Aug 2013 16:45:45 -0500
Message-ID: <52041189.9060807@sgi.com>
References: <51FFC19A.1020204@redhat.com> <20130805161247.GF31845@pd.tnic>
	<51FFD5B0.9080000@redhat.com> <20130805164731.GG31845@pd.tnic>
	<52001896.1030509@redhat.com> <20130805220808.GC14067@pd.tnic>
	<20130806141036.GD14891@pd.tnic> <520116D1.2010000@redhat.com>
	<20130807151935.GJ17920@pd.tnic> <5202889C.2080608@redhat.com>
	<20130808150249.GB27974@pd.tnic>
Reply-To: edk2-devel@lists.sourceforge.net
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <edk2-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20130808150249.GB27974@pd.tnic>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/edk2-devel>,
	<mailto:edk2-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=edk2-devel>
List-Post: <mailto:edk2-devel@lists.sourceforge.net>
List-Help: <mailto:edk2-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/edk2-devel>,
	<mailto:edk2-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: edk2-devel-bounces@lists.sourceforge.net
To: edk2-devel@lists.sourceforge.net
Cc: linux-efi@vger.kernel.org, gleb@redhat.com, lkml <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-efi@vger.kernel.org

On 08/08/2013 10:02 AM, Borislav Petkov wrote:
> On Wed, Aug 07, 2013 at 07:49:16PM +0200, Laszlo Ersek wrote:
>>> Now, lines 01 to 05*do not happen*.
>>>
>>> More precisely, they don't happen in the kernel. They happen in the
>>> firmware. Specifically, "OvmfPkg/Library/LoadLinuxLib/Linux.c".
>>>
>>> You're booting the kernel from the qemu command line. The kernel you
>>> run is also an "[o]ld kernel[] without EFI handover protocol". So what
>>> happens is, OVMF downloads the kernel image from qemu over fw_cfg,
>>> figures it's an old kernel...
>
> Right, I think this is easier than having to go into the EFI shell each
> time and run bzImage.efi. Unless there's a faster way to do that along
> with passing it kernel command line parameters...

You can use mtools or some other utility to update the kernel image and 
bootloader configuration files on the disk image, so it boots the way 
you want.

Or you could set OVMF to boot to the shell, and put a startup.nsh file 
on the boot partition which invokes the loader with the options you 
want.  That may be a bit simpler than rewriting a grub config.  We use 
this technique on our internal simulator.
-- 

                                                 Brian Johnson

--------------------------------------------------------------------

    "The lack of explanation demands an explanation."
                                            -- Schaffer

------------------------------------------------------------------------------
Get 100% visibility into Java/.NET code with AppDynamics Lite!
It's a free troubleshooting tool designed for production.
Get down to code-level detail for bottlenecks, with <2% overhead. 
Download for free and get started troubleshooting in minutes. 
http://pubads.g.doubleclick.net/gampad/clk?id=48897031&iu=/4140/ostg.clktrk
