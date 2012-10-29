From: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Mon, 29 Oct 2012 17:41:31 +0000
Message-ID: <20121029174131.GC7580@srcf.ucam.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1210290848450.10392-1ReQVI26iDCaZKY3DrU6dA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 29, 2012 at 08:49:41AM +0100, Jiri Kosina wrote:
> On Thu, 20 Sep 2012, Matthew Garrett wrote:
> 
> > This is pretty much identical to the first patchset, but with the capability
> > renamed (CAP_COMPROMISE_KERNEL) and the kexec patch dropped. If anyone wants
> > to deploy these then they should disable kexec until support for signed
> > kexec payloads has been merged.
> 
> Apparently your patchset currently doesn't handle device firmware loading, 
> nor do you seem to mention in in the comments.

Correct.

> I believe signed firmware loading should be put on plate as well, right?

I think that's definitely something that should be covered. I hadn't 
worried about it immediately as any attack would be limited to machines 
with a specific piece of hardware, and the attacker would need to expend 
a significant amount of reverse engineering work on the firmware - and 
we'd probably benefit from them doing that in the long run...

Having said that, yes, we should worry about this. Firmware distribution 
licenses often forbid any distribution of modified versions, so 
signatures would probably need to be detached. udev could easily glue 
together a signature and firmware when loading, but if we're moving 
towards an in-kernel firmware loader for the common case then it'll need 
to be implemented there as well.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
