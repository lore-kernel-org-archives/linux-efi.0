From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: unusual uefi call/mapping problem
Date: Tue, 30 Apr 2013 17:23:29 +0100
Message-ID: <20130430162329.GA7962@srcf.ucam.org>
References: <516DC325.6090604@linux.vnet.ibm.com>
 <20130430125225.GA4197@srcf.ucam.org>
 <517FE891.9070103@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <517FE891.9070103-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joel Schopp <jschopp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leonidas da Silva Barbosa <leosilva-xuelUoVDAHHQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 30, 2013 at 10:51:45AM -0500, Joel Schopp wrote:
> On 04/30/2013 07:52 AM, Matthew Garrett wrote:
> >On Tue, Apr 16, 2013 at 04:31:17PM -0500, Joel Schopp wrote:
> >>I'm working on the Linux kernel implementation of an draft standard
> >>that has a uefi component.  The interesting part is that the uefi
> >>component isn't in the uefi runtime table, but instead has a
> >>physical address stored an ACPI table.  Other than not being in the
> >>runtime table it behaves exactly like the other runtime services.
> >
> >Sigh. Is the spec final yet? Doing this in ACPI is inconvenient - ACPI
> >isn't available at the stage where we do early UEFI setup, so it would
> >have been much easier if this had been a UEFI table rather than an ACPI
> >one.
> 
> The spec appears to currently be in purgatory, finished but not
> published.  Do you happen to know offhand what spec defines the UEFI
> runtime services table?

That's in the UEFI spec, but it wouldn't be appropriate to put it there. 
Instead, you can add another UEFI table with a different UUID and have a 
pointer to that from the ConfigurationTables pointer in the UEFI system 
table.

> >
> >>2) Various methods to map in the physical address into virtual
> >>address space and then call the virtual address.  All of these have
> >>failed.
> 
> Turns out there was a bug in the UEFI implementation, I'm pretty
> sure we have a way to map it in and call it now.

Cool.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
