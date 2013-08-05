From: Andrew Fish <afish@apple.com>
Subject: Re: [edk2] Corrupted EFI region
Date: Mon, 05 Aug 2013 08:50:17 -0700
Message-ID: <2DBE3EA4-E321-4A7B-B9AF-EDE55BC2E358@apple.com>
References: <20130731205431.GG4724@pd.tnic>
	<1375307727.22084.103.camel@shinybook.infradead.org>
	<20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com>
	<20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com>
	<20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com>
	<20130805144010.GE31845@pd.tnic>
Reply-To: edk2-devel@lists.sourceforge.net
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <edk2-devel-bounces@lists.sourceforge.net>
In-reply-to: <20130805144010.GE31845@pd.tnic>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/edk2-devel>,
	<mailto:edk2-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=edk2-devel>
List-Post: <mailto:edk2-devel@lists.sourceforge.net>
List-Help: <mailto:edk2-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/edk2-devel>,
	<mailto:edk2-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: edk2-devel-bounces@lists.sourceforge.net
To: edk2-devel@lists.sourceforge.net
Cc: David Woodhouse <dwmw2@infradead.org>, linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>
List-Id: linux-efi@vger.kernel.org


On Aug 5, 2013, at 7:40 AM, Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Aug 05, 2013 at 04:27:44PM +0200, Laszlo Ersek wrote:
>> I wouldn't call the design of SetVirtualAddressMap() braindead.
> 
> Ok, I've always wondered and you could probably shed some light on the
> matter: why is SetVirtualAddressMap() a call-once only? Why can't I
> simply call it again and update the mappings?
> 
>> I'd rather call kexec unique and somewhat unexpected :)
> 
> In all fairness, it was there before UEFI, AFAICT.
> 

AFAICT EFI pre-dates kexec merge into mainline by a number of years as SetVirtualaddressMap() was part of EFI 1.0 (previous millennium) 

The EFI to UEFI conversion was placing EFI 1.10  into an industry standard, UEFI 2.0. UEFI is an industry standard so some one just needs to make a proposal to update the spec. The edk2 open source project is not part of the standards body so complaining on this mailing list is not going to get anything changed. 

The conversion of C code to run from address A to address B is a non trivial operation, and a single conversion is bad enough. The infrastructure code required to do the conversion from physical to virtual addressing currently only runs from physical mode, so a call to change virtual address mappings from virtual mode is more complex than the current scheme. 
In general you don't want complexity in the locked NOR FLASH of the platform that can only be updated by the platform vendor. Even if the platform firmware is easy to update you want to have complexity in the OS as it is easier to change and easier to get right.

Thanks,

Andrew Fish 

>>> I wouldn't wonder if we f*cked it up again like the last time. I'll give
>>> it a long hard look.
>> 
>> Ah sorry, by "and you guys suspect" I didn't mean to imply anything
>> between the lines, I was simply trying to ascertain your working idea :)
> 
> As long as we get to the bottom of this, we're all fine. And I'd
> pretty much expect everyone who is dealing with EFI to have grown a
> sufficiently thick skin before starting to do so, so don't worry.
> 
> :-)
> 
> -- 
> Regards/Gruss,
>    Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 
> ------------------------------------------------------------------------------
> Get your SQL database under version control now!
> Version control is standard for application code, but databases havent 
> caught up. So what steps can you take to put your SQL databases under 
> version control? Why should you start doing it? Read more to find out.
> http://pubads.g.doubleclick.net/gampad/clk?id=49501711&iu=/4140/ostg.clktrk
> _______________________________________________
> edk2-devel mailing list
> edk2-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/edk2-devel


------------------------------------------------------------------------------
Get your SQL database under version control now!
Version control is standard for application code, but databases havent 
caught up. So what steps can you take to put your SQL databases under 
version control? Why should you start doing it? Read more to find out.
http://pubads.g.doubleclick.net/gampad/clk?id=49501711&iu=/4140/ostg.clktrk
