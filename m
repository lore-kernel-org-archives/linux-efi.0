From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: Do not allow MSR or Embedded Controller writes from userspace
 in secure boot case
Date: Thu, 8 Nov 2012 16:43:41 +0000
Message-ID: <20121108164341.657d3db8@pyramind.ukuu.org.uk>
References: <1352323699-52400-1-git-send-email-trenn@suse.de>
	<20121107215403.GA7277@srcf.ucam.org>
	<201211081040.33981.trenn@suse.de>
	<20121108143919.GB24094@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121108143919.GB24094-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 8 Nov 2012 14:39:19 +0000
Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> wrote:

> On Thu, Nov 08, 2012 at 10:40:33AM +0100, Thomas Renninger wrote:
> > On Wednesday, November 07, 2012 09:54:03 PM Matthew Garrett wrote:
> > > Is there a case where modifying MSRs or EC registers can cause arbitrary
> > > code execution?
> > 
> > Ok, I am not familiar enough with this secure stuff.
> > Theoretically writing EC registers could be used to trick ACPI
> > code and change the way it is processed by inspecting ACPI
> > code for bad EC register return values.
> 
> I'd prefer to see an actual example before worrying too much about this.
> 
> > Similar for MSR, the kernel could be (not directly) influenced
> > by setting MSR registers in a way it does not expect them to be.
> 
> Again, I'd like to see an example of arbitrary code execution.

I can think of a few. However that also shows up the lack of
CAP_SYS_RAWIO checking on this interface so I think we need to get that
fixed before posting the obvious ones as its otherwise a way to get from
DAC to RAWIO.

Alan
