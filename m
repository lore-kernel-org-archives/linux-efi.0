From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v12 1/5] efi: ARM/arm64: ignore DT memory nodes instead
 of removing them
Date: Wed, 24 Feb 2016 19:38:07 +0000
Message-ID: <20160224193807.GC9003@leverpostej>
References: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com>
 <1456192703-2274-2-git-send-email-ddaney.cavm@gmail.com>
 <20160223115805.GB4989@leverpostej>
 <20160223221202.GA32031@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160223221202.GA32031@rob-hp-laptop>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 23, 2016 at 04:12:02PM -0600, Rob Herring wrote:
> On Tue, Feb 23, 2016 at 11:58:05AM +0000, Mark Rutland wrote:
> > Hi,
> > 
> > On Mon, Feb 22, 2016 at 05:58:19PM -0800, David Daney wrote:
> > > From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > > 
> > > There are two problems with the UEFI stub DT memory node removal
> > > routine:
> > > - it deletes nodes as it traverses the tree, which happens to work
> > >   but is not supported, as deletion invalidates the node iterator;
> > > - deleting memory nodes entirely may discard annotations in the form
> > >   of additional properties on the nodes.
> > > 
> > > Since the discovery of DT memory nodes occurs strictly before the
> > > UEFI init sequence, we can simply clear the memblock memory table
> > > before parsing the UEFI memory map. This way, it is no longer
> > > necessary to remove the nodes, so we can remove that logic from the
> > > stub as well.
> > 
> > This is a little bit scary, but I guess this works.
> 
> The way it is worded/implemented is, I agree. But if we simply say both 
> can be present and the kernel will default to UEFI memory map, that 
> seems sufficient to me.
>  
> > My only concern is that when we get kexec, a subsequent kernel must also
> > have EFI memory map support, or things go bad for the next EFI-aware
> > kernel after that (as things like the runtime services may have been
> > corrupted by the kernel in the middle). It's difficult to fix the
> > general case later.
> > 
> > A different option would be to support status="disabled" for the memory
> > nodes, and ignore these in early_init_dt_scan_memory. That way a kernel
> > cannot use memory without first having parsed the EFI memory map, and we
> > can still get NUMA info from the disabled nodes.
> 
> That would be a bit strange that the node is disabled, but still used. 

I agree this would be strange, and not necessarily a precedent we'd want
to see copied elsewhere.

Per ePAPR, a "disabled" node can be enabled in a binding-specific
manner, so having the presence of a UEFI memory map "enable" the NUMA
information would appear to be permitted.

> What if DT and UEFI tables are out of sync somehow? RAM is multiple 
> mapped and different addresses were picked for example.

That applies regardless of the status of the memory nodes.

My suggestion was only that we acquired the NUMA node information, and
added this node information (and not any additional extent of memory) to
the UEFI memory map.

This is precisely what we do with Ard's code, with the exception that in
the absence of a UEFI memory map the kernel would know it was not
permitted to access memory.

Mark.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
