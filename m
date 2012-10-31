From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 17:21:21 +0000
Message-ID: <20121031172121.14cc1215@pyramind.ukuu.org.uk>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
	<CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
	<20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
	<alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz>
	<20121031170334.59833fb1@pyramind.ukuu.org.uk>
	<20121031171048.GA17163@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20121031171048.GA17163@srcf.ucam.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, 31 Oct 2012 17:10:48 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Wed, Oct 31, 2012 at 05:03:34PM +0000, Alan Cox wrote:
> > On Wed, 31 Oct 2012 16:55:04 +0100 (CET)
> > Jiri Kosina <jkosina@suse.cz> wrote:
> > > Prepare (as a root) a hand-crafted image, reboot, let the kernel resume 
> > > from that artificial image.
> > 
> > It's not signed. It won't reboot from that image.
> 
> The kernel is signed. The kernel doesn't check the signature on the 
> suspend image.

Which doesn't matter. How are you going to create the tampered image in
the first place ?
