From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [edk2] Corrupted EFI region
Date: Mon, 05 Aug 2013 19:09:34 +0200
Message-ID: <51FFDC4E.20001@redhat.com>
References: <20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com>
	<20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com>
	<20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com>
	<20130805144010.GE31845@pd.tnic> <51FFC19A.1020204@redhat.com>
	<20130805161247.GF31845@pd.tnic> <51FFD5B0.9080000@redhat.com>
	<20130805164731.GG31845@pd.tnic>
Reply-To: edk2-devel@lists.sourceforge.net
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <edk2-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20130805164731.GG31845@pd.tnic>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/edk2-devel>,
	<mailto:edk2-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=edk2-devel>
List-Post: <mailto:edk2-devel@lists.sourceforge.net>
List-Help: <mailto:edk2-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/edk2-devel>,
	<mailto:edk2-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: edk2-devel-bounces@lists.sourceforge.net
To: Borislav Petkov <bp@alien8.de>
Cc: linux-efi@vger.kernel.org, Gleb Natapov <gleb@redhat.com>, edk2-devel@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-efi@vger.kernel.org

On 08/05/13 18:47, Borislav Petkov wrote:
> On Mon, Aug 05, 2013 at 06:41:20PM +0200, Laszlo Ersek wrote:
>> I didn't realize the timestamps survive kexec. (As far as I remember
>> the kernels I played with kexec on didn't have the automatic
>> timestamps yet in dmesg, but I might have messed up just as well...)
> 
> No, no, no, kexec is not involved at all.

I understand. I just explained why I could not derive that fact from the
timestamps. You said,

> No, kexec is not even involved yet. If you look at the timestamps,
> there's 0.005 seconds between the two dumps during the *same* kernel
> booting on the machine, baremetal, straight from grub.

There are four memmap dumps:

(1) first boot, initial dump,
(2) first boot, dump when entering virtual mode,
(3) kexec boot, initial dump,
(4) kexec boot, dump when entering virtual mode.

I was aware that we were discussing a problem either between (1) and
(2), *or* between (3) and (4); I just didn't know inside "which pair".

I misunderstood your reply and thought that you were implying the
(1)+(2) pair by the low absolute timestamps. I assumed that (3)+(4)
would print low timestamps as well (due to the time offset starting from
zero in the kexec kernel too) and took your message as a correction to
that idea. But, you didn't say anything about the magnitude of the
timestamps, only about the differences between them.

Sorry for the noise, it's clear now that we're looking at (1)->(2).

Thanks
Laszlo

------------------------------------------------------------------------------
Get your SQL database under version control now!
Version control is standard for application code, but databases havent 
caught up. So what steps can you take to put your SQL databases under 
version control? Why should you start doing it? Read more to find out.
http://pubads.g.doubleclick.net/gampad/clk?id=49501711&iu=/4140/ostg.clktrk
