From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: BUG: unable to handle kernel paging request at 000000effd870020
Date: Wed, 02 Jan 2013 10:04:50 -0800
Message-ID: <50E476C2.7060300@zytor.com>
References: <20130102172107.GA26761@gulag1.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130102172107.GA26761-3gyQo36HEq8TG1waqwXmH7Cf4lofQVJ7@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/02/2013 09:21 AM, Nathan Zimmer wrote:
> I am getting an early boot problem. It only happens on the larger of the
> machines I haven't seen it crop up on machines with more then 512 GB of ram.
> It shows in the latest linus kernel too.
> 
> I am (wildly) guessing that what is happening is that the new_memmap that is
> being passed to bios is somehow placed incorrectly.  
> I have come up with a workaround.  By placing it the DMA area the issue goes
> away but that doesn't seem like a real fix. 
>

What does your memory map look like?

	-hpa
