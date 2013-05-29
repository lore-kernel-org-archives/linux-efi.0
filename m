From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: Unable to set efi boot variables on 3.10-rc3
Date: Wed, 29 May 2013 10:43:25 +0100
Message-ID: <20130529094325.GA2004@console-pimps.org>
References: <1369766432.2827.13.camel@eressea>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1369766432.2827.13.camel@eressea>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Felix Braun <Felix.Braun-Qbh6zKbeHLYtq+zhY6Lx4A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 28 May, at 08:40:32PM, Felix Braun wrote:
> Hi there,
> 
> I'm unable to set efi boot variables using efibootmgr 0.6.0 using
> kernels 3.9.x (x=0..4) and 3.10-rc3 on an ASUS E45M1-M PRO Board using
> the most current firmware (1202). Things worked fine with kernels 3.7.x
> (x=4..10). I have not been able to boot 3.8 for unrelated reasons.
> 
> When I try to write something to the efi boot variables, I get an kernel
> error
> 
> # efibootmgr
> BootCurrent: 0000
> Timeout: 1 seconds
> BootOrder: 0000,0002,0003
> Boot0000* Linux
> Boot0002* Hard Drive
> Boot0003* CD/DVD Drive
> # efibootmgr -n2
> # tail /var/log/messages
>  [Firmware Bug]: Broken EFI implementation is returning
> MaxVariableSize=0
 
Yeah, this is a common bug on ASUS machines. The 'max' argument to
QueryVariableInfo() isn't filled out correctly.

It sounds like your machine isn't initiating garbage collection. Try
adding the efi_no_storage_paranoia kernel parameter to your kernel
cmdline. 

> On boot up, I get a number of the following error messages:
> 
> e820: too many entries; ignoring [mem 0x01d8a000-0x01d8ffff]
> e820: too many entries; ignoring [mem 0x01d90000-0x01d91fff]
> ...
> 
> is that maybe related?

I doubt that's related but it's certainly not good. Could you paste your
full dmesg? What boot loader are you using?

-- 
Matt Fleming, Intel Open Source Technology Center
