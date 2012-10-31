From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 18:21:39 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1210311821150.22374@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz> <20121029174131.GC7580@srcf.ucam.org> <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz> <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
 <20121031155503.1aaf4c93@pyramind.ukuu.org.uk> <alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz> <20121031170334.59833fb1@pyramind.ukuu.org.uk> <20121031171048.GA17163@srcf.ucam.org> <20121031172121.14cc1215@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121031172121.14cc1215-38n7/U1jhRXW96NNrWNlrekiAK3p4hvP@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 31 Oct 2012, Alan Cox wrote:

> > > > Prepare (as a root) a hand-crafted image, reboot, let the kernel resume 
> > > > from that artificial image.
> > > 
> > > It's not signed. It won't reboot from that image.
> > 
> > The kernel is signed. The kernel doesn't check the signature on the 
> > suspend image.
> 
> Which doesn't matter. How are you going to create the tampered image in
> the first place ?

Editing the suspend partition/file directly when trusted kernel is booted.

-- 
Jiri Kosina
SUSE Labs
