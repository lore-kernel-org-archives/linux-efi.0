From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: BGRT warns again on my system
Date: Thu, 23 Jun 2016 13:01:47 +0100
Message-ID: <20160623120147.GC8415@codeblueprint.co.uk>
References: <CALCETrUJ2QoUSYY82Q1BN3niasiunktnrmdE9Lmi2PZnCJRdag@mail.gmail.com>
 <20160528222531.GA10687@x>
 <574A6B5D.60200@moshe.nl>
 <20160602092438.GD2658@codeblueprint.co.uk>
 <20160620053819.GB13633@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160620053819.GB13633-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: =?iso-8859-1?Q?M=F4she?= van der Sterre <me-A/3C56C7qwM@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 20 Jun, at 01:38:19PM, Dave Young wrote:
> 
> I may missed the background but I worry about who knows if it is meant
> to be used for BGRT image. Some vendors could respect the BGRT valid
> bit and just leave the address as a random address. And the random
> address could be a valid physical address though. It is possible to
> leak memory infomation. 
> 
> Could we reconsider about below commit? It may be a Windows 10 bug?

Valid concerns, but we can only go on anecdotal evidence from the
behaviour of the machines we see.

Even if it is a bug in Windows, if the firmware developers are writing
code that expects the bug, and users see pretty BIOS screens with
Windows but not in Linux, we usually try to be bug-compatible.

All of that is a long way of saying: It doesn't matter if it's a bug
or not, we should provide the same behaviour. 
